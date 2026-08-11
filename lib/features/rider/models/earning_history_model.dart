import 'delivery_model.dart' show DeliveryPagination;

DateTime? _parseDate(dynamic value) =>
    value is String ? DateTime.tryParse(value) : null;

class EarningHistoryOrder {
  final String orderId;
  final String reference;
  final DateTime? date;
  final String time;
  final DateTime? deliveredAt;
  final String customer;
  final String customerMobile;
  final String orderNumber;
  final int itemCount;
  final int lineItemCount;
  final String pickup;
  final String dropoff;
  final double deliveryFee;
  final double amount;

  /// "delivered" | "cancelled"
  final String status;
  final String deliveryStatus;
  final String orderStatus;

  const EarningHistoryOrder({
    required this.orderId,
    required this.reference,
    this.date,
    required this.time,
    this.deliveredAt,
    required this.customer,
    required this.customerMobile,
    required this.orderNumber,
    required this.itemCount,
    required this.lineItemCount,
    required this.pickup,
    required this.dropoff,
    required this.deliveryFee,
    required this.amount,
    required this.status,
    required this.deliveryStatus,
    required this.orderStatus,
  });

  bool get isCancelled => status.toLowerCase() == 'cancelled';

  bool get isDelivered => status.toLowerCase() == 'delivered';

  String get displayStatus => isCancelled ? 'Cancelled' : 'Delivered';

  factory EarningHistoryOrder.fromJson(Map<String, dynamic> json) {
    return EarningHistoryOrder(
      orderId: json['orderId'] as String? ?? '',
      reference: json['reference'] as String? ?? '',
      date: _parseDate(json['date']),
      time: json['time'] as String? ?? '',
      deliveredAt: _parseDate(json['deliveredAt']),
      customer: json['customer'] as String? ?? 'Unknown Customer',
      customerMobile: json['customerMobile'] as String? ?? '',
      orderNumber: json['orderNumber'] as String? ?? '',
      itemCount: (json['itemCount'] as num? ?? 0).toInt(),
      lineItemCount: (json['lineItemCount'] as num? ?? 0).toInt(),
      pickup: json['pickup'] as String? ?? '',
      dropoff: json['dropoff'] as String? ?? '',
      deliveryFee: (json['deliveryFee'] as num? ?? 0).toDouble(),
      amount: (json['amount'] as num? ?? 0).toDouble(),
      status: json['status'] as String? ?? '',
      deliveryStatus: json['deliveryStatus'] as String? ?? '',
      orderStatus: json['orderStatus'] as String? ?? '',
    );
  }
}

class EarningHistoryRange {
  final String? startDate;
  final String? endDate;
  final DateTime? from;
  final DateTime? to;

  const EarningHistoryRange({this.startDate, this.endDate, this.from, this.to});

  factory EarningHistoryRange.fromJson(Map<String, dynamic> json) {
    return EarningHistoryRange(
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      from: _parseDate(json['from']),
      to: _parseDate(json['to']),
    );
  }
}

class EarningHistoryFilters {
  final String? search;
  final int? month;
  final int? year;
  final String status;

  const EarningHistoryFilters({
    this.search,
    this.month,
    this.year,
    this.status = 'delivered',
  });

  factory EarningHistoryFilters.fromJson(Map<String, dynamic> json) {
    return EarningHistoryFilters(
      search: json['search'] as String?,
      month: (json['month'] as num?)?.toInt(),
      year: (json['year'] as num?)?.toInt(),
      status: json['status'] as String? ?? 'delivered',
    );
  }
}

class EarningHistorySummary {
  final double totalEarnings;
  final int totalDeliveries;
  final EarningHistoryRange range;
  final EarningHistoryFilters filters;

  const EarningHistorySummary({
    required this.totalEarnings,
    required this.totalDeliveries,
    required this.range,
    required this.filters,
  });

  factory EarningHistorySummary.fromJson(Map<String, dynamic> json) {
    return EarningHistorySummary(
      totalEarnings: (json['totalEarnings'] as num? ?? 0).toDouble(),
      totalDeliveries: (json['totalDeliveries'] as num? ?? 0).toInt(),
      range: json['range'] is Map
          ? EarningHistoryRange.fromJson(
              Map<String, dynamic>.from(json['range'] as Map),
            )
          : const EarningHistoryRange(),
      filters: json['filters'] is Map
          ? EarningHistoryFilters.fromJson(
              Map<String, dynamic>.from(json['filters'] as Map),
            )
          : const EarningHistoryFilters(),
    );
  }

  static const empty = EarningHistorySummary(
    totalEarnings: 0,
    totalDeliveries: 0,
    range: EarningHistoryRange(),
    filters: EarningHistoryFilters(),
  );
}

class EarningsHistoryResponse {
  final List<EarningHistoryOrder> orders;
  final EarningHistorySummary summary;
  final DeliveryPagination pagination;

  const EarningsHistoryResponse({
    required this.orders,
    required this.summary,
    required this.pagination,
  });

  factory EarningsHistoryResponse.fromJson(Map<String, dynamic> json) {
    return EarningsHistoryResponse(
      orders: (json['orders'] as List<dynamic>? ?? [])
          .map(
            (o) => EarningHistoryOrder.fromJson(
              Map<String, dynamic>.from(o as Map),
            ),
          )
          .toList(),
      summary: json['summary'] is Map
          ? EarningHistorySummary.fromJson(
              Map<String, dynamic>.from(json['summary'] as Map),
            )
          : EarningHistorySummary.empty,
      pagination: json['pagination'] is Map
          ? DeliveryPagination.fromJson(
              Map<String, dynamic>.from(json['pagination'] as Map),
            )
          : DeliveryPagination.empty,
    );
  }
}
