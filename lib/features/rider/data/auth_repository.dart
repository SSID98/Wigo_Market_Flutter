// abstract class AuthRepository {
//   /// Attempts to login. On success returns a token (or user DTO).
//   /// On failure throws AuthException.
//   Future<String> login({required String email, required String password});
// }
//
// class AuthException implements Exception {
//   final String code;
//   final String message;
//
//   AuthException(this.code, this.message);
//
//   @override
//   String toString() => 'AuthException($code): $message';
// }
