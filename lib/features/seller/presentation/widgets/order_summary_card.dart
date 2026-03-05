import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/dashboard_helpers.dart';
import '../../models/order.dart';

class OrderSummaryCard extends StatelessWidget {
  final String imageUrl;
  final Order order;
  final String productName;

  const OrderSummaryCard({
    super.key,
    required this.imageUrl,
    required this.order,
    required this.productName,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppColors.borderColor, width: 1),
      ),
      elevation: 0,
      margin: EdgeInsets.only(bottom: 16),
      color: AppColors.backgroundWhite,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Card(
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3),
                    side: BorderSide(color: AppColors.borderColor),
                  ),
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.network(
                      imageUrl,
                      height: 24,
                      width: 24,
                      errorBuilder: (
                        BuildContext context,
                        Object exception,
                        StackTrace? stackTrace,
                      ) {
                        return const Center(
                          child: Icon(
                            Icons.broken_image,
                            color: AppColors.textIconGrey,
                            size: 50.0,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  productName,
                  style: GoogleFonts.hind(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: AppColors.textBodyText,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 6.0, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildRichText(title: 'Qty', value: order.item),
                  _buildRichText(
                    title: 'Price/Unit',
                    value: formatAmount(order.amount),
                  ),
                  _buildRichText(
                    title: 'Subtotal',
                    value: formatAmount(order.amount),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRichText({required String title, required String value}) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "$title: ",
            style: GoogleFonts.hind(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: AppColors.textBlackGrey,
            ),
          ),
          TextSpan(
            text: value,
            style: GoogleFonts.hind(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: AppColors.textBodyText,
            ),
          ),
        ],
      ),
    );
  }
}
