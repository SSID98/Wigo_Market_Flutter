import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wigo_flutter/features/rider/presentation/widgets/rider_onboarding_pageview.dart';
import 'package:wigo_flutter/features/rider/viewmodels/rider_onboarding_viewmodel.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/custom_button.dart';

class RiderOnboardingScreen extends ConsumerWidget {
  const RiderOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(riderOnboardingViewModelProvider);
    final screenSize = MediaQuery.of(context).size;
    final isWeb = MediaQuery.of(context).size.width < 600;
    return isWeb
        ? _buildMobileLayout(context, viewModel, screenSize)
        : _buildWebLayout(context, viewModel, screenSize);
  }

  //Mobile Layout
  Widget _buildMobileLayout(
    BuildContext context,
    RiderOnboardingViewModel viewModel,
    Size screenSize,
  ) {
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
                      RiderOnboardingPageView(
                        screenSize: screenSize.height * 0.37,
                        titleFontSize: 16,
                        titleColor: AppColors.textBlackLight,
                        imageWidth: 141,
                        imageHeight: 117,
                        dotHeight: 5,
                        dotWidth: 5,
                        expansionFactor: 6.5,
                        padding: 60.0,
                        descriptionFontSize: 14,
                      ),
                      CustomButton(
                        text: 'Next',
                        onPressed: viewModel.nextPage,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        borderRadius: 6.0,
                        height: 49,
                        width: 360,
                      ),
                      const SizedBox(height: 65.0),
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

  Widget _buildWebLayout(
    BuildContext context,
    RiderOnboardingViewModel viewModel,
    Size screenSize,
  ) {
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RiderOnboardingPageView(
                        screenSize: screenSize.height * 0.67,
                        titleFontSize: 36.0,
                        titleColor: AppColors.textDarkerGreen,
                        imageWidth: 414,
                        imageHeight: 414,
                        dotHeight: 7,
                        dotWidth: 7,
                        expansionFactor: 9.5,
                        padding: 200,
                        descriptionFontSize: 20,
                      ),
                      CustomButton(
                        text: 'Next',
                        onPressed: viewModel.nextPage,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        borderRadius: 6.0,
                        height: 56,
                        width: 555,
                      ),
                      const SizedBox(height: 75.0),
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
}
