import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum OnboardingStage {
  none,
  onboarding,
  registration,
  otp,
  ninVerification,
  bankSetup,
  success,
  completed,
}

class LocalUserController {
  static const _roleKey = 'user_role';
  static const _stageKey = 'onboarding_stage';
  static const _hasOnboardedKey = 'has_onboarded';

  final SharedPreferences prefs;

  LocalUserController(this.prefs);

  // ----------------------------
  // ROLE
  // ----------------------------
  Future<void> saveRole(String role) async {
    await prefs.setString(_roleKey, role);
  }

  String? get role => prefs.getString(_roleKey);

  // ----------------------------
  // ONBOARDING STAGE
  // ----------------------------
  Future<void> saveStage(OnboardingStage stage) async {
    await prefs.setInt(_stageKey, stage.index);
  }

  OnboardingStage get stage {
    final index = prefs.getInt(_stageKey);
    if (index == null || index < 0 || index >= OnboardingStage.values.length) {
      return OnboardingStage.none;
    }
    return OnboardingStage.values[index];
  }

  // ----------------------------
  // HAS ONBOARDED
  // ----------------------------
  Future<void> saveHasOnboarded(bool value) async {
    await prefs.setBool(_hasOnboardedKey, value);
  }

  bool get hasOnboarded => prefs.getBool(_hasOnboardedKey) ?? false;

  // ----------------------------
  // FULL RESET
  // ----------------------------
  Future<void> resetAll() async {
    await prefs.remove(_roleKey);
    await prefs.remove(_stageKey);
    await prefs.remove(_hasOnboardedKey);
  }
}

final localUserControllerProvider = Provider<LocalUserController>((ref) {
  throw UnimplementedError("Initialize in main.dart with SharedPrefs");
});
