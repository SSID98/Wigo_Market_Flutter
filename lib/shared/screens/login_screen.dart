import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/utils/validation_utils.dart';
import 'package:wigo_flutter/shared/widgets/custom_text_field.dart';

import '../../core/constants/app_colors.dart';
import '../viewmodels/login_state.dart';
import '../viewmodels/login_view_model.dart';
import '../widgets/custom_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  bool _emailHasError = false;
  bool _passwordHasError = false;
  final emailFieldKey = GlobalKey<FormFieldState<String>>();
  final passwordFieldKey = GlobalKey<FormFieldState<String>>();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginViewModelProvider);
    final vm = ref.watch(loginViewModelProvider.notifier);
    final notifier = ref.read(loginViewModelProvider.notifier);
    final screenSize = MediaQuery.of(context).size;
    final isWeb = MediaQuery.of(context).size.width > 600;
    return isWeb
        ? _buildWebLayout(screenSize, vm, state, notifier, context)
        : _buildMobileLayout(screenSize, vm, state, notifier, context);
  }

  //Mobile Layout
  Widget _buildMobileLayout(
    Size screenSize,
    LoginViewModel vm,
    LoginState state,
    LoginViewModel notifier,
    BuildContext context,
  ) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/images/login.png', fit: BoxFit.cover),
            _buildBottomText(17),
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
                            'assets/icons/logo.svg',
                            height: 49,
                            width: 143.86,
                          ),
                        ),
                        const SizedBox(height: 33),
                        _buildBody(
                          loginFontSize: 20.0,
                          topPadding: 0.0,
                          termsFont: 10.0,
                          buttonHeight: 48.0,
                          buttonWidth: 360.0,
                          vm: vm,
                          state: state,
                          context: context,
                          suffixIconPadding: 10.0,
                          loginColor: AppColors.textDarkGreen,
                          termsPadding: 0.0,
                          sizedBoxHeight: 11.0,
                          notifier: notifier,
                          generalErrorFont: 15.0,
                          errorPadding: 10.0,
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
      ),
    );
  }

  Widget _buildWebLayout(
    Size screenSize,
    LoginViewModel vm,
    LoginState state,
    LoginViewModel notifier,
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
                              child: _buildBottomText(24),
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
                        'assets/icons/logo.svg',
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
                                _buildBody(
                                  loginFontSize: 36.0,
                                  topPadding: 0.0,
                                  termsFont: 16.0,
                                  buttonHeight: 50.0,
                                  buttonWidth: 500.0,
                                  vm: vm,
                                  state: state,
                                  context: context,
                                  termsPadding: 12.0,
                                  sizedBoxHeight: 11,
                                  sizedBoxHeight1: 34,
                                  suffixIconPadding: 25,
                                  loginColor: AppColors.textVidaLocaGreen,
                                  notifier: notifier,
                                  generalErrorFont: 16.0,
                                  errorPadding: 0.0,
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
      ),
    );
  }

  Widget _buildBody({
    required double loginFontSize,
    required double topPadding,
    required double termsFont,
    required double buttonHeight,
    required double buttonWidth,
    required LoginViewModel vm,
    required LoginViewModel notifier,
    required BuildContext context,
    required suffixIconPadding,
    required Color loginColor,
    required double termsPadding,
    required double sizedBoxHeight,
    required double generalErrorFont,
    required LoginState state,
    double? sizedBoxHeight1,
    required double errorPadding,
  }) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          Text(
            'Login',
            textAlign: TextAlign.center,
            style: GoogleFonts.hind(
              fontSize: loginFontSize,
              fontWeight: FontWeight.w700,
              color: loginColor,
            ),
          ),
          const SizedBox(height: 10.0),
          CustomTextField(
            fieldKey: emailFieldKey,
            label: 'Email',
            iconHeight: 15,
            iconWidth: 15,
            prefixIcon: 'assets/icons/mail.svg',
            hintText: 'Enter your email',
            hintTextColor: AppColors.textIconGrey,
            controller: vm.emailController,
            onFocusChange: (hasFocus) {
              if (!hasFocus) {
                final error = FormValidators.validateEmail(
                  vm.emailController.text,
                );

                setState(() {
                  _emailHasError = error != null;
                });
                emailFieldKey.currentState!.validate();
              }
            },
            validator: FormValidators.validateEmail,
            hasError: _emailHasError,
          ),
          const SizedBox(height: 25.0),
          CustomTextField(
            fieldKey: passwordFieldKey,
            label: 'Password',
            isPassword: true,
            iconHeight: 15,
            iconWidth: 15,
            prefixIcon: 'assets/icons/lock.svg',
            hintText: 'Enter your password',
            hintTextColor: AppColors.textIconGrey,
            suffixIcon: Icon(Icons.visibility_outlined),
            controller: vm.passwordController,
            suffixIconPadding: suffixIconPadding,
            hasError: _passwordHasError,
            onFocusChange: (hasFocus) {
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
            validator: FormValidators.validatePassword,
          ),
          const SizedBox(height: 12),
          Padding(
            padding: EdgeInsets.all(termsPadding),
            child: Row(
              children: [
                Transform.scale(
                  scale: 0.8,
                  child: SizedBox(
                    height: sizedBoxHeight,
                    width: 10,
                    child: Checkbox(
                      activeColor: AppColors.primaryDarkGreen,
                      value: state.agreeToTerms,
                      onChanged: vm.toggleAgreeToTerms,
                      side: BorderSide(color: AppColors.textIconGrey),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "I agree to wiGO MARKET ",
                          style: GoogleFonts.hind(
                            fontSize: termsFont,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textBlackLight,
                          ),
                        ),
                        TextSpan(
                          text: "Terms of services",
                          style: GoogleFonts.hind(
                            fontSize: termsFont,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textOrange,
                          ),
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = () {
                                  // Handle terms tap
                                },
                        ),
                        TextSpan(
                          text: " and ",
                          style: GoogleFonts.hind(
                            fontSize: termsFont,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textBlackLight,
                          ),
                        ),
                        TextSpan(
                          text: "Privacy Policy",
                          style: GoogleFonts.hind(
                            fontSize: termsFont,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textOrange,
                          ),
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = () {
                                  // Handle privacy tap
                                },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (state.generalError != null)
            Padding(
              padding: EdgeInsets.only(top: errorPadding),
              child: Text(
                state.generalError!,
                style: GoogleFonts.hind(
                  fontSize: generalErrorFont,
                  fontWeight: FontWeight.w400,
                  color: AppColors.accentRed,
                ),
              ),
            ),
          const SizedBox(height: 44.0),
          CustomButton(
            text: 'Login',
            onPressed: () {
              final emailHasError = FormValidators.validateEmail(
                vm.emailController.text,
              );
              final passwordHasError = FormValidators.validatePassword(
                vm.passwordController.text,
              );
              setState(() {
                state.generalError = null;
                _emailHasError = emailHasError != null;
                _passwordHasError = passwordHasError != null;
              });
              vm.login(formKey);
            },
            fontSize: 18,
            fontWeight: FontWeight.w500,
            height: buttonHeight,
            width: buttonWidth,
          ),
          SizedBox(height: sizedBoxHeight1 ?? 24),
        ],
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
                  color: AppColors.textBlackLight,
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
            CustomButton(
              text: 'Google',
              onPressed: () {},
              fontSize: 16,
              fontWeight: FontWeight.w500,
              borderRadius: 6.0,
              height: 50,
              width: buttonWidth,
              prefixIcon: 'assets/icons/google.svg',
              textColor: AppColors.textBlackLight,
              buttonColor: AppColors.buttonLighterGreen,
              borderColor: AppColors.buttonLightGreen,
              borderWidth: 1,
            ),
            const SizedBox(width: 10.0),
            CustomButton(
              text: 'Facebook',
              onPressed: () {},
              fontSize: 16,
              fontWeight: FontWeight.w500,
              borderRadius: 6.0,
              height: 50,
              width: buttonWidth,
              prefixIcon: 'assets/icons/facebook.svg',
              textColor: AppColors.textBlackLight,
              buttonColor: AppColors.buttonLighterGreen,
              borderColor: AppColors.buttonLightGreen,
              borderWidth: 1,
            ),
          ],
        ),
        SizedBox(height: sizedBoxHeight2 ?? 15.0),
        Padding(
          padding: const EdgeInsets.only(bottom: 60.0),
          child: Text(
            "Forgot Password?",
            style: GoogleFonts.hind(
              fontSize: footerTextFontSize,
              fontWeight: FontWeight.w400,
              color: AppColors.textOrange,
            ),
          ),
        ),
      ],
    );
  }

  // Bottom text gradient overlay
  Widget _buildBottomText(double textSize) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: ClipRect(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 15.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.transparent),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.center,
              colors: [
                Colors.black.withValues(alpha: 0.1),
                // Start with more transparent black
                Colors.black.withValues(alpha: 0.8),
                // End with more opaque black
              ],
              stops: const [0.0, 1.0],
            ),
          ),
          child: Text(
            'WIGOMARKET connects students, sellers, and local businesses—shop, earn, and grow on one seamless platform.',
            textAlign: TextAlign.left,
            style: GoogleFonts.hind(
              textStyle: TextStyle(
                color: AppColors.textWhite,
                fontSize: textSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
