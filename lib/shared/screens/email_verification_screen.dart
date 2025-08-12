import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/shared/widgets/custom_text_field.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/custom_button.dart';

class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({super.key});

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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: SvgPicture.asset(
                          'assets/icons/logo.svg',
                          height: 49,
                          width: 143.86,
                        ),
                      ),
                      _buildBody(
                        screenSize: screenSize.height * 0.35,
                        imageHeight: 86.04,
                        imageWidth: 120,
                        fontSize1: 16.0,
                        fontSize2: 14.0,
                        fontWeight1: FontWeight.w700,
                        fontWeight2: FontWeight.w500,
                        topPadding: 15.0,
                      ),
                      _buildFooter(
                        buttonTextFontSize: 16.0,
                        buttonWidth: 350.0,
                        footerTextFontSize: 12.0,
                      ),
                      const SizedBox(height: 35.0),
                    ],
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
              padding: const EdgeInsets.only(top: 105.0),
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
                    padding: const EdgeInsets.symmetric(horizontal: 250),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 60.0),
                          child: SvgPicture.asset(
                            'assets/icons/logo.svg',
                            height: 78,
                            width: 229,
                          ),
                        ),
                        const SizedBox(height: 25),
                        _buildBody(
                          screenSize: screenSize.height * 0.41,
                          imageHeight: 114.0,
                          imageWidth: 159.0,
                          fontSize1: 28.0,
                          fontSize2: 18.0,
                          fontWeight1: FontWeight.w600,
                          fontWeight2: FontWeight.w400,
                          topPadding: 30.0,
                        ),
                        _buildFooter(
                          buttonTextFontSize: 18.0,
                          buttonWidth: 462.0,
                          footerTextFontSize: 14.0,
                        ),
                        const SizedBox(height: 75.0),
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
    required double imageHeight,
    required double imageWidth,
    required double fontSize1,
    required double fontSize2,
    required FontWeight fontWeight1,
    required FontWeight fontWeight2,
    required double topPadding,
  }) {
    return Column(
      children: [
        SizedBox(
          height: screenSize,
          child: Column(
            children: [
              const SizedBox(height: 13),
              SvgPicture.asset(
                'assets/icons/emailVerifica.svg',
                height: imageHeight,
                width: imageWidth,
              ),
              const SizedBox(height: 20),
              Text(
                'OTP Sent to your Email',
                textAlign: TextAlign.center,
                style: GoogleFonts.hind(
                  fontSize: fontSize1,
                  fontWeight: fontWeight1,
                  color: AppColors.textBlackLight,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Please enter the 6- digit OTP sent to your email at chu******osy@gmail.com to reset your password',
                textAlign: TextAlign.center,
                style: GoogleFonts.hind(
                  fontSize: fontSize2,
                  fontWeight: fontWeight2,
                  color: AppColors.textBlackLight,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20.0, topPadding, 20.0, 0.0),
                child: CustomTextField(
                  label: 'OTP',
                  iconHeight: 15,
                  iconWidth: 15,
                  prefixIcon: 'assets/icons/otp.svg',
                  hintText: 'Enter OTP',
                  hintFontSize: 16,
                  labelTextColor: AppColors.textEdufacilisBlack,
                  hintTextColor: AppColors.textIconGrey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFooter({
    required double buttonTextFontSize,
    required double buttonWidth,
    required double footerTextFontSize,
  }) {
    return Column(
      children: [
        CustomButton(
          text: 'Verify',
          onPressed: () {},
          fontSize: buttonTextFontSize,
          fontWeight: FontWeight.w500,
          borderRadius: 6.0,
          height: 48,
          width: buttonWidth,
          textColor: AppColors.textVidaLocaWhite,
          buttonColor: AppColors.primaryLightGreen,
        ),
        const SizedBox(height: 20.0),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Didn't get a code? ",
                style: GoogleFonts.hind(
                  fontSize: footerTextFontSize,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textBlack,
                ),
              ),
              TextSpan(
                text: 'Resend OTP',
                style: GoogleFonts.hind(
                  fontSize: footerTextFontSize,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textOrange,
                ),
                recognizer:
                    TapGestureRecognizer()
                      ..onTap = () {
                        // Handle privacy tap
                      },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
