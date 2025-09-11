class Delivery {
  final String orderId;
  final DateTime date;
  final String customer;
  final String items;
  final double fee;
  final String status;

  Delivery({
    required this.orderId,
    required this.date,
    required this.customer,
    required this.items,
    required this.fee,
    required this.status,
  });
}
