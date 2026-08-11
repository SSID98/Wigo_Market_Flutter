import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/constants/app_colors.dart';
import '../../core/local/local_user_controller.dart';
import '../../core/utils/context_extensions.dart';
import '../../core/utils/helper_methods_classes.dart';
import '../../gen/assets.gen.dart';
import '../models/email_verification/email_verification_state.dart';
import '../models/user_role.dart';
import '../viewmodels/email_verification_viewmodel.dart';
import '../widgets/verification_widget.dart';

class EmailVerificationScreen extends ConsumerWidget {
  final String email;

  const EmailVerificationScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String displayEmail = email.isEmpty
        ? 'chu******osy@gmail.com'
        : email;
    final String maskedEmail = MaskedEmail.maskEmail(displayEmail);
    final screenSize = MediaQuery.of(context).size;
    final localUser = ref.watch(localUserControllerProvider);
    final role = localUser.role;
    final notifier = ref.read(emailVerificationProvider.notifier);
    final isBuyer = role == UserRole.buyer.name;
    final isSeller = role == UserRole.seller.name;
    final verificationState = ref.watch(emailVerificationProvider);
    return context.isWeb
        ? _buildWebLayout(screenSize, maskedEmail)
        : _buildMobileLayout(
            screenSize,
            maskedEmail,
            context,
            isBuyer,
            isSeller,
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
    bool isSeller,
    EmailVerificationViewModel notifier,
    WidgetRef ref,
    EmailVerificationState state,
  ) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: Stack(
        children: [
          Image.asset(
            AppAssets.images.onboardingRiderMobile.path,
            fit: BoxFit.cover,
            color: AppColors.backGroundOverlay,
            colorBlendMode: BlendMode.overlay,
            errorBuilder:
                (
                  BuildContext context,
                  Object exception,
                  StackTrace? stackTrace,
                ) {
                  return const Center(
                    child: Icon(
                      Icons.broken_image,
                      color: AppColors.textIconGrey,
                      size: 50.0,
                    ),
                  );
                },
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
                          inputFormatters: <TextInputFormatter>[
                            LengthLimitingTextInputFormatter(6),
                          ],
                          email: maskedEmail,
                          onChanged: notifier.updateOtpCode,
                          onPressed: () async {
                            FocusManager.instance.primaryFocus?.unfocus();
                            await notifier.verifyCode(
                              email: email,
                              context: context,
                              ref: ref,
                            );
                            if (ref
                                .read(emailVerificationProvider)
                                .isVerified) {
                              if (isBuyer) {
                                if (!context.mounted) return;
                                ref
                                    .read(localUserControllerProvider.notifier)
                                    .saveStage(OnboardingStage.success);
                              } else if (isSeller) {
                                if (!context.mounted) return;
                                ref
                                    .read(localUserControllerProvider.notifier)
                                    .saveStage(OnboardingStage.businessInfo);
                              } else {
                                if (!context.mounted) return;
                                ref
                                    .read(localUserControllerProvider.notifier)
                                    .saveStage(OnboardingStage.bankSetup);
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
            Image.asset(
              AppAssets.images.onboardingRiderWeb.path,
              fit: BoxFit.cover,
              color: AppColors.backGroundOverlay,
              colorBlendMode: BlendMode.overlay,
              errorBuilder:
                  (
                    BuildContext context,
                    Object exception,
                    StackTrace? stackTrace,
                  ) {
                    return const Center(
                      child: Icon(
                        Icons.broken_image,
                        color: AppColors.textIconGrey,
                        size: 50.0,
                      ),
                    );
                  },
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
