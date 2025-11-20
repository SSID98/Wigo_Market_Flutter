import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';
import 'package:wigo_flutter/shared/viewmodels/onboarding_viewmodel.dart';

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}

class OnboardingPageView extends ConsumerWidget {
  final double screenSize;
  final double titleFontSize, descriptionFontSize;
  final Color titleColor;
  final double imageHeight,
      imageWidth,
      dotHeight,
      dotWidth,
      expansionFactor,
      padding;
  final bool isBuyer;

  const OnboardingPageView({
    super.key,
    required this.screenSize,
    required this.titleFontSize,
    required this.titleColor,
    required this.imageWidth,
    required this.imageHeight,
    required this.dotHeight,
    required this.dotWidth,
    required this.expansionFactor,
    required this.padding,
    required this.descriptionFontSize,
    this.isBuyer = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(riderOnboardingViewModelProvider);

    return SizedBox(
      height: screenSize,
      child: ScrollConfiguration(
        behavior: MyCustomScrollBehavior(),
        child: PageView.builder(
          controller: viewModel.pageController,
          itemCount:
              !isBuyer
                  ? viewModel.riderOnboardingData.length
                  : viewModel.buyerOnboardingData.length,
          onPageChanged: viewModel.onPageChanged,
          itemBuilder: (context, index) {
            final data =
                !isBuyer
                    ? viewModel.riderOnboardingData[index]
                    : viewModel.buyerOnboardingData[index];
            return StreamBuilder<Object>(
              stream: null,
              builder: (context, snapshot) {
                return Column(
                  children: [
                    const SizedBox(height: 35),
                    Text(
                      data['title']!,
                      style: GoogleFonts.hind(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.w700,
                        color: titleColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Image.network(
                      data['image']!,
                      height: imageHeight,
                      width: imageWidth,
                    ),
                    const SizedBox(height: 15),
                    SmoothPageIndicator(
                      controller: viewModel.pageController,
                      count:
                          !isBuyer
                              ? viewModel.riderOnboardingData.length
                              : viewModel.buyerOnboardingData.length,
                      effect: ExpandingDotsEffect(
                        dotColor: AppColors.sliderDotColor,
                        activeDotColor: AppColors.accentOrange,
                        dotHeight: dotHeight,
                        dotWidth: dotWidth,
                        expansionFactor: expansionFactor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: padding),
                      child: Text(
                        data['description']!,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.hind(
                          fontSize: descriptionFontSize,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textBlackGrey,
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
