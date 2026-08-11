import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/utils/context_extensions.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/dashboard_helpers.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../models/delivery_model.dart';

class DeliveryCard extends StatelessWidget {
  const DeliveryCard({
    super.key,
    required this.delivery,
    required this.onDetailsTap,
    this.onDecline,
    this.isSelected = false,
  });

  final Delivery delivery;
  final VoidCallback onDetailsTap;
  final VoidCallback? onDecline;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final isNewRequest = delivery.isPendingAssignment;
    final isCancelled = delivery.isFailed;
    final isWeb = context.isWeb;
    return Card(
      color: AppColors.backgroundWhite,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: isSelected
              ? AppColors.primaryDarkGreen
              : AppColors.borderColor,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      delivery.orderNumber,
                      style: GoogleFonts.hind(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: AppColors.textBlackGrey,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildStatusTag(delivery.displayStatus),
                  ],
                ),
                if (isNewRequest)
                  InkWell(
                    onTap: onDetailsTap,
                    child: Text(
                      "Details",
                      style: GoogleFonts.hind(
                        fontWeight: FontWeight.w600,
                        fontSize: isWeb ? 18 : 14,
                        shadows: [
                          Shadow(
                            color: AppColors.textDarkerGreen,
                            offset: Offset(0, -2),
                          ),
                        ],
                        color: Colors.transparent,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.textDarkerGreen,
                        decorationThickness: 1.3,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: isWeb ? 12 : 20),
            _buildTextRow(
              label: 'Pickup Location',
              value: delivery.pickups.length > 1
                  ? '${delivery.pickupLocation} '
                        '(+${delivery.pickups.length - 1} more stop'
                        '${delivery.pickups.length - 1 == 1 ? '' : 's'})'
                  : delivery.pickupLocation,
              isWeb: isWeb,
            ),
            SizedBox(height: isWeb ? 12 : 20),
            _buildTextRow(
              label: 'Delivery Location',
              value: delivery.deliveryLocation,
              isWeb: isWeb,
            ),
            SizedBox(height: isWeb ? 12 : 20),
            if (!isWeb)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextRow(
                    label: 'Items',
                    value: delivery.items,
                    isWeb: isWeb,
                  ),
                  SizedBox(height: isWeb ? 12 : 20),
                  _buildFeeChip(delivery.deliveryFee),
                ],
              ),
            if (isWeb)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTextRow(
                    label: 'Items',
                    value: delivery.items,
                    isWeb: isWeb,
                  ),
                  _buildFeeChip(delivery.deliveryFee),
                ],
              ),
            const Divider(color: AppColors.clampBgColor),
            const SizedBox(height: 8),
            if (isNewRequest)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Decline',
                      onPressed: onDecline,
                      //No decline endpoint yet
                      buttonColor: AppColors.clampBgColor,
                      textColor: AppColors.textDarkDarkerGreen,
                      height: isWeb ? 48 : 45,
                      fontSize: isWeb ? 18 : 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomButton(
                      text: 'Accept',
                      onPressed: onDetailsTap,
                      buttonColor: AppColors.primaryDarkGreen,
                      textColor: AppColors.textWhite,
                      height: isWeb ? 48 : 45,
                      fontSize: isWeb ? 18 : 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              )
            else
              CustomButton(
                text: 'View Details',
                onPressed: isCancelled ? () {} : onDetailsTap,
                buttonColor: AppColors.buttonLighterGreen,
                textColor: isCancelled
                    ? AppColors.primaryLightGreen
                    : AppColors.textDarkDarkerGreen,
                height: isWeb ? 48 : 45,
                fontSize: isWeb ? 18 : 16,
                fontWeight: FontWeight.w500,
                width: double.infinity,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusTag(String status) {
    switch (status) {
      case "New Request":
        return Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: AppAssets.icons.newRequest.svg(),
        );
      case 'Assigned':
      case 'Picked Up':
      case 'In Transit':
        return Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: AppAssets.icons.onTheWay.svg(),
        );
      case "Delivered":
        return Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: AppAssets.icons.delivered.svg(),
        );
      case "Cancelled":
        return AppAssets.icons.cancelled.svg();
      default:
        return Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: AppAssets.icons.newRequest.svg(),
        );
    }
  }

  Widget _buildTextRow({
    required String label,
    required String value,
    required bool isWeb,
  }) {
    return Row(
      children: [
        if (!isWeb) ...[
          Text(
            '● $label:',
            style: GoogleFonts.hind(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: AppColors.textBlackGrey,
            ),
          ),
        ],
        if (isWeb) ...[
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: Text(
                  '●',
                  style: GoogleFonts.hind(
                    fontSize: 10,
                    color: AppColors.textBlackGrey,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '$label:',
                style: GoogleFonts.hind(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: AppColors.textBlackGrey,
                ),
              ),
            ],
          ),
        ],
        const SizedBox(width: 5),
        Padding(
          padding: EdgeInsets.only(top: isWeb ? 0 : 4.0),
          child: Text(
            value,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: GoogleFonts.hind(
              fontWeight: FontWeight.w500,
              fontSize: isWeb ? 16 : 14,
              color: AppColors.textBlackGrey,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeeChip(double fee) {
    return Container(
      height: 23,
      decoration: BoxDecoration(
        color: AppColors.textDeliveryFee.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 20.0),
      child: Text(
        'Delivery Fee: ${formatAmount(fee)}',
        style: GoogleFonts.notoSans(
          fontWeight: FontWeight.w500,
          fontSize: 12,
          color: AppColors.textDeliveryFee,
        ),
      ),
    );
  }
}
