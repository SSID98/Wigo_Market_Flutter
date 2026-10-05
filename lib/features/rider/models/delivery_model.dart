import 'map_models.dart';

class DeliveryProduct {
  final String productId;
  final String name;
  final int quantity;
  final double price;
  final double subtotal;
  final String? image;
  final String? store;

  const DeliveryProduct({
    required this.productId,
    required this.name,
    required this.quantity,
    required this.price,
    required this.subtotal,
    this.image,
    this.store,
  });

  factory DeliveryProduct.fromJson(Map<String, dynamic> json) =>
      DeliveryProduct(
        productId: json['productId'] as String? ?? '',
        name: json['name'] as String? ?? 'Unknown Item',
        quantity: (json['quantity'] as num? ?? 0).toInt(),
        price: (json['price'] as num? ?? 0).toDouble(),
        subtotal: (json['subtotal'] as num? ?? 0).toDouble(),
        image: json['image'] as String?,
        store: json['store'] as String?,
      );
}

class DeliveryCustomer {
  final String id;
  final String name;
  final String phone;
  final String email;

  const DeliveryCustomer({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
  });

  factory DeliveryCustomer.fromJson(Map<String, dynamic> json) =>
      DeliveryCustomer(
        id: json['id'] as String? ?? '',
        name: json['name'] as String? ?? 'Unknown Customer',
        phone: json['phone'] as String? ?? '',
        email: json['email'] as String? ?? '',
      );
}

class DeliveryPickup {
  final String id;
  final String store;
  final String address;
  final String mobile;
  final double? lat;
  final double? lng;

  const DeliveryPickup({
    required this.id,
    required this.store,
    required this.address,
    this.lat,
    this.lng,
    required this.mobile,
  });

  GeoPoint? get geoPoint {
    if (lat == null || lng == null) return null;
    return GeoPoint(lat: lat!, lng: lng!);
  }

  factory DeliveryPickup.fromJson(Map<String, dynamic> json) => DeliveryPickup(
    id: json['id'] as String? ?? '',
    store: json['store'] as String? ?? '',
    address: json['address'] as String? ?? '',
    mobile: json['mobile'] as String? ?? '',
    lat: (json['lat'] as num?)?.toDouble(),
    lng: (json['lng'] as num?)?.toDouble(),
  );
}

class DeliveryDropoff {
  final String address;
  final String mobile;
  final double? lat;
  final double? lng;

  const DeliveryDropoff({
    required this.address,
    required this.mobile,
    this.lat,
    this.lng,
  });

  GeoPoint? get geoPoint {
    if (lat == null || lng == null) return null;
    return GeoPoint(lat: lat!, lng: lng!);
  }

  const DeliveryDropoff.addressOnly(String address)
    : this(address: address, mobile: '');

  static const empty = DeliveryDropoff(address: '', mobile: '');

  factory DeliveryDropoff.fromJson(Map<String, dynamic> json) =>
      DeliveryDropoff(
        address: json['address'] as String? ?? '',
        mobile: json['mobile'] as String? ?? '',
        lat: (json['lat'] as num?)?.toDouble(),
        lng: (json['lng'] as num?)?.toDouble(),
      );
}

class OrderCounts {
  final int all;
  final int available;
  final int ongoing;
  final int completed;
  final int cancelled;

  const OrderCounts({
    required this.all,
    required this.available,
    required this.ongoing,
    required this.completed,
    required this.cancelled,
  });

  factory OrderCounts.fromJson(Map<String, dynamic> json) => OrderCounts(
    all: (json['all'] as num? ?? 0).toInt(),
    available: (json['available'] as num? ?? 0).toInt(),
    ongoing: (json['ongoing'] as num? ?? 0).toInt(),
    completed: (json['completed'] as num? ?? 0).toInt(),
    cancelled: (json['cancelled'] as num? ?? 0).toInt(),
  );

