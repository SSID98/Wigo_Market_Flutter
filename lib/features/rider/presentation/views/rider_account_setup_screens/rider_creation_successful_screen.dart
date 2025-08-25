import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../shared/widgets/custom_button.dart';

class RiderCreationSuccessfulScreen extends StatelessWidget {
  const RiderCreationSuccessfulScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isWeb = MediaQuery.of(context).size.width > 600;
    return isWeb ? _buildWebLayout(screenSize) : _buildMobileLayout(screenSize);
  }

  Widget _buildMobileLayout(Size screenSize) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: SafeArea(
        child: Stack(
          children: [
            Image.asset(
              'assets/images/onboardingRiderMobile.png',
              fit: BoxFit.cover,
              color: AppColors.backGroundOverlay,
              colorBlendMode: BlendMode.overlay,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 105.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: screenSize.width * 0.95,
                  constraints: BoxConstraints(maxWidth: 400),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundWhite,
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30.0,
                      vertical: 24.0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 50.0),
                        SvgPicture.asset(
                          'assets/icons/logo.svg',
                          height: 49,
                          width: 143.86,
                        ),
                        _buildBody(
                          screenSize: screenSize.height * 0.40,
                          imageSize: 104,
                          fontSize1: 16,
                          fontWeight1: FontWeight.w700,
                          fontWeight2: FontWeight.w500,
                          fontSize2: 14,
                          buttonWidth: 350.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWebLayout(Size screenSize) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: SafeArea(
        child: Stack(
          children: [
            Image.asset(
              'assets/images/onboardingRiderWeb.png',
              fit: BoxFit.cover,
              color: AppColors.backGroundOverlay,
              colorBlendMode: BlendMode.overlay,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 100.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: screenSize.width * 0.95,
                  constraints: BoxConstraints(maxWidth: 1005),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundWhite,
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 150,
                      vertical: 35,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 25),
                        _buildBody(
                          screenSize: screenSize.height * 0.53,
                          imageSize: 184,
                          fontSize1: 31.03,
                          fontWeight1: FontWeight.w600,
                          fontWeight2: FontWeight.w400,
                          fontSize2: 24,
                          buttonWidth: 670.0,
                          web: true,
                        ),
                        const SizedBox(height: 20.0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody({
    required double screenSize,
    required double imageSize,
    required double fontSize1,
    required FontWeight fontWeight1,
    required FontWeight fontWeight2,
    required double fontSize2,
    required double buttonWidth,
    bool web = false,
  }) {
    return SizedBox(
      height: screenSize,
      child: Column(
        children: [
          const SizedBox(height: 20),
          Image.asset(
            'assets/images/successful.png',
            height: imageSize,
            width: imageSize,
          ),
          const SizedBox(height: 17),
          Text(
            '🎉 You’re all set!',
            style: GoogleFonts.hind(
              fontSize: fontSize1,
              fontWeight: fontWeight1,
              color: AppColors.textBlackGrey,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'You are just one click away from making your first earn on wiGO MARKET.',
            textAlign: TextAlign.center,
            style: GoogleFonts.hind(
              fontSize: fontSize2,
              fontWeight: fontWeight2,
              color: AppColors.textBlackGrey,
            ),
          ),
          if (web)
            const SizedBox(height: 50)
          else ...[
            const SizedBox(height: 20),
          ],
          CustomButton(
            text: 'Continue',
            onPressed: () {},
            fontSize: 18,
            fontWeight: FontWeight.w500,
            borderRadius: 6.0,
            height: 50,
            textColor: AppColors.textWhite,
            buttonColor: AppColors.primaryDarkGreen,
            width: buttonWidth,
          ),
        ],
      ),
    );
  }
}
