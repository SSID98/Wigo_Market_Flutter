import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:wigo_flutter/core/utils/masked_email.dart';

import '../../../../core/constants/app_colors.dart';
import '../../core/constants/url.dart';
import '../../core/local/local_user_controller.dart';
import '../../core/providers/otp_code_provider.dart';
import '../../core/providers/role_selection_provider.dart';
import '../../gen/assets.gen.dart';
import '../models/user_role.dart';
import '../viewmodels/email_verification_viewmodel.dart';
import '../widgets/verification_widget.dart';

class EmailVerificationScreen extends ConsumerWidget {
  final String email;

  const EmailVerificationScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<EmailVerificationState>(emailVerificationProvider, (
      previous,
      next,
    ) {
      if (next.errorMessage != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.errorMessage!)));
      }
    });
    final String displayEmail =
        email.isEmpty ? 'chu******osy@gmail.com' : email;
    final String maskedEmail = MaskedEmail.maskEmail(displayEmail);
    final screenSize = MediaQuery.of(context).size;
    final isWeb = MediaQuery.of(context).size.width > 600;
    final role = ref.watch(userRoleProvider);
    final notifier = ref.read(emailVerificationProvider.notifier);
    final isBuyer = role == UserRole.buyer;
    final verificationState = ref.watch(emailVerificationProvider);
    return isWeb
        ? _buildWebLayout(screenSize, maskedEmail)
        : _buildMobileLayout(
          screenSize,
          maskedEmail,
          context,
          isBuyer,
          notifier,
          ref,
          verificationState,
        );
  }

  Widget _buildMobileLayout(
    Size screenSize,
    String maskedEmail,
    BuildContext context,
    bool isBuyer,
    EmailVerificationViewModel notifier,
    WidgetRef ref,
    EmailVerificationState state,
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
          SingleChildScrollView(
            child: Padding(
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
                    padding: const EdgeInsets.only(
                      top: 30.0,
                      left: 20,
                      right: 20,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          AppAssets.icons.logo.path,
                          height: 49,
                          width: 143.86,
                        ),
                        VerificationWidgetBuilder.buildMobileBody(
                          hasError: state.otpError != null,
                          errorMessage: state.otpError,
                          email: maskedEmail,
                          onChanged:
                              (value) =>
                                  ref.read(otpCodeProvider.notifier).state =
                                      value,
                          onPressed: () async {
                            final code = ref.read(otpCodeProvider);
                            await notifier.verifyCode(
                              email: email,
                              code: code,
                              context: context,
                            );
                            if (ref
                                .read(emailVerificationProvider)
                                .isVerified) {
                              if (isBuyer) {
                                if (!context.mounted) return;
                                ref
                                    .read(localUserControllerProvider)
                                    .saveStage(OnboardingStage.success);
                                context.go('/successful');
                              } else {
                                if (!context.mounted) return;
                                ref
                                    .read(localUserControllerProvider)
                                    .saveStage(OnboardingStage.ninVerification);
                                context.go('/rider/verification');
                              }
                            }
                          },
                        ),
                        const SizedBox(height: 35.0),
                      ],
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

  Widget _buildWebLayout(Size screenSize, String maskedEmail) {
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 250),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 60.0),
                          child: SvgPicture.asset(
                            AppAssets.icons.logo.path,
                            height: 78,
                            width: 229,
                          ),
                        ),
                        const SizedBox(height: 25),
                        VerificationWidgetBuilder.buildWebBody(
                          email: maskedEmail,
                        ),
                        const SizedBox(height: 50.0),
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
}
