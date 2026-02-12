import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'order.dart';

enum OrderFilter { all, newRequest, ongoing, completed, cancelled }

class OrderTaskState {
  final AsyncValue<List<Order>> orders;
  final OrderFilter selectedFilter;
  final int currentPage;
  final int totalOrdersCount;
  final Map<OrderFilter, int> orderCounts;
  final int rowsPerPage;

  // final WalletScreenState walletScreenState;

  const OrderTaskState({
    this.orders = const AsyncValue.data([]),
    this.selectedFilter = OrderFilter.all,
    this.currentPage = 0,
    this.totalOrdersCount = 0,
    this.orderCounts = const {},
    this.rowsPerPage = 10,
    // this.walletScreenState = WalletScreenState.overview,
  });

  OrderTaskState copyWith({
    AsyncValue<List<Order>>? orders,
    OrderFilter? selectedFilter,
    int? currentPage,
    int? totalOrdersCount,
    Map<OrderFilter, int>? orderCounts,
    int? rowsPerPage,
    // WalletScreenState? walletScreenState,
  }) {
    return OrderTaskState(
      orders: orders ?? this.orders,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      currentPage: currentPage ?? this.currentPage,
      totalOrdersCount: totalOrdersCount ?? this.totalOrdersCount,
      orderCounts: orderCounts ?? this.orderCounts,
      rowsPerPage: rowsPerPage ?? this.rowsPerPage,
      // walletScreenState: walletScreenState ?? this.walletScreenState,
    );
  }
}

extension DeliveryTaskSelectors on OrderTaskState {
  List<Order> get filteredDeliveries {
    return orders.when(
      data: (list) {
        switch (selectedFilter) {
          case OrderFilter.all:
            return list;
          case OrderFilter.newRequest:
            return list.where((d) => d.status == "New Request").toList();
          case OrderFilter.ongoing:
            return list.where((d) => d.status == "In Progress").toList();
          case OrderFilter.completed:
            return list.where((d) => d.status == "Completed").toList();
          case OrderFilter.cancelled:
            return list.where((d) => d.status == "Cancelled").toList();
        }
      },
      loading: () => [],
      error: (_, __) => [],
    );
  }
}
