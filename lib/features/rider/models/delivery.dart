class Delivery {
  final String orderId;
  final DateTime date;
  final String customerName, customerPhone;
  final String items;
  final double fee;
  final String status;
  final String pickupLocation;
  final String deliveryLocation;

  Delivery({
    required this.orderId,
    required this.date,
    required this.customerName,
    required this.customerPhone,
    required this.items,
    required this.fee,
    required this.status,
    required this.deliveryLocation,
    required this.pickupLocation,
  });
}
