import 'allowed_action_model.dart';
import 'order_enums.dart';

class Order {
  final String id;

  final String orderNumber;
  final DateTime date;
  final String customerId;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final int itemsCount;
  final double amount;
  final String currency;
  final DeliveryType deliveryType;
  final OrderFilter status;
  final String statusLabel;

  final List<AllowedAction> allowedActions;

  const Order({
    required this.id,
    required this.orderNumber,
    required this.date,
    required this.customerId,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.itemsCount,
    required this.amount,
    required this.currency,
    required this.deliveryType,
    required this.status,
    required this.statusLabel,
    required this.allowedActions,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    final customer = Map<String, dynamic>.from(
      json['customer'] as Map? ?? const {},
    );
    return Order(
      id: json['id'] as String? ?? '',
      orderNumber: json['orderNumber'] as String? ?? '',
      date:
          DateTime.tryParse(json['orderDate'] as String? ?? '') ??
          DateTime.now(),
      customerId: customer['id'] as String? ?? '',
      customerName: customer['name'] as String? ?? 'Unknown customer',
      customerEmail: customer['email'] as String? ?? '',
      customerPhone: customer['mobile'] as String? ?? '',
      itemsCount: (json['itemsCount'] as num?)?.toInt() ?? 0,
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      currency: json['currency'] as String? ?? 'NGN',
      deliveryType: DeliveryTypeExtension.fromString(
        json['deliveryType'] as String? ?? 'Delivery',
      ),
      status: OrderFilterExtension.fromString(
        json['status'] as String? ?? 'pending',
      ),
      statusLabel: json['statusLabel'] as String? ?? '',
      allowedActions: (json['allowedActions'] as List? ?? const [])
          .map(
            (e) => AllowedAction.fromJson(Map<String, dynamic>.from(e as Map)),
          )
          .toList(),
    );
  }

  Order copyWith({OrderFilter? status, String? statusLabel}) {
    return Order(
      id: id,
      orderNumber: orderNumber,
      date: date,
      customerId: customerId,
      customerName: customerName,
      customerEmail: customerEmail,
      customerPhone: customerPhone,
      itemsCount: itemsCount,
      amount: amount,
      currency: currency,
      deliveryType: deliveryType,
      status: status ?? this.status,
      statusLabel: statusLabel ?? this.statusLabel,
      allowedActions: allowedActions,
    );
  }
}
