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
    final token = await storage.getToken();

    // NO TOKEN BUT ALREADY OPENED BEFORE
    if (token == null) {
      state = AuthState.loggedOut();
      return;
    }

    final userId = await storage.getUserId();
    final role = await storage.getRole();

    // TOKEN EXISTS → user logged in
    state = AuthState.loggedIn(
      LoginResponseModel(
        id: userId ?? '',
        activeRole: role ?? '',
        token: token,
        role: [],
        status: '',
      ),
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
