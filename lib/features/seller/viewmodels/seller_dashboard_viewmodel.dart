import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wigo_flutter/features/seller/models/earnings.dart';

import '../../../core/auth/auth_state_notifier.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/network/network.dart';
import '../../../shared/widgets/custom_loading_overlay.dart';
import '../../rider/viewmodels/edit_bank_account_viewmodel.dart';
import '../../rider/viewmodels/global_navigation_viewmodel.dart';
import '../models/seller_dashboard_state.dart';
import '../presentation/views/seller_wallet_screens/seller_wallet_main_screen.dart';
import '../services/seller_api_service.dart';

class SellerDashboardViewModel extends StateNotifier<SellerDashboardState> {
  final Reader read;
  final SellerApiService api;

  SellerDashboardViewModel(this.read, {SellerApiService? apiService})
    : api = apiService ?? read(sellerApiServiceProvider),
      super(const SellerDashboardState()) {
    _initiateDashboardDataLoad();
  }

  void _initiateDashboardDataLoad() {
    _fetchAnalytics();
    _fetchEarningHistory();
  }

  Future<void> _fetchAnalytics() async {
    state = state.copyWith(analytics: const AsyncValue.loading());

    final result = await api.getAnalytics(period: 'today,weekly,monthly');

    if (result.isSuccess && result.data != null) {
      state = state.copyWith(analytics: AsyncValue.data(result.data!));
    } else {
      final error = Exception(
        result.errorDescription ?? 'Failed to load analytics',
      );
      state = state.copyWith(
        analytics: AsyncValue.error(error, StackTrace.current),
      );
    }
  }

  Future<void> refreshAnalytics() => _fetchAnalytics();

  void setPeriod(String period) {
    assert(
      ['today', 'weekly', 'monthly'].contains(period),
      'period must be one of: today, weekly, monthly',
    );
    state = state.copyWith(selectedPeriod: period);
  }

  Future<void> _fetchEarningHistory() async {
    state = state.copyWith(recentEarnings: const AsyncValue.loading());
    try {
      await Future.delayed(const Duration(seconds: 1)); // simulate API
      final List<Earnings> earnings = [
        Earnings(
          date: DateTime.now().subtract(const Duration(days: 1)),
          amount: 5000,
          status: "Received",
        ),
        Earnings(
          date: DateTime.now().subtract(const Duration(days: 3)),
          amount: 2000,
          status: "Pending",
        ),
        Earnings(
          date: DateTime.now().subtract(const Duration(days: 7)),
          amount: 7500,
          status: "Failed",
        ),
      ];
      state = state.copyWith(recentEarnings: AsyncValue.data(earnings));
    } catch (e, st) {
      state = state.copyWith(recentEarnings: AsyncValue.error(e, st));
    }
  }

  Future<void> navigateToSellerPaymentSetup(
    BuildContext context,
    WidgetRef ref,
  ) async {
    await runWithOverlay(context, () async {
      await Future.delayed(const Duration(seconds: 1), () {
        final authUser = read(authStateProvider).user;
        if (authUser == null) return;
        final authHasWallet = authUser.hasWallet;
        final authHasPin = authUser.hasWithdrawalPin;

        final targetState = (authHasWallet && !authHasPin)
            ? SellerWalletScreenState.setupPin
            : SellerWalletScreenState.addBankAccount;

        ref
            .read(editBankAccountProvider.notifier)
            .setSellerWalletScreenState(targetState);

        read(globalNavigationViewModelProvider.notifier).setIndex(3);
      });
    }, spinner: SpinKitDualRing(color: AppColors.primaryDarkGreen));
  }
}

final sellerDashboardViewModelProvider =
    StateNotifierProvider<SellerDashboardViewModel, SellerDashboardState>(
      (ref) => SellerDashboardViewModel(ref.read),
    );
