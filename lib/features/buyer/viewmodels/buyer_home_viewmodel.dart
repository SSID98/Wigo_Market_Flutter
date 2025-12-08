import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/url.dart';
import '../models/product_model.dart';

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
    required this.allProducts,
  });

  BuyerHomeState copyWith({
    String? searchQuery,
    bool? isSearchFieldVisible,
    bool? isCategoriesVisibleInMenu,
    bool? shouldClearSearch,
  }) {
    return BuyerHomeState(
      searchQuery: searchQuery ?? this.searchQuery,
      isSearchFieldVisible: isSearchFieldVisible ?? this.isSearchFieldVisible,
      shouldClearSearch: shouldClearSearch ?? this.shouldClearSearch,
      allProducts: allProducts,
    );
  }
}

class BuyerHomeViewModel extends StateNotifier<BuyerHomeState> {
  BuyerHomeViewModel() : super(_initialState);

  static final _initialState = BuyerHomeState(
    allProducts: [
      Product(
        imageUrl: '$networkImageUrl/nintendo.png',
        amount: '10,027.61',
        slashedAmount: '12,053.69',
        productName: 'Nintendo Gaming Console',
        rating: 4.0,
        reviews: 67,
        categoryName: 'Gaming',
      ),
      Product(
        imageUrl: '$networkImageUrl/gamePad.png',
        amount: '10,027.61',
        slashedAmount: '12,053.69',
        productName: 'PS3 Game pad with type C USB',
        rating: 4.0,
        reviews: 67,
        categoryName: 'Gaming',
      ),
      // ... (rest of your products)
      Product(
        imageUrl: '$networkImageUrl/wristwatch.png',
        amount: '10,027.61',
        slashedAmount: '12,053.69',
        productName: 'Quartz Wrist Watch',
        rating: 4.0,
        reviews: 67,
        categoryName: 'Jewelry',
      ),
      Product(
        imageUrl: '$networkImageUrl/phones.png',
        amount: '10,027.61',
        slashedAmount: '12,053.69',
        productName: 'Small Button Phone',
        rating: 4.0,
        reviews: 67,
        categoryName: 'Gadgets',
      ),
      Product(
        imageUrl: '$networkImageUrl/Honey.png',
        amount: '10,027.61',
        slashedAmount: '12,053.69',
        productName: 'Special Honey',
        rating: 4.0,
        reviews: 67,
        categoryName: 'Beverages',
      ),
    ],
  );

  List<Product> get filteredProducts {
    if (state.searchQuery.isEmpty) {
      return state.allProducts;
    }
    final query = state.searchQuery.toLowerCase();
    return state.allProducts.where((product) {
      return product.productName.toLowerCase().contains(query);
    }).toList();
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
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
      (ref) => BuyerHomeViewModel(),
    );
