import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wigo_flutter/core/providers/role_selection_provider.dart';

import '../../core/utils/helper_methods.dart';
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

    await Future.delayed(const Duration(milliseconds: 250));
    if (!context.mounted) return;
    showLoadingDialog(context);
    await Future.delayed(const Duration(seconds: 1));
    if (!context.mounted) return;
    Navigator.of(context, rootNavigator: true).pop();
    context.push('/welcome');
  }
}

final roleSelectionViewModelProvider =
    StateNotifierProvider<RoleSelectionViewModel, UserRole?>(
      (ref) => RoleSelectionViewModel(ref),
    );
