import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/gen/assets.gen.dart';
import 'package:wigo_flutter/shared/widgets/custom_button.dart';

import '../../../../core/constants/app_colors.dart';

class RiderWelcomeScreen extends StatelessWidget {
  const RiderWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return _buildMobileLayout(context, screenSize);
        } else {
          return _buildWebLayout(context, screenSize);
        }
      },
    );
  }

  //Mobile Layout
  Widget _buildMobileLayout(BuildContext context, Size screenSize) {
    final double contentContainerHeight = screenSize.height * 0.60;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 148.0),
            child: AppAssets.images.welcomeRiderMobile.image(
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: contentContainerHeight,
            child: Container(
              constraints: BoxConstraints(),
              decoration: BoxDecoration(color: AppColors.backgroundWhite),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 115),
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(
                        'Hello 👋',
                        style: GoogleFonts.hind(
                          fontWeight: FontWeight.w500,
                          fontSize: 24,
                          color: AppColors.textIconGrey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 11),
                    Text(
                      'Earn by Making Deliverys',
                      style: GoogleFonts.hind(
                        textStyle: TextStyle(
                          color: AppColors.textVidaLocaGreen,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 11),
                    Text(
                      'Join hundreds of riders delivering items, food, and more fast, safe, and student-friendly. You’ll get delivery requests around your campus. Accept orders, track deliveries, and get paid weekly.',
                      style: GoogleFonts.hind(
                        textStyle: TextStyle(
                          color: AppColors.textBlackGrey,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(height: 65),
                    CustomButton(
                      text: 'Get Started',
                      onPressed: () {
                        context.go('/rider/onboarding');
                      },
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      borderRadius: 6.0,
                      suffixIcon: AppAssets.icons.arrowRight.svg(),
                      iconWidth: 20,
                      iconHeight: 20,
                      height: 49,
                      width: double.infinity,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWebLayout(BuildContext context, Size screenSize) {
    final double webContentWidth = screenSize.width * 0.70;
    final double webContentHeight = screenSize.height * 0.99;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 100.0),
        child: Row(
          children: [
            // Left section: Image
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: 600,
                        maxHeight: screenSize.height * 0.90,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  'Hello 👋',
                                  style: GoogleFonts.hind(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 40,
                                    color: AppColors.textIconGrey,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Earn by Making Deliverys',
                                style: GoogleFonts.hind(
                                  textStyle: TextStyle(
                                    color: AppColors.textVidaLocaGreen,
                                    fontSize: 38,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Join hundreds of riders delivering items, food, and more fast, safe, and student-friendly. You’ll get delivery requests around your campus. Accept orders, track deliveries, and get paid weekly.',
                                style: GoogleFonts.hind(
                                  textStyle: TextStyle(
                                    color: AppColors.textBlackGrey,
                                    fontSize: 19,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 65),
                              CustomButton(
                                text: 'Get Started',
                                onPressed: () {},
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                borderRadius: 6.0,
                                suffixIcon: AppAssets.icons.arrowRight.svg(),
                                iconWidth: 20,
                                iconHeight: 20,
                                height: 56,
                                width: 480,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Right form section
            Expanded(
              child: Center(
                child: SizedBox(
                  width: webContentWidth,
                  height: webContentHeight,
                  child: AppAssets.images.welcomeRiderWeb.image(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
