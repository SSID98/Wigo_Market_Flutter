import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wigo_flutter/shared/viewmodels/reset_password_viewmodel.dart';
import 'package:wigo_flutter/shared/widgets/bottom_text.dart';

import '../../core/constants/app_colors.dart';
import '../../core/utils/validation_utils.dart';
import '../../gen/assets.gen.dart';
import '../models/reset_password_state.dart';
import '../widgets/login_reset_password_body.dart';

class ChangePasswordScreen extends ConsumerWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(resetPasswordVerificationProvider);
    final vm = ref.watch(resetPasswordVerificationProvider.notifier);
    final screenSize = MediaQuery.of(context).size;
    final isWeb = MediaQuery.of(context).size.width > 600;
    return isWeb
        ? _buildWebLayout(screenSize, vm, state, context)
        : _buildMobileLayout(screenSize, vm, state, context);
  }

  //Mobile Layout
  Widget _buildMobileLayout(
    Size screenSize,
    ResetPasswordViewmodel vm,
    ResetPasswordState state,
    BuildContext context,
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
                        padding: const EdgeInsets.only(top: 30.0),
                        child: SvgPicture.asset(
                          AppAssets.icons.logo.path,
                          height: 49,
                          width: 143.86,
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      LoginResetPasswordWidgetBuilder.buildMobileBody(
                        suffixIcon: Icon(Icons.visibility_outlined),
                        isPassword: true,
                        contentPadding1: EdgeInsets.only(top: 13.8),
                        titleText: 'Create a New Password',
                        labelText1: 'New Password',
                        hintText1: 'Enter New password',
                        labelText2: 'Confirm Password',
                        hintText2: 'Enter Confirm password',
                        showRichText: false,
                        textFieldIcon: AppAssets.icons.lock.path,
                        termsOnChanged: vm.toggleRememberMe,
                        buttonText: 'Continue',
                        value: state.rememberMe,
                        errorMessage1: state.hasSubmitted
                            ? (FormValidators.validateSignupPassword(
                                    state.password,
                                  ) ??
                                  FormValidators.validatePasswordMatch(
                                    state.password,
                                    state.confirmPassword,
                                  ))
                            : null,
                        errorMessage2: state.hasSubmitted
                            ? (FormValidators.validateSignupPassword(
                                    state.confirmPassword,
                                  ) ??
                                  FormValidators.validatePasswordMatch(
                                    state.password,
                                    state.confirmPassword,
                                  ))
                            : null,
                        controller1: vm.passwordController,
                        controller2: vm.confirmPasswordController,
                        onChanged1: vm.updatePassword,
                        onChanged2: vm.updateConfirmPassword,
                        firstFieldHasError:
                            state.hasSubmitted &&
                            (FormValidators.validateSignupPassword(
                                      state.password,
                                    ) !=
                                    null ||
                                state.password != state.confirmPassword),
                        secondFieldHasError:
                            state.hasSubmitted &&
                            (FormValidators.validateSignupPassword(
                                      state.confirmPassword,
                                    ) !=
                                    null ||
                                state.password != state.confirmPassword),
                        onPressed: () async {
                          vm.resetUserPassword(context: context);
                        },
                      ),
                      const SizedBox(height: 33),
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
    ResetPasswordViewmodel vm,
    ResetPasswordState state,
    BuildContext context,
  ) {
    final double webContentWidth = screenSize.width * 0.34;
    final double webContentHeight = screenSize.height * 0.95;
    final double imageBorderRadius = 15.0;

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20.0,
            horizontal: 100.0,
          ),
          child: Row(
            children: [
              // Left section: Image and Bottom Text
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
                  padding: const EdgeInsets.only(top: 200),
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        AppAssets.icons.logo.path,
                        height: 78,
                        width: 229.86,
                      ),
                      SizedBox(height: 30),
                      Center(
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: 500,
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
                                  suffixIcon: Icon(Icons.visibility_outlined),
                                  isPassword: true,
                                  titleText: 'Create a New Password',
                                  labelText1: 'New Password',
                                  hintText1: 'Enter New password',
                                  labelText2: 'Confirm Password',
                                  hintText2: 'Enter Confirm password',
                                  showRichText: false,
                                  textFieldIcon: AppAssets.icons.lock.path,
                                  buttonText: 'Continue',
                                  controller1: vm.passwordController,
                                  controller2: vm.confirmPasswordController,
                                  errorMessage1: state.hasSubmitted
                                      ? FormValidators.validateSignupPassword(
                                          state.password,
                                        )
                                      : null,
                                  errorMessage2: state.hasSubmitted
                                      ? FormValidators.validateSignupPassword(
                                          state.confirmPassword,
                                        )
                                      : null,
                                  termsOnChanged: vm.toggleRememberMe,
                                  value: state.rememberMe,
                                  contentPadding1: EdgeInsets.only(top: 14.0),
                                  firstFieldHasError:
                                      state.hasSubmitted &&
                                      FormValidators.validateSignupPassword(
                                            state.password,
                                          ) !=
                                          null,
                                  secondFieldHasError:
                                      state.hasSubmitted &&
                                      FormValidators.validateSignupPassword(
                                            state.confirmPassword,
                                          ) !=
                                          null,
                                  onPressed: () async {
                                    vm.resetUserPassword(context: context);
                                  },
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
      ),
    );
  }
}
