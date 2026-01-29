import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wigo_flutter/shared/viewmodels/onboarding_viewmodel.dart';
import 'package:wigo_flutter/shared/widgets/onboarding_pageview.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/url.dart';
import '../../core/providers/role_selection_provider.dart';
import '../../gen/assets.gen.dart';
import '../models/user_role.dart';
import '../widgets/custom_button.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(onboardingViewModelProvider);
    final screenSize = MediaQuery.of(context).size;
    final isWeb = MediaQuery.of(context).size.width < 600;
    final role = ref.watch(userRoleProvider);
    final isBuyer = role == UserRole.buyer;
    final isSeller = role == UserRole.seller;
    return isWeb
        ? _buildMobileLayout(
          context,
          ref,
          viewModel,
          screenSize,
          isBuyer,
          isSeller,
        )
        : _buildWebLayout(
          context,
          ref,
          viewModel,
          screenSize,
          isBuyer,
          isSeller,
        );
  }

  //Mobile Layout
  Widget _buildMobileLayout(
    BuildContext context,
    WidgetRef ref,
    OnboardingViewModel viewModel,
    Size screenSize,
    bool isBuyer,
    bool isSeller,
  ) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: SafeArea(
        child: Stack(
          children: [
            Image.network(
              '$networkImageUrl/onboardingRiderMobile.png',
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
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                        OnboardingPageView(
                          screenSize: screenSize.height * 0.37,
                          titleFontSize: 16,
                          titleColor: AppColors.textBlackGrey,
                          imageWidth: 141,
                          imageHeight: 117,
                          dotHeight: 5,
                          dotWidth: 5,
                          expansionFactor: 5,
                          padding: 40.0,
                          descriptionFontSize: 14,
                        ),
                        CustomButton(
                          text: 'Next',
                          onPressed:
                              isBuyer
                                  ? () => viewModel.buyerNextPage(context, ref)
                                  : isSeller
                                  ? () => viewModel.sellerNextPage(context, ref)
                                  : () => viewModel.riderNextPage(context, ref),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          borderRadius: 6.0,
                          height: 48,
                          width: double.infinity,
                        ),
                        const SizedBox(height: 65.0),
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
    BuildContext context,
    WidgetRef ref,
    OnboardingViewModel viewModel,
    Size screenSize,
    bool isBuyer,
    bool isSeller,
  ) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: SafeArea(
        child: Stack(
          children: [
            Image.network(
              '$networkImageUrl/onboardingRiderWeb.png',
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
                      OnboardingPageView(
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
                        onPressed:
                            () =>
                                !isBuyer
                                    ? viewModel.riderNextPage(context, ref)
                                    : isSeller
                                    ? viewModel.sellerNextPage(context, ref)
                                    : viewModel.buyerNextPage(context, ref),
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
