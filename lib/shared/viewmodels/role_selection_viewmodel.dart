import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:wigo_flutter/core/providers/role_selection_provider.dart';
import 'package:wigo_flutter/shared/widgets/custom_loading_overlay.dart';

import '../../core/constants/app_colors.dart';
import '../../core/local/local_user_controller.dart';
import '../models/user_role.dart';

class RoleSelectionViewModel extends StateNotifier<UserRole?> {
  final Ref ref;

  RoleSelectionViewModel(this.ref) : super(null);

  void selectRole(UserRole? role) {
    ref.read(userRoleProvider.notifier).state = role;
  }

  Future<void> confirmSelection(
    BuildContext context,
    WidgetRef ref,
    UserRole role,
  ) async {
    await runWithOverlay(context, () async {
      ref.read(userRoleProvider.notifier).state = role;
      await Future.delayed(const Duration(seconds: 1));
      await ref.read(localUserControllerProvider.notifier).saveRole(role.name);
      await ref
          .read(localUserControllerProvider.notifier)
          .saveStage(OnboardingStage.welcome);
      if (context.mounted) context.push('/welcome');
    }, spinner: SpinKitDualRing(color: AppColors.primaryDarkGreen));
  }
}

final roleSelectionViewModelProvider =
    StateNotifierProvider<RoleSelectionViewModel, UserRole?>(
      (ref) => RoleSelectionViewModel(ref),
    );
