import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../feedback_models/response_status_model.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage();

  /// Gets the data associated with the given [key]
  /// If the [key] does not exist, return a failed status
  Future<ResponseStatusModel> getData({required String key}) async {
    if (await _storage.containsKey(key: key)) {
      final data = await _storage.read(key: key);
      return ResponseStatusModel(
        accessStatus: ResponseStatusEnum.success,
        data: data,
      );
    } else {
      return ResponseStatusModel(
        accessStatus: ResponseStatusEnum.failed,
        errorDescription: 'No key found in DB',
        data: null,
      );
    }
  }

  Future<ResponseStatusModel> storeData({
    required String key,
    required String data,
  }) async {
    try {
      await _storage.write(key: key, value: data);
      return ResponseStatusModel(
        accessStatus: ResponseStatusEnum.success,
        data: null,
      );
    } catch (_) {
      return ResponseStatusModel(
        accessStatus: ResponseStatusEnum.failed,
        errorDescription: 'Error storing data',
        data: null,
      );
    }
  }

  Future<ResponseStatusModel> deleteData({required String key}) async {
    try {
      await _storage.delete(key: key);
      return ResponseStatusModel(
        accessStatus: ResponseStatusEnum.success,
        data: null,
      );
    } catch (_) {
      return ResponseStatusModel(
        accessStatus: ResponseStatusEnum.failed,
        errorDescription: 'Error deleting data',
        data: null,
      );
    }
  }

  Future<ResponseStatusModel> clearData() async {
    try {
      await _storage.deleteAll();
      return ResponseStatusModel(
        accessStatus: ResponseStatusEnum.success,
        data: null,
      );
    } catch (_) {
      return ResponseStatusModel(
        accessStatus: ResponseStatusEnum.failed,
        errorDescription: 'Error deleting data',
        data: null,
      );
    }
  }
}

final secureStorageProvider = Provider((ref) => SecureStorage());
