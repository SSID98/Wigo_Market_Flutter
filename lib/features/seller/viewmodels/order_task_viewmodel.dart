import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wigo_flutter/features/seller/models/order_task_state.dart';

import '../models/order.dart';

class OrderTaskViewmodel extends StateNotifier<OrderTaskState> {
  OrderTaskViewmodel() : super(const OrderTaskState()) {
    _loadOrders();
  }

  final int _pageSize = 10;
  late List<Order> _allOrders;

  Future<void> _loadOrders() async {
    state = state.copyWith(orders: const AsyncValue.loading());
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      _allOrders = _mockOrders;
      _updateCounts();
      _applyFilterAndPagination();
    } catch (e, st) {
      state = state.copyWith(orders: AsyncValue.error(e, st));
    }
  }

  void _updateCounts() {
    final Map<OrderFilter, int> newCounts = {
      OrderFilter.all: _allOrders.length,
      OrderFilter.pending:
          _allOrders.where((d) => d.status == OrderFilter.pending).length,
      OrderFilter.confirmed:
          _allOrders.where((d) => d.status == OrderFilter.confirmed).length,
      OrderFilter.preparing:
          _allOrders.where((d) => d.status == OrderFilter.preparing).length,
      OrderFilter.pickUpReady:
          _allOrders.where((d) => d.status == OrderFilter.pickUpReady).length,
      OrderFilter.cancelled:
          _allOrders.where((d) => d.status == OrderFilter.cancelled).length,
      OrderFilter.inTransit:
          _allOrders.where((d) => d.status == OrderFilter.inTransit).length,
      OrderFilter.delivered:
          _allOrders.where((d) => d.status == OrderFilter.delivered).length,
    };
    state = state.copyWith(orderCounts: newCounts);
  }

  // void _applyFilterAndPagination() {
  //   List<Order> filtered =
  //       _allOrders.where((d) {
  //         // If no specific statuses are selected, show all (or handle via OrderFilter.all)
  //         if (state.activeStatuses.isEmpty ||
  //             state.activeStatuses.contains(OrderFilter.all)) {
  //           return true;
  //         }
  //         // Check if the order's status is in our "Active" set
  //         return state.activeStatuses.contains(d.status);
  //       }).toList();
  //   // List<Order> filtered =
  //   //     _allOrders.where((d) {
  //   //       if (state.selectedFilter == OrderFilter.all) return true;
  //   //       return d.status == state.selectedFilter;
  //   //     }).toList();
  //
  //   if (state.dateFilterType == DateFilterType.today) {
  //     final now = DateTime.now();
  //     filtered =
  //         filtered.where((d) {
  //           return d.date.year == now.year &&
  //               d.date.month == now.month &&
  //               d.date.day == now.day;
  //         }).toList();
  //   }
  //
  //   if (state.dateFilterType == DateFilterType.custom &&
  //       state.customDate != null) {
  //     final c = state.customDate!;
  //     filtered =
  //         filtered.where((d) {
  //           return d.date.year == c.year &&
  //               d.date.month == c.month &&
  //               d.date.day == c.day;
  //         }).toList();
  //   }
  //
  //   final startIndex = state.currentPage * _pageSize;
  //   final endIndex = (state.currentPage + 1) * _pageSize;
  //   final paginated = filtered.sublist(
  //     startIndex,
  //     endIndex > filtered.length ? filtered.length : endIndex,
  //   );
  //
  //   state = state.copyWith(
  //     orders: AsyncValue.data(paginated),
  //     totalOrdersCount: filtered.length,
  //   );
  // }

  void _applyFilterAndPagination() {
    // Start with the full list
    List<Order> filtered = List.from(_allOrders);

    // 1. Apply Status Filter (Using the "Active" set)
    if (state.activeStatuses.isNotEmpty &&
        !state.activeStatuses.contains(OrderFilter.all)) {
      filtered =
          filtered
              .where((d) => state.activeStatuses.contains(d.status))
              .toList();
    }

    // 2. Apply Date Filter (Today)
    if (state.dateFilterType == DateFilterType.today) {
      final now = DateTime.now();
      filtered =
          filtered
              .where(
                (d) =>
                    d.date.year == now.year &&
                    d.date.month == now.month &&
                    d.date.day == now.day,
              )
              .toList();
    }

    // 3. Apply Date Filter (Custom)
    if (state.activeSelectedDates.isNotEmpty) {
      filtered =
          filtered.where((order) {
            return state.activeSelectedDates.contains(_normalize(order.date));
          }).toList();
    }
    // if (state.dateFilterType == DateFilterType.custom &&
    //     state.customDate != null) {
    //   final c = state.customDate!;
    //   filtered =
    //       filtered
    //           .where(
    //             (d) =>
    //                 d.date.year == c.year &&
    //                 d.date.month == c.month &&
    //                 d.date.day == c.day,
    //           )
    //           .toList();
    // }

    // 4. Pagination (Always last)
    final startIndex = state.currentPage * _pageSize;
    final endIndex = (state.currentPage + 1) * _pageSize;
    final paginated = filtered.sublist(
      startIndex,
      endIndex > filtered.length ? filtered.length : endIndex,
    );

    state = state.copyWith(
      orders: AsyncValue.data(paginated),
      totalOrdersCount: filtered.length,
    );
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

  // 2. The "Apply Now" button logic
  void applyFilters() {
    state = state.copyWith(
      activeStatuses: Set.from(state.tempSelectedStatuses),
      currentPage: 0,
    );
    _applyFilterAndPagination();
  }

  void setFilter(OrderFilter filter) {
    state = state.copyWith(selectedFilter: filter, currentPage: 0);
    _applyFilterAndPagination();
  }

  void toggleSelectStatus(bool? value) {
    state = state.copyWith(selectStatus: value ?? false);
  }

  void goToPage(int page) {
    if (page >= 0 && page <= (state.totalOrdersCount / _pageSize).ceil() - 1) {
      state = state.copyWith(currentPage: page);
      _applyFilterAndPagination();
    }
  }

  void setTodayFilter() {
    state = state.copyWith(
      dateFilterType: DateFilterType.today,
      customDate: null,
      currentPage: 0,
    );
    _applyFilterAndPagination();
  }

  void setCustomDate(DateTime date) {
    state = state.copyWith(
      dateFilterType: DateFilterType.custom,
      customDate: date,
      currentPage: 0,
    );
    _applyFilterAndPagination();
  }

  void clearDateFilter() {
    state = state.copyWith(
      dateFilterType: DateFilterType.all,
      customDate: null,
      currentPage: 0,
    );
    _applyFilterAndPagination();
  }

  DateTime _normalize(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  void toggleDateSelection(DateTime date) {
    final normalized = _normalize(date);
    final currentSet = Set<DateTime>.from(state.tempSelectedDates);

    if (currentSet.contains(normalized)) {
      currentSet.remove(normalized);
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
      // If dates are selected, we change the filter type to 'custom' or a new 'multiple' type
      dateFilterType:
          state.tempSelectedDates.isEmpty
              ? DateFilterType.all
              : DateFilterType.custom,
      currentPage: 0,
    );
    _applyFilterAndPagination();
  }

  void updateOrderStatus(String orderId, OrderFilter newStatus) {
    _allOrders =
        _allOrders.map((order) {
          if (order.orderId == orderId) {
            return order.copyWith(status: newStatus);
          }
          return order;
        }).toList();

    _updateCounts();
    _applyFilterAndPagination();
  }

  // void setWalletScreenState(WalletScreenState screenState) {
  //   state = state.copyWith(walletScreenState: screenState);
  // }

  final _mockOrders = <Order>[
    Order(
      orderId: "#WGO-4532",
      date: DateTime.now().subtract(const Duration(hours: 2)),
      customerName: "Emmanuel Adebayo",
      item: "10 items",
      amount: 500,
      status: OrderFilter.pending,
      customerPhone: '+234 809 876 5432',
      deliveryLocation: 'Sandra 1, Block D Hostel.',
      pickupLocation: 'Campus Cafe, Hall 2',
      deliveryType: 'Delivery',
    ),
    Order(
      orderId: "#WGO-1345",
      date: DateTime.now().subtract(const Duration(days: 1)),
      customerName: "Sarah Adebayo",
      item: "1 item",
      amount: 500,
      status: OrderFilter.preparing,
      customerPhone: '+234 809 876 5432',
      deliveryLocation: 'Sandra 1, Block D Hostel.',
      pickupLocation: 'Campus Cafe, Hall 2',
      deliveryType: 'Delivery',
    ),
    Order(
      orderId: "#WGO-1238",
      date: DateTime.now().subtract(const Duration(days: 7)),
      customerName: "Jane Doe",
      item: "2 items",
      amount: 500,
      status: OrderFilter.cancelled,
      customerPhone: '+234 809 876 5432',
      deliveryLocation: 'Sandra 1, Block D Hostel.',
      pickupLocation: 'Campus Cafe, Hall 2',
      deliveryType: 'Pick up',
    ),
    Order(
      orderId: "#WGO-9876",
      date: DateTime(2020, 12, 25),
      customerName: "John Smith",
      item: "3 items",
      amount: 500,
      status: OrderFilter.confirmed,
      customerPhone: '+234 809 876 5432',
      deliveryLocation: 'Sandra 1, Block D Hostel.',
      pickupLocation: 'Campus Cafe, Hall 2',
      deliveryType: 'Pick up',
    ),
    Order(
      orderId: "#WGO-9875",
      date: DateTime.now().subtract(const Duration(hours: 8)),
      customerName: "Peter Parker",
      item: "3 items",
      amount: 500,
      status: OrderFilter.pickUpReady,
      customerPhone: '+234 809 876 5432',
      deliveryLocation: 'Sandra 1, Block D Hostel.',
      pickupLocation: 'Campus Cafe, Hall 2',
      deliveryType: 'Pick up',
    ),
    Order(
      orderId: "#WGO-9865",
      date: DateTime.now().subtract(const Duration(hours: 8)),
      customerName: "Abraham Lincon",
      item: "10 items",
      amount: 500,
      status: OrderFilter.inTransit,
      customerPhone: '+234 809 876 5432',
      deliveryLocation: 'Sandra 1, Block D Hostel.',
      pickupLocation: 'Campus Cafe, Hall 2',
      deliveryType: 'Delivery',
    ),
    Order(
      orderId: "#WGO-9865",
      date: DateTime.now().subtract(const Duration(hours: 8)),
      customerName: "John Jonhzzns",
      item: "10 items",
      amount: 500,
      status: OrderFilter.delivered,
      customerPhone: '+234 809 876 5432',
      deliveryLocation: 'Sandra 1, Block D Hostel.',
      pickupLocation: 'Campus Cafe, Hall 2',
      deliveryType: 'Delivery',
    ),
  ];
}

final orderTaskProvider =
    StateNotifierProvider<OrderTaskViewmodel, OrderTaskState>(
      (ref) => OrderTaskViewmodel(),
    );
