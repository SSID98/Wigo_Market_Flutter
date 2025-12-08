import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const _accountKey = 'hasCompletedAccountCreation';

  final SharedPreferences prefs;

  LocalStorageService(this.prefs);

  Future<void> setAccountCreationCompleted() =>
      prefs.setBool(_accountKey, true);

  static const _pinSetupCompletedKey = 'pinSetupCompleted';

  Future<void> setPinSetupCompleted() async {
    await prefs.setBool(_pinSetupCompletedKey, true);
  }

  bool get isPinSetupCompleted => prefs.getBool(_pinSetupCompletedKey) ?? false;

  // Reset flow
  Future<void> resetFlow() async {
    await prefs.remove(_accountKey);
    await prefs.remove(_pinSetupCompletedKey);
  }
}
