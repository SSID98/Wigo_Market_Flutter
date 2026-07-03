import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:wigo_flutter/features/rider/models/wallet_overview_transaction_state.dart';

import '../models/delivery.dart';
import '../models/wallet_state.dart';

class WalletOverviewTransactionViewModel
    extends StateNotifier<WalletOverviewTransactionState> {
  WalletOverviewTransactionViewModel()
    : super(const WalletOverviewTransactionState()) {
    _loadOrders();
  }

  late final List<Delivery> _allOrders;

  Future<void> _loadOrders() async {
    state = state.copyWith(orders: const AsyncValue.loading());
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      _allOrders = _mockOrders;
      _applyFilterAndPagination();
    } catch (e, st) {
      state = state.copyWith(orders: AsyncValue.error(e, st));
    }
  }

  void _applyFilterAndPagination() {
    List<Delivery> filtered = _allOrders.where((d) {
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

    final rowsPerPage = state.rowsPerPage;
    final startIndex = state.currentPage * rowsPerPage;
    final endIndex = (state.currentPage + 1) * rowsPerPage;
    final paginated = filtered.sublist(
      startIndex,
      endIndex > filtered.length ? filtered.length : endIndex,
    );

    state = state.copyWith(
      orders: AsyncValue.data(paginated),
      totalOrdersCount: filtered.length,
    );
  }

  // void setFilter(OrderFilter filter) {
  //   state = state.copyWith(selectedFilter: filter, currentPage: 0);
  //   _applyFilterAndPagination();
  // }

  void goToPage(int page) {
    if (page >= 0 &&
        page <= (state.totalOrdersCount / state.rowsPerPage).ceil() - 1) {
      state = state.copyWith(currentPage: page);
      _applyFilterAndPagination();
    }
  }

  void setWalletScreenState(WalletScreenState screenState) {
    state = state.copyWith(walletScreenState: screenState);
  }

  void setRowsPerPage(int count) {
    state = state.copyWith(rowsPerPage: count, currentPage: 0);
    _applyFilterAndPagination();
  }

  final _mockOrders = <Delivery>[
    Delivery(
      orderId: "#WGO-4532",
      date: DateTime.now().subtract(const Duration(hours: 2)),
      customerName: "Emmanuel Adebayo",
      items: "10 items",
      fee: 500,
      status: "New Request",
      customerPhone: '+234 809 876 5432',
      deliveryLocation: 'Sandra 1, Block D Hostel.',
      pickupLocation: 'Campus Cafe, Hall 2',
    ),
    Delivery(
      orderId: "#WGO-1345",
      date: DateTime.now().subtract(const Duration(hours: 4)),
      customerName: "Sarah Adebayo",
      items: "1 item",
      fee: 500,
      status: "Delivered",
      customerPhone: '+234 809 876 5432',
      deliveryLocation: 'Sandra 1, Block D Hostel.',
      pickupLocation: 'Campus Cafe, Hall 2',
    ),
    Delivery(
      orderId: "#WGO-1238",
      date: DateTime.now().subtract(const Duration(hours: 6)),
      customerName: "Jane Doe",
      items: "3 items",
      fee: 500,
      status: "Cancelled",
      customerPhone: '+234 809 876 5432',
      deliveryLocation: 'Sandra 1, Block D Hostel.',
      pickupLocation: 'Campus Cafe, Hall 2',
    ),
    Delivery(
      orderId: "#WGO-9876",
      date: DateTime.now().subtract(const Duration(hours: 8)),
      customerName: "John Smith",
      items: "3 items",
      fee: 500,
      status: "On-going",
      customerPhone: '+234 809 876 5432',
      deliveryLocation: 'Sandra 1, Block D Hostel.',
      pickupLocation: 'Campus Cafe, Hall 2',
    ),
    Delivery(
      orderId: "#WGO-9876",
      date: DateTime.now().subtract(const Duration(hours: 8)),
      customerName: "John Smith",
      items: "3 items",
      fee: 500,
      status: "On-going",
      customerPhone: '+234 809 876 5432',
      deliveryLocation: 'Sandra 1, Block D Hostel.',
      pickupLocation: 'Campus Cafe, Hall 2',
    ),
    Delivery(
      orderId: "#WGO-9876",
      date: DateTime.now().subtract(const Duration(hours: 8)),
      customerName: "John Smith",
      items: "3 items",
      fee: 500,
      status: "On-going",
      customerPhone: '+234 809 876 5432',
      deliveryLocation: 'Sandra 1, Block D Hostel.',
      pickupLocation: 'Campus Cafe, Hall 2',
    ),
    Delivery(
      orderId: "#WGO-9876",
      date: DateTime.now().subtract(const Duration(hours: 8)),
      customerName: "John Smith",
      items: "3 items",
      fee: 500,
      status: "On-going",
      customerPhone: '+234 809 876 5432',
      deliveryLocation: 'Sandra 1, Block D Hostel.',
      pickupLocation: 'Campus Cafe, Hall 2',
    ),
    Delivery(
      orderId: "#WGO-9876",
      date: DateTime.now().subtract(const Duration(hours: 8)),
      customerName: "John Smith",
      items: "3 items",
      fee: 500,
      status: "On-going",
      customerPhone: '+234 809 876 5432',
      deliveryLocation: 'Sandra 1, Block D Hostel.',
      pickupLocation: 'Campus Cafe, Hall 2',
    ),
    Delivery(
      orderId: "#WGO-9876",
      date: DateTime.now().subtract(const Duration(hours: 8)),
      customerName: "John Smith",
      items: "3 items",
      fee: 500,
      status: "On-going",
      customerPhone: '+234 809 876 5432',
      deliveryLocation: 'Sandra 1, Block D Hostel.',
      pickupLocation: 'Campus Cafe, Hall 2',
    ),
    Delivery(
      orderId: "#WGO-9876",
      date: DateTime.now().subtract(const Duration(hours: 8)),
      customerName: "John Smith",
      items: "3 items",
      fee: 500,
      status: "On-going",
      customerPhone: '+234 809 876 5432',
      deliveryLocation: 'Sandra 1, Block D Hostel.',
      pickupLocation: 'Campus Cafe, Hall 2',
    ),
  ];
}

final walletOverviewTransactionProvider =
    StateNotifierProvider<
      WalletOverviewTransactionViewModel,
      WalletOverviewTransactionState
    >((ref) => WalletOverviewTransactionViewModel());
