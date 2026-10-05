double _asDouble(Object? value) {
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value.replaceAll(',', '')) ?? 0;
  return 0;
}

int _asInt(Object? value, {int fallback = 0}) {
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? fallback;
  return fallback;
}

String _asString(Object? value, [String fallback = '']) =>
    value is String ? value : fallback;

Map<String, dynamic> _asMap(Object? value) =>
    value is Map ? Map<String, dynamic>.from(value) : <String, dynamic>{};

DateTime? _asDate(Object? value) {
  if (value is! String || value.isEmpty) return null;
  return DateTime.tryParse(value)?.toLocal();
}

enum EarningStatus {
  paid('paid', 'Paid'),
  partiallyRefunded('partially_refunded', 'Partially refunded'),
  refunded('refunded', 'Refunded'),
  unknown('unknown', 'Unknown');

  const EarningStatus(this.apiValue, this.defaultLabel);

  final String apiValue;
  final String defaultLabel;

  static EarningStatus fromString(String? value) {
    for (final status in EarningStatus.values) {
      if (status.apiValue == value) return status;
    }
    return EarningStatus.unknown;
  }
}

class EarningProduct {
  final String productId;
  final String title;
  final String? image;
  final int quantity;
  final double unitPrice;
  final double amount;

  const EarningProduct({
    required this.productId,
    required this.title,
    required this.image,
    required this.quantity,
    required this.unitPrice,
    required this.amount,
  });

  factory EarningProduct.fromJson(Map<String, dynamic> json) {
    final image = _asString(json['image']);
    return EarningProduct(
      productId: _asString(json['productId']),
      title: _asString(json['title'], 'Unnamed product'),
      image: image.isEmpty ? null : image,
      quantity: _asInt(json['quantity'], fallback: 1),
      unitPrice: _asDouble(json['unitPrice']),
      amount: _asDouble(json['amount']),
    );
  }
}

class SellerEarning {
  final String id;
  final String orderNumber;
  final String productSold;
  final List<EarningProduct> products;
  final String customerId;
  final String customerName;
  final DateTime? orderDate;
  final DateTime? earnedAt;
  final double amountEarned;
  final double grossAmount;
  final double refundedAmount;
  final String currency;
  final EarningStatus status;
  final String statusLabel;

  const SellerEarning({
    required this.id,
    required this.orderNumber,
    required this.productSold,
    required this.products,
    required this.customerId,
    required this.customerName,
    required this.orderDate,
    required this.earnedAt,
    required this.amountEarned,
    required this.grossAmount,
    required this.refundedAmount,
    required this.currency,
    required this.status,
    required this.statusLabel,
  });

  bool get hasRefund => refundedAmount > 0;

  factory SellerEarning.fromJson(Map<String, dynamic> json) {
    final customer = _asMap(json['customer']);
    final products = (json['products'] as List? ?? const [])
        .whereType<Map>()
        .map((e) => EarningProduct.fromJson(Map<String, dynamic>.from(e)))
        .toList();
    final status = EarningStatus.fromString(_asString(json['status']));

    var productSold = _asString(json['productSold']);
    if (productSold.isEmpty && products.isNotEmpty) {
      productSold = products.first.title;
    }

    final amountEarned = _asDouble(json['amountEarned']);
    return SellerEarning(
      id: _asString(json['id']),
      orderNumber: _asString(json['orderNumber']),
      productSold: productSold.isEmpty ? '—' : productSold,
      products: products,
      customerId: _asString(customer['id']),
      customerName: _asString(customer['name'], 'Unknown customer'),
      orderDate: _asDate(json['orderDate']),
      earnedAt: _asDate(json['earnedAt']),
      amountEarned: amountEarned,
      grossAmount: json['grossAmount'] == null
          ? amountEarned
          : _asDouble(json['grossAmount']),
      refundedAmount: _asDouble(json['refundedAmount']),
      currency: _asString(json['currency'], 'NGN'),
      status: status,
      statusLabel: _asString(json['statusLabel'], status.defaultLabel),
    );
  }
}

class EarningMetric {
  final double value;
  final double previous;
  final double changePercent;

