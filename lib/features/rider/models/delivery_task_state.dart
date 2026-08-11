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

  /// The key in the GET /orders/counts response for this tab's badge number.
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

// Sentinel that distinguishes "omitted" (keep current value) from "null"
// (explicitly clear the field) in copyWith. Private to this file — the
// viewmodel never needs to reference it directly.
const _undefined = Object();

class DeliveryTaskState {
  final AsyncValue<List<Delivery>> deliveries;
  final DeliveryFilter selectedFilter;

  /// 0-indexed internally. Add 1 before sending to the API.
  final int currentPage;

  final DeliveryPagination pagination;
  final Map<DeliveryFilter, int> deliveryCounts;

  /// The delivery currently shown in the web side panel. Null on mobile.
  final Delivery? selectedDelivery;

  final bool isActionLoading;
  final String? actionError;

  /// Set after a successful confirm-delivery; cleared after the UI shows it.
  final double? lastCreditedAmount;

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
    );
  }
}
