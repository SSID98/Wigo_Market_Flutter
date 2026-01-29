import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';
import 'package:wigo_flutter/shared/models/register_state.dart';
import 'package:wigo_flutter/shared/widgets/custom_button.dart';
import 'package:wigo_flutter/shared/widgets/forms_field.dart';

import '../../core/constants/url.dart';
import '../../core/local/local_user_controller.dart';
import '../../core/providers/role_selection_provider.dart';
import '../models/user_role.dart';
import '../viewmodels/account_creation_viewmodel.dart';

class AccountCreationScreen extends ConsumerWidget {
  const AccountCreationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;
    final isWeb = MediaQuery.of(context).size.width > 600;
    final notifier = ref.read(registerViewModelProvider.notifier);
    final state = ref.watch(registerViewModelProvider);
    final role = ref.watch(userRoleProvider);
    final isBuyer = role == UserRole.buyer;
    final isSeller = role == UserRole.seller;
    return isWeb
        ? _buildWebLayout(screenSize, context, isBuyer, isSeller)
        : _buildMobileLayout(
          screenSize,
          context,
          ref,
          notifier,
          state,
          isBuyer,
          isSeller,
        );
  }

  Widget _buildMobileLayout(
    Size screenSize,
    BuildContext context,
    WidgetRef ref,
    RegisterViewModel notifier,
    RegisterState state,
    bool isBuyer,
    bool isSeller,
  ) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: Stack(
        children: [
          Image.network(
            '$networkImageUrl/onboardingRiderMobile.png',
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
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      _buildHeader(
                        20.0,
                        14.0,
                        18.0,
                        12.0,
                        0.0,
                        isBuyer,
                        isSeller,
                      ),
                      const Divider(thickness: 1.3),
                      Expanded(
                        child: SingleChildScrollView(
                          child: FormFields(
                            iconHeight: 20,
                            iconWidth: 20,
                            hintFontSize: 11,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: CustomButton(
                          text: 'Continue',
                          onPressed:
                              state.isLoading
                                  ? null
                                  : () async {
                                    notifier.validateOnSubmit();

                                    final currentState = ref.read(
                                      registerViewModelProvider,
                                    );

                                    if (currentState.emailError != null ||
                                        currentState.passwordError != null) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Please fix the highlighted fields',
                                          ),
                                        ),
                                      );
                                      return;
                                    }

                                    // set role before submit if you have separate path
                                    notifier.setRole(
                                      isBuyer
                                          ? UserRole.buyer
                                          : isSeller
                                          ? UserRole.seller
                                          : UserRole.rider,
                                    );

                                    final ok = await notifier.submit(context);
                                    if (ok) {
                                      // navigate to verification or next screen
                                      if (!context.mounted) return;
                                      context.go(
                                        '/verification',
                                        extra: {'email': state.email},
                                      );
                                      ref
                                          .read(localUserControllerProvider)
                                          .saveStage(OnboardingStage.otp);
                                    } else {
                                      // show error via snackBar or inline UI from state.errorMessage
                                      if (!context.mounted) return;
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            state.errorMessage ??
                                                'An error occurred',
                                          ),
                                        ),
                                      );
                                    }
                                  },
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          width: double.infinity,
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
    );
  }

  // onPressed: () {
  //   isBuyer
  //       ? Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder:
  //               (_) => EmailVerificationScreen(
  //                 email: '',
  //                 isBuyer: isBuyer,
  //               ),
  //         ),
  //       )
  //       : context.push('/verification');
  // },

  Widget _buildWebLayout(screenSize, context, bool isBuyer, bool isSeller) {
    return Scaffold(
      body: Stack(
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
                          _buildHeader(
                            web: true,
                            36.0,
                            18.0,
                            24.0,
                            16.72,
                            20,
                            isBuyer,
                            isSeller,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                            child: Column(
                              children: [
                                const Divider(thickness: 1.3),
                                const SizedBox(height: 15),
                                FormFields(
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
                                      onPressed: () {
                                        context.push('/verification');
                                      },
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
    headerPadding,
    bool isBuyer,
    bool isSeller, {
    bool web = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            textAlign: TextAlign.center,
            isBuyer
                ? 'Create Your Buyer Account'
                : isSeller
                ? 'Create Your Seller Account'
                : 'Create Your Rider Account',
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
                  isBuyer
                      ? "Let's get you set up to start shopping with wiGO MARKET."
                      : isSeller
                      ? 'Let’s get your store ready to start selling on WIGOMARKET.'
                      : "Let's get you set up to start delivering and earning with wiGO MARKET.",
                  style: GoogleFonts.hind(
                    fontWeight: FontWeight.w500,
                    fontSize: fontSize2,
                    color: AppColors.textBlackGrey,
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
              isBuyer
                  ? "Let's get you set up to start shopping with wiGO MARKET."
                  : isSeller
                  ? "Let’s get your store ready to start selling on WIGOMARKET."
                  : "Let's get you set up to start delivering and earning with wiGO MARKET.",
              style: GoogleFonts.hind(
                fontWeight: FontWeight.w500,
                fontSize: fontSize2,
                color: AppColors.textBlackGrey,
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
                  color: AppColors.textBlackGrey,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                isBuyer
                    ? 'Provide your basic information for buyer profile setup.'
                    : isSeller
                    ? 'Provide a few personal details to create your seller profile.'
                    : 'Provide your basic information for verification and rider profile setup.',
                style: GoogleFonts.hind(
                  fontWeight: FontWeight.w500,
                  fontSize: fontSize4,
                  color: AppColors.textBlackGrey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
