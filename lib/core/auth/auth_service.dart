import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/models/login/login_request_DTO.dart';
import '../../shared/models/login/login_response_model.dart';
import 'auth_repository.dart';

class AuthService {
  final AuthRepository repo;

  AuthService(this.repo);

  Future<LoginResponseModel> loginUser(LoginRequestDTO dto) async {
    return await repo.login(dto);
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref.read(authRepositoryProvider));
});
