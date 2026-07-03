import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/local/secure_storage.dart';
import '../../core/network/network.dart';
import '../../core/service/user_api_service.dart';
import '../../core/utils/validation_utils.dart';
import '../models/reset_password_state.dart';
import '../widgets/custom_banner.dart';
import '../widgets/custom_loading_overlay.dart';

class ResetPasswordViewmodel extends StateNotifier<ResetPasswordState> {
  final Reader read;
  final UserApiService api;

  ResetPasswordViewmodel(this.read, {UserApiService? apiService})
    : api = apiService ?? read(userApiServiceProvider),
      super(const ResetPasswordState());

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void updateEmail(String value) {
    state = state.copyWith(email: value);
  }

  void updateCode(String value) {
    state = state.copyWith(code: value);
  }

  void updatePassword(String value) {
    state = state.copyWith(password: value);
  }

  void updateConfirmPassword(String value) {
    state = state.copyWith(confirmPassword: value);
  }

  void toggleRememberMe(bool? value) {
    state = state.copyWith(rememberMe: value ?? false);
  }

  Future<bool> requestPasswordToken(BuildContext context) async {
    final localError = FormValidators.validateEmail(state.email);

    if (localError != null) {
      state = state.copyWith(emailError: localError);
      return false;
    }

    state = state.copyWith(isLoading: true, emailError: null);

    final result = await runWithOverlay(context, () async {
      final response = await api.forgotPassword(state.email);

      if (response.isSuccess) {
        final storage = SecureStorage();
        await storage.storeData(key: "resetEmail", data: state.email);
        if (context.mounted) {
          context.push('/resetPassword/verification');
        }
        state = state.copyWith(isLoading: false);
        return true;
      } else {
        if (response.errorDescription != null &&
            response.errorDescription.toString().contains('email')) {
          state = state.copyWith(
            emailError: response.errorDescription.toString(),
          );
        } else {
          if (context.mounted) {
            showErrorBanner(response.errorDescription.toString(), context);
          }
        }
        return false;
      }
    }, spinner: SpinKitDualRing(color: AppColors.primaryDarkGreen));

    return result;
  }

  Future<void> verifyToken({required BuildContext context}) async {
    final code = state.code;

    final isCodeValid = code.length == 6 && code.isNotEmpty;

    if (!isCodeValid) {
      state = state.copyWith(codeError: "Invalid verification code");
      return;
    }

    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      codeError: null,
    );

    await runWithOverlay(context, () async {
      final response = await api.verifyToken(
        email: state.email,
        code: state.code,
      );
      if (response.isSuccess && response.data != null) {
        final resetToken = response.data!["resetSession"];

        state = state.copyWith(token: resetToken);

        if (!context.mounted) return;

        context.go('/changePassword');

        state = state.copyWith(isLoading: false);

        return;
      }
      final message =
          response.errorDescription?.toString() ?? 'Verification failed';

      if (message.toLowerCase().contains('invalid code')) {
        state = state.copyWith(
          isLoading: false,
          codeError: 'Invalid verification code',
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Verification failed. Please try again.',
        );
        if (!context.mounted) return;
        showErrorBanner(state.errorMessage!, context);
      }
    }, spinner: SpinKitDualRing(color: AppColors.primaryDarkGreen));
  }

  void validateOnSubmit() {
    final passwordError = FormValidators.validateSignupPassword(state.password);

    final confirmPasswordError = FormValidators.validatePassword(
      state.confirmPassword,
    );

    final passwordMismatch = state.password != state.confirmPassword;

    String? errorMessage;

    if (passwordError != null ||
        confirmPasswordError != null ||
        passwordMismatch) {
      errorMessage = 'Please fix the Password error';
    }

    state = state.copyWith(hasSubmitted: true, errorMessage: errorMessage);
  }

  Future<bool> resetUserPassword({required BuildContext context}) async {
    validateOnSubmit();

    final passwordError = FormValidators.validatePassword(state.password);
    final confirmPasswordError = FormValidators.validatePassword(
      state.confirmPassword,
    );

    final passwordMismatch = state.password != state.confirmPassword;

    if (confirmPasswordError != null ||
        passwordError != null ||
        passwordMismatch ||
        state.errorMessage != null) {
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await runWithOverlay<bool>(context, () async {
      try {
        final response = await api.resetPassword(
          email: state.email,
          resetSession: state.token,
          password: state.password,
        );

        state = state.copyWith(isLoading: false);

        if (response.isSuccess && context.mounted) {
          showSuccessBanner("Password Successfully Reset", context);
          context.go('/login');
          state = state.copyWith(isLoading: false);
          return true;
        } else {
          state = state.copyWith(
            isLoading: false,
            errorMessage: response.errorDescription,
          );

          if (context.mounted) {
            showErrorBanner(state.errorMessage!, context);
          }
          return false;
        }
      } catch (e) {
        state.copyWith(isLoading: false, errorMessage: e.toString());
        if (context.mounted) {
          showErrorBanner(state.errorMessage!, context);
        }
        return false;
      }
    }, spinner: SpinKitDualRing(color: AppColors.primaryDarkGreen));
    return result;
  }
}

final resetPasswordVerificationProvider =
    StateNotifierProvider<ResetPasswordViewmodel, ResetPasswordState>(
      (ref) => ResetPasswordViewmodel(ref.read),
    );
