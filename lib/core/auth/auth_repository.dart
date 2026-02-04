import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wigo_flutter/core/local/secure_storage.dart';

import '../../shared/models/login/login_request_dto_class.dart';
import '../../shared/models/login/login_response_model.dart';

class AuthRepository {
  final Dio dio;
  final SecureStorage secureStorage;

  AuthRepository(this.secureStorage)
    : dio = Dio(
        BaseOptions(
          baseUrl: dotenv.env['BASE_URL'] ?? '',
          connectTimeout: const Duration(seconds: 20),
          receiveTimeout: const Duration(seconds: 20),
          headers: {"Content-Type": "application/json"},
        ),
      ) {
    _addAuthInterceptor();
  }

  void _addAuthInterceptor() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await secureStorage.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );
  }

  Future<LoginResponseModel> login(LoginRequestDTO dto) async {
    try {
      final resp = await dio.post("/user/login", data: dto.toJson());
      debugPrint('LOGIN REQUEST DATA: ${dto.toJson()}');
      debugPrint('STATUS CODE: ${resp.statusCode}');
      debugPrint('RESPONSE DATA: ${resp.data}');

      return LoginResponseModel.fromJson(resp.data);
    } on DioException catch (e) {
      final data = e.response?.data;

      String errorMessage = 'Login failed';

      if (data is Map<String, dynamic>) {
        errorMessage =
            data['message'] ?? data['msg'] ?? data['error'] ?? errorMessage;
      } else if (data is String) {
        errorMessage = data;
      }
      debugPrint('LOGIN ERROR RAW => ${e.response?.data}');

      throw Exception(errorMessage);
    }
  }

  Future<LoginResponseModel> getMe() async {
    try {
      final resp = await dio.get("/user/me");

      final data = resp.data["data"];

      return LoginResponseModel.fromJson({
        "_id": data["user"]["_id"],
        "status": data["user"]["status"],
        "role": List<String>.from(data["roles"] ?? []),
        "activeRole": data["activeRole"],
        "token": "",
      });
    } on DioException catch (e) {
      debugPrint("Dio error: ${e.message}");
      throw Exception("Session expired: ${e.message}");
    }
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final storage = ref.read(secureStorageProvider);
  return AuthRepository(storage);
});
