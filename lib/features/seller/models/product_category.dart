class ProductCategory {
  final String name;
  final List<String> subCategories;

  const ProductCategory(this.name, [this.subCategories = const []]);
}

const List<ProductCategory> allCategories = [
  ProductCategory("Fashion", [
    "Men's Fashion",
    "Women's Fashion",
    "Unisex Fashion",
  ]),
  ProductCategory("Phones & Accessories", [
    "Phone & Tablet",
    "Phone & Accessories",
  ]),
  ProductCategory("Computers & Accessories", [
    "Laptop & Desktop",
    "Computer & Accessories",
  ]),
  ProductCategory("Gaming"),
  ProductCategory("Books & Stationery"),
  ProductCategory("Electronics & Gadgets"),
  ProductCategory("Beauty & Personal Care"),
  ProductCategory("Home & Living"),
  ProductCategory("Health & Wellness"),
  ProductCategory("Baby Product"),
  ProductCategory("Tools & Electrical"),
  ProductCategory("Automobile"),
  ProductCategory("Gaming"),
  ProductCategory("Sports & Fitness"),
];
