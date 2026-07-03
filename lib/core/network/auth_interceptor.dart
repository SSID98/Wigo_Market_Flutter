import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../local/session_manager.dart';

class AuthInterceptor extends Interceptor {
  final SessionManager session;
  final Dio dio;

  AuthInterceptor(this.session, this.dio);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = session.accessToken;

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final request = err.requestOptions;

    // Don't retry refresh endpoint
    if (request.path.contains('/user/refresh')) {
      await session.clearSession();
      return handler.next(err);
    }

    // Prevent infinite loop
    final alreadyRetried = request.extra['retried'] == true;

    if (err.response?.statusCode == 401 && !alreadyRetried) {
      final success = await session.refreshSession();

      if (success) {
        final newToken = session.accessToken;

        request.headers['Authorization'] = 'Bearer $newToken';
        request.extra['retried'] = true;

        try {
          final response = await dio.fetch(request);
          return handler.resolve(response);
        } catch (e) {
          return handler.next(e as DioException);
        }
      } else {
        await session.clearSession();
      }
    }

    return handler.next(err);
  }
}

final authInterceptorProvider = Provider<Dio>((ref) {
  final dio = Dio();
  final session = ref.watch(sessionManagerProvider);

  dio.interceptors.add(AuthInterceptor(session, dio));

  return dio;
});
