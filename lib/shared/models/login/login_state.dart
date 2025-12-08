class LoginState {
  late String? generalError;
  final bool isLoading, agreeToTerms;
  final bool isLoggedIn;

  LoginState({
    this.generalError,
    this.isLoading = false,
    this.agreeToTerms = false,
    this.isLoggedIn = false,
  });

  LoginState copyWith({
    String? generalError,
    bool? isLoading,
    bool? agreeToTerms,
    bool? isLoggedIn,
  }) {
    return LoginState(
      generalError: generalError ?? this.generalError,
      isLoading: isLoading ?? this.isLoading,
      agreeToTerms: agreeToTerms ?? this.agreeToTerms,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }
}
