class EmailVerificationState {
  final bool isLoading;
  final String? errorMessage;
  final String? otpError;
  final bool isVerified;
  final String otpCode;

  const EmailVerificationState({
    this.isLoading = false,
    this.errorMessage,
    this.otpError,
    this.isVerified = false,
    this.otpCode = '',
  });

  EmailVerificationState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? otpError,
    bool? isVerified,
    String? otpCode,
  }) {
    return EmailVerificationState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      otpError: otpError,
      isVerified: isVerified ?? this.isVerified,
      otpCode: otpCode ?? this.otpCode,
    );
  }
}
