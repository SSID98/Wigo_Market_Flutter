import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'order.dart';
import 'order_details_model.dart';
import 'order_enums.dart';

export 'order_enums.dart';

class OrderTaskState {
  final AsyncValue<List<Order>> orders;
  final OrderCategory category;
  final DeliveryType deliveryType;
  final DateFilterType dateFilterType;
  final int currentPage;
  final int totalOrdersCount;
  final OrderCounts categoryCounts;
  final int rowsPerPage;
  final Set<OrderFilter> tempSelectedStatuses;
  final Set<OrderFilter> activeStatuses;
  final Set<DateTime> tempSelectedDates;
  final Set<DateTime> activeSelectedDates;
  final String searchQuery;
  final String sortBy;
  final String sortOrder;

  const OrderTaskState({
    this.orders = const AsyncValue.data([]),
    this.category = OrderCategory.all,
    this.deliveryType = DeliveryType.all,
    this.dateFilterType = DateFilterType.all,
    this.currentPage = 0,
    this.totalOrdersCount = 0,
    this.categoryCounts = const OrderCounts(),
    this.rowsPerPage = 10,
    this.tempSelectedStatuses = const {},
    this.activeStatuses = const {},
    this.tempSelectedDates = const {},
    this.activeSelectedDates = const {},
    this.searchQuery = '',
    this.sortBy = 'date',
    this.sortOrder = 'desc',
  });

  OrderTaskState copyWith({
    AsyncValue<List<Order>>? orders,
    OrderCategory? category,
    DeliveryType? deliveryType,
    DateFilterType? dateFilterType,
    int? currentPage,
    int? totalOrdersCount,
    OrderCounts? categoryCounts,
    int? rowsPerPage,
    Set<OrderFilter>? tempSelectedStatuses,
    Set<OrderFilter>? activeStatuses,
    Set<DateTime>? tempSelectedDates,
    Set<DateTime>? activeSelectedDates,
    String? searchQuery,
    String? sortBy,
    String? sortOrder,
  }) {
    return OrderTaskState(
      orders: orders ?? this.orders,
      category: category ?? this.category,
      deliveryType: deliveryType ?? this.deliveryType,
      dateFilterType: dateFilterType ?? this.dateFilterType,
      currentPage: currentPage ?? this.currentPage,
      totalOrdersCount: totalOrdersCount ?? this.totalOrdersCount,
      categoryCounts: categoryCounts ?? this.categoryCounts,
      rowsPerPage: rowsPerPage ?? this.rowsPerPage,
      tempSelectedStatuses: tempSelectedStatuses ?? this.tempSelectedStatuses,
      activeStatuses: activeStatuses ?? this.activeStatuses,
      tempSelectedDates: tempSelectedDates ?? this.tempSelectedDates,
      activeSelectedDates: activeSelectedDates ?? this.activeSelectedDates,
      searchQuery: searchQuery ?? this.searchQuery,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}
