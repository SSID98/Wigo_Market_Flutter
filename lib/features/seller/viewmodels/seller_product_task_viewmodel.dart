import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:wigo_flutter/features/seller/models/seller_product_model.dart';
import 'package:wigo_flutter/shared/widgets/custom_banner.dart';

import '../models/seller_product_task_state.dart';
import '../services/seller_api_service.dart';

class SellerProductTaskViewmodel extends StateNotifier<SellerProductTaskState> {
  final SellerApiService _api;

  SellerProductTaskViewmodel(this._api) : super(const SellerProductTaskState());

  Future<void> loadProducts({bool resetPage = true}) async {
    if (state.sellerProducts.isLoading) return;

    if (resetPage) state = state.copyWith(currentPage: 0);
    state = state.copyWith(sellerProducts: const AsyncValue.loading());

    try {
      final statusParam = state.searchQuery.isNotEmpty
          ? null
          : (state.productStatus == SellerProductStatus.all
                ? null
                : state.productStatus.toApiStatusParam);

      final res = await _api.getMyProducts(
        page: state.currentPage + 1,
        limit: state.rowsPerPage,
        search: state.searchQuery.isEmpty ? null : state.searchQuery,
        status: statusParam,
        categoryId: state.filterCategoryId,
      );

      if (!mounted) return;

      if (!res.isSuccess || res.data == null) {
        state = state.copyWith(
          sellerProducts: AsyncValue.error(
            res.errorDescription ?? 'Failed to load products',
            StackTrace.current,
          ),
        );
        return;
      }

      final parsed = ProductsListResponse.fromJson(res.data!);
      state = state.copyWith(
        sellerProducts: AsyncValue.data(parsed.products),
        totalProductsCount: parsed.total,
        apiCounts: parsed.counts,
        sellerProductCounts: {
          SellerProductStatus.all: parsed.counts['all'] ?? 0,
          SellerProductStatus.active: parsed.counts['active'] ?? 0,
          SellerProductStatus.outOfStock: parsed.counts['out_of_stock'] ?? 0,
          SellerProductStatus.hidden: parsed.counts['hidden'] ?? 0,
          SellerProductStatus.draft: 0,
        },
      );
    } catch (e, st) {
      if (!mounted) return;
      state = state.copyWith(sellerProducts: AsyncValue.error(e, st));
    }
  }

  Future<void> goToPage(int page) async {
    final totalPages = (state.totalProductsCount / state.rowsPerPage).ceil();
    if (page < 0 || page >= totalPages) return;
    state = state.copyWith(currentPage: page);
    await loadProducts(resetPage: false);
  }

  Future<void> filterByProductStatus(SellerProductStatus type) async {
    state = state.copyWith(productStatus: type, currentPage: 0);
    await loadProducts(resetPage: false);
  }

  Future<void> filterByCategory(String? categoryId) async {
    state = state.copyWith(filterCategoryId: categoryId, currentPage: 0);
    await loadProducts(resetPage: false);
  }

  void updateTypingQuery(String query) {
    if (query.isEmpty) {
      state = state.copyWith(
        typingQuery: '',
        searchSuggestions: [],
        showSuggestions: false,
      );
      return;
    }

    final loaded = state.sellerProducts.value ?? [];
    final suggestions = loaded
        .where(
          (p) =>
              p.title.toLowerCase().contains(query.toLowerCase()) ||
              (p.sku?.toLowerCase().contains(query.toLowerCase()) ?? false),
        )
        .toList();

    state = state.copyWith(
      typingQuery: query,
      searchSuggestions: suggestions,
      showSuggestions: suggestions.isNotEmpty,
    );
  }

  Future<void> applySearch(String query) async {
    state = state.copyWith(
      searchQuery: query,
      typingQuery: query,
      showSuggestions: false,
      searchSuggestions: [],
      currentPage: 0,
    );
    await loadProducts(resetPage: false);
  }

  Future<void> clearSearch() async {
    final hadActiveSearch = state.searchQuery.isNotEmpty;
    state = state.copyWith(
      searchQuery: '',
      typingQuery: '',
      showSuggestions: false,
      searchSuggestions: [],
      currentPage: 0,
    );
    if (hadActiveSearch) {
      await loadProducts(resetPage: false);
    }
  }

