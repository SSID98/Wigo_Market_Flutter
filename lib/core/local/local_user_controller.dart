import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum OnboardingStage {
  none,
  welcome,
  onboarding,
  registration,
  otp,
  ninVerification,
  businessInfo,
  bankSetup,
  success,
  completed,
}

class LocalUserState {
  final String? role;
  final OnboardingStage stage;
  final bool hasOnboarded;
  final String? email;
  final bool justCompletedOnboarding;

  LocalUserState({
    this.role,
    this.stage = OnboardingStage.none,
    this.hasOnboarded = false,
    this.email,
    this.justCompletedOnboarding = false,
  });

  LocalUserState copyWith({
    String? role,
    String? email,
    OnboardingStage? stage,
    bool? hasOnboarded,
    bool? justCompletedOnboarding,
  }) {
    return LocalUserState(
      role: role ?? this.role,
      email: email ?? this.email,
      stage: stage ?? this.stage,
      hasOnboarded: hasOnboarded ?? this.hasOnboarded,
      justCompletedOnboarding:
          justCompletedOnboarding ?? this.justCompletedOnboarding,
    );
  }
}

class LocalUserController extends StateNotifier<LocalUserState> {
  static const _roleKey = 'user_role';
  static const _emailKey = 'user_email';
  static const _stageKey = 'onboarding_stage';
  static const _hasOnboardedKey = 'has_onboarded';
  static const _justCompletedOnboardingKey = 'just_completed_onboarding';

  final SharedPreferences prefs;

  LocalUserController(this.prefs) : super(LocalUserState()) {
    _init();
  }

  void _init() {
    final role = prefs.getString(_roleKey);
    final email = prefs.getString(_emailKey);
    final stageIndex = prefs.getInt(_stageKey) ?? 0;
    final hasOnboarded = prefs.getBool(_hasOnboardedKey) ?? false;

    state = LocalUserState(
      role: role,
      email: email,
      stage: OnboardingStage.values[stageIndex],
      hasOnboarded: hasOnboarded,
    );
  }

  Future<void> saveRole(String role) async {
    await prefs.setString(_roleKey, role);
    state = state.copyWith(role: role);
  }

  Future<void> saveEmail(String email) async {
    await prefs.setString(_emailKey, email);
    state = state.copyWith(email: email);
  }

  Future<void> saveStage(OnboardingStage stage) async {
    await prefs.setInt(_stageKey, stage.index);
    state = state.copyWith(stage: stage);
  }

  Future<void> saveHasOnboarded(bool value) async {
    await prefs.setBool(_hasOnboardedKey, value);
    state = state.copyWith(hasOnboarded: value);
  }

  Future<void> saveJustCompletedOnboarding(bool value) async {
    await prefs.setBool(_justCompletedOnboardingKey, value);
    state = state.copyWith(justCompletedOnboarding: value);
  }

  Future<void> clearJustCompletedOnboarding() async {
    await saveJustCompletedOnboarding(false);
  }

  Future<void> completeOnboarding() async {
    await prefs.setInt(_stageKey, OnboardingStage.completed.index);
    await prefs.setBool(_hasOnboardedKey, true);
    await prefs.setBool(_justCompletedOnboardingKey, true);

    state = state.copyWith(
      stage: OnboardingStage.completed,
      hasOnboarded: true,
      justCompletedOnboarding: true,
    );
  }

  Future<void> loginAfterOnboarding(String role) async {
    await prefs.setString(_roleKey, role);
    await prefs.setInt(_stageKey, OnboardingStage.completed.index);
    await prefs.setBool(_hasOnboardedKey, true);
    await prefs.setBool(_justCompletedOnboardingKey, true);

    state = state.copyWith(
      role: role,
      stage: OnboardingStage.completed,
      hasOnboarded: true,
      justCompletedOnboarding: true,
    );
  }

  Future<void> resetAll() async {
    await prefs.clear();
    state = LocalUserState();
  }
}

final localUserControllerProvider =
    StateNotifierProvider<LocalUserController, LocalUserState>((ref) {
      throw UnimplementedError("Initialize in main.dart");
    });
