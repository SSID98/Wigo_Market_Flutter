import 'dart:async';

import 'auth_repository.dart';

class FakeAuthRepository implements AuthRepository {
  @override
  Future<String> login({
    required String email,
    required String password,
  }) async {
    // simulate network latency
    await Future.delayed(const Duration(seconds: 1));

    // simulate validations from server
    // valid credentials for demo: user@example.com / password123
    if (email != 'user@example.com') {
      throw AuthException(
        'user_not_found',
        'No account exists for that email.',
      );
    }
    if (password != 'password123') {
      throw AuthException(
        'invalid_credentials',
        'Email or password is incorrect.',
      );
    }

    // success -> return token (string) or user id
    return 'fake_jwt_token_123';
  }
}
