import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wigo_flutter/features/seller/models/earnings.dart';

class SellerDashboardState {
  final AsyncValue<String> pendingOrders;
  final AsyncValue<String> totalSales;
  final AsyncValue<String> completedOrders;
  final AsyncValue<String> activeProduct;
  final AsyncValue<List<Earnings>> recentEarnings;

  const SellerDashboardState({
    this.pendingOrders = const AsyncValue.loading(),
    this.totalSales = const AsyncValue.loading(),
    this.completedOrders = const AsyncValue.loading(),
    this.activeProduct = const AsyncValue.loading(),
    this.recentEarnings = const AsyncValue.loading(),
  });

  SellerDashboardState copyWith({
    AsyncValue<String>? pendingOrders,
    AsyncValue<String>? totalSales,
    AsyncValue<String>? completedOrders,
    AsyncValue<String>? activeProduct,
    AsyncValue<List<Earnings>>? recentEarnings,
  }) {
    return SellerDashboardState(
      pendingOrders: pendingOrders ?? this.pendingOrders,
      totalSales: totalSales ?? this.totalSales,
      completedOrders: completedOrders ?? this.completedOrders,
      activeProduct: activeProduct ?? this.activeProduct,
      recentEarnings: recentEarnings ?? this.recentEarnings,
    );
  }
}
