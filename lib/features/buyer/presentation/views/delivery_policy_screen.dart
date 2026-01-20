import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';

import '../../../../core/utils/helper_methods.dart';
import '../widgets/bullet_list.dart';

class DeliveryPolicyScreen extends StatelessWidget {
  const DeliveryPolicyScreen({super.key});

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
                text: 'Delivery Policy',
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
                  'wiGO Market connects students and verified sellers to make buying and selling on campus seamless. Our delivery policy ensures transparency in shipping costs, timelines, and special delivery requirements.',
            ),
            const SizedBox(height: 20),
            _buildBodyTitle(
              text: 'DELIVERY COSTS',
              isWeb: isWeb,
              isTitle: true,
            ),
            const SizedBox(height: 5),
            BulletList(
              isWeb: isWeb,
              items: const [
                'Within Campus – Free delivery for orders above ₦10,000.',
                'Between Partner Campuses (Inter-Campus) – Delivery cost is based on package size/weight and courier rates.',
                'Off-Campus – Delivery is handled via partner logistics providers, with rates displayed at checkout.',
              ],
            ),
            const SizedBox(height: 20),
            _buildBodyTitle(
              text: 'DELIVERY TIMEFRAME',
              isWeb: isWeb,
              isTitle: true,
            ),
            const SizedBox(height: 5),
            BulletList(
              isWeb: isWeb,
              items: const [
                'Within Campus – 1 to 2 working days.',
                'Inter-Campus – 3 to 5 working days.',
                'Off-Campus (City Delivery) – 5 to 7 working days.',
              ],
            ),
            const SizedBox(height: 5),
            _buildBodyTitle(
              text:
                  'Delivery timelines may vary during peak periods or due to unforeseen circumstances such as weather, strikes, or logistics delays.',
              isWeb: isWeb,
            ),
            const SizedBox(height: 20),
            _buildBodyTitle(
              text: 'SPECIAL REQUIREMENTS',
              isWeb: isWeb,
              isTitle: true,
            ),
            const SizedBox(height: 15),
            _buildBodyTitle(
              text:
                  'If you require delivery at a specific time or date, contact the seller or wiGO support before placing your order. While we will make every effort to meet your request, we cannot guarantee exact timing due to third-party courier constraints.',
              isWeb: isWeb,
            ),
            const SizedBox(height: 20),
            _buildBodyTitle(
              text: 'ORDER TRACKING',
              isWeb: isWeb,
              isTitle: true,
            ),
            const SizedBox(height: 15),
            _buildBodyTitle(
              text:
                  'All shipped orders come with a tracking number accessible through your wiGO dashboard.',
              isWeb: isWeb,
              isImportant: true,
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
