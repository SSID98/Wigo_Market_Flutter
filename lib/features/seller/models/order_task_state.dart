import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'order.dart';

enum OrderFilter {
  all,
  pending,
  confirmed,
  preparing,
  pickUpReady,
  inTransit,
  delivered,
  cancelled,
}

enum DeliveryType { all, delivery, pickUp }

enum DateFilterType { all, today, custom }

class OrderTaskState {
  final AsyncValue<List<Order>> orders;
  final OrderFilter selectedFilter;
  final DeliveryType deliveryType;
  final int currentPage;
  final int totalOrdersCount;
  final Map<OrderFilter, int> orderCounts;
  final int rowsPerPage;
  final DateFilterType dateFilterType;
  final DateTime? customDate;
  final bool selectStatus;
  final Set<OrderFilter> tempSelectedStatuses; // What is checked in the UI
  final Set<OrderFilter> activeStatuses; // What is actually filtering the table
  final Set<DateTime> tempSelectedDates;
  final Set<DateTime> activeSelectedDates;

  // final WalletScreenState walletScreenState;

  const OrderTaskState({
    this.orders = const AsyncValue.data([]),
    this.selectedFilter = OrderFilter.all,
    this.deliveryType = DeliveryType.all,
    this.dateFilterType = DateFilterType.all,
    this.customDate,
    this.currentPage = 0,
    this.totalOrdersCount = 0,
    this.orderCounts = const {},
    this.rowsPerPage = 10,
    this.selectStatus = false,
    this.tempSelectedStatuses = const {},
    this.activeStatuses = const {},
    this.tempSelectedDates = const {},
    this.activeSelectedDates = const {},
    // this.walletScreenState = WalletScreenState.overview,
  });

  OrderTaskState copyWith({
    AsyncValue<List<Order>>? orders,
    OrderFilter? selectedFilter,
    DateFilterType? dateFilterType,
    DeliveryType? deliveryType,
    DateTime? customDate,
    int? currentPage,
    int? totalOrdersCount,
    Map<OrderFilter, int>? orderCounts,
    int? rowsPerPage,
    bool? selectStatus,
    Set<OrderFilter>? tempSelectedStatuses,
    Set<OrderFilter>? activeStatuses,
    Set<DateTime>? tempSelectedDates,
    Set<DateTime>? activeSelectedDates,
    // WalletScreenState? walletScreenState,
  }) {
    return OrderTaskState(
      orders: orders ?? this.orders,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      dateFilterType: dateFilterType ?? this.dateFilterType,
      customDate: customDate ?? this.customDate,
      currentPage: currentPage ?? this.currentPage,
      totalOrdersCount: totalOrdersCount ?? this.totalOrdersCount,
      orderCounts: orderCounts ?? this.orderCounts,
      rowsPerPage: rowsPerPage ?? this.rowsPerPage,
      selectStatus: selectStatus ?? this.selectStatus,
      deliveryType: deliveryType ?? this.deliveryType,
      tempSelectedStatuses: tempSelectedStatuses ?? this.tempSelectedStatuses,
      activeStatuses: activeStatuses ?? this.activeStatuses,
      tempSelectedDates: tempSelectedDates ?? this.tempSelectedDates,
      activeSelectedDates: activeSelectedDates ?? this.activeSelectedDates,
      // walletScreenState: walletScreenState ?? this.walletScreenState,
    );
  }
}

extension OrderFilterExtension on OrderFilter {
  //Backend (JSON)
  String get toJsonString => name;

  String get displayName {
    switch (this) {
      case OrderFilter.pickUpReady:
        return 'Pick up Ready';
      case OrderFilter.inTransit:
        return 'In Transit';
      case OrderFilter.pending:
        return 'Pending';
      case OrderFilter.delivered:
        return 'Delivered';
      case OrderFilter.cancelled:
        return 'Cancelled';
      case OrderFilter.confirmed:
        return 'Confirmed';
      case OrderFilter.preparing:
        return 'Preparing';
      default:
        // Capitalizes the first letter: "pending" -> "Pending"
        return name[0].toUpperCase() + name.substring(1);
    }
  }

  // convert Backend String -> Enum
  static OrderFilter fromString(String status) {
    return OrderFilter.values.firstWhere(
      (e) => e.name.toLowerCase() == status.replaceAll(' ', '').toLowerCase(),
      orElse: () => OrderFilter.pending,
    );
  }
}

extension DeliveryTypeExtension on DeliveryType {
  //Backend (JSON)
  String get toJsonString => name;

  String get displayName {
    switch (this) {
      case DeliveryType.pickUp:
        return 'Pick up';
      case DeliveryType.delivery:
        return 'Delivery';
      default:
        return name[0].toUpperCase() + name.substring(1);
    }
  }

  // convert Backend String -> Enum
  static DeliveryType fromString(String type) {
    return DeliveryType.values.firstWhere(
      (e) => e.name.toLowerCase() == type.replaceAll(' ', '').toLowerCase(),
      orElse: () => DeliveryType.delivery,
    );
  }
}

// extension OrderTaskSelectors on OrderTaskState {
//   List<Order> get filteredOrders {
//     return orders.when(
//       data: (list) {
//         switch (selectedFilter) {
//           case OrderFilter.all:
//             return list;
//           case OrderFilter.pending:
//             return list.where((d) => d.status == "Pending").toList();
//           case OrderFilter.confirmed:
//             return list.where((d) => d.status == "Confirmed").toList();
//           case OrderFilter.preparing:
//             return list.where((d) => d.status == "Preparing").toList();
//           case OrderFilter.cancelled:
//             return list.where((d) => d.status == "Cancelled").toList();
//           case OrderFilter.pickUpReady:
//             return list.where((d) => d.status == "Pick up Ready").toList();
//           case OrderFilter.inTransit:
//             return list.where((d) => d.status == "In Transit").toList();
//           case OrderFilter.delivered:
//             return list.where((d) => d.status == "Delivered").toList();
//         }
//       },
//       loading: () => [],
//       error: (_, __) => [],
//     );
//   }
// }
//
// extension DeliveryTypeSelectors on OrderTaskState {
//   List<Order> get filteredOrders {
//     return orders.when(
//       data: (list) {
//         switch (deliveryType) {
//           case DeliveryType.all:
//             return list;
//           case DeliveryType.pickUp:
//             return list.where((d) => d.deliveryType == "Pick up").toList();
//           case DeliveryType.delivery:
//             return list.where((d) => d.deliveryType == "Delivery").toList();
//         }
//       },
//       loading: () => [],
//       error: (_, __) => [],
//     );
//   }
// }
