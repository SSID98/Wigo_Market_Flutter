import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wigo_flutter/core/service/user_api_service.dart';

class EmailVerificationState {
  final bool isLoading;
  final String? errorMessage;
  final bool isVerified;

  const EmailVerificationState({
    this.isLoading = false,
    this.errorMessage,
    this.isVerified = false,
  });

  EmailVerificationState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isVerified,
  }) {
    return EmailVerificationState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
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

  Future<void> verifyCode({required String email, required String code}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await api.verifyEmail(email: email, code: code);

    if (result['success'] == true) {
      state = state.copyWith(isLoading: false, isVerified: true);
    } else {
      state = state.copyWith(
        isLoading: false,
        errorMessage: result['message'] ?? 'Verification failed',
      );
    }
  }
}

final emailVerificationProvider =
    StateNotifierProvider<EmailVerificationViewModel, EmailVerificationState>(
      (ref) => EmailVerificationViewModel(ref.read),
    );

typedef Reader = T Function<T>(ProviderListenable<T> provider);
