import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/url.dart';
import '../../core/local/local_user_controller.dart';
import '../../core/providers/role_selection_provider.dart';
import '../../gen/assets.gen.dart';
import '../models/user_role.dart';
import '../widgets/custom_button.dart';

class CreationSuccessfulScreen extends ConsumerWidget {
  const CreationSuccessfulScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;
    final isWeb = MediaQuery.of(context).size.width > 600;
    final role = ref.watch(userRoleProvider);

    final isBuyer = role == UserRole.buyer;
    final isSeller = role == UserRole.seller;

    return isWeb
        ? _buildWebLayout(screenSize, context, isBuyer, isSeller, ref)
        : _buildMobileLayout(screenSize, context, isBuyer, isSeller, ref);
  }

  Widget _buildMobileLayout(
    Size screenSize,
    BuildContext context,
    bool isBuyer,
    bool isSeller,
    WidgetRef ref,
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30.0,
                      vertical: 24.0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 50.0),
                        SvgPicture.asset(
                          AppAssets.icons.logo.path,
                          height: 49,
                          width: 143.86,
                        ),
                        _buildBody(
                          screenSize: screenSize.height * 0.40,
                          imageSize: 104,
                          fontSize1: 16,
                          fontWeight1: FontWeight.w700,
                          fontWeight2: FontWeight.w500,
                          fontSize2: 14,
                          context: context,
                          ref: ref,
                          isBuyer: isBuyer,
                          isSeller: isSeller,
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

  Widget _buildWebLayout(
    Size screenSize,
    BuildContext context,
    bool isBuyer,
    bool isSeller,
    WidgetRef ref,
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
              padding: const EdgeInsets.only(top: 100.0),
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 150,
                      vertical: 35,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 25),
                        _buildBody(
                          screenSize: screenSize.height * 0.53,
                          imageSize: 184,
                          fontSize1: 31.03,
                          fontWeight1: FontWeight.w600,
                          fontWeight2: FontWeight.w400,
                          fontSize2: 24,
                          web: true,
                          context: context,
                          ref: ref,
                          isBuyer: isBuyer,
                          isSeller: isSeller,
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

  Widget _buildBody({
    required bool isBuyer,
    required bool isSeller,
    required double screenSize,
    required double imageSize,
    required double fontSize1,
    required FontWeight fontWeight1,
    required FontWeight fontWeight2,
    required double fontSize2,
    required BuildContext context,
    required WidgetRef ref,
    bool web = false,
  }) {
    return SizedBox(
      height: screenSize,
      child: Column(
        children: [
          const SizedBox(height: 20),
          Image.network(
            '$networkImageUrl/successful.png',
            height: imageSize,
            width: imageSize,
          ),
          const SizedBox(height: 17),
          Text(
            '🎉 You’re all set!',
            style: GoogleFonts.hind(
              fontSize: fontSize1,
              fontWeight: fontWeight1,
              color: AppColors.textBlackGrey,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            !isBuyer
                ? 'You are just one click away from making your first earn on wiGO MARKET.'
                : isSeller
                ? 'You can now list products, manage your shop, and start selling to students Instantly.'
                : 'You are just one click away from making your first purchase on wiGO MARKET.',
            textAlign: TextAlign.center,
            style: GoogleFonts.hind(
              fontSize: fontSize2,
              fontWeight: fontWeight2,
              color: AppColors.textBlackGrey,
            ),
          ),
          if (web)
            const SizedBox(height: 50)
          else ...[
            const SizedBox(height: 20),
          ],
          CustomButton(
            text: 'Continue',
            onPressed: () async {
              ref
                  .read(localUserControllerProvider.notifier)
                  .saveStage(OnboardingStage.completed);
              ref
                  .read(localUserControllerProvider.notifier)
                  .saveHasOnboarded(true);
              if (!context.mounted) return;
              isBuyer ? context.go('/buyerHomeScreen') : context.go('/login');
            },
            fontSize: 18,
            fontWeight: FontWeight.w500,
            borderRadius: 6.0,
            height: 50,
            textColor: AppColors.textWhite,
            buttonColor: AppColors.primaryDarkGreen,
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}
