import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:wigo_flutter/shared/widgets/bottom_text.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/url.dart';
import '../../core/utils/validation_utils.dart';
import '../../gen/assets.gen.dart';
import '../models/login/login_state.dart';
import '../viewmodels/change_password_viewmodel.dart';
import '../widgets/login_reset_password_body.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  String? _passwordError;
  String? _confirmPasswordError;
  final passwordFieldKey = GlobalKey<FormFieldState<String>>();
  final confirmPasswordFieldKey = GlobalKey<FormFieldState<String>>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(changePasswordViewModelProvider);
    final vm = ref.watch(changePasswordViewModelProvider.notifier);
    final screenSize = MediaQuery.of(context).size;
    final isWeb = MediaQuery.of(context).size.width > 600;
    return isWeb
        ? _buildWebLayout(screenSize, vm, state, context)
        : _buildMobileLayout(screenSize, vm, state, context);
  }

  //Mobile Layout
  Widget _buildMobileLayout(
    Size screenSize,
    ChangePasswordViewmodel vm,
    LoginState state,
    BuildContext context,
  ) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.network('$networkImageUrl/login.png', fit: BoxFit.cover),
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
                        validator1: (value) => null,
                        validator2: (value) => null,
                        termsOnChanged: vm.toggleRememberMe,
                        buttonText: 'Continue',
                        state: state,
                        autoValidateMode: _autovalidateMode,
                        errorMessage1: _passwordError,
                        errorMessage2: _confirmPasswordError,
                        controller1: vm.passwordController,
                        controller2: vm.confirmPasswordController,
                        firstFieldHasError: _passwordError != null,
                        secondFieldHasError: _confirmPasswordError != null,
                        onFocusChange1: (hasFocus) {
                          if (!hasFocus) {
                            final passwordLengthError =
                                FormValidators.validatePassword(
                                  vm.passwordController.text,
                                );
                            final confirmPasswordLengthError =
                                FormValidators.validatePassword(
                                  vm.confirmPasswordController.text,
                                );
                            String? mismatchError;
                            if (passwordLengthError == null &&
                                confirmPasswordLengthError == null) {
                              if (vm.passwordController.text !=
                                  vm.confirmPasswordController.text) {
                                mismatchError =
                                    'Password Mismatch. Please re-enter.';
                              }
                            }
                            setState(() {
                              _passwordError =
                                  passwordLengthError ?? mismatchError;
                              mismatchError;
                              _autovalidateMode = AutovalidateMode.always;
                            });
                            final hasAnyError = _passwordError != null;
                            if (!hasAnyError) {}
                          }
                        },
                        onFocusChange2: (hasFocus) {
                          if (!hasFocus) {
                            final passwordLengthError =
                                FormValidators.validatePassword(
                                  vm.passwordController.text,
                                );
                            final confirmPasswordLengthError =
                                FormValidators.validatePassword(
                                  vm.confirmPasswordController.text,
                                );
                            String? mismatchError;
                            if (passwordLengthError == null &&
                                confirmPasswordLengthError == null) {
                              if (vm.passwordController.text !=
                                  vm.confirmPasswordController.text) {
                                mismatchError =
                                    'Password Mismatch. Please re-enter.';
                              }
                            }
                            setState(() {
                              _confirmPasswordError =
                                  confirmPasswordLengthError ?? mismatchError;
                              _autovalidateMode = AutovalidateMode.always;
                            });
                            final hasAnyError = _confirmPasswordError != null;
                            if (!hasAnyError) {}
                          }
                        },
                        onPressed: () async {
                          FocusManager.instance.primaryFocus?.unfocus();
                          final passwordLengthError =
                              FormValidators.validatePassword(
                                vm.passwordController.text,
                              );
                          final confirmPasswordLengthError =
                              FormValidators.validatePassword(
                                vm.confirmPasswordController.text,
                              );
                          String? mismatchError;
                          if (passwordLengthError == null &&
                              confirmPasswordLengthError == null) {
                            if (vm.passwordController.text !=
                                vm.confirmPasswordController.text) {
                              mismatchError =
                                  'Password Mismatch. Please re-enter.';
                            }
                          }
                          setState(() {
                            _passwordError =
                                passwordLengthError ?? mismatchError;
                            _confirmPasswordError =
                                confirmPasswordLengthError ?? mismatchError;
                            _autovalidateMode = AutovalidateMode.always;
                          });
                          final hasAnyError =
                              _passwordError != null ||
                              _confirmPasswordError != null;
                          if (!hasAnyError) {
                            vm.setLoading(true);
                            await Future.delayed(
                              const Duration(milliseconds: 500),
                            );
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Password Successfully Reset'),
                              ),
                            );
                            context.go('/login');
                            vm.setLoading(false);
                          }
                        },
                        fieldKey1: passwordFieldKey,
                        fieldKey2: confirmPasswordFieldKey,
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
    ChangePasswordViewmodel vm,
    LoginState state,
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
                          image: NetworkImage('$networkImageUrl/login.png'),
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
                                  autoValidateMode: _autovalidateMode,
                                  errorMessage1: _passwordError,
                                  errorMessage2: _confirmPasswordError,
                                  validator1: (value) => null,
                                  validator2: (value) => null,
                                  termsOnChanged: vm.toggleRememberMe,
                                  cvm: vm,
                                  state: state,
                                  contentPadding1: EdgeInsets.only(top: 14.0),
                                  firstFieldHasError: _passwordError != null,
                                  secondFieldHasError:
                                      _confirmPasswordError != null,
                                  onFocusChange1: (hasFocus) {
                                    if (!hasFocus) {
                                      final error =
                                          FormValidators.validatePassword(
                                            vm.passwordController.text,
                                          );
                                      setState(() {
                                        _passwordError = error;
                                      });
                                      _autovalidateMode =
                                          AutovalidateMode.always;
                                      if (_passwordError != null) {}
                                    }
                                  },
                                  onFocusChange2: (hasFocus) {
                                    if (!hasFocus) {
                                      if (!hasFocus) {
                                        final error =
                                            FormValidators.validatePassword(
                                              vm.confirmPasswordController.text,
                                            );
                                        setState(() {
                                          _confirmPasswordError = error;
                                        });
                                        _autovalidateMode =
                                            AutovalidateMode.always;
                                        if (_confirmPasswordError != null) {}
                                      }
                                    }
                                  },
                                  onPressed: () async {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    final passwordLengthError =
                                        FormValidators.validatePassword(
                                          vm.passwordController.text,
                                        );
                                    final confirmPasswordLengthError =
                                        FormValidators.validatePassword(
                                          vm.confirmPasswordController.text,
                                        );
                                    String? mismatchError;
                                    if (passwordLengthError == null &&
                                        confirmPasswordLengthError == null) {
                                      if (vm.passwordController.text !=
                                          vm.confirmPasswordController.text) {
                                        mismatchError =
                                            'Password Mismatch. Please re-enter.';
                                      }
                                    }
                                    setState(() {
                                      _passwordError =
                                          passwordLengthError ?? mismatchError;
                                      _confirmPasswordError =
                                          confirmPasswordLengthError ??
                                          mismatchError;
                                      _autovalidateMode =
                                          AutovalidateMode.always;
                                    });
                                    final hasAnyError =
                                        _passwordError != null ||
                                        _confirmPasswordError != null;
                                    if (!hasAnyError) {
                                      vm.setLoading(true);
                                      await Future.delayed(
                                        const Duration(milliseconds: 500),
                                      );
                                      if (!context.mounted) return;
                                      context.go('/login');
                                      vm.setLoading(false);
                                    }
                                  },
                                  fieldKey1: passwordFieldKey,
                                  fieldKey2: confirmPasswordFieldKey,
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
