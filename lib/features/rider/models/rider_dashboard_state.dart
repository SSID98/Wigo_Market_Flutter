import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'current_location.dart';
import 'delivery_model.dart';
import 'earning_history_model.dart';

class RiderDashboardState {
  // Individual AsyncValues for each specific earning metric
  final bool isAvailable;
  final String errorMessage;
  final AsyncValue<String> totalEarnings;
  final AsyncValue<String> thisWeekEarnings;
  final AsyncValue<String> pendingPayout;
  final AsyncValue<String> todaysEarnings;
  final AsyncValue<CurrentLocation?> currentLocation;
  final AsyncValue<List<EarningHistoryOrder>> earningHistory;
  final AsyncValue<List<Delivery>> recentDeliveries;

  const RiderDashboardState({
    this.errorMessage = '',
    this.isAvailable = false,
    this.totalEarnings = const AsyncValue.loading(),
    this.thisWeekEarnings = const AsyncValue.loading(),
    this.pendingPayout = const AsyncValue.loading(),
    this.todaysEarnings = const AsyncValue.loading(),
    this.currentLocation = const AsyncValue.loading(),
    this.earningHistory = const AsyncValue.loading(),
    this.recentDeliveries = const AsyncValue.loading(),
  });

  RiderDashboardState copyWith({
    bool? isAvailable,
    String? errorMessage,
    AsyncValue<String>? totalEarnings,
    AsyncValue<String>? thisWeekEarnings,
    AsyncValue<String>? pendingPayout,
    AsyncValue<String>? todaysEarnings,
    AsyncValue<CurrentLocation?>? currentLocation,
    AsyncValue<List<EarningHistoryOrder>>? earningHistory,
    AsyncValue<List<Delivery>>? recentDeliveries,
  }) {
    return RiderDashboardState(
      totalEarnings: totalEarnings ?? this.totalEarnings,
      thisWeekEarnings: thisWeekEarnings ?? this.thisWeekEarnings,
      pendingPayout: pendingPayout ?? this.pendingPayout,
      todaysEarnings: todaysEarnings ?? this.todaysEarnings,
      isAvailable: isAvailable ?? this.isAvailable,
      currentLocation: currentLocation ?? this.currentLocation,
      earningHistory: earningHistory ?? this.earningHistory,
      errorMessage: errorMessage ?? this.errorMessage,
      recentDeliveries: recentDeliveries ?? this.recentDeliveries,
    );
  }
}
