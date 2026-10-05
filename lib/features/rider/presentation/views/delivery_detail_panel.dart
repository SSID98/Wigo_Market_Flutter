import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/dashboard_helpers.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../models/delivery_model.dart';
import '../../models/tracking_state.dart';

class DeliveryDetailPanel extends StatelessWidget {
  const DeliveryDetailPanel({
    super.key,
    required this.delivery,
    required this.phase,
    this.etaText,
    required this.isActionLoading,
    this.onMarkPickedUp,
    this.onMarkInTransit,
    this.onConfirmDelivery,
    this.onClose,
  });

  final Delivery delivery;
  final TrackingPhase phase;
  final String? etaText;
  final bool isActionLoading;

  final VoidCallback? onMarkPickedUp;
  final VoidCallback? onMarkInTransit;
  final VoidCallback? onConfirmDelivery;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.backgroundWhite,
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: AppColors.borderColor, width: 1),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Details',
                  style: GoogleFonts.hind(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: AppColors.textBlack,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      delivery.orderNumber,
                      style: GoogleFonts.hind(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: AppColors.textBlack,
                      ),
                    ),
                    if (onClose != null) ...[
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: onClose,
                        child: const Icon(
                          Icons.close,
                          size: 18,
                          color: AppColors.textBodyText,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),

            if (etaText != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppColors.clampBgColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 14,
                      color: AppColors.textDarkDarkerGreen,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Estimated delivery: $etaText min',
                      style: GoogleFonts.hind(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textDarkDarkerGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),

            Text(
              "Customer's Information",
              style: GoogleFonts.hind(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: AppColors.textBlackGrey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              delivery.customerName,
              style: GoogleFonts.hind(
                fontSize: 14,
                color: AppColors.textBlackGrey,
              ),
            ),
            if (delivery.customerPhone.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                delivery.customerPhone,
                style: GoogleFonts.hind(
                  fontSize: 14,
                  color: AppColors.textBodyText,
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => _callCustomer(delivery.customerPhone),
                icon: const Icon(
                  Icons.phone,
                  size: 16,
                  color: AppColors.primaryDarkGreen,
                ),
                label: Text(
                  'Call this customer',
                  style: GoogleFonts.hind(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryDarkGreen,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppColors.primaryDarkGreen.withValues(
                    alpha: 0.07,
                  ),
                  side: const BorderSide(
                    color: AppColors.primaryDarkGreen,
                    width: 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
              ),
            ],

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Delivery Details',
                  style: GoogleFonts.hind(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: AppColors.textBlackGrey,
                  ),
                ),
                const Icon(
                  Icons.location_on,
                  size: 18,
                  color: AppColors.primaryDarkGreen,
                ),
              ],
            ),
            const SizedBox(height: 12),

            _detailRow(
              label: 'Pickup Location',
              value: delivery.pickupStoreName.isNotEmpty
                  ? '${delivery.pickupStoreName}\n${delivery.pickupLocation}'
                  : delivery.pickupLocation,
            ),
            const SizedBox(height: 10),
            _detailRow(
              label: 'Delivery Location',
              value: delivery.deliveryLocation,
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),

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
                  formatAmount(delivery.fee),
                  style: GoogleFonts.notoSans(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: AppColors.textOrange,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            _buildActionButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    if (phase.isTerminal || !phase.hasActiveOrder) {
      return const SizedBox.shrink();
    }

    VoidCallback? onPressed;
    Color buttonColor;

    switch (phase) {
      case TrackingPhase.toPickup:
        onPressed = isActionLoading ? null : onMarkPickedUp;
        buttonColor = AppColors.primaryDarkGreen;
        break;
      case TrackingPhase.pickedUp:
        onPressed = isActionLoading ? null : onMarkInTransit;
        buttonColor = AppColors.primaryDarkGreen;
        break;
      case TrackingPhase.toDelivery:
        onPressed = isActionLoading ? null : onConfirmDelivery;
        buttonColor = AppColors.clampBgColor;
        break;
      default:
        return const SizedBox.shrink();
    }

    return CustomButton(
      text: isActionLoading ? 'Please wait...' : phase.nextActionLabel,
      onPressed: onPressed,
      buttonColor: buttonColor,
      textColor: phase == TrackingPhase.toDelivery
          ? AppColors.textDarkDarkerGreen
          : AppColors.textWhite,
      height: 48,
      fontSize: 16,
      width: double.infinity,
      fontWeight: FontWeight.w600,
    );
  }

  Widget _detailRow({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.hind(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: AppColors.textBodyText,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.hind(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: AppColors.textBlackGrey,
          ),
        ),
      ],
    );
  }

  Future<void> _callCustomer(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
