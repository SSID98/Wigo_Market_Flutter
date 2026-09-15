import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wigo_flutter/features/seller/models/seller_product_model.dart';

enum SellerProductStatus { all, active, outOfStock, hidden, draft }

const _kUndefined = Object();

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
  final String searchQuery;
  final String typingQuery;
  final List<SellerProduct> searchSuggestions;
  final bool showSuggestions;
  final Set<String> selectedProductIds;
  final String? filterCategoryId;
  final Map<String, int> apiCounts;

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
    this.filterCategoryId,
    this.apiCounts = const {},
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
    String? searchQuery,
    String? typingQuery,
    List<SellerProduct>? searchSuggestions,
    Set<String>? selectedProductIds,
    bool? showSuggestions,
    Object? filterCategoryId = _kUndefined,
    Map<String, int>? apiCounts,
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
      filterCategoryId: identical(filterCategoryId, _kUndefined)
          ? this.filterCategoryId
          : filterCategoryId as String?,
      apiCounts: apiCounts ?? this.apiCounts,
    );
  }
}

extension SellerProductStatusExtension on SellerProductStatus {
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
        return name[0].toUpperCase() + name.substring(1);
    }
  }

  static SellerProductStatus fromString(String status) {
    return SellerProductStatus.values.firstWhere(
          (e) =>
      e.name.toLowerCase() == status.replaceAll(' ', '').toLowerCase(),
      orElse: () => SellerProductStatus.active,
    );
  }

  static SellerProductStatus fromDisplayString(String s) {
    switch (s) {
      case 'out_of_stock':
        return SellerProductStatus.outOfStock;
      case 'hidden':
        return SellerProductStatus.hidden;
      case 'active':
        return SellerProductStatus.active;
      default:
        return SellerProductStatus.active;
    }
  }

  String get toApiStatusParam {
    switch (this) {
      case SellerProductStatus.hidden:
        return 'hidden';
      case SellerProductStatus.outOfStock:
        return 'out_of_stock';
      case SellerProductStatus.active:
        return 'active';
      default:
        return 'all';
    }
  }
}
