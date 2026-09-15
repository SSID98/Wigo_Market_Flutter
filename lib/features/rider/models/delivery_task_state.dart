import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'delivery_model.dart';

enum DeliveryFilter { all, newRequest, ongoing, completed, cancelled }

extension DeliveryFilterExtension on DeliveryFilter {
  String get displayName {
    switch (this) {
      case DeliveryFilter.all:
        return 'All';
      case DeliveryFilter.newRequest:
        return 'New Request';
      case DeliveryFilter.ongoing:
        return 'Ongoing';
      case DeliveryFilter.completed:
        return 'Completed';
      case DeliveryFilter.cancelled:
        return 'Cancelled';
    }
  }

  String get tabParam {
    switch (this) {
      case DeliveryFilter.all:
        return 'all';
      case DeliveryFilter.newRequest:
        return 'available';
      case DeliveryFilter.ongoing:
        return 'ongoing';
      case DeliveryFilter.completed:
        return 'completed';
      case DeliveryFilter.cancelled:
        return 'cancelled';
    }
  }

  String get countKey {
    switch (this) {
      case DeliveryFilter.all:
        return 'all';
      case DeliveryFilter.newRequest:
        return 'available';
      case DeliveryFilter.ongoing:
        return 'ongoing';
      case DeliveryFilter.completed:
        return 'completed';
      case DeliveryFilter.cancelled:
        return 'cancelled';
    }
  }
}

const _undefined = Object();

class DeliveryTaskState {
  final AsyncValue<List<Delivery>> deliveries;
  final DeliveryFilter selectedFilter;
  final int currentPage;
  final DeliveryPagination pagination;
  final Map<DeliveryFilter, int> deliveryCounts;
  final Delivery? selectedDelivery;
  final bool isActionLoading;
  final String? actionError;
  final double? lastCreditedAmount;
  final int rowsPerPage;

  const DeliveryTaskState({
    this.deliveries = const AsyncValue.data([]),
    this.selectedFilter = DeliveryFilter.all,
    this.currentPage = 0,
    this.pagination = DeliveryPagination.empty,
    this.deliveryCounts = const {},
    this.selectedDelivery,
    this.isActionLoading = false,
    this.actionError,
    this.lastCreditedAmount,
    this.rowsPerPage = 10,
  });

  int get totalDeliveriesCount => pagination.totalOrders;

  int get totalPages => pagination.totalPages == 0 ? 1 : pagination.totalPages;

  DeliveryTaskState copyWith({
    AsyncValue<List<Delivery>>? deliveries,
    DeliveryFilter? selectedFilter,
    int? currentPage,
    DeliveryPagination? pagination,
    Map<DeliveryFilter, int>? deliveryCounts,
    Object? selectedDelivery = _undefined,
    bool? isActionLoading,
    Object? actionError = _undefined,
    Object? lastCreditedAmount = _undefined,
    int? rowsPerPage,
  }) {
    return DeliveryTaskState(
      deliveries: deliveries ?? this.deliveries,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      currentPage: currentPage ?? this.currentPage,
      pagination: pagination ?? this.pagination,
      deliveryCounts: deliveryCounts ?? this.deliveryCounts,
      selectedDelivery: identical(selectedDelivery, _undefined)
          ? this.selectedDelivery
          : selectedDelivery as Delivery?,
      isActionLoading: isActionLoading ?? this.isActionLoading,
      actionError: identical(actionError, _undefined)
          ? this.actionError
          : actionError as String?,
      lastCreditedAmount: identical(lastCreditedAmount, _undefined)
          ? this.lastCreditedAmount
          : lastCreditedAmount as double?,
      rowsPerPage: rowsPerPage ?? this.rowsPerPage,
    );
  }
}
