import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/auth/auth_service.dart';
import '../../core/auth/auth_state_notifier.dart';
import '../../core/local/local_user_controller.dart';
import '../../core/utils/helper_methods.dart';
import '../models/login/login_request_dto_class.dart';
import '../models/login/login_state.dart';

class LoginViewModel extends StateNotifier<LoginState> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService auth;
  final Ref ref;

  LoginViewModel(this.auth, this.ref) : super(LoginState());

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void toggleAgreeToTerms(bool? value) {
    state = state.copyWith(agreeToTerms: value ?? false);
  }

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  Future<void> login(GlobalKey<FormState> formKey, BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    if (!state.agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You must agree to the terms.")),
      );
      return;
    }

    setLoading(true);

    showLoadingDialog(context);

    final dto = LoginRequestDTO(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    try {
      // 1. Call login API
      final result = await auth.loginUser(dto);

      // 2. Update global auth state (this saves token + user)

      final localUserController = ref.read(
        localUserControllerProvider.notifier,
      );
      await localUserController.saveRole(result.activeRole);
      await localUserController.saveHasOnboarded(true);
      await localUserController.saveStage(OnboardingStage.completed);

      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      await Future.delayed(const Duration(milliseconds: 50));
      ref.read(authStateProvider.notifier).login(result);
      // 3. Router will auto-redirect based on role
      if (!context.mounted) return;
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setLoading(false);
    }
  }
}

final loginViewModelProvider =
    StateNotifierProvider.autoDispose<LoginViewModel, LoginState>((ref) {
      return LoginViewModel(ref.read(authServiceProvider), ref);
    });
