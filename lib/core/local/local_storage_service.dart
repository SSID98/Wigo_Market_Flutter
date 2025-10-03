import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const _roleKey = 'hasCompletedRoleSelection';
  static const _onboardingKey = 'hasCompletedOnboarding';
  static const _accountKey = 'hasCompletedAccountCreation';

  final SharedPreferences prefs;

  LocalStorageService(this.prefs);

  // Role selection
  bool get hasCompletedRoleSelection => prefs.getBool(_roleKey) ?? false;

  Future<void> setRoleCompleted() => prefs.setBool(_roleKey, true);

  // Onboarding
  bool get hasCompletedOnboarding => prefs.getBool(_onboardingKey) ?? false;

  Future<void> setOnboardingCompleted() => prefs.setBool(_onboardingKey, true);

  // Account creation
  bool get hasCompletedAccountCreation => prefs.getBool(_accountKey) ?? false;

  Future<void> setAccountCreationCompleted() =>
      prefs.setBool(_accountKey, true);

  // Reset flow
  Future<void> resetFlow() async {
    await prefs.remove(_roleKey);
    await prefs.remove(_onboardingKey);
    await prefs.remove(_accountKey);
  }
}
