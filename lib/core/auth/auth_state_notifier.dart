import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wigo_flutter/core/auth/auth_repository.dart';

import '../../shared/models/login/login_response_model.dart';
import '../local/secure_storage.dart';
import 'auth_state.dart';

class AuthStateNotifier extends StateNotifier<AuthState> {
  final SecureStorage storage;
  final AuthRepository authRepository;

  AuthStateNotifier(this.storage, this.authRepository)
    : super(AuthState.loading()) {
    _init();
  }

  Future<void> _init() async {
    final token = await storage.getToken();

    if (token == null) {
      state = AuthState.loggedOut();
      return;
    }

    try {
      final profile = await authRepository.getMe();
      state = AuthState.loggedIn(profile);
    } catch (_) {
      await storage.clear();
      state = AuthState.loggedOut();
    }
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
  return AuthStateNotifier(
    ref.read(secureStorageProvider),
    ref.read(authRepositoryProvider),
  );
});
