import '../../shared/models/login/login_response_model.dart';

enum AuthStatus { loading, loggedOut, loggedIn }

class AuthState {
  final AuthStatus status;
  final LoginResponseModel? user;

  AuthState({required this.status, this.user});

  factory AuthState.loading() => AuthState(status: AuthStatus.loading);

  factory AuthState.loggedOut() => AuthState(status: AuthStatus.loggedOut);

  factory AuthState.loggedIn(LoginResponseModel user) =>
      AuthState(status: AuthStatus.loggedIn, user: user);
}
