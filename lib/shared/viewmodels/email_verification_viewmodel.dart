import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wigo_flutter/core/service/user_api_service.dart';

import '../../core/utils/helper_methods.dart';

class EmailVerificationState {
  final bool isLoading;
  final String? errorMessage;
  final String? otpError;
  final bool isVerified;

  const EmailVerificationState({
    this.isLoading = false,
    this.errorMessage,
    this.otpError,
    this.isVerified = false,
  });

  EmailVerificationState copyWith({
    bool? isLoading,
    String? errorMessage,
    final String? otpError,
    bool? isVerified,
  }) {
    return EmailVerificationState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      otpError: otpError,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}

class EmailVerificationViewModel extends StateNotifier<EmailVerificationState> {
  // final Ref ref;
  final Reader read;
  final UserApiService api;

  EmailVerificationViewModel(this.read, {UserApiService? apiService})
    : api = apiService ?? UserApiService(),
      super(const EmailVerificationState());

  Future<void> verifyCode({
    required String email,
    required String code,
    required BuildContext context,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null, otpError: null);
    showLoadingDialog(context);
    final result = await api.verifyEmail(email: email, code: code);
    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }
    if (result['success'] == true) {
      state = state.copyWith(isLoading: false, isVerified: true);
      return;
    }
    final message = result['message']?.toString() ?? 'Verification failed';

    if (message.toLowerCase().contains('invalid code') || code.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        otpError: 'Invalid verification code',
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Verification failed. Please try again.',
      );
    }
  }
}

final emailVerificationProvider =
    StateNotifierProvider<EmailVerificationViewModel, EmailVerificationState>(
      (ref) => EmailVerificationViewModel(ref.read),
    );

typedef Reader = T Function<T>(ProviderListenable<T> provider);
