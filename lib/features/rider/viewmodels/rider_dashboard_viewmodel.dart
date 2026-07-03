import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:wigo_flutter/shared/widgets/custom_banner.dart';

import '../../../core/constants/dashboard_helpers.dart';
import '../../../core/network/network.dart';
import '../models/rider_dashboard_state.dart';
import '../models/transaction.dart';
import '../service/rider_api_service.dart';

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
