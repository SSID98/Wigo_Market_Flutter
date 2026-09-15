import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'earning_history_model.dart';

class _Unset {
  const _Unset();
}

const _unset = _Unset();

class WalletOverviewTransactionState {
  final AsyncValue<List<EarningHistoryOrder>> orders;
  final EarningHistorySummary? summary;

  final int currentPage;
  final int totalPages;
  final int totalOrdersCount;
  final bool hasNext;
  final bool hasPrev;
  final int rowsPerPage;

  final String searchQuery;
  final int? selectedMonth;
  final int? selectedYear;
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
