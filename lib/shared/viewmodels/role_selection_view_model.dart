import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wigo_flutter/core/providers/role_selection_provider.dart';

import '../models/user_role.dart';

class RoleSelectionViewModel extends StateNotifier<UserRole?> {
  final Ref ref;

  RoleSelectionViewModel(this.ref) : super(null);

  void selectRole(UserRole? role) {
    ref.read(userRoleProvider.notifier).state = role;
  }

  Future<void> confirmSelection(BuildContext context) async {
    final role = ref.read(userRoleProvider);
    if (role == null) return;

    // small delay for UX
    await Future.delayed(const Duration(milliseconds: 250));
    if (!context.mounted) return;

    // Use same route for now — can be role-specific later
    context.push('/welcome');
  }
}

final roleSelectionViewModelProvider =
    StateNotifierProvider<RoleSelectionViewModel, UserRole?>(
      (ref) => RoleSelectionViewModel(ref),
    );
