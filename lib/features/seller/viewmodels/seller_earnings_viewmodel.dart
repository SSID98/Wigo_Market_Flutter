import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../models/seller_earnings_models.dart';
import '../models/seller_earnings_state.dart';
import '../services/seller_api_service.dart';

class SellerEarningsViewModel extends StateNotifier<SellerEarningsState> {
  SellerEarningsViewModel(this._api) : super(const SellerEarningsState());

  final SellerApiService _api;
  Timer? _searchDebounce;

  int _requestId = 0;

  @override
  void dispose() {
    _searchDebounce?.cancel();
    super.dispose();
  }

  DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);

  Future<void> loadEarnings({
    bool resetPage = false,
    bool forceSummary = false,
  }) async {
    if (!mounted) return;

    final requestId = ++_requestId;
    final page = resetPage ? 0 : state.currentPage;

    final hasSummary = state.summary.hasValue;
    final needsSummary = forceSummary || !hasSummary;

    state = state.copyWith(
      currentPage: page,
      earnings: const AsyncValue<List<SellerEarning>>.loading(),
      summary: hasSummary ? null : const AsyncValue<EarningsSummary>.loading(),
    );

    try {
      final response = await _api.getEarnings(
        search: state.searchQuery.isEmpty ? null : state.searchQuery,
        dateFrom: state.dateFrom,
        dateTo: state.dateTo,
        page: page + 1,
        limit: state.rowsPerPage,
        includeSummary: needsSummary,
      );

      if (!mounted || requestId != _requestId) return;

      final data = response.data;
      if (response.isSuccess && data != null) {
        final lastPage = data.pagination.pages - 1;
        if (data.earnings.isEmpty &&
            data.pagination.total > 0 &&
            page > lastPage &&
            lastPage >= 0) {
          state = state.copyWith(currentPage: lastPage);
          return loadEarnings();
        }

        AsyncValue<EarningsSummary>? summary;
        if (data.summary != null) {
          summary = AsyncValue.data(data.summary!);
        } else if (!state.summary.hasValue) {
          summary = AsyncValue.error(
            'Failed to load earnings summary',
            StackTrace.current,
          );
        }

        state = state.copyWith(
          earnings: AsyncValue.data(data.earnings),
          totalCount: data.pagination.total,
          totalPages: data.pagination.pages,
          summary: summary,
        );
      } else {
        _setError(response.errorDescription ?? 'Failed to load earnings');
      }
    } catch (e) {
      if (!mounted || requestId != _requestId) return;
      _setError('Something went wrong loading your earnings.');
    }
  }

  void _setError(String message) {
    state = state.copyWith(
      earnings: AsyncValue.error(message, StackTrace.current),
      summary: state.summary.hasValue
          ? null
          : AsyncValue.error(message, StackTrace.current),
    );
  }

  Future<void> refresh() => loadEarnings(forceSummary: true);

  void onSearchChanged(String query) {
    final trimmed = query.trim();
    if (trimmed == state.searchQuery) return;
    state = state.copyWith(searchQuery: trimmed);
    _searchDebounce?.cancel();
    _searchDebounce = Timer(
      const Duration(milliseconds: 450),
      () => loadEarnings(resetPage: true),
    );
  }

  void goToPage(int page) {
    if (page < 0 || page > state.totalPages - 1 || page == state.currentPage) {
      return;
    }
    state = state.copyWith(currentPage: page);
    loadEarnings();
  }

  void setRowsPerPage(int rows) {
    if (rows <= 0 || rows == state.rowsPerPage) return;
    state = state.copyWith(rowsPerPage: rows, currentPage: 0);
    loadEarnings();
  }

  void setTodayFilter() {
    if (state.dateFilter == EarningsDateFilter.today) return;
    final today = _day(DateTime.now());
    state = state.copyWith(
      dateFilter: EarningsDateFilter.today,
      dateFrom: today,
      dateTo: today,
    );
    loadEarnings(resetPage: true);
  }

  void applyDateRange(DateTime from, DateTime to) {
    var start = _day(from);
    var end = _day(to);
    if (end.isBefore(start)) {
      final tmp = start;
      start = end;
      end = tmp;
    }
    state = state.copyWith(
      dateFilter: EarningsDateFilter.custom,
      dateFrom: start,
      dateTo: end,
    );
    loadEarnings(resetPage: true);
  }

  void clearDateFilter() {
    if (!state.hasDateFilter) return;
    state = state.copyWith(
      dateFilter: EarningsDateFilter.all,
      clearDateRange: true,
    );
    loadEarnings(resetPage: true);
  }
}

final sellerEarningsViewModelProvider =
    StateNotifierProvider.autoDispose<
      SellerEarningsViewModel,
      SellerEarningsState
    >((ref) => SellerEarningsViewModel(ref.read(sellerApiServiceProvider)));
