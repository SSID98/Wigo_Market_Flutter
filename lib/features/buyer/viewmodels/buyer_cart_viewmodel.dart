import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/cart_database.dart';
import '../models/cart_model.dart';

class CartNotifier extends StateNotifier<List<CartState>> {
  CartNotifier() : super([]) {
    _loadCart();
  }

  Future<void> _loadCart() async {
    final items = await CartDatabase.instance.getAllItems();
    state = items;
  }

  Future<void> addItem(CartState newItem) async {
    final exists = state.any(
      (item) => item.product.productName == newItem.product.productName,
    );

    if (!exists) {
      state = [...state, newItem];
      await CartDatabase.instance.insertItem(newItem);
    }
  }

  Future<void> toggleOrderItem(String productName) async {
    state = [
      for (final item in state)
        if (item.product.productName == productName)
          item.copyWith(isOrdered: !item.isOrdered)
        else
          item,
    ];
    final updatedItem = state.firstWhere(
      (e) => e.product.productName == productName,
    );
    await CartDatabase.instance.insertItem(updatedItem);
  }

  Future<void> updateQuantity(String productName, int newQuantity) async {
    if (newQuantity <= 0) {
      removeItem(productName);
      return;
    }
    state =
        state.map((item) {
          if (item.product.productName == productName) {
            return item.copyWith(quantity: newQuantity);
          }
          return item;
        }).toList();
    final updatedItem = state.firstWhere(
      (e) => e.product.productName == productName,
    );
    await CartDatabase.instance.insertItem(updatedItem);
  }

  Future<void> removeItem(String productName) async {
    state =
        state.where((item) => item.product.productName != productName).toList();
    await CartDatabase.instance.deleteItem(productName);
  }

  double get subtotal {
    double total = 0.0;
    for (var item in state) {
      total += (item.product.price * item.quantity);
    }
    return total;
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartState>>(
  (ref) => CartNotifier(),
);

final cartSubtotalProvider = Provider<double>((ref) {
  final cartItems = ref.watch(cartProvider);

  // Filter the list to only include items where isOrdered is true
  final orderedItems = cartItems.where((item) => item.isOrdered);

  // Sum only the filtered items
  return orderedItems.fold(0.0, (previousValue, item) {
    return previousValue + (item.product.price * item.quantity);
  });
});

// Returns only the items where 'isOrdered' is true.
// This is what you will send to your API/Backend.
final cartSelectedItemsProvider = Provider<List<CartState>>((ref) {
  final allCartItems = ref.watch(cartProvider);
  return allCartItems.where((item) => item.isOrdered).toList();
});

final cartCountProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).length;
});

final isInCartProvider = Provider.family<bool, String>((ref, uniqueId) {
  final cart = ref.watch(cartProvider);
  return cart.any((item) => item.product.productName == uniqueId);
});
