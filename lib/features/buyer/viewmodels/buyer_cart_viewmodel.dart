import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/cart_database.dart';
import '../models/cart_model.dart';
import 'order_viewmodel.dart';

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

  Future<void> processCheckout(WidgetRef ref) async {
    // 1. Identify selected items
    final selectedItems = state.where((item) => item.isOrdered).toList();

    if (selectedItems.isEmpty) return;

    // 2. Convert to OrderItemModels
    final newOrders =
        selectedItems
            .map(
              (item) => OrderItemModel(
                productName: item.product.productName,
                price: item.product.price,
                imageUrl: item.product.imageUrl,
                quantity: item.quantity,
                size: item.size,
                colorName: item.colorName,
              ),
            )
            .toList();

    // 3. Add to the Orders Screen provider
    ref.read(ordersProvider.notifier).addOrders(newOrders);

    // 4. Update SQLite and State: Remove purchased items from Cart
    for (var item in selectedItems) {
      await CartDatabase.instance.deleteItem(item.product.productName);
    }

    // Update state to only include items that were NOT ordered (the ones left in the "wishlist")
    state = state.where((item) => !item.isOrdered).toList();
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
