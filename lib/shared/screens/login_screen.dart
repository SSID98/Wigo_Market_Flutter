import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/utils/context_extensions.dart';
import 'package:wigo_flutter/shared/widgets/login_reset_password_body.dart';

import '../../core/constants/app_colors.dart';
import '../../core/providers/role_selection_provider.dart';
import '../../core/utils/validation_utils.dart';
import '../../gen/assets.gen.dart';
import '../models/login/login_state.dart';
import '../models/user_role.dart';
import '../viewmodels/login_viewmodel.dart';
import '../widgets/bottom_text.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_loading_overlay.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(loginViewModelProvider);
    final vm = ref.watch(loginViewModelProvider.notifier);
    final screenSize = MediaQuery.of(context).size;
    final role = ref.watch(userRoleProvider);
    final isBuyer = role == UserRole.buyer;
    return context.isWeb
        ? _buildWebLayout(screenSize, vm, state, context, ref, isBuyer)
        : _buildMobileLayout(screenSize, vm, state, context, ref, isBuyer);
  }

  //Mobile Layout
  Widget _buildMobileLayout(
    Size screenSize,
    LoginViewModel vm,
    LoginState state,
    BuildContext context,
    WidgetRef ref,
    bool isBuyer,
  ) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(AppAssets.images.login.path, fit: BoxFit.cover),
          BottomTextBuilder.buildMobileBottomText(),
          Center(
            child: SingleChildScrollView(
              child: Container(
                width: screenSize.width * 0.95,
                constraints: BoxConstraints(maxWidth: 400),
                decoration: BoxDecoration(
                  color: AppColors.backgroundWhite,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 50.0),
                        child: SvgPicture.asset(
                          AppAssets.icons.logo.path,
                          height: 49,
                          width: 143.86,
                        ),
                      ),
                      const SizedBox(height: 33),
                      LoginResetPasswordWidgetBuilder.buildMobileBody(
                        controller1: vm.emailController,
                        controller2: vm.passwordController,
                        firstFieldHasError:
                            state.hasSubmitted &&
                            FormValidators.validateEmail(state.email) != null,
                        secondFieldHasError:
                            state.hasSubmitted &&
                            FormValidators.validateSignupPassword(
                                  state.password,
                                ) !=
                                null,
                        errorMessage1: state.hasSubmitted
                            ? FormValidators.validateEmail(state.email)
                            : null,
                        errorMessage2: state.hasSubmitted
                            ? FormValidators.validateSignupPassword(
                                state.password,
                              )
                            : null,
                        onPressed: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          vm.login(context, ref);
                        },
                        onChanged1: vm.updateEmail,
                        onChanged2: vm.updatePassword,
                        contentPadding1: EdgeInsets.only(top: 0.0),
                        signUp: () {
                          context.go('/roleSelection');
                        },
                        resetPassword: () async {
                          await runWithOverlay(
                            context,
                            () async {
                              await Future.delayed(
                                const Duration(seconds: 1),
                                () {
                                  if (!context.mounted) return;
                                  context.push('/resetPassword/enterEmail');
                                },
                              );
                            },
                            spinner: SpinKitDualRing(
                              color: AppColors.primaryDarkGreen,
                            ),
                          );
                        },
                      ),
                      _buildFooter(
                        orSignupFont: 14.0,
                        buttonWidth: 170.0,
                        footerTextFontSize: 14.0,
                        context: context,
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

  Widget _buildWebLayout(
    Size screenSize,
    LoginViewModel vm,
    LoginState state,
    BuildContext context,
    WidgetRef ref,
    bool isBuyer,
  ) {
    final double webContentWidth = screenSize.width * 0.34;
    final double webContentHeight = screenSize.height * 0.95;
    final double imageBorderRadius = 15.0;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 100.0),
        child: Row(
          children: [
            Expanded(
              child: Container(
                color: AppColors.backgroundWhite,
                child: Center(
                  child: Container(
                    width: webContentWidth,
                    height: webContentHeight,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(imageBorderRadius),
                      image: DecorationImage(
                        image: AssetImage(AppAssets.images.login.path),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              imageBorderRadius,
                            ),
                            child: BottomTextBuilder.buildWebBottomText(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Right form section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Column(
                  children: [
                    SvgPicture.asset(
                      AppAssets.icons.logo.path,
                      height: 78,
                      width: 229.86,
                    ),
                    SizedBox(height: 24),
                    Center(
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: 525,
                          maxHeight: screenSize.height * 0.70,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundWhite,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              LoginResetPasswordWidgetBuilder.buildWebBody(
                                controller1: vm.emailController,
                                controller2: vm.passwordController,
                                firstFieldHasError:
                                    state.hasSubmitted &&
                                    FormValidators.validateEmail(state.email) !=
                                        null,
                                secondFieldHasError:
                                    state.hasSubmitted &&
                                    FormValidators.validateSignupPassword(
                                          state.password,
                                        ) !=
                                        null,
                                errorMessage1: state.hasSubmitted
                                    ? FormValidators.validateEmail(state.email)
                                    : null,
                                errorMessage2: state.hasSubmitted
                                    ? FormValidators.validateSignupPassword(
                                        state.password,
                                      )
                                    : null,

                                onPressed: () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  vm.login(context, ref);
                                },
                                onChanged1: vm.updateEmail,
                                onChanged2: vm.updatePassword,
                                contentPadding1: EdgeInsets.only(top: 4.0),
                                signUp: () {
                                  context.go('/roleSelection');
                                },
                                resetPassword: () async {
                                  await runWithOverlay(
                                    context,
                                    () async {
                                      await Future.delayed(
                                        const Duration(seconds: 1),
                                        () {
                                          if (!context.mounted) return;
                                          context.push(
                                            '/resetPassword/enterEmail',
                                          );
                                        },
                                      );
                                    },
                                    spinner: SpinKitDualRing(
                                      color: AppColors.primaryDarkGreen,
                                    ),
                                  );
                                },
                              ),
                              _buildFooter(
                                orSignupFont: 16.0,
                                buttonWidth: screenSize.width * 0.126,
                                footerTextFontSize: 16.0,
                                sizedBoxHeight1: 35,
                                sizedBoxHeight2: 25,
                                context: context,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter({
    required double orSignupFont,
    required double buttonWidth,
    required double footerTextFontSize,
    double? sizedBoxHeight1,
    double? sizedBoxHeight2,
    required BuildContext context,
  }) {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(child: Divider(thickness: 1)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22.0),
              child: Text(
                "Or sign up with",
                style: GoogleFonts.hind(
                  fontSize: orSignupFont,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textBlackGrey,
                ),
              ),
            ),
            const Expanded(child: Divider(thickness: 1)),
          ],
        ),
        SizedBox(height: sizedBoxHeight1 ?? 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: CustomButton(
                text: 'Google',
                onPressed: () {},
                fontSize: 16,
                fontWeight: FontWeight.w500,
                borderRadius: 6.0,
                height: 50,
                width: double.infinity,
                prefixIcon: AppAssets.icons.google.svg(),
                textColor: AppColors.textBlackGrey,
                buttonColor: AppColors.buttonLighterGreen,
                borderColor: AppColors.buttonLightGreen,
                borderWidth: 1,
              ),
            ),
            const SizedBox(width: 15.0),
            Expanded(
              child: CustomButton(
                text: 'Facebook',
                onPressed: () {},
                fontSize: 16,
                fontWeight: FontWeight.w500,
                borderRadius: 6.0,
                height: 50,
                width: double.infinity,
                prefixIcon: AppAssets.icons.facebook.svg(),
                textColor: AppColors.textBlackGrey,
                buttonColor: AppColors.buttonLighterGreen,
                borderColor: AppColors.buttonLightGreen,
                borderWidth: 1,
              ),
            ),
          ],
        ),
        SizedBox(height: 40),
      ],
    );
  }
}
