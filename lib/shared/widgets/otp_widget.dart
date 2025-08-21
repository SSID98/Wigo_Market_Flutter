import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import 'custom_button.dart';
import 'custom_text_field.dart';

class OtpWidgetBuilder {
  static Widget _buildBody({
    required String email,
    required double imageHeight,
    required double imageWidth,
    required double fontSize1,
    required double fontSize2,
    required FontWeight fontWeight1,
    required FontWeight fontWeight2,
    required double topPadding,
    bottomPadding,
    horizontalPadding,
    required double buttonTextFontSize,
    required double footerTextFontSize,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
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
                color: AppColors.textBlackGrey,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Text(
                'Please enter the 6-digit OTP sent to your email at $email to reset your password',
                textAlign: TextAlign.center,
                style: GoogleFonts.hind(
                  fontSize: fontSize2,
                  fontWeight: fontWeight2,
                  color: AppColors.textBlackGrey,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: topPadding, bottom: bottomPadding),
              child: CustomTextField(
                label: 'OTP',
                iconHeight: 15,
                iconWidth: 15,
                prefixIcon: 'assets/icons/otp.svg',
                hintText: 'Enter OTP',
                prefixIconPadding: 24,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
                hintFontSize: 16,
                labelTextColor: AppColors.textEdufacilisBlack,
                hintTextColor: AppColors.textIconGrey,
              ),
            ),
          ],
        ),
        CustomButton(
          text: 'Verify',
          onPressed: () {},
          fontSize: buttonTextFontSize,
          fontWeight: FontWeight.w500,
          borderRadius: 6.0,
          height: 49,
          textColor: AppColors.textVidaLocaWhite,
          buttonColor: AppColors.primaryLightGreen,
          width: double.infinity,
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
                recognizer: TapGestureRecognizer()..onTap = () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  static Widget buildMobileBody({required String email}) => _buildBody(
    email: email,
    imageHeight: 86.04,
    imageWidth: 120,
    fontSize1: 16.0,
    fontSize2: 14.0,
    fontWeight1: FontWeight.w700,
    fontWeight2: FontWeight.w500,
    topPadding: 15.0,
    bottomPadding: 35.0,
    buttonTextFontSize: 16.0,
    footerTextFontSize: 12.0,
    horizontalPadding: 0.0,
  );

  static Widget buildWebBody({required String email}) => _buildBody(
    email: email,
    imageHeight: 114.0,
    imageWidth: 159.0,
    fontSize1: 28.0,
    fontSize2: 18.0,
    fontWeight1: FontWeight.w600,
    fontWeight2: FontWeight.w400,
    topPadding: 30.0,
    bottomPadding: 55.0,
    buttonTextFontSize: 18.0,
    footerTextFontSize: 14.0,
    horizontalPadding: 65.0,
  );
}
