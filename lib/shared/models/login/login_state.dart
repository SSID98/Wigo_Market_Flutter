class LoginState {
  final String? generalError;
  final bool isLoading, agreeToTerms;
  final bool isLoggedIn;
  final bool hasSubmitted;
  final String email;
  final String password;
  final String? errorMessage;

  LoginState({
    this.generalError,
    this.isLoading = false,
    this.agreeToTerms = false,
    this.isLoggedIn = false,
    this.password = '',
    this.email = '',
    this.errorMessage,
    this.hasSubmitted = false,
  });

  LoginState copyWith({
    String? generalError,
    bool? isLoading,
    bool? agreeToTerms,
    bool? isLoggedIn,
    String? email,
    String? password,
    String? errorMessage,
    bool? hasSubmitted,
  }) {
    return LoginState(
      generalError: generalError ?? this.generalError,
      isLoading: isLoading ?? this.isLoading,
      agreeToTerms: agreeToTerms ?? this.agreeToTerms,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      email: email ?? this.email,
      errorMessage: errorMessage ?? this.errorMessage,
      password: password ?? this.password,
      hasSubmitted: hasSubmitted ?? this.hasSubmitted,
    );
  }
}
