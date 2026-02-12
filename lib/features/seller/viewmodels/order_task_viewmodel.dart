import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wigo_flutter/features/seller/models/order_task_state.dart';

import '../models/order.dart';

class OrderTaskViewmodel extends StateNotifier<OrderTaskState> {
  OrderTaskViewmodel() : super(const OrderTaskState()) {
    _loadOrders();
  }

  final int _pageSize = 10;
  late final List<Order> _allOrders;

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
      OrderFilter.newRequest:
          _allOrders.where((d) => d.status == "New Request").length,
      OrderFilter.ongoing:
          _allOrders.where((d) => d.status == "On-going").length,
      OrderFilter.completed:
          _allOrders.where((d) => d.status == "Delivered").length,
      OrderFilter.cancelled:
          _allOrders.where((d) => d.status == "Cancelled").length,
    };
    state = state.copyWith(orderCounts: newCounts);
  }

  void _applyFilterAndPagination() {
    List<Order> filtered =
        _allOrders.where((d) {
          switch (state.selectedFilter) {
            case OrderFilter.all:
              return true;
            case OrderFilter.newRequest:
              return d.status == "New Request";
            case OrderFilter.ongoing:
              return d.status == "On-going";
            case OrderFilter.completed:
              return d.status == "Delivered";
            case OrderFilter.cancelled:
              return d.status == "Cancelled";
          }
        }).toList();

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

  void setFilter(OrderFilter filter) {
    state = state.copyWith(selectedFilter: filter, currentPage: 0);
    _applyFilterAndPagination();
  }

  void goToPage(int page) {
    if (page >= 0 && page <= (state.totalOrdersCount / _pageSize).ceil() - 1) {
      state = state.copyWith(currentPage: page);
      _applyFilterAndPagination();
    }
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
      status: "New Request",
      customerPhone: '+234 809 876 5432',
      deliveryLocation: 'Sandra 1, Block D Hostel.',
      pickupLocation: 'Campus Cafe, Hall 2',
    ),
    Order(
      orderId: "#WGO-1345",
      date: DateTime.now().subtract(const Duration(hours: 4)),
      customerName: "Sarah Adebayo",
      item: "1 item",
      amount: 500,
      status: "Delivered",
      customerPhone: '+234 809 876 5432',
      deliveryLocation: 'Sandra 1, Block D Hostel.',
      pickupLocation: 'Campus Cafe, Hall 2',
    ),
    Order(
      orderId: "#WGO-1238",
      date: DateTime.now().subtract(const Duration(hours: 6)),
      customerName: "Jane Doe",
      item: "2 items",
      amount: 500,
      status: "Cancelled",
      customerPhone: '+234 809 876 5432',
      deliveryLocation: 'Sandra 1, Block D Hostel.',
      pickupLocation: 'Campus Cafe, Hall 2',
    ),
    Order(
      orderId: "#WGO-9876",
      date: DateTime.now().subtract(const Duration(hours: 8)),
      customerName: "John Smith",
      item: "3 items",
      amount: 500,
      status: "On-going",
      customerPhone: '+234 809 876 5432',
      deliveryLocation: 'Sandra 1, Block D Hostel.',
      pickupLocation: 'Campus Cafe, Hall 2',
    ),
  ];
}

final orderTaskProvider =
    StateNotifierProvider<OrderTaskViewmodel, OrderTaskState>(
      (ref) => OrderTaskViewmodel(),
    );
