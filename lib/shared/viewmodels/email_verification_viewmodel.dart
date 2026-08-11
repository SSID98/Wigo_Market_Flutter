import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';
import 'package:wigo_flutter/core/local/session_manager.dart';
import 'package:wigo_flutter/core/service/user_api_service.dart';
import 'package:wigo_flutter/shared/widgets/custom_banner.dart';

import '../../core/auth/auth_state_notifier.dart';
import '../../core/network/network.dart';
import '../models/email_verification/email_verification_state.dart';
import '../models/login/login_response_model.dart';
import '../widgets/custom_loading_overlay.dart';

class EmailVerificationViewModel extends StateNotifier<EmailVerificationState> {
  final Reader read;
  final UserApiService api;
  final SessionManager session;

  EmailVerificationViewModel(
    this.read,
    this.session, {
    UserApiService? apiService,
  }) : api = apiService ?? read(userApiServiceProvider),
       super(const EmailVerificationState());

  void updateOtpCode(String value) => state = state.copyWith(otpCode: value);

  Future<void> verifyCode({
    required BuildContext context,
    required String email,
    required WidgetRef ref,
  }) async {
    await runWithOverlay(context, () async {
      final code = state.otpCode;

      final isCodeValid = code.length == 6 && code.isNotEmpty;

      if (!isCodeValid) {
        state = state.copyWith(otpError: "Invalid verification code");
        return;
      }

      {
        state = state.copyWith(
          isLoading: true,
          errorMessage: null,
          otpError: null,
        );

        final response = await api.verifyEmail(
          email: email,
          code: state.otpCode,
        );

        if (response.isSuccess && response.data != null) {
          final model = response.data!;

          final loginModel = LoginResponseModel(
            id: model.id,
            token: model.token,
            refreshToken: model.refreshToken,
            activeRole: model.activeRole,
            expiresAt: model.expiresAt,
            email: email,
            role: [model.activeRole],
            status: "verified",
            fullName: "",
            city: "",
            mobile: "",
            state: "",
            address: "",
            image: "",
            hasWallet: false,
          );

          await read(authStateProvider.notifier).login(loginModel, ref);

          state = state.copyWith(isLoading: false, isVerified: true);
          return;
        }

        final message =
            response.errorDescription?.toString() ?? 'Verification failed';

        if (message.toLowerCase().contains('invalid code') ||
            state.otpCode.isEmpty) {
          state = state.copyWith(
            isLoading: false,
            otpError: 'Invalid verification code',
          );
          return;
        } else {
          state = state.copyWith(
            isLoading: false,
            errorMessage:
                response.errorDescription?.toString() ??
                'Verification failed. Please try again.',
          );
          if (!context.mounted) return;

          if (state.errorMessage != null) {
            showErrorBanner(state.errorMessage!, context);
          }
          return;
        }
      }
    }, spinner: SpinKitDualRing(color: AppColors.primaryDarkGreen));
  }
}

final emailVerificationProvider =
    StateNotifierProvider<EmailVerificationViewModel, EmailVerificationState>(
      (ref) => EmailVerificationViewModel(
        ref.read,
        ref.watch(sessionManagerProvider),
      ),
    );
