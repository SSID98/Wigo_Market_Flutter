import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/url.dart';
import '../models/product_model.dart';
import '../presentation/views/search_results_view.dart';

class BuyerHomeState {
  final String searchQuery;
  final bool isSearchFieldVisible;
  final bool shouldClearSearch;
  final List<Product> allProducts;

  // NOTE: OverlayEntry management MUST stay in the UI (context)

  BuyerHomeState({
    this.searchQuery = '',
    this.isSearchFieldVisible = false,
    this.shouldClearSearch = false,
    this.allProducts = const [],
  });

  BuyerHomeState copyWith({
    String? searchQuery,
    bool? isSearchFieldVisible,
    bool? shouldClearSearch,
    List<Product>? allProducts,
  }) {
    return BuyerHomeState(
      searchQuery: searchQuery ?? this.searchQuery,
      isSearchFieldVisible: isSearchFieldVisible ?? this.isSearchFieldVisible,
      shouldClearSearch: shouldClearSearch ?? this.shouldClearSearch,
      allProducts: allProducts ?? this.allProducts,
    );
  }
}

class BuyerHomeViewModel extends StateNotifier<BuyerHomeState> {
  BuyerHomeViewModel({List<Product>? initialProducts})
    : super(BuyerHomeState(allProducts: initialProducts ?? _mockProducts));
  Timer? _searchDebounce;

  static final _mockProducts = [
    Product(
      imageUrl: '$networkImageUrl/nintendo.png',
      price: 10027,
      slashedAmount: '12,053',
      productName: 'Nintendo Gaming Console',
      rating: 4.0,
      reviews: 67,
      categoryName: 'Gaming',
      stock: 6,
    ),
    Product(
      imageUrl: '$networkImageUrl/gamePad.png',
      price: 10027,
      slashedAmount: '12,053',
      productName: 'PS3 Game pad with type C USB',
      rating: 4.0,
      reviews: 67,
      categoryName: 'Gaming',
      stock: 0,
    ),
    // ... (rest of your products)
    Product(
      imageUrl: '$networkImageUrl/wristwatch.png',
      price: 10027,
      slashedAmount: '12,053',
      productName: 'Quartz Wrist Watch',
      rating: 4.0,
      reviews: 67,
      categoryName: 'Jewelry',
      stock: 5,
    ),
    Product(
      imageUrl: '$networkImageUrl/phones.png',
      price: 10027,
      slashedAmount: '12,053',
      productName: 'Small Button Phone',
      rating: 4.0,
      reviews: 67,
      categoryName: 'Gadgets',
      stock: 0,
    ),
    Product(
      imageUrl: '$networkImageUrl/Honey.png',
      price: 10027,
      slashedAmount: '12,053',
      productName: 'Special Honey',
      rating: 4.0,
      reviews: 67,
      categoryName: 'Beverages',
      stock: 10,
    ),
  ];

  // List<Product> get filteredProducts {
  //   if (state.searchQuery.isEmpty) {
  //     return state.allProducts;
  //   }
  //   final query = state.searchQuery.toLowerCase();
  //   return state.allProducts.where((product) {
  //     return product.productName.toLowerCase().contains(query);
  //   }).toList();
  // }
  @override
  void dispose() {
    _searchDebounce?.cancel();
    super.dispose();
  }

  List<String> searchSuggestions(String query) {
    if (query.isEmpty) return [];

    final normalized = normalizeText(query);

    return state.allProducts
        .map((p) => p.productName)
        .where((name) => normalizeText(name).contains(normalized))
        .take(6)
        .toList();
  }

  List<Product> searchProducts(String query) {
    if (query.isEmpty) return [];

    final q = normalizeText(query);

    return state.allProducts
        .where((p) => normalizeText(p.productName).contains(q))
        .toList();
  }

  void updateSearchQuery(String query) {
    _searchDebounce?.cancel();

    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      state = state.copyWith(searchQuery: query);
    });
  }

  void toggleSearchFieldVisibility() {
    final newVisibility = !state.isSearchFieldVisible;

    if (!newVisibility) {
      state = state.copyWith(
        isSearchFieldVisible: false,
        searchQuery: '',
        shouldClearSearch: true,
      );
    } else {
      state = state.copyWith(
        isSearchFieldVisible: true,
        shouldClearSearch: false,
      );
    }
  }

  void resetSearch() {
    state = state.copyWith(isSearchFieldVisible: false, searchQuery: '');
  }
}

final buyerHomeViewModelProvider =
    StateNotifierProvider<BuyerHomeViewModel, BuyerHomeState>(
      (ref) =>
          BuyerHomeViewModel(initialProducts: BuyerHomeViewModel._mockProducts),
    );
