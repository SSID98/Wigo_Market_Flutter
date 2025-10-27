import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wigo_flutter/shared/screens/welcome_screen.dart';

import '../../../core/local/local_storage_service.dart';
import '../../../shared/models/user_role.dart';
import 'role_selection_provider.dart';

class RoleSelectionViewModel extends ChangeNotifier {
  final Ref ref;

  RoleSelectionViewModel(this.ref);

  UserRole? get selectedRole => ref.read(selectedRoleProvider);

  void selectRole(UserRole role) {
    ref.read(selectedRoleProvider.notifier).state = role;
    notifyListeners();
  }

  Future<void> confirmSelection(BuildContext context) async {
    final role = selectedRole;
    if (role == null) return;

    // Save that role selection is completed
    final prefs = await SharedPreferences.getInstance();
    final storage = LocalStorageService(prefs);
    await storage.setRoleCompleted();

    await Future.delayed(const Duration(milliseconds: 250));

    if (!context.mounted) return;

    switch (role) {
      case UserRole.rider:
        context.push('/welcome');
        break;
      case UserRole.buyer:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => WelcomeScreen(isBuyer: true)),
        );
        break;
      case UserRole.seller:
        context.push('/seller/welcome');
        break;
    }
  }
}

final roleSelectionViewModelProvider = ChangeNotifierProvider(
  (ref) => RoleSelectionViewModel(ref),
);