  void toggleProductSelection(String productId) {
    final current = Set<String>.from(state.selectedProductIds);
    if (current.contains(productId)) {
      current.remove(productId);
    } else {
      current.add(productId);
    }
    state = state.copyWith(selectedProductIds: current);
  }

  void clearSelections() =>
      state = state.copyWith(selectedProductIds: const {});

  void updateProductInList(SellerProduct updated) {
    final current = List<SellerProduct>.from(state.sellerProducts.value ?? []);
    final idx = current.indexWhere((p) => p.id == updated.id);
    if (idx != -1) {
      current[idx] = updated;
      state = state.copyWith(sellerProducts: AsyncValue.data(current));
    }
  }

  void removeProductFromList(String productId) {
    final current = List<SellerProduct>.from(state.sellerProducts.value ?? [])
      ..removeWhere((p) => p.id == productId);
    state = state.copyWith(
      sellerProducts: AsyncValue.data(current),
      totalProductsCount: (state.totalProductsCount - 1)
          .clamp(0, double.maxFinite)
          .toInt(),
    );
  }

  Future<bool> bulkHide(BuildContext context) => _doBulkAction('hide', context);

  Future<bool> bulkUnhide(BuildContext context) =>
      _doBulkAction('unhide', context);

  Future<bool> bulkDelete(BuildContext context) =>
      _doBulkAction('delete', context);

  Future<bool> _doBulkAction(String action, BuildContext context) async {
    if (state.selectedProductIds.isEmpty) return false;

    final ids = state.selectedProductIds.toList();
    final res = await _api.bulkProductAction(action: action, ids: ids);

    if (!res.isSuccess) {
      if (context.mounted) {
        showErrorBanner(
          res.errorDescription?.toString() ?? 'Bulk action failed',
          context,
        );
      }
      return false;
    }
    clearSelections();
    await loadProducts();
    return true;
  }

  Future<bool> hideSingleProduct(String productId, BuildContext context) async {
    final products = state.sellerProducts.value ?? [];
    final idx = products.indexWhere((p) => p.id == productId);
    if (idx == -1) return false;

    final newStatus = products[idx].status == 'hidden' ? 'active' : 'hidden';
    final res = await _api.updateProduct(productId, {'status': newStatus});

    if (!res.isSuccess) {
      if (context.mounted) {
        showErrorBanner(
          res.errorDescription?.toString() ?? 'Failed to update product',
          context,
        );
      }
      return false;
    }

    final updated = SellerProduct.fromJson(res.data!);
    updateProductInList(updated);
    return true;
  }

  Future<bool> deleteSingleProduct(
    String productId,
    BuildContext context,
  ) async {
    final res = await _api.deleteProduct(productId);

    if (!res.isSuccess) {
      if (context.mounted) {
        showErrorBanner(
          res.errorDescription?.toString() ?? 'Failed to delete product',
          context,
        );
      }
      return false;
    }

    removeProductFromList(productId);
    return true;
  }

  void syncTempWithActive() => state = state.copyWith(
    tempSelectedStatuses: Set.from(state.activeStatuses),
  );

  Future<void> setRowsPerPage(int rows) async {
    state = state.copyWith(rowsPerPage: rows, currentPage: 0);
    await loadProducts(resetPage: false);
  }
}

final sellerProductTaskProvider =
    StateNotifierProvider<SellerProductTaskViewmodel, SellerProductTaskState>(
      (ref) => SellerProductTaskViewmodel(ref.read(sellerApiServiceProvider)),
    );

final productByIdProvider = Provider.family<SellerProduct?, String>((ref, id) {
  return ref
      .watch(sellerProductTaskProvider)
      .sellerProducts
      .value
      ?.firstWhere(
        (p) => p.id == id,
        orElse: () => throw StateError('not found'),
      );
});

final searchControllerProvider = Provider.autoDispose<TextEditingController>((
  ref,
) {
  final controller = TextEditingController();
  ref.onDispose(() => controller.dispose());
  return controller;
});

final searchFocusProvider = Provider<FocusNode>((ref) {
  final node = FocusNode();
  ref.onDispose(node.dispose);
  return node;
});
