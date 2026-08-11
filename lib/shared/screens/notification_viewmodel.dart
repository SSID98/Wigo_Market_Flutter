import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../core/local/secure_storage.dart';
import '../../core/network/network.dart';
import '../../features/rider/models/rider_notification_state.dart';
import '../../features/rider/service/rider_api_service.dart';

class NotificationViewModel extends StateNotifier<NotificationState> {
  final Reader read;
  final RiderApiService api;
  final SecureStorage _storage = SecureStorage();

  static const String _notifFetchedKey = 'rider_notif_fetched_once';
  static const String _notifCacheKey = 'rider_notif_cache';

  NotificationViewModel(this.read, {RiderApiService? apiService})
    : api = apiService ?? read(riderApiServiceProvider),
      super(const NotificationState());

  void togglePush(bool newValue) =>
      state = state.copyWith(pushNotify: newValue);

  void toggleSms(bool newValue) => state = state.copyWith(smsNotify: newValue);

  void toggleEmail(bool newValue) =>
      state = state.copyWith(emailNotify: newValue);

  void clearError() => state = state.copyWith(errorMessage: null);

  void enterEditMode() => state = state.copyWith(isEditMode: true);

  void exitEditMode() {
    _loadFromCache();
    state = state.copyWith(isEditMode: false);
  }

  Future<void> fetchPreferencesIfNeeded(BuildContext context) async {
    final fetchedOnce = await _storage.getData(key: _notifFetchedKey);

    if (fetchedOnce.data == "true") {
      await _loadFromCache();
      return;
    }

    if (!context.mounted) return;
    await _fetchPreferencesWithRetry(context, maxAttempts: 3);
  }

  Future<void> _fetchPreferencesWithRetry(
    BuildContext context, {
    required int maxAttempts,
  }) async {
    state = state.copyWith(loadStatus: NotificationLoadStatus.loading);

    for (int attempt = 1; attempt <= maxAttempts; attempt++) {
      final result = await api.getNotificationPreferences();

      if (result.isSuccess && result.data != null) {
        await _markFetchedOnce();
        await _cachePreferences(result.data!);
        _populateFromProfile(result.data!);

        state = state.copyWith(
          loadStatus: NotificationLoadStatus.loaded,
          hasData: true,
          isEditMode: false,
        );
        return;
      }

      if (attempt < maxAttempts) {
        await Future.delayed(Duration(seconds: attempt));
      }
    }

    await _markFetchedOnce();
    state = state.copyWith(loadStatus: NotificationLoadStatus.error);
  }

  Future<void> _loadFromCache() async {
    final cachedJson = await _storage.getData(key: _notifCacheKey);

    if (!cachedJson.isSuccess || cachedJson.data == null) {
      state = state.copyWith(
        loadStatus: NotificationLoadStatus.notFound,
        hasData: false,
        isEditMode: true,
      );
      return;
    }

    try {
      final data = jsonDecode(cachedJson.data) as Map<String, dynamic>;
      _populateFromProfile(data);
      state = state.copyWith(
        loadStatus: NotificationLoadStatus.loaded,
        hasData: true,
        isEditMode: false,
      );
    } catch (_) {
      state = state.copyWith(
        loadStatus: NotificationLoadStatus.notFound,
        hasData: false,
        isEditMode: true,
      );
    }
  }

  Future<void> _markFetchedOnce() =>
      _storage.storeData(key: _notifFetchedKey, data: 'true');

  Future<void> _cachePreferences(Map<String, dynamic> data) =>
      _storage.storeData(key: _notifCacheKey, data: jsonEncode(data));

  void _populateFromProfile(Map<String, dynamic> data) {
    final push = data['pushNotifications']?['enabled'] ?? false;
    final sms = data['smsNotifications']?['enabled'] ?? false;
    final email = data['emailNotifications']?['enabled'] ?? false;

    state = state.copyWith(
      pushNotify: push,
      smsNotify: sms,
      emailNotify: email,
    );
  }

  Map<String, dynamic> _buildPayload() {
    return {
      "pushNotifications": {"enabled": state.pushNotify},
      "emailNotifications": {"enabled": state.emailNotify},
      "smsNotifications": {"enabled": state.smsNotify},
    };
  }

  Future<bool> updatePreferences() async {
    state = state.copyWith(isLoading: true, errorMessage: null, success: false);

    try {
      final payload = _buildPayload();
      final result = await api.updateNotificationPreferences(payload);

      if (result.isSuccess == true) {
        await _cachePreferences(state.toJson());

        state = state.copyWith(
          isLoading: false,
          success: true,
          hasData: true,
          isEditMode: false,
          loadStatus: NotificationLoadStatus.loaded,
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: result.errorDescription?.toString(),
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }
}

final notificationViewModelProvider =
    StateNotifierProvider<NotificationViewModel, NotificationState>(
      (ref) => NotificationViewModel(ref.read),
    );
