import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../models/order.dart';
import '../models/order_task_state.dart';
import '../services/seller_api_service.dart';

class OrderTaskViewmodel extends StateNotifier<OrderTaskState> {
  OrderTaskViewmodel(this._api) : super(const OrderTaskState());

  final SellerApiService _api;
  Timer? _searchDebounce;

  @override
  void dispose() {
    _searchDebounce?.cancel();
    super.dispose();
  }

  Future<void> loadOrders({bool resetPage = false}) async {
    if (resetPage) {
      state = state.copyWith(currentPage: 0);
    }
    state = state.copyWith(orders: const AsyncValue.loading());
    try {
      final statusParam = state.activeStatuses.isEmpty
          ? null
          : state.activeStatuses.map((s) => s.toJsonString).join(',');

      final orderTypeParam = state.deliveryType == DeliveryType.all
          ? null
          : state.deliveryType.displayName;

      DateTime? dateFrom;
      DateTime? dateTo;
      if (state.dateFilterType == DateFilterType.today) {
        final now = DateTime.now();
        dateFrom = DateTime(now.year, now.month, now.day);
        dateTo = dateFrom;
      } else if (state.dateFilterType == DateFilterType.custom &&
          state.activeSelectedDates.isNotEmpty) {
        final sorted = state.activeSelectedDates.toList()..sort();
        dateFrom = sorted.first;
        dateTo = sorted.length > 1 ? sorted.last : _normalize(DateTime.now());
      }

      final response = await _api.getOrders(
        category: state.category.apiValue,
        status: statusParam,
        orderType: orderTypeParam,
        dateFrom: dateFrom,
        dateTo: dateTo,
        search: state.searchQuery.isEmpty ? null : state.searchQuery,
        sortBy: state.sortBy,
        sortOrder: state.sortOrder,
        page: state.currentPage + 1,
        limit: state.rowsPerPage,
      );

      final page = response.data;
      if (response.isSuccess && page != null) {
        state = state.copyWith(
          orders: AsyncValue.data(page.orders),
          totalOrdersCount: page.pagination.total,
          categoryCounts: page.counts,
        );
      } else {
        state = state.copyWith(
          orders: AsyncValue.error(
            response.errorDescription ?? 'Failed to load orders',
            StackTrace.current,
          ),
        );
      }
    } catch (e, st) {
      state = state.copyWith(orders: AsyncValue.error(e, st));
    }
  }

  Future<void> refresh() => loadOrders();

  void setCategory(OrderCategory category) {
    if (category == state.category) return;
    state = state.copyWith(category: category);
    loadOrders(resetPage: true);
  }

  void onSearchChanged(String query) {
    state = state.copyWith(searchQuery: query);
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 450), () {
      loadOrders(resetPage: true);
    });
  }

  void syncTempWithActive() {
    state = state.copyWith(
      tempSelectedStatuses: Set.from(state.activeStatuses),
    );
  }

  void toggleStatusSelection(OrderFilter status) {
    final currentSet = Set<OrderFilter>.from(state.tempSelectedStatuses);
    if (currentSet.contains(status)) {
      currentSet.remove(status);
    } else {
      currentSet.add(status);
    }
    state = state.copyWith(tempSelectedStatuses: currentSet);
  }

  void applyFilters() {
    state = state.copyWith(
      activeStatuses: Set.from(state.tempSelectedStatuses),
    );
    loadOrders(resetPage: true);
  }

  void setSingleStatusFilter(OrderFilter? status) {
    state = state.copyWith(activeStatuses: status == null ? {} : {status});
    loadOrders(resetPage: true);
  }

  void goToPage(int page) {
    final totalPages = (state.totalOrdersCount / state.rowsPerPage).ceil();
    if (page >= 0 && page <= (totalPages - 1)) {
      state = state.copyWith(currentPage: page);
      loadOrders();
    }
  }

  void setRowsPerPage(int rows) {
    if (rows <= 0 || rows == state.rowsPerPage) return;
    state = state.copyWith(rowsPerPage: rows, currentPage: 0);
    loadOrders();
  }

  void setTodayFilter() {
    state = state.copyWith(dateFilterType: DateFilterType.today);
    loadOrders(resetPage: true);
  }

  void clearDateFilter() {
    state = state.copyWith(
      dateFilterType: DateFilterType.all,
      activeSelectedDates: {},
      tempSelectedDates: {},
    );
    loadOrders(resetPage: true);
  }

  DateTime _normalize(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  void toggleDateSelection(DateTime date) {
    final normalized = _normalize(date);
    final currentSet = Set<DateTime>.from(state.tempSelectedDates);

    if (currentSet.contains(normalized)) {
      currentSet.remove(normalized);
    } else if (currentSet.length >= 2) {
      currentSet
        ..clear()
        ..add(normalized);
    } else {
      currentSet.add(normalized);
    }
    state = state.copyWith(tempSelectedDates: currentSet);
  }

  void syncDateTempWithActive() {
    state = state.copyWith(
      tempSelectedDates: Set.from(state.activeSelectedDates),
    );
  }

  void applyDateFilters() {
    state = state.copyWith(
      activeSelectedDates: Set.from(state.tempSelectedDates),
      dateFilterType: state.tempSelectedDates.isEmpty
          ? DateFilterType.all
          : DateFilterType.custom,
    );
    loadOrders(resetPage: true);
  }

  void setDeliveryType(DeliveryType type) {
    state = state.copyWith(deliveryType: type);
    loadOrders(resetPage: true);
  }

  void setSort(String sortBy, String sortOrder) {
    if (sortBy == state.sortBy && sortOrder == state.sortOrder) return;
    state = state.copyWith(sortBy: sortBy, sortOrder: sortOrder);
    loadOrders(resetPage: true);
  }

  Future<String?> updateOrderStatus(
    String orderId,
    OrderFilter newStatus, {
    String? reason,
  }) async {
    try {
      final response = await _api.updateOrderStatus(
        orderId,
        newStatus,
        reason: reason,
      );

      if (response.isSuccess) {
        unawaited(refresh());
        return null;
      }

      if (response.statusCode == 409) {
        unawaited(refresh());
        return null;
      }
      if (response.statusCode == 422) {
        unawaited(refresh());
        return "This order's status has changed. Refresh to see the "
            'available actions.';
      }

      return response.errorDescription ?? 'Could not update the order status.';
    } catch (_) {
      return 'Something went wrong updating the order. Please try again.';
    }
  }
}

final orderTaskProvider =
    StateNotifierProvider<OrderTaskViewmodel, OrderTaskState>(
      (ref) => OrderTaskViewmodel(ref.read(sellerApiServiceProvider)),
    );

final orderByIdProvider = Provider.family<Order?, String>((ref, orderId) {
  final orders = ref.watch(orderTaskProvider).orders.value;
  if (orders == null) return null;
  for (final order in orders) {
    if (order.id == orderId) return order;
  }
  return null;
});
