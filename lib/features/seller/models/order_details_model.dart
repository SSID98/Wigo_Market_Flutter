import 'allowed_action_model.dart';
import 'order.dart';
import 'order_enums.dart';

class OrdersPage {
  final List<Order> orders;
  final OrdersPagination pagination;
  final OrderCounts counts;

  const OrdersPage({
    required this.orders,
    required this.pagination,
    required this.counts,
  });

  factory OrdersPage.fromJson(Map<String, dynamic> json) {
    return OrdersPage(
      orders: (json['orders'] as List? ?? const [])
          .map((e) => Order.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      pagination: OrdersPagination.fromJson(
        Map<String, dynamic>.from(json['pagination'] as Map? ?? const {}),
      ),
      counts: OrderCounts.fromJson(
        Map<String, dynamic>.from(json['counts'] as Map? ?? const {}),
      ),
    );
  }
}

class OrdersPagination {
  final int total;
  final int page;
  final int limit;
  final int pages;
  final bool hasMore;

  const OrdersPagination({
    this.total = 0,
    this.page = 1,
    this.limit = 10,
    this.pages = 1,
    this.hasMore = false,
  });

  factory OrdersPagination.fromJson(Map<String, dynamic> json) {
    return OrdersPagination(
      total: (json['total'] as num?)?.toInt() ?? 0,
      page: (json['page'] as num?)?.toInt() ?? 1,
      limit: (json['limit'] as num?)?.toInt() ?? 10,
      pages: (json['pages'] as num?)?.toInt() ?? 1,
      hasMore: json['hasMore'] as bool? ?? false,
    );
  }
}

class OrderCounts {
  final int all;
  final int pending;
  final int ongoing;
  final int history;

  const OrderCounts({
    this.all = 0,
    this.pending = 0,
    this.ongoing = 0,
    this.history = 0,
  });

  factory OrderCounts.fromJson(Map<String, dynamic> json) {
    return OrderCounts(
      all: (json['all'] as num?)?.toInt() ?? 0,
      pending: (json['pending'] as num?)?.toInt() ?? 0,
      ongoing: (json['ongoing'] as num?)?.toInt() ?? 0,
      history: (json['history'] as num?)?.toInt() ?? 0,
    );
  }

  int forCategory(OrderCategory category) {
    switch (category) {
      case OrderCategory.all:
        return all;
      case OrderCategory.pending:
        return pending;
      case OrderCategory.ongoing:
        return ongoing;
      case OrderCategory.history:
        return history;
    }
  }
}

class BuyerInfo {
  final String id;
  final String name;
  final String mobile;
  final String email;

  const BuyerInfo({
    this.id = '',
    this.name = 'Unknown buyer',
    this.mobile = '',
    this.email = '',
  });

  factory BuyerInfo.fromJson(Map<String, dynamic> json) {
    return BuyerInfo(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Unknown buyer',
      mobile: json['mobile'] as String? ?? '',
      email: json['email'] as String? ?? '',
    );
  }
}

class DeliveryInfo {
  final String type;
  final String method;
  final String? address;
  final String? preferredTime;
  final DateTime? estimatedDeliveryTime;
  final String? deliveryStatus;
  final String? riderName;

  const DeliveryInfo({
    this.type = 'Delivery',
    this.method = '',
    this.address,
    this.preferredTime,
    this.estimatedDeliveryTime,
    this.deliveryStatus,
    this.riderName,
  });

  factory DeliveryInfo.fromJson(Map<String, dynamic> json) {
    final rider = json['rider'];
    return DeliveryInfo(
      type: json['type'] as String? ?? 'Delivery',
      method: json['method'] as String? ?? '',
      address: json['address'] as String?,
      preferredTime: json['preferredTime'] as String?,
      estimatedDeliveryTime: json['estimatedDeliveryTime'] != null
          ? DateTime.tryParse(json['estimatedDeliveryTime'] as String)
          : null,
      deliveryStatus: json['deliveryStatus'] as String?,
      riderName: rider is Map ? rider['name'] as String? : null,
    );
  }
}

class OrderItemDetail {
  final String productId;
  final String title;
  final String image;
  final int quantity;
  final double unitPrice;
  final double subtotal;

  const OrderItemDetail({
    required this.productId,
    required this.title,
    required this.image,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
  });

  factory OrderItemDetail.fromJson(Map<String, dynamic> json) {
    return OrderItemDetail(
      productId: json['productId'] as String? ?? '',
      title: json['title'] as String? ?? 'Product',
      image: json['image'] as String? ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      unitPrice: (json['unitPrice'] as num?)?.toDouble() ?? 0,
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0,
    );
  }
}

class OrderSummaryTotals {
  final double itemsTotal;
  final double deliveryFee;
  final double total;
  final String currency;

