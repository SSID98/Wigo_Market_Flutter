import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/current_location.dart';
import '../models/rider_dashboard_state.dart';
import '../models/transaction.dart';

class RiderDashboardViewModel extends StateNotifier<RiderDashboardState> {
  RiderDashboardViewModel() : super(const RiderDashboardState()) {
    _initiateDashboardDataLoad();
  }

  void _initiateDashboardDataLoad() {
    _fetchTodaysEarnings();
    _fetchThisWeekEarnings();
    _fetchPendingPayout();
    _fetchTotalEarnings();
    _fetchCurrentLocation();
    _fetchEarningHistory();
  }

  Future<void> _fetchTodaysEarnings() async {
    state = state.copyWith(todaysEarnings: const AsyncValue.loading());
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      const String value = "₦0.00";
      state = state.copyWith(todaysEarnings: AsyncValue.data(value));
    } catch (e, st) {
      state = state.copyWith(todaysEarnings: AsyncValue.error(e, st));
    }
  }

  Future<void> _fetchThisWeekEarnings() async {
    state = state.copyWith(thisWeekEarnings: const AsyncValue.loading());
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      const String value = "₦0.000";
      state = state.copyWith(thisWeekEarnings: AsyncValue.data(value));
    } catch (e, st) {
      state = state.copyWith(thisWeekEarnings: AsyncValue.error(e, st));
    }
  }

  Future<void> _fetchPendingPayout() async {
    state = state.copyWith(pendingPayout: const AsyncValue.loading());
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      const String value = "₦0.00";
      state = state.copyWith(pendingPayout: AsyncValue.data(value));
    } catch (e, st) {
      state = state.copyWith(pendingPayout: AsyncValue.error(e, st));
    }
  }

  Future<void> _fetchTotalEarnings() async {
    state = state.copyWith(totalEarnings: const AsyncValue.loading());
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      const String value = "₦0.00";
      state = state.copyWith(totalEarnings: AsyncValue.data(value));
    } catch (e, st) {
      state = state.copyWith(totalEarnings: AsyncValue.error(e, st));
    }
  }

  Future<void> _fetchCurrentLocation() async {
    state = state.copyWith(currentLocation: const AsyncValue.loading());
    try {
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call

      const mockLocation = CurrentLocation(
        latitude: 6.5244,
        longitude: 3.3792,
        label: "Rider’s Spot",
      );

      state = state.copyWith(
        currentLocation: const AsyncValue.data(mockLocation),
      );
    } catch (e, st) {
      state = state.copyWith(currentLocation: AsyncValue.error(e, st));
    }
  }

  Future<void> _fetchEarningHistory() async {
    state = state.copyWith(earningHistory: const AsyncValue.loading());
    try {
      await Future.delayed(const Duration(seconds: 1)); // simulate API
      final List<Transaction> transactions = [
        // Transaction(
        //   date: DateTime.now().subtract(const Duration(days: 1)),
        //   amount: 5000,
        //   status: "Received",
        // ),
        // Transaction(
        //   date: DateTime.now().subtract(const Duration(days: 3)),
        //   amount: 2000,
        //   status: "Pending",
        // ),
        // Transaction(
        //   date: DateTime.now().subtract(const Duration(days: 7)),
        //   amount: 7500,
        //   status: "Failed",
        // ),
      ];
      state = state.copyWith(earningHistory: AsyncValue.data(transactions));
    } catch (e, st) {
      state = state.copyWith(earningHistory: AsyncValue.error(e, st));
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

  void toggleSwitch(bool newValue) {
    state = state.copyWith(isAvailable: newValue);
  }
}

final riderDashboardViewModelProvider =
    StateNotifierProvider<RiderDashboardViewModel, RiderDashboardState>(
      (ref) => RiderDashboardViewModel(),
    );
