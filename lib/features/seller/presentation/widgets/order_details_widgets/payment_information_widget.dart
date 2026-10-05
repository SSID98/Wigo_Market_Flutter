import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/features/seller/presentation/widgets/order_details_widgets/app_section_card.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../models/order_details_model.dart';

class PaymentInformationWidget extends StatelessWidget {
  const PaymentInformationWidget({super.key, required this.payment});

  final PaymentInfo payment;

  Color? _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return const Color(0xff53B483);
      case 'awaiting':
      case 'pending':
        return AppColors.textOrange;
      case 'failed':
        return AppColors.textRed;
      default:
        return null;
    }
  }

  String _titleCase(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return AppSectionCard(
      child: Padding(
        padding: const EdgeInsets.only(right: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Payment Information ',
                  style: GoogleFonts.hind(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: AppColors.textVidaGreen800,
                  ),
                ),
                SizedBox(),
              ],
            ),
            const SizedBox(height: 15),
            _buildRichText(
              title: 'Payment Method',
              value: _titleCase(payment.method),
            ),
            const SizedBox(height: 10),
            _buildRichText(
              title: 'Payment Status',
              value: _titleCase(payment.status),
              valueColor: _statusColor(payment.status),
              valueFontWeight: FontWeight.w500,
            ),
            const SizedBox(height: 10),
            _buildRichText(
              title: 'Transaction ID',
              value: payment.transactionId.isEmpty
                  ? '-'
                  : payment.transactionId,
            ),
            const SizedBox(height: 10),
            _buildRichText(
              title: 'Payout Status',
              value: _titleCase(payment.payoutStatus),
              valueColor: _statusColor(payment.payoutStatus),
              valueFontStyle: FontStyle.italic,
              valueFontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRichText({
    required String title,
    required String value,
    FontStyle? valueFontStyle,
    Color? valueColor,
    FontWeight? valueFontWeight,
  }) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "$title:          ",
            style: GoogleFonts.hind(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: AppColors.textBodyText,
            ),
          ),
          TextSpan(
            text: value,
            style: GoogleFonts.hind(
              fontWeight: valueFontWeight ?? FontWeight.w400,
              fontSize: 16,
              color: valueColor ?? AppColors.textBodyText,
              fontStyle: valueFontStyle,
            ),
          ),
        ],
      ),
    );
  }
}
