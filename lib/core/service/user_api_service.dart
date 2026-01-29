import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserApiService {
  final Dio _dio;

  UserApiService({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: dotenv.env['BASE_URL'] ?? '',
              connectTimeout: const Duration(seconds: 15),
              receiveTimeout: const Duration(seconds: 15),
              headers: {'Content-Type': 'application/json'},
            ),
          );

  Future<Map<String, dynamic>> registerRider(
    Map<String, dynamic> payload,
  ) async {
    try {
      final resp = await _dio.post('/user/register/delivery', data: payload);
      if (resp.statusCode != null &&
          resp.statusCode! >= 200 &&
          resp.statusCode! < 300) {
        return {"success": true, "data": resp.data};
      } else {
        return {
          "success": false,
          "message": resp.data?['message'] ?? 'Unknown error',
        };
      }
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ?? e.message;
      return {"success": false, "message": "Network/API error: $msg"};
    } catch (e) {
      return {"success": false, "message": "Unexpected error: $e"};
    }
  }

  Future<Map<String, dynamic>> registerBuyer(
    Map<String, dynamic> payload,
  ) async {
    try {
      final resp = await _dio.post('/user/register/buyer', data: payload);
      if (resp.statusCode != null &&
          resp.statusCode! >= 200 &&
          resp.statusCode! < 300) {
        return {"success": true, "data": resp.data};
      } else {
        return {
          "success": false,
          "message": resp.data?['message'] ?? 'Unknown error',
        };
      }
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ?? e.message;
      return {"success": false, "message": "Network/API error: $msg"};
    } catch (e) {
      return {"success": false, "message": "Unexpected error: $e"};
    }
  }

  Future<Map<String, dynamic>> registerSeller(
    Map<String, dynamic> payload,
  ) async {
    try {
      final resp = await _dio.post('/user/register/seller', data: payload);
      if (resp.statusCode != null &&
          resp.statusCode! >= 200 &&
          resp.statusCode! < 300) {
        return {"success": true, "data": resp.data};
      } else {
        return {
          "success": false,
          "message": resp.data?['message'] ?? 'Unknown error',
        };
      }
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ?? e.message;
      return {"success": false, "message": "Network/API error: $msg"};
    } catch (e) {
      return {"success": false, "message": "Unexpected error: $e"};
    }
  }

  Future<Map<String, dynamic>> verifyEmail({
    required String email,
    required String code,
  }) async {
    try {
      final resp = await _dio.post(
        '/user/verify',
        data: {"email": email, "code": code},
      );

      final data = resp.data;

      if (data is Map<String, dynamic> && data['success'] == true) {
        return {"success": true, "data": data};
      } else {
        return {
          "success": false,
          "message": data?['msg'] ?? 'Invalid or expired code',
        };
      }
    } on DioException catch (e) {
      final msg = e.response?.data?['msg'] ?? e.message;
      return {"success": false, "message": "Network/API error: $msg"};
    } catch (e) {
      return {"success": false, "message": "Unexpected error: $e"};
    }
  }
}

final userApiServiceProvider = Provider<UserApiService>((ref) {
  return UserApiService();
});