  static const empty = OrderCounts(
    all: 0,
    available: 0,
    ongoing: 0,
    completed: 0,
    cancelled: 0,
  );
}

class ConfirmDeliveryResult {
  final bool credited;
  final double amount;
  final double walletBalance;
  final String? reason;

  const ConfirmDeliveryResult({
    required this.credited,
    required this.amount,
    required this.walletBalance,
    this.reason,
  });

  bool get isAwaitingCustomer => reason == 'awaiting_customer_confirmation';

  factory ConfirmDeliveryResult.fromJson(Map<String, dynamic> json) =>
      ConfirmDeliveryResult(
        credited: json['credited'] as bool? ?? false,
        amount: (json['amount'] as num? ?? 0).toDouble(),
        walletBalance: (json['walletBalance'] as num? ?? 0).toDouble(),
        reason: json['reason'] as String?,
      );
}

class DeliveryPagination {
  final int currentPage;
  final int totalPages;
  final int totalOrders;
  final bool hasNext;
  final bool hasPrev;

  const DeliveryPagination({
    required this.currentPage,
    required this.totalPages,
    required this.totalOrders,
    required this.hasNext,
    required this.hasPrev,
  });

  factory DeliveryPagination.fromJson(Map<String, dynamic> json) =>
      DeliveryPagination(
        currentPage: (json['currentPage'] as num? ?? 1).toInt(),
        totalPages: (json['totalPages'] as num? ?? 1).toInt(),
        totalOrders: (json['totalOrders'] as num? ?? 0).toInt(),
        hasNext: json['hasNext'] as bool? ?? false,
        hasPrev: json['hasPrev'] as bool? ?? false,
      );

  static const empty = DeliveryPagination(
    currentPage: 1,
    totalPages: 1,
    totalOrders: 0,
    hasNext: false,
    hasPrev: false,
  );
}

class OrdersResponse {
  final List<Delivery> orders;
  final DeliveryPagination pagination;

  const OrdersResponse({required this.orders, required this.pagination});

  factory OrdersResponse.fromJson(Map<String, dynamic> json) {
    return OrdersResponse(
      orders: (json['orders'] as List<dynamic>? ?? [])
          .map((o) => Delivery.fromJson(Map<String, dynamic>.from(o as Map)))
          .toList(),
      pagination: json['pagination'] is Map
          ? DeliveryPagination.fromJson(
              Map<String, dynamic>.from(json['pagination'] as Map),
            )
          : DeliveryPagination.empty,
    );
  }
}

class Delivery {
  final String id;

  final String orderNumber;

  final DateTime? createdAt;
  final DeliveryCustomer? customer;

  final DeliveryPickup? pickup;

  final List<DeliveryPickup> pickups;
  final DeliveryDropoff dropoff;
  final List<DeliveryProduct> products;
  final int? itemsCount;
  final double itemsTotal;
  final double deliveryFee;
  final double total;
  final String currency;
  final String deliveryMethod;
  final String deliveryStatus;
  final String orderStatus;
  final DateTime? estimatedDeliveryTime;
  final String? deliveryNotes;

  const Delivery({
    required this.id,
    required this.orderNumber,
    this.createdAt,
    this.customer,
    this.pickup,
    required this.pickups,
    required this.dropoff,
    required this.products,
    this.itemsCount,
    required this.itemsTotal,
    required this.deliveryFee,
    required this.total,
    required this.currency,
    required this.deliveryMethod,
    required this.deliveryStatus,
    required this.orderStatus,
    this.estimatedDeliveryTime,
    this.deliveryNotes,
  });

  String get orderId => orderNumber;

  String get customerName => customer?.name ?? 'Unknown Customer';

  String get customerPhone =>
      customer?.phone.isNotEmpty == true ? customer!.phone : dropoff.mobile;

  double get fee => deliveryFee;

  String get pickupStoreName => pickup?.store ?? '';

  String get pickupLocation => pickup?.address ?? 'Pickup location unavailable';

  String get deliveryLocation => dropoff.address;

