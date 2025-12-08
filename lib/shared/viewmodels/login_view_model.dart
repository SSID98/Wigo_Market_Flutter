import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/auth/auth_service.dart';
import '../../core/auth/auth_state_notifier.dart';
import '../models/login/login_request_DTO.dart';
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

    final dto = LoginRequestDTO(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    try {
      // 1. Call login API
      final result = await auth.loginUser(dto);

      // 2. Update global auth state (this saves token + user)
      ref.read(authStateProvider.notifier).login(result); // << THE REAL MAGIC

      // 3. Router will auto-redirect based on role
      if (!context.mounted) return;

      context.go('/'); // Router will handle where to send user
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setLoading(false);
    }
  }
}

//
//   Future<void> login(
//     GlobalKey<FormState> formKey,
//     BuildContext context,
//     bool isBuyer,
//   ) async {
//     if (!formKey.currentState!.validate()) return;
//
//     if (!state.agreeToTerms) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("You must agree to the terms.")),
//       );
//       return;
//     }
//
//     setLoading(true);
//
//     final dto = LoginRequestDTO(
//       email: emailController.text.trim(),
//       password: passwordController.text.trim(),
//     );
//
//     try {
//       // 1. Call login API
//       final result = await auth.loginUser(dto);
//
//
//       /// Save token (later we’ll implement secure storage)
//       // await secureStorage.write(key: "token", value: result.token);
//
//       state = state.copyWith(isLoggedIn: true);
//
//       if (!context.mounted) return;
//       if (isBuyer) {
//         context.go("/buyerHomeScreen");
//       } else {
//         context.go("/riderMainScreen");
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text(e.toString())));
//     } finally {
//       setLoading(false);
//       debugPrint("Email: $state.email");
//       debugPrint("Password: $state.password");
//     }
//   }
// }

//   Future<void> login(
//     GlobalKey<FormState> formKey,
//     BuildContext context,
//     bool isBuyer,
//   ) async {
//     if (formKey.currentState!.validate()) {
//       if (!state.agreeToTerms) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('You must agree to the terms.')),
//         );
//         return;
//       }
//       setLoading(true);
//
//       !isBuyer
//           ? context.push('/riderMainScreen')
//           : context.push('/buyerHomeScreen');
//       await Future.delayed(const Duration(milliseconds: 500));
//       setLoading(false);
//       debugPrint("Email: $state.email");
//       debugPrint("Password: $state.password");
//     }
//   }
// }

final loginViewModelProvider =
    StateNotifierProvider.autoDispose<LoginViewModel, LoginState>((ref) {
      return LoginViewModel(ref.read(authServiceProvider), ref);
    });
