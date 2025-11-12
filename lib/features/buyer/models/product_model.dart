class Product {
  final String productName;
  final String amount;
  final String slashedAmount;
  final String imageUrl;
  final double rating;
  final int reviews;

  Product({
    required this.imageUrl,
    required this.productName,
    required this.amount,
    required this.rating,
    required this.reviews,
    required this.slashedAmount,
  });
}
