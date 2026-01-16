import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/cart_database.dart';
import '../models/product_model.dart';

class SavedProductsNotifier extends StateNotifier<List<Product>> {
  bool isInitialized = false;

  SavedProductsNotifier() : super([]) {
    _loadWishlist();
  }

  Future<void> _loadWishlist() async {
    final data = await CartDatabase.instance.getWishlist();
    state =
        data
            .map(
              (map) => Product(
                productName: map['productName'],
                price: map['price'],
                imageUrl: map['imageUrl'],
                slashedAmount: map['slashedAmount'],
                rating: map['rating'],
                reviews: map['reviews'],
                stock: map['stock'],
                categoryName: map['categoryName'] ?? '',
              ),
            )
            .toList();
    isInitialized = true;
  }

  Future<bool> toggleFavorite(Product product) async {
    final isSaved = state.any(
      (item) => item.productName == product.productName,
    );

    if (isSaved) {
      state =
          state
              .where((item) => item.productName != product.productName)
              .toList();
      await CartDatabase.instance.deleteSavedProduct(product.productName);
      return false;
    } else {
      state = [...state, product];
      await CartDatabase.instance.insertSavedProduct({
        'productName': product.productName,
        'price': product.price,
        'imageUrl': product.imageUrl,
        'slashedAmount': product.slashedAmount,
        'rating': product.rating,
        'reviews': product.reviews,
        'stock': product.stock,
      });
      return true;
    }
  }

  bool isProductSaved(String productName) {
    return state.any((item) => item.productName == productName);
  }
}

final savedProductsProvider =
    StateNotifierProvider<SavedProductsNotifier, List<Product>>((ref) {
      return SavedProductsNotifier();
    });
