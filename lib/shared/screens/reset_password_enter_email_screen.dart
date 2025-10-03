import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:wigo_flutter/shared/widgets/bottom_text.dart';

import '../../core/constants/app_colors.dart';
import '../../gen/assets.gen.dart';
import '../widgets/verification_widget.dart';

class ResetPasswordEnterEmailScreen extends StatelessWidget {
  const ResetPasswordEnterEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isWeb = MediaQuery.of(context).size.width > 600;
    return isWeb
        ? _buildWebLayout(screenSize)
        : _buildMobileLayout(screenSize, context);
  }

  //Mobile Layout
  Widget _buildMobileLayout(Size screenSize, BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            AppAssets.images.login.image(fit: BoxFit.cover),
            BottomTextBuilder.buildMobileBottomText(),
            Center(
              child: SingleChildScrollView(
                child: Container(
                  width: screenSize.width * 0.95,
                  constraints: BoxConstraints(maxWidth: 400),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundWhite,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: SvgPicture.asset(
                            AppAssets.icons.logo.path,
                            height: 49,
                            width: 143.86,
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        VerificationWidgetBuilder.buildMobileBody(
                          titleText: 'Kindly Verify Your Email Address',
                          bodyText:
                              "Enter the email address linked to your wiGO MARKET account. We'll send you a reset link.",
                          textFieldLabel: 'Email',
                          textFieldHint: 'Please enter your email address',
                          textFieldIcon: AppAssets.icons.mail.path,
                          buttonText: 'Send Code',
                          buttonColor: AppColors.primaryDarkGreen,
                          buttonTextColor: AppColors.textWhite,
                          hintTextSize: 14,
                          labelTextColor: AppColors.textBlack,
                          labelTextFontWeight: FontWeight.w600,
                          showFooter: false,
                          buttonTextFontSize: 18.0,
                          onPressed: () {
                            context.go('/resetPassword/verification');
                          },
                        ),
                        const SizedBox(height: 33),
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
    final double webContentWidth = screenSize.width * 0.34;
    final double webContentHeight = screenSize.height * 0.95;
    final double imageBorderRadius = 15.0;

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20.0,
            horizontal: 100.0,
          ),
          child: Row(
            children: [
              // Left section: Image and Bottom Text
              Expanded(
                child: Container(
                  color: AppColors.backgroundWhite,
                  child: Center(
                    child: Container(
                      width: webContentWidth,
                      height: webContentHeight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(imageBorderRadius),
                        image: DecorationImage(
                          image: AssetImage(AppAssets.images.login.path),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                imageBorderRadius,
                              ),
                              child: BottomTextBuilder.buildWebBottomText(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Right form section
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 200),
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        AppAssets.icons.logo.path,
                        height: 78,
                        width: 229.86,
                      ),
                      SizedBox(height: 30),
                      Center(
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: 500,
                            maxHeight: screenSize.height * 0.70,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.backgroundWhite,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                VerificationWidgetBuilder.buildWebBody(
                                  titleText: 'Kindly Verify Your Email Address',
                                  bodyText:
                                      "Enter the email address linked to your wiGO MARKET account. We'll send you a reset link.",
                                  textFieldLabel: 'Email',
                                  textFieldHint:
                                      'Please enter your email address',
                                  textFieldIcon: AppAssets.icons.mail.path,
                                  buttonText: 'Send Code',
                                  buttonColor: AppColors.primaryDarkGreen,
                                  buttonTextColor: AppColors.textWhite,
                                  hintTextSize: 14,
                                  labelTextColor: AppColors.textBlack,
                                  labelTextFontWeight: FontWeight.w600,
                                  showFooter: false,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
