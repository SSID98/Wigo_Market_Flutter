import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../../gen/assets.gen.dart';
import 'custom_button.dart';
import 'custom_text_field.dart';

class VerificationWidgetBuilder {
  static Widget _buildBody({
    String? email,
    required double imageHeight,
    required double imageWidth,
    required double fontSize1,
    required double fontSize2,
    required FontWeight fontWeight1,
    required FontWeight fontWeight2,
    required double topPadding,
    void Function()? onPressed,
    void Function(String)? onChanged,
    bottomPadding,
    horizontalPadding,
    double? buttonTextFontSize,
    required double footerTextFontSize,
    String? titleText,
    bodyText,
    textFieldLabel,
    textFieldIcon,
    textFieldHint,
    buttonText,
    Color? buttonColor,
    buttonTextColor,
    labelTextColor,
    double? hintTextSize,
    FontWeight? labelTextFontWeight,
    bool showFooter = true,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 13),

            AppAssets.icons.emailVerifica.svg(
              height: imageHeight,
              width: imageWidth,
            ),

            const SizedBox(height: 20),
            Text(
              titleText ?? 'OTP Sent to your Email',
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
                bodyText ??
                    'Please enter the 6-digit OTP sent to your email at $email to verify',
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
                label: textFieldLabel ?? 'OTP',
                iconHeight: 15,
                iconWidth: 15,
                prefixIcon: textFieldIcon ?? AppAssets.icons.otp.path,
                hintText: textFieldHint ?? 'Enter OTP',
                prefixIconPadding: 24,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
                hintFontSize: hintTextSize ?? 16,
                labelTextColor: labelTextColor ?? AppColors.textEdufacilisBlack,
                hintTextColor: AppColors.textIconGrey,
                labelFontWeight: labelTextFontWeight,
                onChanged: onChanged,
              ),
            ),
          ],
        ),
        CustomButton(
          text: buttonText ?? 'Verify',
          onPressed: onPressed ?? () {},
          fontSize: buttonTextFontSize ?? 16,
          fontWeight: FontWeight.w500,
          borderRadius: 6.0,
          height: 49,
          textColor: buttonTextColor ?? AppColors.textVidaLocaWhite,
          buttonColor: buttonColor ?? AppColors.primaryLightGreen,
          width: double.infinity,
        ),
        const SizedBox(height: 20.0),
        if (showFooter)
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

  static Widget buildMobileBody({
    String? email,
    titleText,
    bodyText,
    textFieldLabel,
    textFieldIcon,
    textFieldHint,
    buttonText,
    Color? buttonColor,
    buttonTextColor,
    labelTextColor,
    double? hintTextSize,
    void Function(String)? onChanged,
    buttonTextFontSize,
    FontWeight? labelTextFontWeight,
    showFooter = true,
    void Function()? onPressed,
  }) => _buildBody(
    email: email,
    titleText: titleText,
    bodyText: bodyText,
    textFieldLabel: textFieldLabel,
    textFieldIcon: textFieldIcon,
    textFieldHint: textFieldHint,
    buttonText: buttonText,
    buttonColor: buttonColor,
    buttonTextColor: buttonTextColor,
    showFooter: showFooter,
    labelTextColor: labelTextColor,
    hintTextSize: hintTextSize,
    labelTextFontWeight: labelTextFontWeight,
    imageHeight: 86.04,
    imageWidth: 120,
    fontSize1: 16.0,
    fontSize2: 14.0,
    fontWeight1: FontWeight.w700,
    fontWeight2: FontWeight.w500,
    topPadding: 15.0,
    bottomPadding: 35.0,
    buttonTextFontSize: buttonTextFontSize,
    footerTextFontSize: 12.0,
    horizontalPadding: 0.0,
    onPressed: onPressed,
    onChanged: onChanged,
  );

  static Widget buildWebBody({
    String? email,
    titleText,
    bodyText,
    textFieldLabel,
    textFieldIcon,
    textFieldHint,
    buttonText,
    Color? buttonColor,
    buttonTextColor,
    labelTextColor,
    double? hintTextSize,
    FontWeight? labelTextFontWeight,
    showFooter = true,
    void Function()? onPressed,
    void Function(String)? onChanged,
  }) => _buildBody(
    email: email,
    titleText: titleText,
    bodyText: bodyText,
    textFieldLabel: textFieldLabel,
    textFieldIcon: textFieldIcon,
    textFieldHint: textFieldHint,
    buttonText: buttonText,
    buttonColor: buttonColor,
    buttonTextColor: buttonTextColor,
    showFooter: showFooter,
    hintTextSize: hintTextSize,
    labelTextFontWeight: labelTextFontWeight,
    labelTextColor: labelTextColor,
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
    onPressed: onPressed,
    onChanged: onChanged,
  );
}
