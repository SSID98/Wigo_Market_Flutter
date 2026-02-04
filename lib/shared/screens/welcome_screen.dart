import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/gen/assets.gen.dart';
import 'package:wigo_flutter/shared/widgets/custom_button.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/url.dart';
import '../../core/providers/role_selection_provider.dart';
import '../../core/utils/helper_methods.dart';
import '../models/user_role.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size screenSize = MediaQuery.of(context).size;
    final role = ref.watch(userRoleProvider);
    final isRider = role == UserRole.dispatch;
    final isSeller = role == UserRole.seller;
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return _buildMobileLayout(context, screenSize, isRider, isSeller);
        } else {
          return _buildWebLayout(context, screenSize);
        }
      },
    );
  }

  Widget _buildMobileLayout(
    BuildContext context,
    Size screenSize,
    bool isRider,
    bool isSeller,
  ) {
    final double contentContainerHeight = screenSize.height * 0.60;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 148.0),
            child: Image.network(
              isRider
                  ? '$networkImageUrl/welcomeRiderMobile.png'
                  : isSeller
                  ? '$networkImageUrl/sellerMobileWelcome.png'
                  : '$networkImageUrl/buyerWelcomeMobile.png',
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
                      isRider
                          ? 'Earn by Making Deliverys'
                          : isSeller
                          ? 'Welcome to wiGO MARKET'
                          : 'Shop what you’re looking for!',
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
                      isRider
                          ? 'Join hundreds of riders delivering items, food, and more fast, safe, and student-friendly. You’ll get delivery requests around your campus. Accept orders, track deliveries, and get paid weekly.'
                          : isSeller
                          ? 'You’re just a few steps away from reaching more buyers and growing your business. Whether you’re a shop owner, student entrepreneur, WIGOMARKET gives you the tools to list your products, manage orders, and connect with thousands of students nearby.'
                          : 'Join hundreds of trusted campus riders delivering items, food, and more fast, safe, and student-friendly. You’ll get delivery requests around your campus. Accept orders, track deliveries, and get paid weekly.ndly. You’ll get delivery requests around your campus. Accept orders, track deliveries, and get paid weekly.',
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
                      onPressed: () async {
                        showLoadingDialog(context);
                        await Future.delayed(const Duration(seconds: 1));
                        if (!context.mounted) return;
                        Navigator.of(context, rootNavigator: true).pop();
                        context.push('/onboarding');
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
            Expanded(
              child: Center(
                child: SizedBox(
                  width: webContentWidth,
                  height: webContentHeight,
                  child: Image.network('$networkImageUrl/welcomeRiderWeb.png'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
