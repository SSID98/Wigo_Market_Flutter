import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:wigo_flutter/features/rider/models/wallet_overview_transaction_state.dart';

import '../service/rider_api_service.dart';

class WalletOverviewTransactionViewModel
    extends StateNotifier<WalletOverviewTransactionState> {
  WalletOverviewTransactionViewModel(this._apiService)
    : super(const WalletOverviewTransactionState()) {
    _fetchEarnings(page: 1);
  }

  final RiderApiService _apiService;
  Timer? _searchDebounce;

  Future<void> _fetchEarnings({int? page}) async {
    state = state.copyWith(orders: const AsyncValue.loading());

    final response = await _apiService.getEarningsHistory(
      page: page ?? state.currentPage,
      limit: state.rowsPerPage,
      status: state.status,
      search: state.searchQuery.isEmpty ? null : state.searchQuery,
      month: state.selectedMonth,
      year: state.selectedYear,
    );

    if (response.isSuccess && response.data != null) {
      final data = response.data!;
      state = state.copyWith(
        orders: AsyncValue.data(data.orders),
        summary: data.summary,
        currentPage: data.pagination.currentPage,
        totalPages: data.pagination.totalPages,
        totalOrdersCount: data.pagination.totalOrders,
        hasNext: data.pagination.hasNext,
        hasPrev: data.pagination.hasPrev,
      );
    } else {
      state = state.copyWith(
        orders: AsyncValue.error(
          response.errorDescription ?? 'Failed to load earnings history',
          StackTrace.current,
        ),
      );
    }
  }

  void updateSearch(String query) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      if (query == state.searchQuery) return;
      state = state.copyWith(searchQuery: query, currentPage: 1);
      _fetchEarnings(page: 1);
    });
  }

  void updateMonth(int? month) {
    if (month == state.selectedMonth) return;
    state = state.copyWith(selectedMonth: month, currentPage: 1);
    _fetchEarnings(page: 1);
  }

  void updateYear(int? year) {
    if (year == state.selectedYear) return;
    state = state.copyWith(selectedYear: year, currentPage: 1);
    _fetchEarnings(page: 1);
  }

  void setRowsPerPage(int count) {
    if (count == state.rowsPerPage) return;
    state = state.copyWith(rowsPerPage: count, currentPage: 1);
    _fetchEarnings(page: 1);
  }

  void goToPage(int page) {
    if (page < 1 || page > state.totalPages || page == state.currentPage) {
      return;
    }
    _fetchEarnings(page: page);
  }

  void refresh() => _fetchEarnings(page: state.currentPage);

  @override
  void dispose() {
    _searchDebounce?.cancel();
    super.dispose();
  }
}

final walletOverviewTransactionProvider =
    StateNotifierProvider<
      WalletOverviewTransactionViewModel,
      WalletOverviewTransactionState
    >(
      (ref) =>
          WalletOverviewTransactionViewModel(ref.read(riderApiServiceProvider)),
    );
