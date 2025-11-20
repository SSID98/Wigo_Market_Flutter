import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'login_state.dart';

class LoginViewModel extends StateNotifier<LoginState> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginViewModel() : super(LoginState());

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

  Future<void> login(
    GlobalKey<FormState> formKey,
    BuildContext context,
    bool isBuyer,
  ) async {
    if (formKey.currentState!.validate()) {
      if (!state.agreeToTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You must agree to the terms.')),
        );
        return;
      }
      setLoading(true);
      !isBuyer
          ? context.push('/riderMainScreen')
          : context.push('/buyerHomeScreen');
      await Future.delayed(const Duration(milliseconds: 500));
      setLoading(false);
      debugPrint("Email: $state.email");
      debugPrint("Password: $state.password");
    }
  }
}

final loginViewModelProvider =
    StateNotifierProvider.autoDispose<LoginViewModel, LoginState>((ref) {
      return LoginViewModel();
    });
