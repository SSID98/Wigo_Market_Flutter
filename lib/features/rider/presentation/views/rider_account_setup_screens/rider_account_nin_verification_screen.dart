import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/gen/assets.gen.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../shared/widgets/custom_button.dart';
import '../../../viewmodels/account_setup_viewmodels/rider_account_nin_verification_viewmodel.dart';

class RiderAccountNinVerificationScreen extends ConsumerWidget {
  const RiderAccountNinVerificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(riderAccountVerificationViewmodelProvider);
    final screenSize = MediaQuery.of(context).size;
    final isWeb = MediaQuery.of(context).size.width > 600;
    return isWeb
        ? _buildWebLayout(screenSize, viewModel)
        : _buildMobileLayout(screenSize, viewModel);
  }

  Widget _buildMobileLayout(
    Size screenSize,
    RiderAccountNinVerificationViewmodel viewModel,
  ) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Stack(
          children: [
            AppAssets.images.onboardingRiderMobile.image(
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
                    color: AppColors.backgroundLight,
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
                      horizontal: 20.0,
                      vertical: 24.0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildHeader(
                          titleFontSize: 20.0,
                          descriptionFontSize: 14.0,
                        ),
                        _buildBody(
                          screenSize: screenSize.height * 0.38,
                          fontSize1: 18.0,
                          fontSize2: 12.0,
                          viewModel: viewModel,
                          containerWidth: 350.0,
                          sizedBoxHeight: 11.0,
                        ),
                        _buildFooter(
                          buttonTextFontSize: 16.0,
                          buttonWidth: 350.0,
                        ),
                        const SizedBox(height: 35.0),
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

  Widget _buildWebLayout(
    Size screenSize,
    RiderAccountNinVerificationViewmodel viewModel,
  ) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Stack(
          children: [
            AppAssets.images.onboardingRiderWeb.image(
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
                    color: AppColors.backgroundLight,
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
                      horizontal: 200,
                      vertical: 35,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildHeader(
                          titleFontSize: 36.0,
                          descriptionFontSize: 18.0,
                        ),
                        const SizedBox(height: 25),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: _buildBody(
                            screenSize: screenSize.height * 0.35,
                            fontSize1: 20.0,
                            fontSize2: 16.0,
                            viewModel: viewModel,
                            containerWidth: 610.0,
                            web: true,
                            sizedBoxHeight: 20.0,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: _buildFooter(
                            buttonTextFontSize: 18.0,
                            buttonWidth: 610.0,
                            web: true,
                          ),
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

  Widget _buildHeader({
    required double titleFontSize,
    required double descriptionFontSize,
  }) {
    return Column(
      children: [
        Text(
          'Complete Account Setup',
          textAlign: TextAlign.center,
          style: GoogleFonts.hind(
            fontSize: titleFontSize,
            fontWeight: FontWeight.w700,
            color: AppColors.textDarkGreen,
          ),
        ),
        const SizedBox(height: 15.0),
        Text(
          'Let’s get you set up to start delivering and earning with wiGO MARKET.',
          textAlign: TextAlign.center,
          style: GoogleFonts.hind(
            fontSize: descriptionFontSize,
            fontWeight: FontWeight.w500,
            color: AppColors.textBodyText,
          ),
        ),
      ],
    );
  }

  Widget _buildBody({
    required double screenSize,
    required double fontSize1,
    required double fontSize2,
    required double containerWidth,
    required RiderAccountNinVerificationViewmodel viewModel,
    required double sizedBoxHeight,
    bool web = false,
  }) {
    return SizedBox(
      height: screenSize,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            'Account Verification',
            textAlign: TextAlign.center,
            style: GoogleFonts.hind(
              fontSize: fontSize1,
              fontWeight: FontWeight.w700,
              color: AppColors.textBodyText,
            ),
          ),
          const Divider(thickness: 1),
          const SizedBox(height: 10),
          Text(
            'Upload your NIN document for Verification',
            textAlign: TextAlign.center,
            style: GoogleFonts.hind(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
              color: AppColors.textBlack,
            ),
          ),
          const SizedBox(height: 8),
          DottedBorder(
            color: AppColors.textIconGrey,
            strokeWidth: 1.0,
            borderType: BorderType.RRect,
            radius: Radius.circular(8.0),
            dashPattern: [6, 6],
            child: SizedBox(
              height: 60.0,
              width: containerWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0),
                    child: AppAssets.icons.cloud.svg(),
                  ),
                  if (web)
                    Padding(
                      padding: const EdgeInsets.only(right: 18.0),
                      child: CustomButton(
                        text: 'Upload',
                        onPressed: () {},
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        prefixIcon: AppAssets.icons.cloud.svg(),
                        height: 30.0,
                        width: 84.0,
                        padding: EdgeInsets.zero,
                        borderRadius: 4,
                      ),
                    )
                  else
                    ...[],
                ],
              ),
            ),
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Transform.scale(
                scale: 0.8,
                child: SizedBox(
                  height: sizedBoxHeight,
                  width: 10,
                  child: Checkbox(
                    activeColor: AppColors.primaryDarkGreen,
                    value: viewModel.agreeToTerms,
                    onChanged: viewModel.toggleAgreeToTerms,
                    side: BorderSide(color: AppColors.textIconGrey),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  "I agree to allow wiGO MARKET track my real-time location for the purpose of deliveries and customer navigation. My location will only be shared with buyers and vendors during active orders, and is protected under wiGO MARKET's privacy policy.",
                  style: GoogleFonts.hind(
                    fontSize: fontSize2,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textBlack,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooter({
    required double buttonTextFontSize,
    required double buttonWidth,
    bool web = false,
  }) {
    return Column(
      children: [
        CustomButton(
          text: 'Verify',
          onPressed: () {},
          fontSize: buttonTextFontSize,
          fontWeight: FontWeight.w500,
          borderRadius: 6.0,
          height: 50,
          textColor: AppColors.textVidaLocaWhite,
          buttonColor: AppColors.primaryLightGreen,
          width: buttonWidth,
        ),
        if (web) SizedBox(height: 60) else ...[],
        CustomButton(
          text: 'Skip',
          onPressed: () {},
          suffixIcon: AppAssets.icons.arrowRight2.svg(),
          fontSize: 18,
          fontWeight: FontWeight.w500,
          borderRadius: 6.0,
          height: 70,
          textColor: AppColors.textDarkerGreen,
          buttonColor: Colors.transparent,
        ),
      ],
    );
  }
}
