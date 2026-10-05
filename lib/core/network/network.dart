import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../feedback_models/response_status_model.dart';
import '../local/session_manager.dart';
import '../utils/helper_methods_classes.dart';
import 'auth_interceptor.dart';

typedef Reader = T Function<T>(ProviderListenable<T> provider);

typedef JsonMap = Map<String, dynamic>;

class NetworkService {
  late Dio _dio;

  ///Defines a new Network Service for use in the app
  NetworkService({
    required String baseUrl,
    required SessionManager session,
    Map<String, dynamic>? headers,
  }) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 200),
        receiveTimeout: const Duration(seconds: 200),
        headers: headers,
      ),
    );

    /// Logger
    PrettyDioLogger prettyDioLogger = PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90,
    );

    _dio.interceptors.add(prettyDioLogger);

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (options.contentType == null) {
            final dynamic data = options.data;
            final String? contentType;
            if (data is FormData) {
              contentType = Headers.multipartFormDataContentType;
            } else if (data is Map) {
              contentType = Headers.formUrlEncodedContentType;
            } else if (data is String) {
              contentType = Headers.jsonContentType;
            } else if (data != null) {
              contentType = Headers.textPlainContentType;
            } else {
              contentType = null;
            }
            options.contentType = contentType;
          }
          return handler.next(options);
        },
      ),
    );

    _dio.interceptors.add(AuthInterceptor(session, _dio));
  }

  Future<Response> get(String endpoint, {Map<String, dynamic>? query}) async {
    return await _dio.get(endpoint, queryParameters: query);
  }

  Future<Response> post(String endpoint, {dynamic data}) async {
    return await _dio.post(endpoint, data: data);
  }

  Future<Response> patch(String endpoint, {dynamic data}) async {
    return await _dio.patch(endpoint, data: data);
  }

  Future<Response> put(String endpoint, {dynamic data}) async {
    return await _dio.put(endpoint, data: data);
  }

  Future<Response> delete(String endpoint, {dynamic data}) async {
    return await _dio.delete(endpoint, data: data);
  }

  Future<Response> postMultipart(
    String endpoint, {
    required Map<String, dynamic> fields,
    required Map<String, MultipartFile> files,
  }) async {
    FormData formData = FormData();

    // Add fields to the form data
    fields.forEach((key, value) {
      formData.fields.add(MapEntry(key, value.toString()));
    });

    // Add files to the form data
    files.forEach((key, file) {
      formData.files.add(MapEntry(key, file));
    });

    return await _dio.post(endpoint, data: formData);
  }

  Future<ResponseStatusModel<T>> request<T>(
    Future<Response> Function() apiCall, {
    T Function(dynamic json)? parser,
  }) async {
    debugPrint('REQUEST: ${request.toString()}');
    try {
      final response = await apiCall();
      final parsedData = parser != null
          ? parser(response.data)
          : response.data as T;

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('STATUS CODE: ${response.statusCode}');
        debugPrint('RESPONSE DATA: ${response.data}');
        return ResponseStatusModel<T>(
          accessStatus: ResponseStatusEnum.success,
          data: parsedData,
          statusCode: response.statusCode,
        );
      } else {
        final dynamic raw = response.data;
        Map<String, dynamic>? errorJson;

        if (raw is String) {
          try {
            errorJson = jsonDecode(raw) as Map<String, dynamic>;
          } catch (_) {
            errorJson = null;
          }
        } else if (raw is Map<String, dynamic>) {
          errorJson = raw;
        }

        return ResponseStatusModel<T>(
          accessStatus: ResponseStatusEnum.failed,
          errorDescription: errorJson?['message']?.toString(),
          errors: (errorJson?['errors'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList(),
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      List<String>? extractedErrors;
      int? statusCode;

      if (e is DioException) {
        statusCode = e.response?.statusCode;
        if (e.response?.data != null) {
          final dynamic rawData = e.response!.data;

          if (rawData is Map<String, dynamic>) {
            extractedErrors = (rawData['errors'] as List<dynamic>?)
                ?.map((err) => err.toString())
                .toList();
          } else if (rawData is String) {
            try {
              final decoded = jsonDecode(rawData) as Map<String, dynamic>;
              extractedErrors = (decoded['errors'] as List<dynamic>?)
                  ?.map((err) => err.toString())
                  .toList();
            } catch (_) {}
          }
        }
      }

      return ResponseStatusModel<T>(
        accessStatus: ResponseStatusEnum.failed,
        errorDescription: parseError(e),
        errors: extractedErrors,
        statusCode: statusCode,
      );
    }
  }
}

final networkServiceProvider = Provider<NetworkService>((ref) {
  final session = ref.read(sessionManagerProvider);

  return NetworkService(baseUrl: dotenv.env['BASE_URL']!, session: session);
});
