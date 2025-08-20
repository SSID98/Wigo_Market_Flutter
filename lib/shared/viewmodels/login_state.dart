class LoginState {
  late String? generalError;
  final bool isLoading, agreeToTerms;

  LoginState({
    this.generalError,
    this.isLoading = false,
    this.agreeToTerms = false,
  });

  LoginState copyWith({
    String? generalError,
    bool? isLoading,
    bool? agreeToTerms,
  }) {
    return LoginState(
      generalError: generalError ?? this.generalError,
      isLoading: isLoading ?? this.isLoading,
      agreeToTerms: agreeToTerms ?? this.agreeToTerms,
    );
  }
}
