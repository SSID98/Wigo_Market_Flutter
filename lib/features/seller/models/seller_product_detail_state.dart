import 'package:wigo_flutter/features/seller/models/seller_product_model.dart';

enum ProductDetailStatus { idle, loading, loaded, error }

enum ReviewSort { recent, highest, lowest, helpful }

extension ReviewSortExt on ReviewSort {
  String get apiValue {
    switch (this) {
      case ReviewSort.recent:
        return 'recent';
      case ReviewSort.highest:
        return 'highest';
      case ReviewSort.lowest:
        return 'lowest';
      case ReviewSort.helpful:
        return 'helpful';
    }
  }

  String get label {
    switch (this) {
      case ReviewSort.recent:
        return 'Most Recent';
      case ReviewSort.highest:
        return 'Highest Rated';
      case ReviewSort.lowest:
        return 'Lowest Rated';
      case ReviewSort.helpful:
        return 'Most Helpful';
    }
  }
}

class SellerProductDetailState {
  final ProductDetailStatus status;
  final SellerProduct? product;
  final String? errorMessage;

  final List<ReviewItem> reviews;
  final bool reviewsLoading;
  final int reviewPage;
  final int reviewTotalPages;
  final ReviewSort reviewSort;

  final bool isUpdating;
  final bool showEditVariants;

  const SellerProductDetailState({
    this.status = ProductDetailStatus.idle,
    this.product,
    this.errorMessage,
    this.reviews = const [],
    this.reviewsLoading = false,
    this.reviewPage = 1,
    this.reviewTotalPages = 1,
    this.reviewSort = ReviewSort.recent,
    this.isUpdating = false,
    this.showEditVariants = false,
  });

  SellerProductDetailState copyWith({
    ProductDetailStatus? status,
    SellerProduct? product,
    String? errorMessage,
    List<ReviewItem>? reviews,
    bool? reviewsLoading,
    int? reviewPage,
    int? reviewTotalPages,
    ReviewSort? reviewSort,
    bool? isUpdating,
    bool? showEditVariants,
  }) => SellerProductDetailState(
    status: status ?? this.status,
    product: product ?? this.product,
    errorMessage: errorMessage ?? this.errorMessage,
    reviews: reviews ?? this.reviews,
    reviewsLoading: reviewsLoading ?? this.reviewsLoading,
    reviewPage: reviewPage ?? this.reviewPage,
    reviewTotalPages: reviewTotalPages ?? this.reviewTotalPages,
    reviewSort: reviewSort ?? this.reviewSort,
    isUpdating: isUpdating ?? this.isUpdating,
    showEditVariants: showEditVariants ?? this.showEditVariants,
  );
}
