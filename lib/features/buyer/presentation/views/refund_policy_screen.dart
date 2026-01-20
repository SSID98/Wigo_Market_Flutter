import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';

import '../../../../core/utils/helper_methods.dart';
import '../widgets/bullet_list.dart';

class RefundPolicyScreen extends StatelessWidget {
  const RefundPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 600;
    bool isHandlingBack = false;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (isHandlingBack || didPop) return;
        isHandlingBack = true;
        showLoadingDialog(context);
        await Future.delayed(const Duration(seconds: 1));
        if (!context.mounted) return;
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.of(context).pop(result);
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: _buildHeaderTitle(
                text: 'Refund Policy',
                isWeb: isWeb,
                isTitle: true,
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: _buildHeaderTitle(
                text: 'Last updated: 12 August 2025',
                isWeb: isWeb,
              ),
            ),
            const SizedBox(height: 40),
            _buildBodyTitle(text: 'INTRODUCTION', isWeb: isWeb, isTitle: true),
            const SizedBox(height: 15),
            _buildBodyTitle(
              isWeb: isWeb,
              text:
                  'At wiGO Market, we value customer satisfaction and strive '
                  'to ensure every order meets your expectations.\n\n'
                  'This Refund Policy explains when and how refunds are '
                  'processed for products purchased through our platform.\n\n'
                  'By making a purchase on wiGO Market, you agree to the terms '
                  'stated in this policy, which apply to all customers, sellers, '
                  'and vendors on our marketplace.',
            ),
            const SizedBox(height: 20),
            _buildBodyTitle(
              text: 'ELIGIBILITY FOR REFUNDS',
              isWeb: isWeb,
              isTitle: true,
            ),
            const SizedBox(height: 5),
            BulletList(
              isWeb: isWeb,
              items: const ['You may request a refund if:'],
            ),
            IndentedBulletList(
              isWeb: isWeb,
              items: const [
                'You received the wrong item or an item significantly different from its description.',
                'The item arrives damaged or defective.',
                'Your order was canceled before shipping but payment was processed.',
                'A seller fails to fulfill the order within the stated delivery period.',
              ],
            ),
            const SizedBox(height: 12),
            BulletList(
              isWeb: isWeb,
              items: const ['Refunds will not be granted if:'],
            ),
            IndentedBulletList(
              isWeb: isWeb,
              items: const [
                'The product matches the description and is free of defects.',
                'The item was damaged after delivery due to mishandling.',
                'You change your mind after receiving the item.',
              ],
            ),
            const SizedBox(height: 20),
            _buildBodyTitle(
              text: 'REFUND PROCESS',
              isWeb: isWeb,
              isTitle: true,
            ),
            const SizedBox(height: 5),
            BulletList(
              isWeb: isWeb,
              items: const [
                'Submit a Refund Request via your wiGO account within 48 hours of delivery.',
                'Provide photos or videos showing the product’s condition.',
                'wiGO’s support team will review and respond within 3–5 working days.',
                'If approved, your refund will be processed via your original payment method within 5–10 working days.',
              ],
            ),
            const SizedBox(height: 20),
            _buildBodyTitle(
              text: 'NON-REFUNDABLE ITEMS',
              isWeb: isWeb,
              isTitle: true,
            ),
            const SizedBox(height: 5),
            BulletList(
              isWeb: isWeb,
              items: const [
                'Gift cards or discount vouchers',
                'Perishable goods or consumables',
                'Customized or personalized products',
              ],
            ),
            const SizedBox(height: 20),
            _buildBodyTitle(text: 'CONTACT', isWeb: isWeb, isTitle: true),
            const SizedBox(height: 10),
            _buildBodyTitle(
              isWeb: isWeb,
              text: 'Email: support@wigomarket.com',
              isEmail: true,
            ),
            const SizedBox(height: 10),
            _buildBodyTitle(isWeb: isWeb, text: 'Phone: +234 XXX XXX XXXX'),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderTitle({
    bool isTitle = false,
    required String text,
    required bool isWeb,
  }) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize:
            isTitle
                ? isWeb
                    ? 26
                    : 18
                : isWeb
                ? 16
                : 14,
        fontWeight: isTitle ? FontWeight.w700 : FontWeight.w500,
        color: AppColors.textBlackGrey,
      ),
    );
  }

  Widget _buildBodyTitle({
    bool isTitle = false,
    bool isEmail = false,
    required String text,
    required bool isWeb,
  }) {
    return Text(
      text,
      style: GoogleFonts.hind(
        fontSize:
            isTitle
                ? isWeb
                    ? 20
                    : 16
                : isWeb
                ? 18
                : 14,
        fontWeight: isTitle ? FontWeight.w700 : FontWeight.w400,
        color: isEmail ? AppColors.primaryDarkGreen : AppColors.textBlackGrey,
      ),
    );
  }
}
