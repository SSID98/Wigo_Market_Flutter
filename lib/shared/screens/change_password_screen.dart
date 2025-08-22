import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wigo_flutter/shared/widgets/bottom_text.dart';

import '../../core/constants/app_colors.dart';
import '../../core/utils/validation_utils.dart';
import '../viewmodels/change_password_viewmodel.dart';
import '../viewmodels/login_state.dart';
import '../widgets/login_reset_password_body.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final formKey = GlobalKey<FormState>();
  bool _passwordHasError = false;
  bool _confirmPasswordHasError = false;
  final passwordFieldKey = GlobalKey<FormFieldState<String>>();
  final confirmPasswordFieldKey = GlobalKey<FormFieldState<String>>();

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
    return SafeArea(
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/images/login.png', fit: BoxFit.cover),
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
                            'assets/icons/logo.svg',
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
                          textFieldIcon: 'assets/icons/lock.svg',
                          validator: FormValidators.validatePassword,
                          termsOnChanged: vm.toggleRememberMe,
                          buttonText: 'Continue',
                          state: state,
                          controller1: vm.passwordController,
                          controller2: vm.confirmPasswordController,
                          firstFieldHasError: _passwordHasError,
                          secondFieldHasError: _confirmPasswordHasError,
                          onFocusChange1: (hasFocus) {
                            if (!hasFocus) {
                              final error = FormValidators.validatePassword(
                                vm.passwordController.text,
                              );
                              setState(() {
                                _passwordHasError = error != null;
                              });
                              passwordFieldKey.currentState!.validate();
                            }
                          },
                          onFocusChange2: (hasFocus) {
                            if (!hasFocus) {
                              final error = FormValidators.validatePassword(
                                vm.confirmPasswordController.text,
                              );
                              setState(() {
                                _confirmPasswordHasError = error != null;
                              });
                              confirmPasswordFieldKey.currentState!.validate();
                            }
                          },
                          onPressed: () {
                            final passwordHasError =
                                FormValidators.validatePassword(
                                  vm.passwordController.text,
                                );
                            final confirmPasswordHasError =
                                FormValidators.validatePassword(
                                  vm.confirmPasswordController.text,
                                );
                            setState(() {
                              _passwordHasError = passwordHasError != null;
                              _confirmPasswordHasError =
                                  confirmPasswordHasError != null;
                            });
                            vm.submit(formKey);
                          },
                          formKey: formKey,
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
                          image: AssetImage('assets/images/login.png'),
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
                        'assets/icons/logo.svg',
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
                                  textFieldIcon: 'assets/icons/lock.svg',
                                  buttonText: 'Continue',
                                  controller1: vm.passwordController,
                                  controller2: vm.confirmPasswordController,
                                  validator: FormValidators.validatePassword,
                                  termsOnChanged: vm.toggleRememberMe,
                                  cvm: vm,
                                  state: state,
                                  contentPadding1: EdgeInsets.only(top: 14.0),
                                  firstFieldHasError: _passwordHasError,
                                  secondFieldHasError: _confirmPasswordHasError,
                                  onFocusChange1: (hasFocus) {
                                    if (!hasFocus) {
                                      final error =
                                          FormValidators.validatePassword(
                                            vm.passwordController.text,
                                          );
                                      setState(() {
                                        _passwordHasError = error != null;
                                      });
                                      passwordFieldKey.currentState!.validate();
                                    }
                                  },
                                  onFocusChange2: (hasFocus) {
                                    if (!hasFocus) {
                                      final error =
                                          FormValidators.validatePassword(
                                            vm.confirmPasswordController.text,
                                          );
                                      setState(() {
                                        _confirmPasswordHasError =
                                            error != null;
                                      });
                                      confirmPasswordFieldKey.currentState!
                                          .validate();
                                    }
                                  },
                                  onPressed: () {
                                    final passwordHasError =
                                        FormValidators.validatePassword(
                                          vm.passwordController.text,
                                        );
                                    final confirmPasswordHasError =
                                        FormValidators.validatePassword(
                                          vm.confirmPasswordController.text,
                                        );
                                    setState(() {
                                      _passwordHasError =
                                          passwordHasError != null;
                                      _confirmPasswordHasError =
                                          confirmPasswordHasError != null;
                                    });
                                    vm.submit(formKey);
                                  },
                                  formKey: formKey,
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