  const OrderSummaryTotals({
    this.itemsTotal = 0,
    this.deliveryFee = 0,
    this.total = 0,
    this.currency = 'NGN',
  });

  factory OrderSummaryTotals.fromJson(Map<String, dynamic> json) {
    return OrderSummaryTotals(
      itemsTotal: (json['itemsTotal'] as num?)?.toDouble() ?? 0,
      deliveryFee: (json['deliveryFee'] as num?)?.toDouble() ?? 0,
      total: (json['total'] as num?)?.toDouble() ?? 0,
      currency: json['currency'] as String? ?? 'NGN',
    );
  }
}

class PaymentInfo {
  final String method;
  final String status;
  final String transactionId;
  final String payoutStatus;

  const PaymentInfo({
    this.method = '',
    this.status = '',
    this.transactionId = '',
    this.payoutStatus = '',
  });

  factory PaymentInfo.fromJson(Map<String, dynamic> json) {
    return PaymentInfo(
      method: json['method'] as String? ?? '',
      status: json['status'] as String? ?? '',
      transactionId: json['transactionId'] as String? ?? '',
      payoutStatus: json['payoutStatus'] as String? ?? '',
    );
  }
}

class OrderTimelineEntry {
  final OrderFilter status;
  final String label;
  final bool completed;
  final DateTime? at;

  const OrderTimelineEntry({
    required this.status,
    required this.label,
    required this.completed,
    required this.at,
  });

  factory OrderTimelineEntry.fromJson(Map<String, dynamic> json) {
    return OrderTimelineEntry(
      status: OrderFilterExtension.fromString(json['status'] as String? ?? ''),
      label: json['label'] as String? ?? '',
      completed: json['completed'] as bool? ?? false,
      at: json['at'] != null ? DateTime.tryParse(json['at'] as String) : null,
    );
  }
}

class OrderDetail {
  final String id;
  final String orderNumber;
  final DateTime orderDate;
  final OrderFilter status;
  final String statusLabel;
  final List<AllowedAction> allowedActions;
  final BuyerInfo buyer;
  final DeliveryInfo delivery;
  final List<OrderItemDetail> items;
  final OrderSummaryTotals summary;
  final PaymentInfo payment;
  final List<OrderTimelineEntry> timeline;
  final String buyerNote;

  const OrderDetail({
    required this.id,
    required this.orderNumber,
    required this.orderDate,
    required this.status,
    required this.statusLabel,
    required this.allowedActions,
    required this.buyer,
    required this.delivery,
    required this.items,
    required this.summary,
    required this.payment,
    required this.timeline,
    required this.buyerNote,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      id: json['id'] as String? ?? '',
      orderNumber: json['orderNumber'] as String? ?? '',
      orderDate:
          DateTime.tryParse(json['orderDate'] as String? ?? '') ??
          DateTime.now(),
      status: OrderFilterExtension.fromString(json['status'] as String? ?? ''),
      statusLabel: json['statusLabel'] as String? ?? '',
      allowedActions: (json['allowedActions'] as List? ?? const [])
          .map(
            (e) => AllowedAction.fromJson(Map<String, dynamic>.from(e as Map)),
          )
          .toList(),
      buyer: BuyerInfo.fromJson(
        Map<String, dynamic>.from(json['buyer'] as Map? ?? const {}),
      ),
      delivery: DeliveryInfo.fromJson(
        Map<String, dynamic>.from(json['delivery'] as Map? ?? const {}),
      ),
      items: (json['items'] as List? ?? const [])
          .map(
            (e) =>
                OrderItemDetail.fromJson(Map<String, dynamic>.from(e as Map)),
          )
          .toList(),
      summary: OrderSummaryTotals.fromJson(
        Map<String, dynamic>.from(json['summary'] as Map? ?? const {}),
      ),
      payment: PaymentInfo.fromJson(
        Map<String, dynamic>.from(json['payment'] as Map? ?? const {}),
      ),
      timeline: (json['timeline'] as List? ?? const [])
          .map(
            (e) => OrderTimelineEntry.fromJson(
              Map<String, dynamic>.from(e as Map),
            ),
          )
          .toList(),
      buyerNote: json['buyerNote'] as String? ?? '',
    );
  }
}

class ContactCustomerResult {
  final String notificationId;
  final DateTime sentAt;

  const ContactCustomerResult({
    required this.notificationId,
    required this.sentAt,
  });

  factory ContactCustomerResult.fromJson(Map<String, dynamic> json) {
    return ContactCustomerResult(
      notificationId: json['notificationId'] as String? ?? '',
      sentAt:
          DateTime.tryParse(json['sentAt'] as String? ?? '') ?? DateTime.now(),
    );
  }
}
