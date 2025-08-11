import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginViewModel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool agreeToTerms = false;

  void toggleAgreeToTerms(bool? value) {
    agreeToTerms = value ?? false;
    notifyListeners();
  }

  void login(BuildContext context) {
    if (formKey.currentState?.validate() ?? false) {
      if (agreeToTerms) {
        // Do login logic here
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("You must agree to the terms.")));
      }
      // Perform login API call later
      debugPrint("Email: ${emailController.text}");
      debugPrint("Password: ${passwordController.text}");
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

// Provider for Riverpod
final loginViewModelProvider = ChangeNotifierProvider<LoginViewModel>((ref) {
  return LoginViewModel();
});
