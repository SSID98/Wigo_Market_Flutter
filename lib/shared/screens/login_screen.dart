import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/utils/validation_utils.dart';
import 'package:wigo_flutter/shared/widgets/login_reset_password_body.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/url.dart';
import '../../gen/assets.gen.dart';
import '../viewmodels/login_state.dart';
import '../viewmodels/login_view_model.dart';
import '../widgets/bottom_text.dart';
import '../widgets/custom_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key, this.isBuyer = false});

  final bool isBuyer;

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  String? _passwordError;
  String? _emailError;
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  final emailFieldKey = GlobalKey<FormFieldState<String>>();
  final passwordFieldKey = GlobalKey<FormFieldState<String>>();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginViewModelProvider);
    final vm = ref.watch(loginViewModelProvider.notifier);
    final screenSize = MediaQuery.of(context).size;
    final isWeb = MediaQuery.of(context).size.width > 600;
    return isWeb
        ? _buildWebLayout(screenSize, vm, state, context)
        : _buildMobileLayout(screenSize, vm, state, context);
  }

  //Mobile Layout
  Widget _buildMobileLayout(
    Size screenSize,
    LoginViewModel vm,
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
                        termsOnChanged: vm.toggleAgreeToTerms,
                        vm: vm,
                        state: state,
                        firstFieldHasError: _emailError != null,
                        secondFieldHasError: _passwordError != null,
                        validator1: (value) => null,
                        validator2: (value) => null,
                        errorMessage1: _emailError,
                        errorMessage2: _passwordError,
                        autoValidateMode: _autovalidateMode,
                        onFocusChange1: (hasFocus) {
                          if (!hasFocus) {
                            final error = FormValidators.validateEmail(
                              vm.emailController.text,
                            );
                            setState(() {
                              _emailError = error;
                              _autovalidateMode = AutovalidateMode.always;
                            });
                            final emailError = _emailError != null;
                            if (!emailError) {}
                          }
                        },
                        onFocusChange2: (hasFocus) {
                          if (!hasFocus) {
                            final error = FormValidators.validatePassword(
                              vm.passwordController.text,
                            );
                            setState(() {
                              _passwordError = error;
                              _autovalidateMode = AutovalidateMode.always;
                            });
                            final passwordError = _passwordError != null;
                            if (!passwordError) {}
                          }
                        },
                        onPressed: () {
                          final emailHasError = FormValidators.validateEmail(
                            vm.emailController.text,
                          );
                          final passwordHasError =
                              FormValidators.validatePassword(
                                vm.passwordController.text,
                              );
                          setState(() {
                            state.generalError = null;
                            _emailError = emailHasError;
                            _passwordError = passwordHasError;
                            _autovalidateMode = AutovalidateMode.always;
                          });
                          final hasAnyError =
                              _emailError != null || _passwordError != null;
                          if (!hasAnyError) {
                            vm.login(formKey, context, widget.isBuyer);
                          }
                        },
                        formKey: formKey,
                        fieldKey1: emailFieldKey,
                        fieldKey2: passwordFieldKey,
                        contentPadding1: EdgeInsets.only(top: 0.0),
                      ),
                      _buildFooter(
                        orSignupFont: 14.0,
                        buttonWidth: 170.0,
                        footerTextFontSize: 14.0,
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
  ) {
    final double webContentWidth = screenSize.width * 0.34;
    final double webContentHeight = screenSize.height * 0.95;
    final double imageBorderRadius = 15.0;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 100.0),
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
                                termsOnChanged: vm.toggleAgreeToTerms,
                                controller1: vm.emailController,
                                controller2: vm.passwordController,
                                vm: vm,
                                state: state,
                                firstFieldHasError: _emailError != null,
                                secondFieldHasError: _passwordError != null,
                                onFocusChange1: (hasFocus) {
                                  if (!hasFocus) {
                                    final error = FormValidators.validateEmail(
                                      vm.emailController.text,
                                    );
                                    setState(() {
                                      _emailError = error;
                                      _autovalidateMode =
                                          AutovalidateMode.always;
                                    });
                                    final emailError = _emailError != null;
                                    if (!emailError) {}
                                  }
                                },
                                onFocusChange2: (hasFocus) {
                                  if (!hasFocus) {
                                    final error =
                                        FormValidators.validatePassword(
                                          vm.passwordController.text,
                                        );
                                    setState(() {
                                      _passwordError = error;
                                      _autovalidateMode =
                                          AutovalidateMode.always;
                                    });
                                    final passwordError =
                                        _passwordError != null;
                                    if (!passwordError) {}
                                  }
                                },
                                onPressed: () {
                                  final emailHasError =
                                      FormValidators.validateEmail(
                                        vm.emailController.text,
                                      );
                                  final passwordHasError =
                                      FormValidators.validatePassword(
                                        vm.passwordController.text,
                                      );
                                  setState(() {
                                    state.generalError = null;
                                    _emailError = emailHasError;
                                    _passwordError = passwordHasError;
                                    _autovalidateMode = AutovalidateMode.always;
                                  });
                                  final hasAnyError =
                                      _emailError != null ||
                                      _passwordError != null;
                                  if (!hasAnyError) {
                                    vm.login(formKey, context, widget.isBuyer);
                                  }
                                },
                                validator1: (value) => null,
                                validator2: (value) => null,
                                formKey: formKey,
                                fieldKey1: emailFieldKey,
                                fieldKey2: passwordFieldKey,
                                contentPadding1: EdgeInsets.only(top: 4.0),
                              ),
                              _buildFooter(
                                orSignupFont: 16.0,
                                buttonWidth: screenSize.width * 0.126,
                                footerTextFontSize: 16.0,
                                sizedBoxHeight1: 35,
                                sizedBoxHeight2: 25,
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
        SizedBox(height: sizedBoxHeight2 ?? 15.0),
        Padding(
          padding: const EdgeInsets.only(bottom: 60.0),
          child: InkWell(
            onTap: () {
              context.push('/resetPassword/enterEmail');
            },
            child: Text(
              "Forgot Password?",
              style: GoogleFonts.hind(
                fontSize: footerTextFontSize,
                fontWeight: FontWeight.w400,
                color: AppColors.textOrange,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
