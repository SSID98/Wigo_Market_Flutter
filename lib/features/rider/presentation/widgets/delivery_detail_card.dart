import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/dashboard_helpers.dart';
import '../../../../core/utils/context_extensions.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../models/delivery_model.dart';

enum DeliveryActionType {
  select, // pending_assignment → assigned
  markPickedUp, // assigned → picked_up
  markInTransit, // picked_up → in_transit
  confirmDelivery, // in_transit → delivered + wallet credited
}

class _ButtonConfig {
  final String label;
  final Color color;
  final Widget icon;
  final DeliveryActionType actionType;

  const _ButtonConfig({
    required this.label,
    required this.color,
    required this.icon,
    required this.actionType,
  });
}

class DeliveryDetailCard extends StatelessWidget {
  const DeliveryDetailCard({
    super.key,
    required this.delivery,
    this.onAction,
    this.isActionLoading = false,
  });

  final Delivery delivery;
  final void Function(DeliveryActionType)? onAction;
  final bool isActionLoading;

  @override
  Widget build(BuildContext context) {
    final config = _resolveButtonConfig();

    // String buttonText = "Pick Up";
    // Color buttonColor = AppColors.primaryDarkGreen;
    // Widget prefixIcon = AppAssets.icons.tickDouble.svg();
    // if (isOngoing) {
    //   buttonText = "Delivered";
    //   buttonColor = AppColors.clampBgColor;
    //   prefixIcon = AppAssets.icons.tickDouble.svg();
    // } else if (isDelivered) {
    //   buttonText = "Delivered";
    //   buttonColor = AppColors.primaryDarkGreen;
    //   prefixIcon = AppAssets.icons.tickDouble.svg();
    // } else if (isNewRequest) {
    //   buttonText = "Pick Up";
    //   buttonColor = AppColors.textOrange;
    //   prefixIcon = AppAssets.icons.package.svg();
    // }

    return Card(
      color: AppColors.backgroundWhite,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: AppColors.borderColor, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Details",
                  style: GoogleFonts.hind(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: AppColors.textBlack,
                  ),
                ),
                Text(
                  delivery.orderNumber,
                  style: GoogleFonts.hind(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: AppColors.textBlack,
                  ),
                ),
              ],
            ),
            _buildStatusTag(delivery.displayStatus),
            const SizedBox(height: 15),
            _buildInfoRow(
              title: "Customer's Information",
              label: delivery.customerName,
              value: delivery.customerPhone,
              isWeb: context.isWeb,
              showIcon: true,
            ),
            const SizedBox(height: 10),
            if (delivery.pickups.length > 1) ...[
              ...delivery.pickups.asMap().entries.map(
                (entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: _buildInfoRow(
                    title: 'Pickup ${entry.key + 1} — ${entry.value.store}',
                    label: entry.value.address,
                    isWeb: context.isWeb,
                  ),
                ),
              ),
            ] else ...[
              _buildInfoRow(
                title: delivery.pickupStoreName.isNotEmpty
                    ? 'Pickup — ${delivery.pickupStoreName}'
                    : 'Pickup Location',
                label: delivery.pickupLocation,
                isWeb: context.isWeb,
              ),
              const SizedBox(height: 10),
            ],
            // _buildInfoRow(
            //   title: "Pickup Location",
            //   label: delivery.pickupLocation,
            //   isWeb: context.isWeb,
            // ),
            const SizedBox(height: 10),
            _buildInfoRow(
              title: "Delivery Location",
              label: delivery.deliveryLocation,
              isWeb: context.isWeb,
            ),
            const SizedBox(height: 10),
            _buildInfoRow(
              title: "Order Details",
              label: delivery.items,
              fee: formatAmount(delivery.fee),
              isWeb: context.isWeb,
              showFee: true,
            ),

            if (delivery.deliveryNotes != null &&
                delivery.deliveryNotes!.isNotEmpty) ...[
              const SizedBox(height: 10),
              _buildInfoRow(
                title: 'Delivery Notes',
                label: delivery.deliveryNotes!,
                isWeb: context.isWeb,
              ),
            ],
            const SizedBox(height: 20),
            CustomButton(
              text: isActionLoading ? 'Please wait...' : config.label,
              prefixIcon: isActionLoading ? null : config.icon,
              onPressed:
                  (isActionLoading || delivery.isTerminal || onAction == null)
                  ? null
                  : () => onAction!(config.actionType),
              buttonColor: config.color,
              textColor: AppColors.textWhite,
              height: 48,
              fontSize: 18,
              width: double.infinity,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  _ButtonConfig _resolveButtonConfig() {
    if (delivery.isPendingAssignment) {
      return _ButtonConfig(
        label: 'Pick Up',
        color: AppColors.textOrange,
        icon: AppAssets.icons.package.svg(),
        actionType: DeliveryActionType.select,
      );
    }
    if (delivery.isAssigned) {
      return _ButtonConfig(
        label: 'Mark as Picked Up',
        color: AppColors.primaryDarkGreen,
        icon: AppAssets.icons.package.svg(),
        actionType: DeliveryActionType.markPickedUp,
      );
    }
    if (delivery.isPickedUp) {
      return _ButtonConfig(
        label: 'Mark as In Transit',
        color: AppColors.primaryDarkGreen,
        icon: AppAssets.icons.tickDouble.svg(),
        actionType: DeliveryActionType.markInTransit,
      );
    }
    if (delivery.isInTransit) {
      return _ButtonConfig(
        label: 'Confirm Delivery',
        color: AppColors.clampBgColor,
        icon: AppAssets.icons.tickDouble.svg(),
        actionType: DeliveryActionType.confirmDelivery,
      );
    }

    return _ButtonConfig(
      label: delivery.isDelivered ? 'Delivered' : 'Cancelled',
      color: delivery.isDelivered
          ? AppColors.primaryDarkGreen
          : AppColors.textBodyText,
      icon: AppAssets.icons.tickDouble.svg(),
      actionType: DeliveryActionType.confirmDelivery,
    );
  }

  Widget _buildStatusTag(String status) {
    switch (status) {
      case "New Request":
        return AppAssets.icons.newRequest.svg();
      case 'Assigned':
      case 'Picked Up':
      case 'In Transit':
        return AppAssets.icons.onTheWay.svg();
      case "Delivered":
        return AppAssets.icons.delivered.svg();
      case "Cancelled":
        return AppAssets.icons.cancelled.svg();
      default:
        return AppAssets.icons.newRequest.svg();
    }
  }

  Widget _buildInfoRow({
    required String title,
    required String label,
    String value = '',
    required bool isWeb,
    bool showIcon = false,
    bool showFee = false,
    String fee = '',
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: AppColors.shadowColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      color: AppColors.backgroundWhite,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: GoogleFonts.hind(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: AppColors.textBlackGrey,
                  ),
                ),
                if (showIcon) ...[AppAssets.icons.deliveryContact.svg()],
              ],
            ),
            SizedBox(height: 5),
            Text(
              label,
              style: GoogleFonts.hind(
                fontWeight: FontWeight.w400,
                fontSize: isWeb ? 14 : 12,
                color: AppColors.textBlackGrey,
              ),
            ),
            const SizedBox(height: 5),
            if (value.isNotEmpty)
              Text(
                value,
                style: GoogleFonts.hind(
                  fontWeight: FontWeight.w400,
                  fontSize: isWeb ? 14 : 12,
                  color: AppColors.textBlackGrey,
                ),
              ),
            if (showFee) ...[
              Column(
                children: [
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Delivery Fee',
                        style: GoogleFonts.hind(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: AppColors.textOrange,
                        ),
                      ),
                      Text(
                        fee,
                        style: GoogleFonts.notoSans(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: AppColors.textOrange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
