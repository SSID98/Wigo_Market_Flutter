import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'delivery.dart';

enum DeliveryFilter { all, newRequest, ongoing, completed, cancelled }

enum WalletScreenState {
  overview,
  transactions,
  paymentMethods,
  setupPin,
  pinSuccess,
}

class DeliveryTaskState {
  final AsyncValue<List<Delivery>> deliveries;
  final DeliveryFilter selectedFilter;
  final int currentPage;
  final int totalDeliveriesCount;
  final Map<DeliveryFilter, int> deliveryCounts;
  final WalletScreenState walletScreenState;
  final int rowsPerPage;

  const DeliveryTaskState({
    this.deliveries = const AsyncValue.data([]),
    this.selectedFilter = DeliveryFilter.all,
    this.currentPage = 0,
    this.totalDeliveriesCount = 0,
    this.deliveryCounts = const {},
    this.walletScreenState = WalletScreenState.overview,
    this.rowsPerPage = 10,
  });

  DeliveryTaskState copyWith({
    AsyncValue<List<Delivery>>? deliveries,
    DeliveryFilter? selectedFilter,
    int? currentPage,
    int? totalDeliveriesCount,
    Map<DeliveryFilter, int>? deliveryCounts,
    WalletScreenState? walletScreenState,
    int? rowsPerPage,
  }) {
    return DeliveryTaskState(
      deliveries: deliveries ?? this.deliveries,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      currentPage: currentPage ?? this.currentPage,
      totalDeliveriesCount: totalDeliveriesCount ?? this.totalDeliveriesCount,
      deliveryCounts: deliveryCounts ?? this.deliveryCounts,
      walletScreenState: walletScreenState ?? this.walletScreenState,
      rowsPerPage: rowsPerPage ?? this.rowsPerPage,
    );
  }
}

extension DeliveryTaskSelectors on DeliveryTaskState {
  List<Delivery> get filteredDeliveries {
    return deliveries.when(
      data: (list) {
        switch (selectedFilter) {
          case DeliveryFilter.all:
            return list;
          case DeliveryFilter.newRequest:
            return list.where((d) => d.status == "New Request").toList();
          case DeliveryFilter.ongoing:
            return list.where((d) => d.status == "In Progress").toList();
          case DeliveryFilter.completed:
            return list.where((d) => d.status == "Completed").toList();
          case DeliveryFilter.cancelled:
            return list.where((d) => d.status == "Cancelled").toList();
        }
      },
      loading: () => [],
      error: (_, __) => [],
    );
  }
}