  const EarningMetric({
    required this.value,
    required this.previous,
    required this.changePercent,
  });

  factory EarningMetric.fromJson(Map<String, dynamic> json) => EarningMetric(
    value: _asDouble(json['value']),
    previous: _asDouble(json['previous']),
    changePercent: _asDouble(json['changePercent']),
  );
}

class EarningsSummary {
  final EarningMetric totalEarnings;
  final EarningMetric weeklyEarnings;
  final EarningMetric todayEarnings;
  final int paidOrders;

  const EarningsSummary({
    required this.totalEarnings,
    required this.weeklyEarnings,
    required this.todayEarnings,
    required this.paidOrders,
  });

  factory EarningsSummary.fromJson(Map<String, dynamic> json) =>
      EarningsSummary(
        totalEarnings: EarningMetric.fromJson(_asMap(json['totalEarnings'])),
        weeklyEarnings: EarningMetric.fromJson(_asMap(json['weeklyEarnings'])),
        todayEarnings: EarningMetric.fromJson(_asMap(json['todayEarnings'])),
        paidOrders: _asInt(json['paidOrders']),
      );
}

class EarningsPagination {
  final int total;
  final int page;
  final int limit;
  final int pages;
  final bool hasMore;

  const EarningsPagination({
    required this.total,
    required this.page,
    required this.limit,
    required this.pages,
    required this.hasMore,
  });

  factory EarningsPagination.fromJson(Map<String, dynamic> json) {
    final total = _asInt(json['total']);
    final limit = _asInt(json['limit'], fallback: 10);
    final page = _asInt(json['page'], fallback: 1);
    final pages = json['pages'] != null
        ? _asInt(json['pages'])
        : (limit > 0 ? (total / limit).ceil() : 0);
    return EarningsPagination(
      total: total,
      page: page,
      limit: limit,
      pages: pages,
      hasMore: json['hasMore'] as bool? ?? page < pages,
    );
  }
}

class EarningsPage {
  final String currency;
  final EarningsSummary? summary;
  final List<SellerEarning> earnings;
  final EarningsPagination pagination;

  const EarningsPage({
    required this.currency,
    required this.summary,
    required this.earnings,
    required this.pagination,
  });

  factory EarningsPage.fromJson(Map<String, dynamic> json) {
    final summaryJson = json['summary'];
    return EarningsPage(
      currency: _asString(json['currency'], 'NGN'),
      summary: summaryJson is Map
          ? EarningsSummary.fromJson(Map<String, dynamic>.from(summaryJson))
          : null,
      earnings: (json['earnings'] as List? ?? const [])
          .whereType<Map>()
          .map((e) => SellerEarning.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      pagination: EarningsPagination.fromJson(_asMap(json['pagination'])),
    );
  }
}

class RecentEarning {
  final String id;
  final String orderNumber;
  final String type;
  final String title;
  final double amount;
  final double grossAmount;
  final double refundedAmount;
  final String currency;
  final DateTime? earnedAt;
  final EarningStatus status;
  final String statusLabel;

  const RecentEarning({
    required this.id,
    required this.orderNumber,
    required this.type,
    required this.title,
    required this.amount,
    required this.grossAmount,
    required this.refundedAmount,
    required this.currency,
    required this.earnedAt,
    required this.status,
    required this.statusLabel,
  });

  factory RecentEarning.fromJson(Map<String, dynamic> json) {
    final status = EarningStatus.fromString(_asString(json['status']));
    final amount = _asDouble(json['amount']);
    return RecentEarning(
      id: _asString(json['id']),
      orderNumber: _asString(json['orderNumber']),
      type: _asString(json['type'], 'sale'),
      title: _asString(json['title'], 'Sales'),
      amount: amount,
      grossAmount: json['grossAmount'] == null
          ? amount
          : _asDouble(json['grossAmount']),
      refundedAmount: _asDouble(json['refundedAmount']),
      currency: _asString(json['currency'], 'NGN'),
      earnedAt: _asDate(json['earnedAt']),
      status: status,
      statusLabel: _asString(
        json['statusLabel'],
        status == EarningStatus.paid ? 'Successful' : status.defaultLabel,
      ),
    );
  }
}
