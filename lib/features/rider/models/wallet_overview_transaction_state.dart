import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'earning_history_model.dart';

/// Sentinel to distinguish "leave this field alone" from "explicitly
/// set this nullable field to null" inside copyWith (needed for
/// clearing selectedMonth/selectedYear).
class _Unset {
  const _Unset();
}

const _unset = _Unset();

class WalletOverviewTransactionState {
  final AsyncValue<List<EarningHistoryOrder>> orders;
  final EarningHistorySummary? summary;

  /// 1-indexed — mirrors the API's `pagination.currentPage` directly,
  /// so there's no +1/-1 translation anywhere else in the app.
  final int currentPage;
  final int totalPages;
  final int totalOrdersCount;
  final bool hasNext;
  final bool hasPrev;
  final int rowsPerPage;

  final String searchQuery;
  final int? selectedMonth;
  final int? selectedYear;

  /// delivered | cancelled | all — mirrors the API's `status` param.
  final String status;

  const WalletOverviewTransactionState({
    this.orders = const AsyncValue.data([]),
    this.summary,
    this.currentPage = 1,
    this.totalPages = 1,
    this.totalOrdersCount = 0,
    this.hasNext = false,
    this.hasPrev = false,
    this.rowsPerPage = 10,
    this.searchQuery = '',
    this.selectedMonth,
    this.selectedYear,
    this.status = 'delivered',
  });

  WalletOverviewTransactionState copyWith({
    AsyncValue<List<EarningHistoryOrder>>? orders,
    Object? summary = _unset,
    int? currentPage,
    int? totalPages,
    int? totalOrdersCount,
    bool? hasNext,
    bool? hasPrev,
    int? rowsPerPage,
    String? searchQuery,
    Object? selectedMonth = _unset,
    Object? selectedYear = _unset,
    String? status,
  }) {
    return WalletOverviewTransactionState(
      orders: orders ?? this.orders,
      summary: identical(summary, _unset)
          ? this.summary
          : summary as EarningHistorySummary?,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalOrdersCount: totalOrdersCount ?? this.totalOrdersCount,
      hasNext: hasNext ?? this.hasNext,
      hasPrev: hasPrev ?? this.hasPrev,
      rowsPerPage: rowsPerPage ?? this.rowsPerPage,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedMonth: identical(selectedMonth, _unset)
          ? this.selectedMonth
          : selectedMonth as int?,
      selectedYear: identical(selectedYear, _unset)
          ? this.selectedYear
          : selectedYear as int?,
      status: status ?? this.status,
    );
  }
}

// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:wigo_flutter/features/rider/models/wallet_state.dart';
//
// import 'delivery_model.dart';
//
// enum OrderFilter { all, newRequest, ongoing, completed, cancelled }
//
// class WalletOverviewTransactionState {
//   final AsyncValue<List<Delivery>> orders;
//   final OrderFilter selectedFilter;
//   final int currentPage;
//   final int totalOrdersCount;
//   final Map<OrderFilter, int> orderCounts;
//   final int rowsPerPage;
//   final WalletScreenState walletScreenState;
//
//   const WalletOverviewTransactionState({
//     this.orders = const AsyncValue.data([]),
//     this.selectedFilter = OrderFilter.all,
//     this.currentPage = 0,
//     this.totalOrdersCount = 0,
//     this.orderCounts = const {},
//     this.rowsPerPage = 10,
//     this.walletScreenState = WalletScreenState.overview,
//   });
//
//   WalletOverviewTransactionState copyWith({
//     AsyncValue<List<Delivery>>? orders,
//     OrderFilter? selectedFilter,
//     int? currentPage,
//     int? totalOrdersCount,
//     Map<OrderFilter, int>? orderCounts,
//     int? rowsPerPage,
//     WalletScreenState? walletScreenState,
//   }) {
//     return WalletOverviewTransactionState(
//       orders: orders ?? this.orders,
//       selectedFilter: selectedFilter ?? this.selectedFilter,
//       currentPage: currentPage ?? this.currentPage,
//       totalOrdersCount: totalOrdersCount ?? this.totalOrdersCount,
//       orderCounts: orderCounts ?? this.orderCounts,
//       rowsPerPage: rowsPerPage ?? this.rowsPerPage,
//       walletScreenState: walletScreenState ?? this.walletScreenState,
//     );
//   }
// }
//
// extension DeliveryTaskSelectors on WalletOverviewTransactionState {
//   List<Delivery> get filteredOrders {
//     return orders.when(
//       data: (list) {
//         switch (selectedFilter) {
//           case OrderFilter.all:
//             return list;
//           case OrderFilter.newRequest:
//             return list
//                 .where((d) => d.deliveryStatus == "New Request")
//                 .toList();
//           case OrderFilter.ongoing:
//             return list
//                 .where((d) => d.deliveryStatus == "In Progress")
//                 .toList();
//           case OrderFilter.completed:
//             return list.where((d) => d.deliveryStatus == "Completed").toList();
//           case OrderFilter.cancelled:
//             return list.where((d) => d.deliveryStatus == "Cancelled").toList();
//         }
//       },
//       loading: () => [],
//       error: (_, __) => [],
//     );
//   }
// }
