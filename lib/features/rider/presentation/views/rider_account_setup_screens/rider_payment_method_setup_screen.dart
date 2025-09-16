import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/gen/assets.gen.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../shared/widgets/custom_button.dart';
import '../../../../../shared/widgets/custom_text_field.dart';
import '../../../viewmodels/account_setup_viewmodels/rider_payment_method_setup_viewmodel.dart';

class RiderPaymentMethodSetupScreen extends ConsumerWidget {
  const RiderPaymentMethodSetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(riderAccountSetupViewmodelProvider);
    final screenSize = MediaQuery.of(context).size;
    final isWeb = MediaQuery.of(context).size.width > 600;
    return isWeb
        ? _buildWebLayout(screenSize, viewModel)
        : _buildMobileLayout(screenSize, viewModel);
  }

  Widget _buildMobileLayout(
    Size screenSize,
    RiderAccountSetupViewmodel viewModel,
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
              padding: const EdgeInsets.only(top: 70.0),
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
                          descriptionPadding: 50.0,
                        ),
                        _buildBody(
                          screenSize: screenSize.height * 0.56,
                          fontSize1: 12.0,
                          fontSize2: 12.0,
                          viewModel: viewModel,
                        ),
                        _buildFooter(buttonWidth: 350.0, viewModel: viewModel),
                        const SizedBox(height: 15.0),
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
    RiderAccountSetupViewmodel viewModel,
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
              padding: const EdgeInsets.only(top: 70.0),
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
                      horizontal: 210,
                      vertical: 35,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildHeader(
                          titleFontSize: 36.0,
                          descriptionFontSize: 18.0,
                          descriptionPadding: 0.0,
                        ),
                        const SizedBox(height: 25),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: _buildBody(
                            screenSize: screenSize.height * 0.50,
                            fontSize1: 16.72,
                            fontSize2: 16.0,
                            viewModel: viewModel,
                            web: true,
                          ),
                        ),
                        const SizedBox(height: 40.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: _buildFooter(
                            buttonWidth: 610.0,
                            web: true,
                            viewModel: viewModel,
                          ),
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

  Widget _buildHeader({
    required double descriptionPadding,
    required double titleFontSize,
    required double descriptionFontSize,
  }) {
    return Column(
      children: [
        Text(
          'Setup Payment Method',
          textAlign: TextAlign.center,
          style: GoogleFonts.hind(
            fontSize: titleFontSize,
            fontWeight: FontWeight.w700,
            color: AppColors.textDarkGreen,
          ),
        ),
        const SizedBox(height: 15.0),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: descriptionPadding),
          child: Text(
            'Let’s get your profile ready to start delivering on wiGO MARKET.',
            textAlign: TextAlign.center,
            style: GoogleFonts.hind(
              fontSize: descriptionFontSize,
              fontWeight: FontWeight.w500,
              color: AppColors.textBodyText,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody({
    required double screenSize,
    required double fontSize1,
    required double fontSize2,
    required RiderAccountSetupViewmodel viewModel,
    bool web = false,
  }) {
    return SizedBox(
      height: screenSize,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            'Payment Method',
            style: GoogleFonts.hind(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textBlackGrey,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'We use this information to pay you quickly and securely after each completed Delivery.',
            style: GoogleFonts.hind(
              fontSize: fontSize1,
              fontWeight: FontWeight.w500,
              color: AppColors.textBlackGrey,
            ),
          ),
          const Divider(thickness: 1),
          const SizedBox(height: 8),
          CustomDropdownField(
            label: 'Bank Name',
            labelTextColor: AppColors.textBlackGrey,
            items: [],
            prefixIcon: AppAssets.icons.bank.svg(),
            hintText: 'Select your bank',
            hintTextColor: AppColors.textBodyText,
          ),
          const SizedBox(height: 25.0),
          CustomTextField(
            label: 'Account Number',
            labelTextColor: AppColors.textBlackGrey,
            prefixIcon: AppAssets.icons.group.path,
            hintText: 'Enter 10 digit account Number',
            hintTextColor: AppColors.textBodyText,
          ),
          const SizedBox(height: 25),
          CustomTextField(
            label: 'Account Name',
            labelTextColor: AppColors.textBlackGrey,
            prefixIcon: AppAssets.icons.user.path,
            hintText: 'Enter account name',
            hintTextColor: AppColors.textBodyText,
          ),
          const SizedBox(height: 20),
          Text(
            'Your bank details are encrypted and protected. We’ll never share them with anyone.',
            style: GoogleFonts.hind(
              fontSize: fontSize2,
              fontWeight: FontWeight.w500,
              color: AppColors.textBodyText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter({
    required double buttonWidth,
    required RiderAccountSetupViewmodel viewModel,
    bool web = false,
  }) {
    return Column(
      children: [
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
