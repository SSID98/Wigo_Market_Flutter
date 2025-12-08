import '../../shared/models/login/login_response_model.dart';

enum AuthStatus { loading, loggedOut, loggedIn }

class AuthState {
  final AuthStatus status;
  final LoginResponseModel? user;
  final String? role; // buyer / rider / seller
  final bool hasOnboarded;

  AuthState({
    required this.status,
    this.user,
    this.role,
    this.hasOnboarded = false,
  });

  factory AuthState.loading() => AuthState(status: AuthStatus.loading);

  factory AuthState.loggedOut({String? role, bool hasOnboarded = false}) =>
      AuthState(
        status: AuthStatus.loggedOut,
        role: role,
        hasOnboarded: hasOnboarded,
      );

  factory AuthState.loggedIn(
    LoginResponseModel user, {
    bool hasOnboarded = true,
  }) => AuthState(
    status: AuthStatus.loggedIn,
    user: user,
    role: user.activeRole,
    hasOnboarded: hasOnboarded,
  );
}
