class Product {
  final String productName;
  final double price;
  final String slashedAmount;
  final String imageUrl;
  final double rating;
  final int reviews;
  final int stock;
  final String categoryName;

  Product({
    required this.imageUrl,
    required this.productName,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.slashedAmount,
    required this.stock,
    required this.categoryName,
  });
}
