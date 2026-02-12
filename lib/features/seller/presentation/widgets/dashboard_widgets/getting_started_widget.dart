import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/gen/assets.gen.dart';
import 'package:wigo_flutter/shared/widgets/custom_button.dart';

import '../../../../../core/constants/app_colors.dart';

class GettingStartedWidget extends StatelessWidget {
  const GettingStartedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 600;
    return Card(
      color: AppColors.backgroundWhite,
      elevation: 0,
      margin: EdgeInsets.only(bottom: 20, top: isWeb ? 20 : 20),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Need Help Getting Started?",
              style: GoogleFonts.hind(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: AppColors.textBlackGrey,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Learn how to sell, manage your shop, and get paid—all in one place.",
              style: GoogleFonts.hind(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: AppColors.textBlackGrey,
              ),
            ),
            const SizedBox(height: 20),
            _buildCard(
              "How to List a Product",
              "Step-by-step guide to uploading and managing items in your store.",
              isWeb,
              AppAssets.icons.listProduct.svg(),
            ),
            const SizedBox(height: 20),
            _buildCard(
              "Understanding Orders & Fulfillment",
              "Track, accept, and deliver orders like a pro—no experience needed.",
              isWeb,
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: AppColors.clampBgColor,
                  borderRadius: BorderRadius.circular(80.71),
                ),
                child: Center(
                  child: AppAssets.icons.cart2.svg(
                    colorFilter: ColorFilter.mode(
                      AppColors.primaryDarkGreen,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: isWeb ? 100 : 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, String body, bool isWeb, Widget icon) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppColors.borderColor, width: 1),
      ),
      elevation: 0,
      margin: EdgeInsets.zero,
      color: AppColors.backgroundWhite,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon,
            const SizedBox(height: 5),
            Text(
              title,
              style: GoogleFonts.hind(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: AppColors.textBlackGrey,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              body,
              textAlign: TextAlign.center,
              style: GoogleFonts.hind(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: AppColors.textBlackGrey,
              ),
            ),
            const SizedBox(height: 10),
            CustomButton(
              text: 'Learn How',
              fontSize: 14,
              height: 28,
              width: double.infinity,
              borderRadius: 4,
              fontWeight: FontWeight.w500,
              suffixIcon: AppAssets.icons.arrowRight.svg(),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
