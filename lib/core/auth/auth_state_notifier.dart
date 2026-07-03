import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:wigo_flutter/core/auth/auth_repository.dart';

import '../../shared/models/login/login_response_model.dart';
import '../feedback_models/response_status_model.dart';
import '../local/session_manager.dart';
import 'auth_state.dart';

class AuthStateNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository;
  final SessionManager session;

  AuthStateNotifier(this.authRepository, this.session)
    : super(AuthState.loading()) {
    init();
  }

  Future<void> init() async {
    final authToken = session.accessToken;

    if (authToken == null) {
      state = AuthState.loggedOut();
      return;
    }

    try {
      final response = await authRepository.getMe();

      if (response.accessStatus == ResponseStatusEnum.success &&
          response.data != null) {
        state = AuthState.loggedIn(response.data!);
      } else {
        throw Exception(response.errorDescription);
      }
    } catch (e) {
      debugPrint("Failed to fetch full profile on startup: $e");

      if (session.userId != null) {
        final fallbackModel = LoginResponseModel(
          id: session.userId!,
          token: session.accessToken!,
          refreshToken: session.refreshToken ?? '',
          activeRole: session.activeRole ?? '',
          expiresAt: '',
          email: '',
          role: [session.activeRole ?? ''],
          status: "mid_onboarding",
          fullName: "",
          city: "",
          mobile: "",
          state: "",
          address: "",
          image: "",
          hasWallet: false,
        );

        state = AuthState.loggedIn(fallbackModel);
      } else {
        await session.clearSession();
        state = AuthState.loggedOut();
      }
    }
  }

  Future<void> login(LoginResponseModel model) async {
    await session.saveSession(
      userId: model.id,
      accessToken: model.token,
      refreshToken: model.refreshToken,
      activeRole: model.activeRole,
      expiresAt: DateTime.tryParse(model.expiresAt) ?? DateTime.now(),
    );

    try {
      // 2. Immediately fetch the full profile data
      final response = await authRepository.getMe();

      // 3. Update the state with the FULL data (including the token from the login model)
      if (response.isSuccess && response.data != null) {
        final fullProfile = response.data!;
        state = AuthState.loggedIn(fullProfile.copyWith(token: model.token));
      } else {
        throw Exception(response.errorDescription);
      }
    } catch (e) {
      state = AuthState.loggedIn(model);
      debugPrint("Failed to fetch full profile after login: $e");
    }
  }

  Future<void> logout() async {
    await session.clearSession();
    state = AuthState.loggedOut();
  }
}

final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>((
  ref,
) {
  return AuthStateNotifier(
    ref.read(authRepositoryProvider),
    ref.watch(sessionManagerProvider),
  );
});
