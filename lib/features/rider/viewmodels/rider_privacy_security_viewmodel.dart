import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../core/auth/auth_state_notifier.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/network/network.dart';
import '../../../shared/widgets/custom_banner.dart';
import '../../../shared/widgets/custom_loading_overlay.dart';
import '../service/rider_api_service.dart';

class RiderPrivacySecurityState {
  final String errorMessage;
  final bool isLoading;

  const RiderPrivacySecurityState({
    this.errorMessage = '',
    this.isLoading = false,
  });

  RiderPrivacySecurityState copyWith({String? errorMessage, bool? isLoading}) {
    return RiderPrivacySecurityState(
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class RiderPrivacySecurityViewmodel
    extends StateNotifier<RiderPrivacySecurityState> {
  final Reader read;
  final RiderApiService api;

  RiderPrivacySecurityViewmodel(this.read, {RiderApiService? apiService})
    : api = apiService ?? read(riderApiServiceProvider),
      super(const RiderPrivacySecurityState());

  Future<void> deleteRiderAccount(BuildContext context, WidgetRef ref) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    await runWithOverlay(context, () async {
      final response = await api.deleteRiderAccount();

      if (response.isSuccess) {
        ref.read(authStateProvider.notifier).logout();
        if (!context.mounted) return;
        showSuccessBanner("Account deleted successfully.", context);
        state = state.copyWith(isLoading: false);
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: "Failed to delete account.",
        );
        if (!context.mounted) return;
        showErrorBanner(state.errorMessage, context);
      }
    }, spinner: SpinKitDualRing(color: AppColors.primaryDarkGreen));
  }
}

final riderPrivacySecurityProvider =
    StateNotifierProvider<
      RiderPrivacySecurityViewmodel,
      RiderPrivacySecurityState
    >((ref) => RiderPrivacySecurityViewmodel(ref.read));
