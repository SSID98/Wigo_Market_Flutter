import 'order_task_state.dart';

class Order {
  final String orderId;
  final DateTime date;
  final String customerName, customerPhone;
  final String item;
  final double amount;
  final OrderFilter status;
  final DeliveryType deliveryType;
  final String pickupLocation;
  final String deliveryLocation;

  Order({
    required this.orderId,
    required this.date,
    required this.customerName,
    required this.customerPhone,
    required this.item,
    required this.amount,
    required this.status,
    required this.deliveryLocation,
    required this.pickupLocation,
    required this.deliveryType,
  });

  Order copyWith({OrderFilter? status, DeliveryType? deliveryType}) {
    return Order(
      orderId: orderId,
      date: date,
      customerName: customerName,
      customerPhone: customerPhone,
      item: item,
      amount: amount,
      status: status ?? this.status,
      deliveryType: deliveryType ?? this.deliveryType,
      deliveryLocation: deliveryLocation,
      pickupLocation: pickupLocation,
    );
  }
}
