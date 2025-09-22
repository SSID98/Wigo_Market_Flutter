import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/dashboard_helpers.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../models/delivery.dart';

class DeliveryDetailCard extends StatelessWidget {
  const DeliveryDetailCard({super.key, required this.delivery});

  final Delivery delivery;

  @override
  Widget build(BuildContext context) {
    bool isNewRequest = delivery.status == "New Request";
    bool isOngoing = delivery.status == "On-going";
    bool isDelivered = delivery.status == "Delivered";
    final isWeb = MediaQuery.of(context).size.width > 800;

    String buttonText = "Pick Up";
    Color buttonColor = AppColors.primaryDarkGreen;
    Widget prefixIcon = AppAssets.icons.tickDouble.svg();
    if (isOngoing) {
      buttonText = "Delivered";
      buttonColor = AppColors.clampBgColor;
      prefixIcon = AppAssets.icons.tickDouble.svg();
    } else if (isDelivered) {
      buttonText = "Delivered";
      buttonColor = AppColors.primaryDarkGreen;
      prefixIcon = AppAssets.icons.tickDouble.svg();
    } else if (isNewRequest) {
      buttonText = "Pick Up";
      buttonColor = AppColors.textOrange;
      prefixIcon = AppAssets.icons.package.svg();
    }

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
                  delivery.orderId,
                  style: GoogleFonts.hind(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: AppColors.textBlack,
                  ),
                ),
              ],
            ),
            _buildStatusTag(delivery.status),
            const SizedBox(height: 15),
            _buildInfoRow(
              title: "Customer's Information",
              label: delivery.customerName,
              value: delivery.customerPhone,
              isWeb: isWeb,
              showIcon: true,
            ),
            const SizedBox(height: 10),
            _buildInfoRow(
              title: "Pickup Location",
              label: delivery.pickupLocation,
              isWeb: isWeb,
            ),
            const SizedBox(height: 10),
            _buildInfoRow(
              title: "Delivery Location",
              label: delivery.deliveryLocation,
              isWeb: isWeb,
            ),
            const SizedBox(height: 10),
            _buildInfoRow(
              title: "Order Details",
              label: delivery.items,
              fee: formatAmount(delivery.fee),
              isWeb: isWeb,
              showFee: true,
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: buttonText,
              prefixIcon: prefixIcon,
              onPressed: () {},
              buttonColor: buttonColor,
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

  Widget _buildStatusTag(String status) {
    switch (status) {
      case "New Request":
        return AppAssets.icons.newRequest.svg();
      case "On-going":
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
