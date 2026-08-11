import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wigo_flutter/shared/widgets/custom_banner.dart';

import '../../../core/auth/auth_state_notifier.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/dashboard_helpers.dart';
import '../../../core/network/network.dart';
import '../../../shared/viewmodels/settings_navg_viewmodel.dart';
import '../../../shared/widgets/custom_loading_overlay.dart';
import '../models/earning_history_model.dart';
import '../models/rider_dashboard_state.dart';
import '../models/wallet_state.dart';
import '../service/rider_api_service.dart';
import 'edit_bank_account_viewmodel.dart';
import 'global_navigation_viewmodel.dart';

class RiderDashboardViewModel extends StateNotifier<RiderDashboardState> {
  final Reader read;
  final RiderApiService api;

  RiderDashboardViewModel(this.read, {RiderApiService? apiService})
    : api = apiService ?? read(riderApiServiceProvider),
      super(const RiderDashboardState()) {
    _initiateDashboardDataLoad();
  }

  void _initiateDashboardDataLoad() {
    _fetchEarningsOverview();
    // _fetchCurrentLocation();
    _fetchEarningHistory();
    _fetchRecentDeliveries();
  }

  Future<void> _fetchRecentDeliveries() async {
    state = state.copyWith(recentDeliveries: const AsyncValue.loading());
    try {
      final result = await api.getRecentOrders(limit: 5);
      if (!mounted) return;

      if (result.isSuccess && result.data != null) {
        state = state.copyWith(recentDeliveries: AsyncValue.data(result.data!));
      } else {
        state = state.copyWith(
          recentDeliveries: AsyncValue.error(
            Exception(
              result.errorDescription ?? 'Failed to load recent deliveries.',
            ),
            StackTrace.current,
          ),
        );
      }
    } catch (e, st) {
      if (!mounted) return;
      state = state.copyWith(recentDeliveries: AsyncValue.error(e, st));
    }
  }

  Future<void> _fetchEarningsOverview() async {
    state = state.copyWith(
      todaysEarnings: const AsyncValue.loading(),
      thisWeekEarnings: const AsyncValue.loading(),
      pendingPayout: const AsyncValue.loading(),
      totalEarnings: const AsyncValue.loading(),
    );

    final result = await api.getEarningsOverview();

    if (result.isSuccess && result.data != null) {
      final overview = result.data!;
      state = state.copyWith(
        todaysEarnings: AsyncValue.data(formatAmount(overview.today)),
        thisWeekEarnings: AsyncValue.data(formatAmount(overview.thisWeek)),
        pendingPayout: AsyncValue.data(formatAmount(overview.pendingPayout)),
        totalEarnings: AsyncValue.data(formatAmount(overview.totalEarnings)),
      );
    } else {
      final error = Exception(
        result.errorDescription ?? 'Failed to load earnings',
      );
      final st = StackTrace.current;
      state = state.copyWith(
        todaysEarnings: AsyncValue.error(error, st),
        thisWeekEarnings: AsyncValue.error(error, st),
        pendingPayout: AsyncValue.error(error, st),
        totalEarnings: AsyncValue.error(error, st),
      );
    }
  }

  // Future<void> _fetchCurrentLocation() async {
  //   state = state.copyWith(currentLocation: const AsyncValue.loading());
  //   try {
  //     await Future.delayed(const Duration(seconds: 1)); // Simulate API call
  //
  //     const mockLocation = CurrentLocation(
  //       latitude: 6.5244,
  //       longitude: 3.3792,
  //       label: "Rider’s Spot",
  //     );
  //
  //     state = state.copyWith(
  //       currentLocation: const AsyncValue.data(mockLocation),
  //     );
  //   } catch (e, st) {
  //     state = state.copyWith(currentLocation: AsyncValue.error(e, st));
  //   }
  // }

  Future<void> _fetchEarningHistory() async {
    state = state.copyWith(earningHistory: const AsyncValue.loading());
    try {
      final result = await api.getEarningsHistory(limit: 5, status: 'all');
      if (!mounted) return;

      if (result.isSuccess && result.data != null) {
        final orders = List<EarningHistoryOrder>.from(result.data!.orders)
          ..sort((a, b) {
            final aDate = a.deliveredAt ?? a.date ?? DateTime(0);
            final bDate = b.deliveredAt ?? b.date ?? DateTime(0);
            return bDate.compareTo(aDate);
          });
        state = state.copyWith(earningHistory: AsyncValue.data(orders));
      } else {
        state = state.copyWith(
          earningHistory: AsyncValue.error(
            Exception(
              result.errorDescription ?? 'Failed to load earning history.',
            ),
            StackTrace.current,
          ),
        );
      }
    } catch (e, st) {
      if (!mounted) return;
      state = state.copyWith(earningHistory: AsyncValue.error(e, st));
    }
  }

  Future<void> navigateToVehicleDocuments(
    WidgetRef ref,
    BuildContext context,
  ) async {
    await runWithOverlay(context, () async {
      await Future.delayed(const Duration(seconds: 1), () {
        ref
            .read(settingsNavigationProvider.notifier)
            .updateIndex(1, mobilePush: true);

        ref.read(globalNavigationViewModelProvider.notifier).setIndex(4);
      });
    }, spinner: SpinKitDualRing(color: AppColors.primaryDarkGreen));
  }

  Future<void> navigateToPaymentSetup(
    WidgetRef ref,
    BuildContext context,
  ) async {
    await runWithOverlay(context, () async {
      await Future.delayed(const Duration(seconds: 1), () async {
        final authUser = read(authStateProvider).user;
        if (authUser == null) return;
        final authHasWallet = authUser.hasWallet;
        final authHasPin = authUser.hasWithdrawalPin;

        final targetState = (authHasWallet && !authHasPin)
            ? WalletScreenState.addBankAccount
            : WalletScreenState.setupPin;

        ref
            .read(editBankAccountProvider.notifier)
            .setWalletScreenState(targetState);

        ref.read(globalNavigationViewModelProvider.notifier).setIndex(3);
      });
    }, spinner: SpinKitDualRing(color: AppColors.primaryDarkGreen));
  }

  Future<void> toggleSwitch(bool newValue, BuildContext context) async {
    final previousState = state.isAvailable;
    state = state.copyWith(isAvailable: newValue);

    final result = await api.updateAvailability(newValue);
    if (!context.mounted) return;
    if (result.isSuccess == false) {
      state = state.copyWith(isAvailable: previousState);
      if (result.errorDescription!.contains("profile not found")) {
        state = state.copyWith(
          errorMessage: "Please complete your vehicle profile first!",
        );
        showErrorBanner(state.errorMessage, context);
        debugPrint("Availability Update Failed: ${result.errorDescription}");
      } else {
        state = state.copyWith(errorMessage: result.errorDescription);
      }
    }
  }
}

final riderDashboardViewModelProvider =
    StateNotifierProvider<RiderDashboardViewModel, RiderDashboardState>(
      (ref) => RiderDashboardViewModel(ref.read),
    );
