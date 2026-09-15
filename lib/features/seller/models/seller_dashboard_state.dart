import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wigo_flutter/features/seller/models/earnings.dart';
import 'package:wigo_flutter/features/seller/models/seller_analytics_model.dart';

class SellerDashboardState {
  final AsyncValue<SellerAnalytics> analytics;
  final String selectedPeriod;
  final AsyncValue<List<Earnings>> recentEarnings;

  const SellerDashboardState({
    this.analytics = const AsyncValue.loading(),
    this.selectedPeriod = 'today',
    this.recentEarnings = const AsyncValue.loading(),
  });

  SellerDashboardState copyWith({
    AsyncValue<SellerAnalytics>? analytics,
    String? selectedPeriod,
    AsyncValue<List<Earnings>>? recentEarnings,
  }) {
    return SellerDashboardState(
      analytics: analytics ?? this.analytics,
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
      recentEarnings: recentEarnings ?? this.recentEarnings,
    );
  }
}
