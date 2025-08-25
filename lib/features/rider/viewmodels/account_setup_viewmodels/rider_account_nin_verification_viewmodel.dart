import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RiderAccountNinVerificationViewmodel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  bool agreeToTerms = false;

  void toggleAgreeToTerms(bool? value) {
    agreeToTerms = value ?? false;
    notifyListeners();
  }

  void verify(BuildContext context) {
    if (formKey.currentState?.validate() ?? false) {
      if (agreeToTerms) {
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("You must agree to the terms.")));
      }
      // Perform login API call later
    }
  }
}

final riderAccountVerificationViewmodelProvider =
    ChangeNotifierProvider<RiderAccountNinVerificationViewmodel>((ref) {
      return RiderAccountNinVerificationViewmodel();
    });
