import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/custom_button.dart';

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}

class RiderOnboardingScreen extends ConsumerStatefulWidget {
  const RiderOnboardingScreen({super.key});

  @override
  ConsumerState<RiderOnboardingScreen> createState() =>
      _RiderOnboardingScreenState();
}

class _RiderOnboardingScreenState extends ConsumerState<RiderOnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      'image': 'assets/images/onboarding1.png',
      'title': 'Earn Easily with WIGOMARKET',
      'description':
          'Join a trusted network of campus riders helping students and vendors deliver fast, safe, and on time within your campus.',
    },
    {
      'image': 'assets/images/onboarding2.png',
      'title': 'Here’s What to Expect',
      'description':
          'Get delivery requests, pick up from vendors, and earn directly into your bank account, all while staying active on campus.',
    },
  ];

  void _nextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return LayoutBuilder(
      builder: (context, constraints) {
        return constraints.maxWidth < 600
            ? _buildMobileLayout(context, ref, screenSize)
            : _buildWebLayout(context, ref, screenSize);
      },
    );
  }

  //Mobile Layout
  Widget _buildMobileLayout(
    BuildContext context,
    WidgetRef ref,
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
                      SizedBox(
                        height: screenSize.height * 0.38,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: _onboardingData.length,
                          onPageChanged:
                              (index) => setState(() => _currentPage = index),
                          itemBuilder: (context, index) {
                            final data = _onboardingData[index];
                            return StreamBuilder<Object>(
                              stream: null,
                              builder: (context, snapshot) {
                                return Column(
                                  children: [
                                    const SizedBox(height: 35),
                                    Text(
                                      data['title']!,
                                      style: GoogleFonts.hind(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textBlackLight,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Image.asset(
                                      data['image']!,
                                      height: 117,
                                      width: 141,
                                    ),
                                    const SizedBox(height: 15),
                                    SmoothPageIndicator(
                                      controller: _pageController,
                                      count: _onboardingData.length,
                                      effect: ExpandingDotsEffect(
                                        dotColor: AppColors.sliderDotColor,
                                        activeDotColor: AppColors.accentOrange,
                                        dotHeight: 5,
                                        dotWidth: 5,
                                        expansionFactor: 6.5,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 60.0,
                                      ),
                                      child: Text(
                                        data['description']!,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.hind(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.textBlackLight,
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
                      CustomButton(
                        text: 'Next',
                        onPressed: _nextPage,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        borderRadius: 6.0,
                        height: 49,
                        width: 360,
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

  Widget _buildWebLayout(BuildContext context, WidgetRef ref, Size screenSize) {
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
                      SizedBox(
                        height: screenSize.height * 0.67,
                        child: ScrollConfiguration(
                          behavior: MyCustomScrollBehavior(),
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: _onboardingData.length,
                            onPageChanged:
                                (index) => setState(() => _currentPage = index),
                            itemBuilder: (context, index) {
                              final data = _onboardingData[index];
                              return StreamBuilder<Object>(
                                stream: null,
                                builder: (context, snapshot) {
                                  return Column(
                                    children: [
                                      const SizedBox(height: 35),
                                      Text(
                                        data['title']!,
                                        style: GoogleFonts.hind(
                                          fontSize: 36,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.textDarkerGreen,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Image.asset(
                                        data['image']!,
                                        height: 414,
                                        width: 414,
                                      ),
                                      const SizedBox(height: 15),
                                      SmoothPageIndicator(
                                        controller: _pageController,
                                        count: _onboardingData.length,
                                        effect: ExpandingDotsEffect(
                                          dotColor: AppColors.sliderDotColor,
                                          activeDotColor:
                                              AppColors.accentOrange,
                                          dotHeight: 7,
                                          dotWidth: 7,
                                          expansionFactor: 9.5,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 200.0,
                                        ),
                                        child: Text(
                                          data['description']!,
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.hind(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.textBlackLight,
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
                      ),
                      CustomButton(
                        text: 'Next',
                        onPressed: _nextPage,
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
