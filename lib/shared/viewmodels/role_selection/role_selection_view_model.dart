import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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

    // Optional: delay for animation
    await Future.delayed(const Duration(milliseconds: 250));

    if (!context.mounted) return;

    switch (role) {
      case UserRole.rider:
        context.go('/rider/welcome');
        break;
      case UserRole.buyer:
        context.go('/buyer/welcome');
        break;
      case UserRole.seller:
        context.go('/seller/welcome');
        break;
    }
  }
}

final roleSelectionViewModelProvider = ChangeNotifierProvider(
  (ref) => RoleSelectionViewModel(ref),
);
