import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:wigo_flutter/core/local/secure_storage.dart';

class SessionManager {
  final SecureStorage storage;

  SessionManager(this.storage);

  String? _accessToken;
  String? _refreshToken;
  String? _userId;
  String? _activeRole;
  DateTime? _expiresAt;
  bool _isLoggingOut = false;

  Future<bool>? _refreshFuture;

  Future<void> init() async {
    final accessRes = await storage.getData(key: 'access_token');
    final refreshRes = await storage.getData(key: 'ref_token');
    final userRes = await storage.getData(key: 'current_user_id');
    final expiryRes = await storage.getData(key: 'expires_at');
    final activeRl = await storage.getData(key: 'active_role');

    _accessToken = accessRes.data;
    _refreshToken = refreshRes.data;
    _userId = userRes.data;
    _activeRole = activeRl.data;

    if (expiryRes.data != null) {
      _expiresAt = DateTime.tryParse(expiryRes.data!);
    } else {
      _expiresAt = null;
    }
  }

  String? get accessToken => _accessToken;

  String? get refreshToken => _refreshToken;

  String? get userId => _userId;

  String? get activeRole => _activeRole;

  Future<void> saveSession({
    required String userId,
    required String accessToken,
    required String refreshToken,
    required String activeRole,
    DateTime? expiresAt,
  }) async {
    _userId = userId;
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    _expiresAt = expiresAt;
    _activeRole = activeRole;

    await storage.storeData(key: 'current_user_id', data: userId);
    await storage.storeData(key: 'access_token', data: accessToken);
    await storage.storeData(key: 'ref_token', data: refreshToken);
    await storage.storeData(key: 'active_role', data: activeRole);

    if (expiresAt != null) {
      await storage.storeData(key: 'expires_at', data: expiresAt.toString());
    }
  }

  Future<void> clearSession() async {
    if (_isLoggingOut) return;

    _isLoggingOut = true;

    await storage.deleteData(key: 'current_user_id');
    await storage.deleteData(key: 'access_token');
    await storage.deleteData(key: 'ref_token');
    await storage.deleteData(key: 'expires_at');
    await storage.deleteData(key: 'active_role');

    _userId = null;
    _accessToken = null;
    _refreshToken = null;
    _expiresAt = null;

    _isLoggingOut = false;
  }

  bool get isTokenExpired {
    if (_expiresAt == null) return true;

    return DateTime.now().isAfter(
      _expiresAt!.subtract(const Duration(minutes: 1)),
    );
  }

  Future<bool> refreshSession() {
    if (_refreshFuture != null) {
      return _refreshFuture!;
    }

    _refreshFuture = _performRefresh();
    return _refreshFuture!;
  }

  Future<bool> _performRefresh() async {
    try {
      if (_refreshToken == null) return false;

      final dio = Dio(BaseOptions(baseUrl: dotenv.env['BASE_URL']!));

      PrettyDioLogger prettyDioLogger = PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      );

      dio.interceptors.add(prettyDioLogger);

      final response = await dio.post(
        '/user/refresh',
        data: {'refreshToken': _refreshToken},
      );

      final newAccessToken = response.data['token'];
      // final newRefreshToken = response.data['data']['refresh_token'];

      if (_userId == null) return false;

      await saveSession(
        userId: _userId!,
        accessToken: newAccessToken,
        refreshToken: _refreshToken!,
        activeRole: _activeRole!,
      );

      return true;
    } catch (_) {
      return false;
    } finally {
      _refreshFuture = null;
    }
  }

  Future<bool> validateOrRefreshToken() async {
    if (_accessToken == null) return false;

    if (isTokenExpired) {
      return await refreshSession();
    }

    return true;
  }
}

final sessionManagerProvider = Provider<SessionManager>((ref) {
  throw UnimplementedError();
});
