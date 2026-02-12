import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wigo_flutter/features/seller/models/earnings.dart';

import '../models/seller_dashboard_state.dart';

class SellerDashboardViewModel extends StateNotifier<SellerDashboardState> {
  SellerDashboardViewModel() : super(const SellerDashboardState()) {
    _initiateDashboardDataLoad();
  }

  void _initiateDashboardDataLoad() {
    _fetchTotalSales();
    _fetchPendingOrders();
    _fetchCompletedOrders();
    _fetchActiveProduct();
    _fetchEarningHistory();
  }

  Future<void> _fetchTotalSales() async {
    state = state.copyWith(totalSales: const AsyncValue.loading());
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      const String value = "₦30,000";
      state = state.copyWith(totalSales: AsyncValue.data(value));
    } catch (e, st) {
      state = state.copyWith(totalSales: AsyncValue.error(e, st));
    }
  }

  Future<void> _fetchPendingOrders() async {
    state = state.copyWith(pendingOrders: const AsyncValue.loading());
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      const String value = "50";
      state = state.copyWith(pendingOrders: AsyncValue.data(value));
    } catch (e, st) {
      state = state.copyWith(pendingOrders: AsyncValue.error(e, st));
    }
  }

  Future<void> _fetchCompletedOrders() async {
    state = state.copyWith(completedOrders: const AsyncValue.loading());
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      const String value = "50";
      state = state.copyWith(completedOrders: AsyncValue.data(value));
    } catch (e, st) {
      state = state.copyWith(completedOrders: AsyncValue.error(e, st));
    }
  }

  Future<void> _fetchActiveProduct() async {
    state = state.copyWith(activeProduct: const AsyncValue.loading());
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      const String value = "50";
      state = state.copyWith(activeProduct: AsyncValue.data(value));
    } catch (e, st) {
      state = state.copyWith(activeProduct: AsyncValue.error(e, st));
    }
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

  // Future<List<SetupStep>> fetchSetupSteps() async {
  //   final response = await http.get(
  //     Uri.parse('https://api.example.com/account/setup'),
  //   );
  //
  //   if (response.statusCode == 200) {
  //     final List data = jsonDecode(response.body);
  //     return data.map((item) => SetupStep.fromJson(item)).toList();
  //   } else {
  //     throw Exception('Failed to load setup steps');
  //   }
  // }
}

final sellerDashboardViewModelProvider =
    StateNotifierProvider<SellerDashboardViewModel, SellerDashboardState>(
      (ref) => SellerDashboardViewModel(),
    );
