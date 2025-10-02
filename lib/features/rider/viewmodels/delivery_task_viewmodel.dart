import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/delivery.dart';
import '../models/delivery_task_state.dart';
import '../models/wallet_state.dart';

class DeliveryTaskViewModel extends StateNotifier<DeliveryTaskState> {
  DeliveryTaskViewModel() : super(const DeliveryTaskState()) {
    _loadDeliveries();
  }

  final int _pageSize = 3;
  late final List<Delivery> _allDeliveries;

  Future<void> _loadDeliveries() async {
    state = state.copyWith(deliveries: const AsyncValue.loading());
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      _allDeliveries = _mockDeliveries;
      _updateCounts();
      _applyFilterAndPagination();
    } catch (e, st) {
      state = state.copyWith(deliveries: AsyncValue.error(e, st));
    }
  }

  void _updateCounts() {
    final Map<DeliveryFilter, int> newCounts = {
      DeliveryFilter.all: _allDeliveries.length,
      DeliveryFilter.newRequest:
          _allDeliveries.where((d) => d.status == "New Request").length,
      DeliveryFilter.ongoing:
          _allDeliveries.where((d) => d.status == "On-going").length,
      DeliveryFilter.completed:
          _allDeliveries.where((d) => d.status == "Delivered").length,
      DeliveryFilter.cancelled:
          _allDeliveries.where((d) => d.status == "Cancelled").length,
    };
    state = state.copyWith(deliveryCounts: newCounts);
  }

  void _applyFilterAndPagination() {
    List<Delivery> filtered =
        _allDeliveries.where((d) {
          switch (state.selectedFilter) {
            case DeliveryFilter.all:
              return true;
            case DeliveryFilter.newRequest:
              return d.status == "New Request";
            case DeliveryFilter.ongoing:
              return d.status == "On-going";
            case DeliveryFilter.completed:
              return d.status == "Delivered";
            case DeliveryFilter.cancelled:
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
      deliveries: AsyncValue.data(paginated),
      totalDeliveriesCount: filtered.length,
    );
  }

  void setFilter(DeliveryFilter filter) {
    state = state.copyWith(selectedFilter: filter, currentPage: 0);
    _applyFilterAndPagination();
  }

  void goToPage(int page) {
    if (page >= 0 &&
        page <= (state.totalDeliveriesCount / _pageSize).ceil() - 1) {
      state = state.copyWith(currentPage: page);
      _applyFilterAndPagination();
    }
  }

  void setWalletScreenState(WalletScreenState screenState) {
    state = state.copyWith(walletScreenState: screenState);
  }

  final _mockDeliveries = <Delivery>[
    Delivery(
      orderId: "#WGO-4532",
      date: DateTime.now().subtract(const Duration(hours: 2)),
      customerName: "Emmanuel Adebayo",
      items: "1 Food Pack, 1 Drink",
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
      items: "2 Food Pack, 1 Drink",
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
      items: "1 Food Pack, 1 Drink",
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

final deliveryTaskProvider =
    StateNotifierProvider<DeliveryTaskViewModel, DeliveryTaskState>(
      (ref) => DeliveryTaskViewModel(),
    );
