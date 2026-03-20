import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wigo_flutter/core/constants/url.dart';
import 'package:wigo_flutter/features/seller/models/seller_product_model.dart';

import '../models/seller_product_task_state.dart';

class SellerProductTaskViewmodel extends StateNotifier<SellerProductTaskState> {
  SellerProductTaskViewmodel() : super(const SellerProductTaskState()) {
    _loadProducts();
  }

  final int _pageSize = 10;
  late List<SellerProduct> _allProducts;

  Future<void> _loadProducts() async {
    state = state.copyWith(sellerProducts: const AsyncValue.loading());
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      _allProducts = _mockProducts;
      _updateCounts();
      _applyFilterAndPagination();
    } catch (e, st) {
      state = state.copyWith(sellerProducts: AsyncValue.error(e, st));
    }
  }

  void _updateCounts() {
    final Map<SellerProductStatus, int> newCounts = {
      SellerProductStatus.all: _allProducts.length,
      SellerProductStatus.active:
          _allProducts
              .where((d) => d.sellerProductStatus == SellerProductStatus.active)
              .length,
      SellerProductStatus.hidden:
          _allProducts
              .where((d) => d.sellerProductStatus == SellerProductStatus.hidden)
              .length,
      SellerProductStatus.draft:
          _allProducts
              .where((d) => d.sellerProductStatus == SellerProductStatus.draft)
              .length,
      SellerProductStatus.outOfStock:
          _allProducts
              .where(
                (d) => d.sellerProductStatus == SellerProductStatus.outOfStock,
              )
              .length,
    };
    state = state.copyWith(sellerProductCounts: newCounts);
  }

  void _applyFilterAndPagination() {
    // Start with the full list
    List<SellerProduct> filtered = List.from(_allProducts);

    // 1. Status Filter
    if (state.productStatus != SellerProductStatus.all) {
      filtered =
          filtered
              .where(
                (product) => product.sellerProductStatus == state.productStatus,
              )
              .toList();
    }

    // SEARCH FILTER (The applied search query)
    if (state.searchQuery.isNotEmpty) {
      filtered =
          filtered
              .where(
                (p) =>
                    p.productName.toLowerCase() ==
                        state.searchQuery.toLowerCase() ||
                    p.productId.toLowerCase() ==
                        state.searchQuery.toLowerCase(),
              )
              .toList();
    }

    // 2. Pagination (Always last)
    final startIndex = state.currentPage * _pageSize;
    final endIndex = (state.currentPage + 1) * _pageSize;
    final finalEndIndex =
        endIndex > filtered.length ? filtered.length : endIndex;

    // Handle empty lists gracefully
    final paginated =
        filtered.isEmpty
            ? <SellerProduct>[]
            : filtered.sublist(startIndex, finalEndIndex);

    state = state.copyWith(
      sellerProducts: AsyncValue.data(paginated),
      totalProductsCount: filtered.length,
    );
  }

  void toggleSelectStatus(bool? value) {
    state = state.copyWith(selectStatus: value ?? false);
  }

  void goToPage(int page) {
    if (page >= 0 &&
        page <= (state.totalProductsCount / _pageSize).ceil() - 1) {
      state = state.copyWith(currentPage: page);
      _applyFilterAndPagination();
    }
  }

  void updateProductStatus(String productId, SellerProductStatus newStatus) {
    _allProducts =
        _allProducts.map((product) {
          if (product.productId == productId) {
            return product.copyWith(sellerProductStatus: newStatus);
          }
          return product;
        }).toList();

    _updateCounts();
    _applyFilterAndPagination();
  }

  void filterByProductStatus(SellerProductStatus type) {
    state = state.copyWith(
      productStatus: type,
      currentPage: 0, // Reset pagination when filter changes
    );
    _applyFilterAndPagination();
  }

  void syncTempWithActive() {
    state = state.copyWith(
      tempSelectedStatuses: Set.from(state.activeStatuses),
    );
  }

  void updateTypingQuery(String query) {
    if (query.isEmpty) {
      state = state.copyWith(
        typingQuery: '',
        searchQuery: '',
        searchSuggestions: [],
        showSuggestions: false,
      );
      return;
    }

    final suggestions =
        _allProducts
            .where(
              (p) =>
                  p.productName.toLowerCase().contains(query.toLowerCase()) ||
                  p.productId.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();

    state = state.copyWith(
      typingQuery: query,
      searchSuggestions: suggestions,
      // We'll use this bool to tell the UI when to trigger controller.open()
      showSuggestions: suggestions.isNotEmpty,
    );
  }

  void applySearch(String selectedName) {
    state = state.copyWith(
      searchQuery: selectedName,
      showSuggestions: false,
      currentPage: 0,
    );
    _applyFilterAndPagination();
  }

  void clearSearch() {
    state = state.copyWith(
      searchQuery: '',
      typingQuery: '',
      showSuggestions: false,
      currentPage: 0,
    );
    _applyFilterAndPagination();
  }

  // --- SELECTION LOGIC ---

  void toggleProductSelection(String productId) {
    final currentSet = Set<String>.from(state.selectedProductIds);
    if (currentSet.contains(productId)) {
      currentSet.remove(productId);
    } else {
      currentSet.add(productId);
    }
    state = state.copyWith(selectedProductIds: currentSet);
  }

  void clearSelections() {
    state = state.copyWith(selectedProductIds: const {});
  }

  // --- HIDING LOGIC ---

  // Helper to update status in the master list
  void _updateProductStatusInMaster(
    List<String> ids,
    SellerProductStatus newStatus,
  ) {
    _allProducts =
        _allProducts.map((p) {
          if (ids.contains(p.productId)) {
            return p.copyWith(sellerProductStatus: newStatus);
          }
          return p;
        }).toList();

    _updateCounts();
    _applyFilterAndPagination();
  }

  // 1. Single Hide (from the View More icon)
  void hideSingleProduct(String productId) {
    _updateProductStatusInMaster([productId], SellerProductStatus.hidden);
  }

  // 2. Bulk Hide (from the Bulk Action button)
  void hideSelectedProducts() {
    if (state.selectedProductIds.isEmpty) return;

    _updateProductStatusInMaster(
      state.selectedProductIds.toList(),
      SellerProductStatus.hidden,
    );

    // Clear selection after action is complete
    clearSelections();
  }

  final _mockProducts = <SellerProduct>[
    SellerProduct(
      productId: "#WGO-4532",
      sellerProductStatus: SellerProductStatus.active,
      price: 5000,
      imageUrl: '$networkImageUrl/Cake.png',
      productName: 'Sprinkle Birthday Cake',
      rating: 4.5,
      reviews: 131,
      stock: '50',
      variant: '6',
      sold: '50',
    ),
    SellerProduct(
      productId: "#WGO-1345",
      sellerProductStatus: SellerProductStatus.hidden,
      price: 5000,
      imageUrl: '$networkImageUrl/meatpie.jpg',
      productName: 'Special Hot Godly Meatpie',
      rating: 4.5,
      reviews: 131,
      stock: '50',
      variant: '6',
      sold: '50',
    ),
    SellerProduct(
      productId: "#WGO-1238",
      sellerProductStatus: SellerProductStatus.outOfStock,
      price: 5000,
      imageUrl: '$networkImageUrl/shirt.png',
      productName: 'Men\'s Casual Short Sleeve Shirt',
      rating: 4.5,
      reviews: 131,
      stock: '50',
      variant: '6',
      sold: '50',
    ),
    SellerProduct(
      productId: "#WGO-9876",
      sellerProductStatus: SellerProductStatus.draft,
      price: 5000,
      imageUrl: '$networkImageUrl/shoe.png',
      productName: 'Light Weight Men\'s Canvas Shoe',
      rating: 4.5,
      reviews: 131,
      stock: '50',
      variant: '6',
      sold: '50',
    ),
    SellerProduct(
      productId: "#WGO-9875",
      sellerProductStatus: SellerProductStatus.active,
      price: 5000,
      imageUrl: '$networkImageUrl/nintendo.png',
      productName: 'Nintendo Console',
      rating: 4.5,
      reviews: 131,
      stock: '50',
      variant: '6',
      sold: '50',
    ),
  ];
}

final sellerProductTaskProvider =
    StateNotifierProvider<SellerProductTaskViewmodel, SellerProductTaskState>(
      (ref) => SellerProductTaskViewmodel(),
    );

final productByIdProvider = Provider.family<SellerProduct?, String>((
  ref,
  productId,
) {
  final state = ref.watch(sellerProductTaskProvider);

  return state.sellerProducts.value?.firstWhere(
    (o) => o.productId == productId,
  );
});

final searchControllerProvider = Provider.autoDispose<TextEditingController>((
  ref,
) {
  final controller = TextEditingController();
  // Clean up when the screen is closed
  ref.onDispose(() => controller.dispose());
  return controller;
});

final searchFocusProvider = Provider<FocusNode>((ref) {
  final node = FocusNode();
  ref.onDispose(node.dispose);
  return node;
});
