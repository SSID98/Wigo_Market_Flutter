import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';

import '../../../../core/utils/helper_methods.dart';
import '../widgets/bullet_list.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
                text: 'Privacy Policy',
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
                  'This Privacy Policy describes how wiGO Market collects, uses, and protects your personal information when you visit or make a purchase through our platform\n\n.'
                  'By using wiGO Market, you consent to the collection and use of your data as described in this policy.',
            ),
            const SizedBox(height: 20),
            _buildBodyTitle(
              text: 'INFORMATION WE COLLECT',
              isWeb: isWeb,
              isTitle: true,
            ),
            const SizedBox(height: 5),
            BulletList(
              isWeb: isWeb,
              items: const [
                'Personal Information: Name, email address, phone number, delivery address.',
                'Payment Information: Billing details and payment method (processed securely via third-party providers; we do not store card details).',
                'Usage Data: IP address, browser type, device information, and activity on our platform.',
              ],
            ),
            const SizedBox(height: 20),
            _buildBodyTitle(
              text: 'HOW WE USE YOUR INFORMATION',
              isWeb: isWeb,
              isTitle: true,
            ),
            const SizedBox(height: 5),
            _buildBodyTitle(isWeb: isWeb, text: 'We use your information to:'),
            BulletList(
              isWeb: isWeb,
              items: const [
                'Process and deliver your orders',
                'Communicate with you about purchases, offers, and support',
                'Improve platform functionality and user experience',
                'Prevent fraud and ensure secure transactions',
              ],
            ),
            const SizedBox(height: 20),
            _buildBodyTitle(
              text: 'DATA PROTECTION',
              isWeb: isWeb,
              isTitle: true,
            ),
            const SizedBox(height: 15),
            _buildBodyTitle(
              text:
                  'We implement encryption, secure servers, and restricted data access to safeguard your information.',
              isWeb: isWeb,
              isImportant: true,
            ),
            const SizedBox(height: 20),
            _buildBodyTitle(
              text: 'SHARING YOUR INFORMATION',
              isWeb: isWeb,
              isTitle: true,
            ),
            const SizedBox(height: 15),
            _buildBodyTitle(
              text:
                  'We do not sell or rent personal data. Your information may be shared only with:',
              isWeb: isWeb,
            ),
            BulletList(
              isWeb: isWeb,
              items: const [
                'Verified sellers to fulfill your order',
                'Payment processors for transaction completion',
                'Logistics providers for delivery purposes',
                'Legal authorities if required by law',
              ],
            ),
            const SizedBox(height: 20),
            _buildBodyTitle(text: 'YOUR RIGHTS', isWeb: isWeb, isTitle: true),
            const SizedBox(height: 15),
            _buildBodyTitle(text: 'You may:', isWeb: isWeb, isImportant: true),
            BulletList(
              isWeb: isWeb,
              isImportant: true,
              items: const [
                'Request a copy of your personal data',
                'Request corrections to inaccurate data',
                'Request deletion of your account',
              ],
            ),
            const SizedBox(height: 20),
            _buildBodyTitle(
              text: 'CHANGES TO THIS POLICY',
              isWeb: isWeb,
              isTitle: true,
            ),
            const SizedBox(height: 15),
            _buildBodyTitle(
              text:
                  'wiGO Market may update this Privacy Policy from time to time. Any changes will be posted on this page with a revised date. Continued use of the platform after changes indicates your acceptance.',
              isWeb: isWeb,
            ),
            const SizedBox(height: 20),
            _buildBodyTitle(text: 'CONTACT', isWeb: isWeb, isTitle: true),
            const SizedBox(height: 10),
            _buildBodyTitle(
              isWeb: isWeb,
              text: 'Email: support@wigomarket.com',
              isEmail: true,
            ),
            const SizedBox(height: 3),
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
    bool isImportant = false,
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
        fontWeight:
            isTitle
                ? FontWeight.w700
                : isImportant
                ? FontWeight.w600
                : FontWeight.w400,
        color: isEmail ? AppColors.primaryDarkGreen : AppColors.textBlackGrey,
      ),
    );
  }
}
