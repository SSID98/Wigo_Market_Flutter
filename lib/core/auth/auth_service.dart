import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wigo_flutter/shared/models/login/login_request_model.dart';

import '../../shared/models/login/login_response_model.dart';
import 'auth_repository.dart';

class AuthService {
  final AuthRepository repo;

  AuthService(this.repo);

  Future<LoginResponseModel> loginUser(LoginRequestModel request) async {
    final response = await repo.login(request);
    if (response.isSuccess && response.data != null) {
      return response.data!;
    } else {
      throw Exception(response.errorDescription);
    }
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref.read(authRepositoryProvider));
});
