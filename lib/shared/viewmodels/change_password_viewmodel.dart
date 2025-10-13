import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'login_state.dart';

class ChangePasswordViewmodel extends StateNotifier<LoginState> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  ChangePasswordViewmodel() : super(LoginState());

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void toggleRememberMe(bool? value) {
    state = state.copyWith(agreeToTerms: value ?? false);
  }
}

final changePasswordViewModelProvider =
    StateNotifierProvider.autoDispose<ChangePasswordViewmodel, LoginState>((
      ref,
    ) {
      return ChangePasswordViewmodel();
    });
