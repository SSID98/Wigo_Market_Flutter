import 'package:wigo_flutter/features/seller/models/seller_product_task_state.dart';

class SellerProduct {
  final String productName;
  final String productId;
  final SellerProductStatus sellerProductStatus;
  final String imageUrl;
  final double rating;
  final double price;
  final int reviews;
  final String stock;
  final String sold;
  final String variant;

  SellerProduct({
    required this.imageUrl,
    required this.productName,
    required this.rating,
    required this.reviews,
    required this.stock,
    required this.variant,
    required this.productId,
    required this.sellerProductStatus,
    required this.price,
    required this.sold,
  });

  SellerProduct copyWith({SellerProductStatus? sellerProductStatus}) {
    return SellerProduct(
      productId: productId,
      productName: productName,
      imageUrl: imageUrl,
      stock: stock,
      price: price,
      sellerProductStatus: sellerProductStatus ?? this.sellerProductStatus,
      sold: sold,
      variant: variant,
      reviews: reviews,
      rating: rating,
    );
  }
}