  String get items {
    final count =
        itemsCount ?? products.fold<int>(0, (sum, p) => sum + p.quantity);
    if (count == 0) return 'No items';
    return '$count item${count == 1 ? '' : 's'}';
  }

  GeoPoint? get pickupGeoPoint => pickup?.geoPoint;

  GeoPoint? get dropoffGeoPoint => dropoff.geoPoint;

  bool get isPendingAssignment => deliveryStatus == 'pending_assignment';

  bool get isAssigned => deliveryStatus == 'assigned';

  bool get isPickedUp => deliveryStatus == 'picked_up';

  bool get isInTransit => deliveryStatus == 'in_transit';

  bool get isDelivered => deliveryStatus == 'delivered';

  bool get isFailed => deliveryStatus == 'failed';

  bool get isOngoing =>
      const {'assigned', 'picked_up', 'in_transit'}.contains(deliveryStatus);

  bool get isTerminal => isDelivered || isFailed;

  String get displayStatus {
    switch (deliveryStatus) {
      case 'pending_assignment':
        return 'New Request';
      case 'assigned':
        return 'Assigned';
      case 'picked_up':
        return 'Picked Up';
      case 'in_transit':
        return 'In Transit';
      case 'delivered':
        return 'Delivered';
      case 'failed':
        return 'Cancelled';
      default:
        return deliveryStatus;
    }
  }

  factory Delivery.fromJson(Map<String, dynamic> json) {
    final rawId = json['orderId'] as String? ?? '';

    DeliveryDropoff dropoff;
    final dropoffJson = json['dropoff'];
    if (dropoffJson is Map) {
      dropoff = DeliveryDropoff.fromJson(
        Map<String, dynamic>.from(dropoffJson),
      );
    } else if (dropoffJson is String) {
      dropoff = DeliveryDropoff.addressOnly(dropoffJson);
    } else {
      dropoff = DeliveryDropoff.empty;
    }

    return Delivery(
      id: rawId,
      orderNumber: json['orderNumber'] as String? ?? _fallbackNumber(rawId),
      createdAt: _parseDate(json['createdAt']),
      customer: json['customer'] is Map
          ? DeliveryCustomer.fromJson(
              Map<String, dynamic>.from(json['customer'] as Map),
            )
          : null,
      pickup: json['pickup'] is Map
          ? DeliveryPickup.fromJson(
              Map<String, dynamic>.from(json['pickup'] as Map),
            )
          : null,
      pickups: (json['pickups'] as List<dynamic>? ?? [])
          .map(
            (p) => DeliveryPickup.fromJson(Map<String, dynamic>.from(p as Map)),
          )
          .toList(),
      dropoff: dropoff,
      products: (json['products'] as List<dynamic>? ?? [])
          .map(
            (p) =>
                DeliveryProduct.fromJson(Map<String, dynamic>.from(p as Map)),
          )
          .toList(),
      itemsCount: (json['itemsCount'] as num?)?.toInt(),
      itemsTotal: (json['itemsTotal'] as num? ?? 0).toDouble(),
      deliveryFee: (json['deliveryFee'] as num? ?? 0).toDouble(),
      total: (json['total'] as num? ?? 0).toDouble(),
      currency: json['currency'] as String? ?? 'NGN',
      deliveryMethod: json['deliveryMethod'] as String? ?? '',
      deliveryStatus: json['deliveryStatus'] as String? ?? '',
      orderStatus: json['orderStatus'] as String? ?? '',
      estimatedDeliveryTime: _parseDate(json['estimatedDeliveryTime']),
      deliveryNotes: json['deliveryNotes'] as String?,
    );
  }

  static String _fallbackNumber(String rawId) => rawId.length >= 8
      ? '#${rawId.substring(rawId.length - 8).toUpperCase()}'
      : '#$rawId';

  static DateTime? _parseDate(dynamic value) =>
      value is String ? DateTime.tryParse(value) : null;
}
