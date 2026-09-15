import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:wigo_flutter/shared/widgets/custom_banner.dart';

import '../../seller/models/seller_product_detail_state.dart';
import '../../seller/models/seller_product_model.dart';
import '../../seller/services/seller_api_service.dart';
import '../../seller/viewmodels/seller_product_task_viewmodel.dart';

final sellerProductDetailProvider = StateNotifierProvider.autoDispose
    .family<SellerProductDetailViewModel, SellerProductDetailState, String>(
      (ref, productId) => SellerProductDetailViewModel(
        ref.read(sellerApiServiceProvider),
        ref,
        productId,
      ),
    );

class SellerProductDetailViewModel
    extends StateNotifier<SellerProductDetailState> {
  final SellerApiService _api;
  final Ref _ref;
  final String _productId;

  SellerProductDetailViewModel(this._api, this._ref, this._productId)
    : super(const SellerProductDetailState()) {
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    state = state.copyWith(status: ProductDetailStatus.loading);
    try {
      final res = await _api.getProductDetail(_productId);
      if (!res.isSuccess || res.data == null) {
        state = state.copyWith(
          status: ProductDetailStatus.error,
          errorMessage:
              res.errorDescription?.toString() ?? 'Failed to load product',
        );
        return;
      }
      final product = SellerProduct.fromJson(res.data!);
      state = state.copyWith(
        status: ProductDetailStatus.loaded,
        product: product,
      );
      await loadReviews(page: 1);
    } catch (e) {
      state = state.copyWith(
        status: ProductDetailStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> refresh() => _loadDetail();

  Future<void> loadReviews({int? page, ReviewSort? sort}) async {
    final newPage = page ?? state.reviewPage;
    final newSort = sort ?? state.reviewSort;
    state = state.copyWith(
      reviewsLoading: true,
      reviewSort: newSort,
      reviewPage: newPage,
    );
    try {
      final res = await _api.getProductReviews(
        _productId,
        page: newPage,
        limit: 5,
        sort: newSort.apiValue,
      );
      if (res.isSuccess && res.data != null) {
        final parsed = ReviewsResponse.fromJson(res.data!);
        state = state.copyWith(
          reviews: parsed.reviews,
          reviewTotalPages: parsed.pages,
          reviewPage: newPage,
          reviewsLoading: false,
        );
      } else {
        state = state.copyWith(reviewsLoading: false);
      }
    } catch (_) {
      state = state.copyWith(reviewsLoading: false);
    }
  }

  Future<void> nextReviewPage() async {
    if (state.reviewPage < state.reviewTotalPages) {
      await loadReviews(page: state.reviewPage + 1);
    }
  }

  Future<void> prevReviewPage() async {
    if (state.reviewPage > 1) {
      await loadReviews(page: state.reviewPage - 1);
    }
  }

  Future<void> changeReviewSort(ReviewSort sort) async {
    await loadReviews(page: 1, sort: sort);
  }

  Future<bool> toggleHide(BuildContext context) async {
    final product = state.product;
    if (product == null) return false;

    final newStatus = product.status == 'hidden' ? 'active' : 'hidden';
    state = state.copyWith(isUpdating: true);

    final res = await _api.updateProduct(product.id, {'status': newStatus});

    if (!res.isSuccess) {
      state = state.copyWith(isUpdating: false);
      if (context.mounted) {
        showErrorBanner(
          res.errorDescription?.toString() ?? 'Update failed',
          context,
        );
      }
      return false;
    }

    final updated = SellerProduct.fromJson(res.data!);
    state = state.copyWith(product: updated, isUpdating: false);

    _ref.read(sellerProductTaskProvider.notifier).updateProductInList(updated);
    return true;
  }

  Future<bool> delete(BuildContext context) async {
    final product = state.product;
    if (product == null) return false;

    state = state.copyWith(isUpdating: true);
    final res = await _api.deleteProduct(product.id);

    if (!res.isSuccess) {
      state = state.copyWith(isUpdating: false);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res.errorDescription?.toString() ?? 'Delete failed'),
          ),
        );
      }
      return false;
    }

    _ref
        .read(sellerProductTaskProvider.notifier)
        .removeProductFromList(product.id);
    return true;
  }

  Future<bool> saveEdits(
    BuildContext context,
    Map<String, dynamic> payload,
  ) async {
    final product = state.product;
    if (product == null) return false;

    state = state.copyWith(isUpdating: true);
    final res = await _api.updateProduct(product.id, payload);

    if (!res.isSuccess) {
      state = state.copyWith(isUpdating: false);
      if (context.mounted) {
        showErrorBanner(
          res.errorDescription?.toString() ?? 'Update failed',
          context,
        );
      }
      return false;
    }

    final updated = SellerProduct.fromJson(res.data!);
    state = state.copyWith(product: updated, isUpdating: false);
    _ref.read(sellerProductTaskProvider.notifier).updateProductInList(updated);
    return true;
  }

  void toggleEditVariants() =>
      state = state.copyWith(showEditVariants: !state.showEditVariants);
}
