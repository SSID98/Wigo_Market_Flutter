import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wigo_flutter/features/seller/models/seller_product_model.dart';

enum SellerProductStatus { all, active, outOfStock, hidden, draft }

class SellerProductTaskState {
  final AsyncValue<List<SellerProduct>> sellerProducts;
  final SellerProductStatus productStatus;
  final int currentPage;
  final int totalProductsCount;
  final Map<SellerProductStatus, int> sellerProductCounts;
  final int rowsPerPage;
  final Set<SellerProductStatus>? tempSelectedStatuses;
  final bool selectStatus;
  final Set<SellerProductStatus> activeStatuses;
  final String searchQuery; // The applied filter
  final String typingQuery; // What the user is currently typing
  final List<SellerProduct> searchSuggestions;
  final bool showSuggestions;
  final Set<String> selectedProductIds;

  const SellerProductTaskState({
    this.sellerProducts = const AsyncValue.data([]),
    this.productStatus = SellerProductStatus.all,
    this.currentPage = 0,
    this.sellerProductCounts = const {},
    this.totalProductsCount = 0,
    this.rowsPerPage = 10,
    this.selectStatus = false,
    this.activeStatuses = const {},
    this.tempSelectedStatuses = const {},
    this.searchQuery = '',
    this.typingQuery = '',
    this.searchSuggestions = const [],
    this.showSuggestions = false,
    this.selectedProductIds = const {},
  });

  SellerProductTaskState copyWith({
    AsyncValue<List<SellerProduct>>? sellerProducts,
    SellerProductStatus? productStatus,
    int? currentPage,
    int? totalProductsCount,
    Map<SellerProductStatus, int>? sellerProductCounts,
    int? rowsPerPage,
    bool? selectStatus,
    Set<SellerProductStatus>? activeStatuses,
    Set<SellerProductStatus>? tempSelectedStatuses,
    String? searchQuery, // The applied filter
    String? typingQuery, // What the user is currently typing
    List<SellerProduct>? searchSuggestions,
    Set<String>? selectedProductIds,
    bool? showSuggestions,
  }) {
    return SellerProductTaskState(
      sellerProducts: sellerProducts ?? this.sellerProducts,
      currentPage: currentPage ?? this.currentPage,
      totalProductsCount: totalProductsCount ?? this.totalProductsCount,
      rowsPerPage: rowsPerPage ?? this.rowsPerPage,
      selectStatus: selectStatus ?? this.selectStatus,
      sellerProductCounts: sellerProductCounts ?? this.sellerProductCounts,
      activeStatuses: activeStatuses ?? this.activeStatuses,
      productStatus: productStatus ?? this.productStatus,
      tempSelectedStatuses: tempSelectedStatuses ?? this.tempSelectedStatuses,
      searchQuery: searchQuery ?? this.searchQuery,
      typingQuery: typingQuery ?? this.typingQuery,
      searchSuggestions: searchSuggestions ?? this.searchSuggestions,
      showSuggestions: showSuggestions ?? this.showSuggestions,
      selectedProductIds: selectedProductIds ?? this.selectedProductIds,
    );
  }
}

extension SellerProductStatusExtension on SellerProductStatus {
  //Backend (JSON)
  String get toJsonString => name;

  String get displayName {
    switch (this) {
      case SellerProductStatus.outOfStock:
        return 'Out of Stock';
      case SellerProductStatus.active:
        return 'Active';
      case SellerProductStatus.hidden:
        return 'Hidden';
      case SellerProductStatus.draft:
        return 'Draft';
      default:
        // Capitalizes the first letter: "pending" -> "Pending"
        return name[0].toUpperCase() + name.substring(1);
    }
  }

  // convert Backend String -> Enum
  static SellerProductStatus fromString(String status) {
    return SellerProductStatus.values.firstWhere(
      (e) => e.name.toLowerCase() == status.replaceAll(' ', '').toLowerCase(),
      orElse: () => SellerProductStatus.active,
    );
  }
}
