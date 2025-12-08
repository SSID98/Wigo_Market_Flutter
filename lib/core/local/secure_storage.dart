import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'token', value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  Future<void> saveUserId(String id) async {
    await _storage.write(key: 'userId', value: id);
  }

  Future<String?> getUserId() async {
    return await _storage.read(key: 'userId');
  }

  Future<void> saveRole(String role) async {
    await _storage.write(key: 'role', value: role);
  }

  Future<String?> getRole() async {
    return await _storage.read(key: 'role');
  }

  Future<void> clear() async {
    await _storage.deleteAll();
  }

  // STORE FIRST TIME FLAG
  Future<void> saveHasOnboarded() async {
    await _storage.write(key: 'hasOnboarded', value: 'true');
  }

  Future<bool> getHasOnboarded() async {
    return await _storage.read(key: 'hasOnboarded') == 'true';
  }
}

final secureStorageProvider = Provider((ref) => SecureStorage());
