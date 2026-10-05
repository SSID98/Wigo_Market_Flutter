import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'seller_earnings_models.dart';

enum EarningsDateFilter { all, today, custom }

class SellerEarningsState {
  final AsyncValue<EarningsSummary> summary;
  final AsyncValue<List<SellerEarning>> earnings;

  final int totalCount;
  final int totalPages;

  final int currentPage;
  final int rowsPerPage;

  final String searchQuery;
  final EarningsDateFilter dateFilter;
  final DateTime? dateFrom;
  final DateTime? dateTo;

  const SellerEarningsState({
    this.summary = const AsyncValue<EarningsSummary>.loading(),
    this.earnings = const AsyncValue<List<SellerEarning>>.loading(),
    this.totalCount = 0,
    this.totalPages = 0,
    this.currentPage = 0,
    this.rowsPerPage = 10,
    this.searchQuery = '',
    this.dateFilter = EarningsDateFilter.all,
    this.dateFrom,
    this.dateTo,
  });

  bool get hasDateFilter => dateFilter != EarningsDateFilter.all;

  bool get hasActiveFilters => searchQuery.isNotEmpty || hasDateFilter;

  SellerEarningsState copyWith({
    AsyncValue<EarningsSummary>? summary,
    AsyncValue<List<SellerEarning>>? earnings,
    int? totalCount,
    int? totalPages,
    int? currentPage,
    int? rowsPerPage,
    String? searchQuery,
    EarningsDateFilter? dateFilter,
    DateTime? dateFrom,
    DateTime? dateTo,
    bool clearDateRange = false,
  }) {
    return SellerEarningsState(
      summary: summary ?? this.summary,
      earnings: earnings ?? this.earnings,
      totalCount: totalCount ?? this.totalCount,
      totalPages: totalPages ?? this.totalPages,
      currentPage: currentPage ?? this.currentPage,
      rowsPerPage: rowsPerPage ?? this.rowsPerPage,
      searchQuery: searchQuery ?? this.searchQuery,
      dateFilter: dateFilter ?? this.dateFilter,
      dateFrom: clearDateRange ? null : (dateFrom ?? this.dateFrom),
      dateTo: clearDateRange ? null : (dateTo ?? this.dateTo),
    );
  }
}
