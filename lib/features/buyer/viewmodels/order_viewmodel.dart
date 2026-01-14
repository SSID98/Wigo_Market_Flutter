import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/cart_database.dart';

class OrderItemModel {
  final String productName;
  final double price;
  final String imageUrl;
  final int quantity;
  final String status;
  final String size;
  final String colorName;

  OrderItemModel({
    required this.productName,
    required this.price,
    required this.imageUrl,
    required this.quantity,
    required this.colorName,
    required this.size,
    this.status = 'On Delivery',
  });

  Map<String, dynamic> toMap() {
    return {
      'productName': productName,
      'price': price,
      'imageUrl': imageUrl,
      'quantity': quantity,
      'colorName': colorName,
      'size': size,
      'status': status,
    };
  }
}

class OrdersNotifier extends StateNotifier<List<OrderItemModel>> {
  bool isInitialized = false;

  OrdersNotifier() : super([]) {
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    final savedOrders = await CartDatabase.instance.getAllOrders();

    state = {...state, ...savedOrders}.toList();

    // // Sort by date to keep newest at the top
    // state.sort((a, b) => b.orderDate.compareTo(a.orderDate));

    isInitialized = true;
  }

  // Future<void> _loadOrders() async {
  //   state = await CartDatabase.instance.getAllOrders();
  // }

  void addOrders(List<OrderItemModel> newOrders) async {
    state = [...newOrders, ...state];
    for (var order in newOrders) {
      await CartDatabase.instance.insertOrder(order);
    }
  }
}

final ordersProvider =
    StateNotifierProvider<OrdersNotifier, List<OrderItemModel>>((ref) {
      return OrdersNotifier();
    });
