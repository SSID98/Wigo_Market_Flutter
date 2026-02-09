import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum OnboardingStage {
  none,
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

  LocalUserState({
    this.role,
    this.stage = OnboardingStage.none,
    this.hasOnboarded = false,
    this.email,
  });

  LocalUserState copyWith({
    String? role,
    String? email,
    OnboardingStage? stage,
    bool? hasOnboarded,
  }) {
    return LocalUserState(
      role: role ?? this.role,
      email: email ?? this.email,
      stage: stage ?? this.stage,
      hasOnboarded: hasOnboarded ?? this.hasOnboarded,
    );
  }
}

class LocalUserController extends StateNotifier<LocalUserState> {
  static const _roleKey = 'user_role';
  static const _emailKey = 'user_email';
  static const _stageKey = 'onboarding_stage';
  static const _hasOnboardedKey = 'has_onboarded';

  final SharedPreferences prefs;

  // Initialize state by reading from prefs immediately
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
    state = state.copyWith(role: role); // 👈 This triggers the redirect!
  }

  Future<void> saveEmail(String email) async {
    await prefs.setString(_emailKey, email);
    state = state.copyWith(email: email); // 👈 This triggers the redirect!
  }

  Future<void> saveStage(OnboardingStage stage) async {
    await prefs.setInt(_stageKey, stage.index);
    state = state.copyWith(stage: stage); // 👈 This triggers the redirect!
  }

  Future<void> saveHasOnboarded(bool value) async {
    await prefs.setBool(_hasOnboardedKey, value);
    state = state.copyWith(
      hasOnboarded: value,
    ); // 👈 This triggers the redirect!
  }

  Future<void> resetAll() async {
    await prefs.clear();
    state = LocalUserState(); // Reset state
  }
}

// Update the provider type
final localUserControllerProvider =
    StateNotifierProvider<LocalUserController, LocalUserState>((ref) {
      throw UnimplementedError("Initialize in main.dart");
    });
