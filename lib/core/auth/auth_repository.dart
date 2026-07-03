import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wigo_flutter/core/feedback_models/response_status_model.dart';

import '../../shared/models/login/login_request_model.dart';
import '../../shared/models/login/login_response_model.dart';
import '../network/network.dart';

class AuthRepository {
  final NetworkService _networkService;

  AuthRepository(this._networkService);

  Future<ResponseStatusModel<LoginResponseModel>> login(
    LoginRequestModel request,
  ) {
    return _networkService.request<LoginResponseModel>(
      () => _networkService.post("/user/login", data: request.toJson()),
      parser: (json) => LoginResponseModel.fromJson(json),
    );
  }

  Future<ResponseStatusModel<LoginResponseModel>> getMe() async {
    return _networkService.request<LoginResponseModel>(
      () => _networkService.get("/user/me"),
      parser: (json) => LoginResponseModel.fromJson(json["data"]),
    );
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.read(networkServiceProvider));
});
