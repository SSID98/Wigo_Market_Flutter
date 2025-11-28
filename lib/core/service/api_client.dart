// import 'package:dio/dio.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
//
// class ApiClient {
//   late Dio dio;
//
//   ApiClient() {
//     dio = Dio(
//       BaseOptions(
//         baseUrl: dotenv.env['BASE_URL']!,
//         connectTimeout: const Duration(seconds: 10),
//         receiveTimeout: const Duration(seconds: 10),
//         headers: {'Content-Type': 'application/json'},
//       ),
//     );
//
//     dio.interceptors.add(
//       LogInterceptor(
//         request: true,
//         requestBody: true,
//         responseBody: true,
//         error: true,
//       ),
//     );
//   }
// }
//
// final apiClient = ApiClient();
