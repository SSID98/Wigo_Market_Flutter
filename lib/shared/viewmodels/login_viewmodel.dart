import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';
import 'package:wigo_flutter/shared/widgets/custom_banner.dart';

import '../../core/auth/auth_service.dart';
import '../../core/auth/auth_state_notifier.dart';
import '../../core/local/local_user_controller.dart';
import '../../core/utils/validation_utils.dart';
import '../models/login/login_request_model.dart';
import '../models/login/login_state.dart';
import '../widgets/custom_loading_overlay.dart';

class LoginViewModel extends StateNotifier<LoginState> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService auth;
  final Ref ref;

  LoginViewModel(this.auth, this.ref) : super(LoginState());

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void updateEmail(String value) {
    state = state.copyWith(email: value);
  }

  void updatePassword(String value) {
    state = state.copyWith(password: value);
  }

  void validateOnSubmit() {
    final emailError = FormValidators.validateEmail(state.email);
    final passwordError = FormValidators.validateSignupPassword(state.password);

    String? errorMessage;
    if (emailError != null || passwordError != null) {
      errorMessage = 'Please fix the input error';
    }

    state = state.copyWith(hasSubmitted: true, errorMessage: errorMessage);
  }

  Future<bool> login(BuildContext context, WidgetRef ref) async {
    validateOnSubmit();

    final passwordError = FormValidators.validateSignupPassword(state.password);
    final emailError = FormValidators.validateEmail(state.email);

    if (emailError != null || passwordError != null) {
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await runWithOverlay<bool>(context, () async {
      final loginRequest = LoginRequestModel(
        email: state.email,
        password: state.password,
      );

      try {
        final response = await auth.loginUser(loginRequest);

        await ref
            .read(localUserControllerProvider.notifier)
            .loginAfterOnboarding(response.activeRole);

        ref.read(authStateProvider.notifier).login(response, ref);

        return true;
      } catch (e) {
        if (e.toString().toLowerCase().contains("invalid credentials") &&
            context.mounted) {
          showErrorBanner("Invalid Credentials", context);
        }

        return false;
      }
    }, spinner: SpinKitDualRing(color: AppColors.primaryDarkGreen));
    return result;
  }
}

final loginViewModelProvider =
    StateNotifierProvider.autoDispose<LoginViewModel, LoginState>((ref) {
      return LoginViewModel(ref.read(authServiceProvider), ref);
    });
