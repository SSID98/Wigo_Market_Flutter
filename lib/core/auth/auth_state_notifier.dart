import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/models/login/login_response_model.dart';
import '../local/secure_storage.dart';
import 'auth_state.dart';

class AuthStateNotifier extends StateNotifier<AuthState> {
  final SecureStorage storage;

  AuthStateNotifier(this.storage) : super(AuthState.loading()) {
    _init();
  }

  Future<void> _init() async {
    final hasOnboarded = await storage.getHasOnboarded();
    final savedRole = await storage.getRole();
    final token = await storage.getToken();

    // FIRST APP OPEN → role selection
    if (!hasOnboarded) {
      state = AuthState.loggedOut(role: savedRole, hasOnboarded: false);
      return;
    }

    // NO TOKEN BUT ALREADY OPENED BEFORE
    if (token == null) {
      state = AuthState.loggedOut(role: savedRole, hasOnboarded: true);
      return;
    }

    // TOKEN EXISTS → user logged in
    state = AuthState.loggedIn(
      LoginResponseModel(
        id: await storage.getUserId() ?? '',
        activeRole: savedRole ?? '',
        token: token,
        role: [],
        status: '',
      ),
      hasOnboarded: true,
    );
  }

  Future<void> login(LoginResponseModel model) async {
    await storage.saveToken(model.token);
    await storage.saveUserId(model.id);
    await storage.saveRole(model.activeRole);

    state = AuthState.loggedIn(model);
  }

  Future<void> logout() async {
    await storage.clear();
    state = AuthState.loggedOut();
  }
}

final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>((
  ref,
) {
  return AuthStateNotifier(ref.read(secureStorageProvider));
});
