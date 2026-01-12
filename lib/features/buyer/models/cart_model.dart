import 'package:wigo_flutter/features/buyer/models/product_model.dart';

class CartState {
  final Product product;
  final int quantity;
  final String size;
  final String colorName;
  final bool saveInfo;
  final bool isOrdered;

  CartState({
    this.quantity = 1,
    required this.product,
    required this.size,
    required this.colorName,
    this.saveInfo = false,
    this.isOrdered = true,
  });

  // Convert a Map (from SQL) into a CartItemModel
  factory CartState.fromMap(Map<String, dynamic> map) {
    return CartState(
      product: Product(
        productName: map['productName'],
        price: map['price'],
        imageUrl: map['imageUrl'],
        stock: map['stock'],
        rating: map['rating'] ?? 0.0,
        reviews: map['reviews'] ?? 0,
        slashedAmount: map['slashedAmount'] ?? '',
        categoryName: map['categoryName'] ?? '',
      ),
      size: map['size'],
      quantity: map['quantity'],
      // SQL stores bool as 1 or 0
      isOrdered: map['isOrdered'] == 1,
      saveInfo: map['saveInfo'] == 0,
      colorName: map['colorName'],
    );
  }

  // Convert a CartItemModel into a Map (for SQL)
  Map<String, dynamic> toMap() {
    return {
      'productName': product.productName,
      'price': product.price,
      'imageUrl': product.imageUrl,
      'stock': product.stock,
      'colorName': colorName,
      'size': size,
      'quantity': quantity,
      'isOrdered': isOrdered ? 1 : 0,
      // Store as 1 or 0
      'saveInfo': saveInfo ? 0 : 1,
    };
  }

  CartState copyWith({
    int? quantity,
    String? size,
    String? colorName,
    bool? saveInfo,
    bool? isOrdered,
  }) {
    return CartState(
      quantity: quantity ?? this.quantity,
      product: product,
      size: size ?? this.size,
      colorName: colorName ?? this.colorName,
      saveInfo: saveInfo ?? this.saveInfo,
      isOrdered: isOrdered ?? this.isOrdered,
    );
  }
}
