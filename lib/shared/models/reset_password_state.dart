class ResetPasswordState {
  final String? emailError;
  final bool isLoading;
  final String email;
  final String? errorMessage;
  final String code;
  final String token;
  final String? codeError;
  final bool rememberMe;
  final String password;
  final String confirmPassword;
  final bool hasSubmitted;

  const ResetPasswordState({
    this.emailError,
    this.isLoading = false,
    this.email = '',
    this.codeError,
    this.code = '',
    this.errorMessage,
    this.token = '',
    this.rememberMe = false,
    this.password = '',
    this.confirmPassword = '',
    this.hasSubmitted = false,
  });

  ResetPasswordState copyWith({
    String? emailError,
    bool? isLoading,
    String? email,
    String? code,
    String? codeError,
    String? errorMessage,
    String? token,
    bool? rememberMe,
    String? password,
    String? confirmPassword,
    bool? hasSubmitted,
  }) {
    return ResetPasswordState(
      emailError: emailError,
      isLoading: isLoading ?? this.isLoading,
      email: email ?? this.email,
      codeError: codeError,
      code: code ?? this.code,
      errorMessage: errorMessage,
      token: token ?? this.token,
      rememberMe: rememberMe ?? this.rememberMe,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      hasSubmitted: hasSubmitted ?? this.hasSubmitted,
    );
  }
}
