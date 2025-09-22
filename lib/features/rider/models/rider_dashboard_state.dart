import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wigo_flutter/features/rider/models/transaction.dart';

import 'current_location.dart';

class RiderDashboardState {
  // Individual AsyncValues for each specific earning metric
  final bool isAvailable;
  final AsyncValue<String> totalEarnings;
  final AsyncValue<String> thisWeekEarnings;
  final AsyncValue<String> pendingPayout;
  final AsyncValue<String> todaysEarnings;
  final AsyncValue<CurrentLocation?> currentLocation;
  final AsyncValue<List<Transaction>> earningHistory;

  const RiderDashboardState({
    this.isAvailable = true,
    this.totalEarnings = const AsyncValue.loading(),
    this.thisWeekEarnings = const AsyncValue.loading(),
    this.pendingPayout = const AsyncValue.loading(),
    this.todaysEarnings = const AsyncValue.loading(),
    this.currentLocation = const AsyncValue.loading(),
    this.earningHistory = const AsyncValue.loading(),
  });

  RiderDashboardState copyWith({
    bool? isAvailable,
    AsyncValue<String>? totalEarnings,
    AsyncValue<String>? thisWeekEarnings,
    AsyncValue<String>? pendingPayout,
    AsyncValue<String>? todaysEarnings,
    AsyncValue<CurrentLocation?>? currentLocation,
    AsyncValue<List<Transaction>>? earningHistory,
  }) {
    return RiderDashboardState(
      totalEarnings: totalEarnings ?? this.totalEarnings,
      thisWeekEarnings: thisWeekEarnings ?? this.thisWeekEarnings,
      pendingPayout: pendingPayout ?? this.pendingPayout,
      todaysEarnings: todaysEarnings ?? this.todaysEarnings,
      isAvailable: isAvailable ?? this.isAvailable,
      currentLocation: currentLocation ?? this.currentLocation,
      earningHistory: earningHistory ?? this.earningHistory,
    );
  }
}
