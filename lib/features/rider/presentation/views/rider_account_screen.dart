import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';
import 'package:wigo_flutter/features/rider/presentation/widgets/rider_forms_field.dart';
import 'package:wigo_flutter/shared/widgets/custom_button.dart';

class RiderAccountScreen extends ConsumerWidget {
  const RiderAccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;
    final isWeb = MediaQuery.of(context).size.width > 600;
    return isWeb ? _buildWebLayout(screenSize) : _buildMobileLayout(screenSize);
  }

  Widget _buildMobileLayout(Size screenSize) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Image.asset(
              'assets/images/onboardingRiderMobile.png',
              fit: BoxFit.cover,
              color: AppColors.backGroundOverlay,
              colorBlendMode: BlendMode.overlay,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 90.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: screenSize.height * 0.82,
                  width: screenSize.width * 0.95,
                  constraints: BoxConstraints(maxWidth: 400),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundWhite,
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        _buildHeader(20.0, 14.0, 18.0, 12.0, 0.0),
                        const Divider(thickness: 1.3),
                        RiderFormFields(
                          iconHeight: 20,
                          iconWidth: 20,
                          hintFontSize: 11,
                        ),
                        const SizedBox(height: 24),
                        Center(
                          child: CustomButton(
                            text: 'Continue',
                            onPressed: () {},
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            width: 380,
                            height: 50,
                            borderRadius: 6.0,
                          ),
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
    );
  }

  Widget _buildWebLayout(screenSize) {
    return Scaffold(
      body: Stack(
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
                height: screenSize.height * 0.85,
                constraints: BoxConstraints(maxWidth: 1005),
                decoration: BoxDecoration(
                  color: AppColors.backgroundWhite,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 700),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 32),
                          _buildHeader(web: true, 36.0, 18.0, 24.0, 16.72, 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                            child: Column(
                              children: [
                                const Divider(thickness: 1.3),
                                const SizedBox(height: 15),
                                RiderFormFields(
                                  iconHeight: 20,
                                  iconWidth: 40,
                                  hintFontSize: 6,
                                  web: true,
                                  suffixIcon: Icon(Icons.visibility_outlined),
                                ),
                                const SizedBox(height: 32),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 24.0),
                                  child: Center(
                                    child: CustomButton(
                                      text: 'Continue',
                                      onPressed: () {},
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      width: 680,
                                      height: 50,
                                      borderRadius: 6.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(
    double fontSize1,
    fontSize2,
    fontSize3,
    fontSize4,
    headerPadding, {
    bool web = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            textAlign: TextAlign.center,
            'Create Your Rider Account',
            style: GoogleFonts.hind(
              fontWeight: FontWeight.w700,
              fontSize: fontSize1,
              color: AppColors.textDarkGreen,
            ),
          ),
        ),
        const SizedBox(height: 15),
        if (web)
          Column(
            children: [
              Center(
                child: Text(
                  "Let's get you set up to start delivering and earning with wiGO MARKET.",
                  style: GoogleFonts.hind(
                    fontWeight: FontWeight.w500,
                    fontSize: fontSize2,
                    color: AppColors.textBlackLight,
                  ),
                ),
              ),
              SizedBox(height: 19),
            ],
          )
        else ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              textAlign: TextAlign.center,
              "Let's get you set up to start delivering and earning with wiGO MARKET.",
              style: GoogleFonts.hind(
                fontWeight: FontWeight.w500,
                fontSize: fontSize2,
                color: AppColors.textBlackLight,
              ),
            ),
          ),
        ],
        const SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: headerPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Personal information',
                style: GoogleFonts.hind(
                  fontWeight: FontWeight.w700,
                  fontSize: fontSize3,
                  color: AppColors.textBlackLight,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Provide your basic information for verification and rider profile setup.',
                style: GoogleFonts.hind(
                  fontWeight: FontWeight.w500,
                  fontSize: fontSize4,
                  color: AppColors.textBlackLight,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
