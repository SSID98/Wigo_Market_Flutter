import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/models/login/login_request_DTO.dart';
import '../../shared/models/login/login_response_model.dart';

class AuthRepository {
  final Dio dio;

  AuthRepository(String baseUrl)
    : dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 20),
          receiveTimeout: const Duration(seconds: 20),
          headers: {"Content-Type": "application/json"},
        ),
      );

  Future<LoginResponseModel> login(LoginRequestDTO dto) async {
    try {
      final resp = await dio.post("/api/user/login", data: dto.toJson());

      return LoginResponseModel.fromJson(resp.data);
    } on DioException catch (e) {
      final message = e.response?.data?["message"] ?? e.message;
      throw Exception("Login failed: $message");
    }
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final baseUrl = const String.fromEnvironment("BASE_URL"); // OR dotenv
  return AuthRepository(baseUrl);
});
