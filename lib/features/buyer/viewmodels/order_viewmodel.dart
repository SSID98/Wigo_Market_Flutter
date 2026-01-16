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
  final int rating;

  OrderItemModel({
    required this.productName,
    required this.price,
    required this.imageUrl,
    required this.quantity,
    required this.colorName,
    required this.size,
    this.status = 'On Delivery',
    this.rating = 0,
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
      'rating': rating,
    };
  }

  OrderItemModel copyWith({
    String? productName,
    double? price,
    String? imageUrl,
    int? quantity,
    String? status,
    String? size,
    String? colorName,
    int? rating,
  }) {
    return OrderItemModel(
      productName: productName ?? this.productName,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      quantity: quantity ?? this.quantity,
      status: status ?? this.status,
      size: size ?? this.size,
      colorName: colorName ?? this.colorName,
      rating: rating ?? this.rating,
    );
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

    isInitialized = true;
  }

  void addOrders(List<OrderItemModel> newOrders) async {
    state = [...newOrders, ...state];
    for (var order in newOrders) {
      await CartDatabase.instance.insertOrder(order);
    }
  }

  Future<void> updateRating(String productName, int newRating) async {
    state =
        state.map((order) {
          if (order.productName == productName) {
            return order.copyWith(rating: newRating);
          }
          return order;
        }).toList();

    // await CartDatabase.instance.updateOrderRating(productName, newRating);
  }
}

final ordersProvider =
    StateNotifierProvider<OrdersNotifier, List<OrderItemModel>>((ref) {
      return OrdersNotifier();
    });
