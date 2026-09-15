import 'package:wigo_flutter/features/seller/models/seller_product_task_state.dart';

class ProductOptionType {
  final String name;
  final List<String> values;

  const ProductOptionType({required this.name, required this.values});

  factory ProductOptionType.fromJson(Map<String, dynamic> j) =>
      ProductOptionType(
        name: j['name'] as String,
        values: (j['values'] as List<dynamic>).cast<String>(),
      );

  Map<String, dynamic> toJson() => {'name': name, 'values': values};
}

class ProductVariantOption {
  final String name;
  final String value;

  const ProductVariantOption({required this.name, required this.value});

  factory ProductVariantOption.fromJson(Map<String, dynamic> j) =>
      ProductVariantOption(
        name: j['name'] as String,
        value: j['value'] as String,
      );

  Map<String, dynamic> toJson() => {'name': name, 'value': value};
}

class ProductVariantItem {
  final String id;
  final String? sku;
  final double price;
  final double listedPrice;
  final int stock;
  final int sold;
  final String? image;
  final bool inStock;
  final List<ProductVariantOption> options;

  const ProductVariantItem({
    required this.id,
    this.sku,
    required this.price,
    required this.listedPrice,
    required this.stock,
    required this.sold,
    this.image,
    required this.inStock,
    required this.options,
  });

  factory ProductVariantItem.fromJson(Map<String, dynamic> j) =>
      ProductVariantItem(
        id: j['id'] as String? ?? j['_id'] as String? ?? '',
        sku: j['sku'] as String?,
        price: (j['price'] as num).toDouble(),
        listedPrice: (j['listedPrice'] as num? ?? j['price'] as num).toDouble(),
        stock: j['stock'] as int? ?? 0,
        sold: j['sold'] as int? ?? 0,
        image: j['image'] as String?,
        inStock: j['inStock'] as bool? ?? true,
        options: (j['options'] as List<dynamic>? ?? [])
            .map(
              (o) => ProductVariantOption.fromJson(o as Map<String, dynamic>),
        )
            .toList(),
      );

  Map<String, dynamic> toEditPayload() =>
      {
        'id': id,
        if (sku != null) 'sku': sku,
        'price': price,
        'quantity': stock,
        'options': options.map((o) => o.toJson()).toList(),
      };

  String? optionValue(String name) {
    try {
      return options
          .firstWhere((o) => o.name == name)
          .value;
    } catch (_) {
      return null;
    }
  }

  String get label => options.map((o) => o.value).join(' / ');
}

class PriceRange {
  final double from;
  final double to;

  const PriceRange({required this.from, required this.to});

  factory PriceRange.fromJson(Map<String, dynamic> j) =>
      PriceRange(
        from: (j['from'] as num).toDouble(),
        to: (j['to'] as num).toDouble(),
      );
}

class SellerProductCategory {
  final String id;
  final String name;
  final String? parent;
  final String? parentName;
  final String? path;

  const SellerProductCategory({
    required this.id,
    required this.name,
    this.parent,
    this.parentName,
    this.path,
  });

  factory SellerProductCategory.fromJson(Map<String, dynamic> j) {
    final parentCat = j['parentCategory'] as Map<String, dynamic>?;
    return SellerProductCategory(
      id: j['id'] as String? ?? j['_id'] as String? ?? '',
      name: j['name'] as String,
      parent: j['parent'] as String?,
      parentName: parentCat?['name'] as String?,
      path: j['path'] as String?,
    );
  }

  String get displayPath {
    if (path != null) return path!;
    if (parentName != null) return '$parentName > $name';
    return name;
  }
}

class ProductRating {
  final double average;
  final int count;

  const ProductRating({required this.average, required this.count});

  factory ProductRating.fromJson(Map<String, dynamic> j) =>
      ProductRating(
        average: (j['average'] as num? ?? 0).toDouble(),
        count: j['count'] as int? ?? 0,
      );
}

class ProductOverview {
  final String name;
  final String categoryPath;
  final SellerProductCategory? category;
  final String? sku;
  final DateTime? dateAdded;
  final int variantCount;
  final String availableForLabel;
  final String statusLabel;
  final String displayStatus;
  final String productType;
  final String? brand;

  const ProductOverview({
    required this.name,
    required this.categoryPath,
    this.category,
    this.sku,
    this.dateAdded,
    required this.variantCount,
    required this.availableForLabel,
    required this.statusLabel,
    required this.displayStatus,
    required this.productType,
    this.brand,
  });

  factory ProductOverview.fromJson(Map<String, dynamic> j) =>
      ProductOverview(
        name: j['name'] as String? ?? '',
        categoryPath: j['categoryPath'] as String? ?? '',
        category: j['category'] != null
            ? SellerProductCategory.fromJson(
            j['category'] as Map<String, dynamic>)
            : null,
        sku: j['sku'] as String?,
        dateAdded: j['dateAdded'] != null
            ? DateTime.tryParse(j['dateAdded'] as String)
            : null,
        variantCount: j['variantCount'] as int? ?? 0,
        availableForLabel: j['availableForLabel'] as String? ?? '',
        statusLabel: j['statusLabel'] as String? ?? '',
        displayStatus: j['displayStatus'] as String? ?? 'active',
        productType: j['productType'] as String? ?? 'single',
        brand: j['brand'] as String?,
      );
}

class ProductInventory {
  final double price;
  final double listedPrice;
  final String currency;
  final PriceRange? priceRange;
  final int totalStock;
  final int availableStock;
  final int totalSold;
  final DateTime? lastOrderedAt;
  final List<ProductVariantItem> variants;

  const ProductInventory({
    required this.price,
    required this.listedPrice,
    required this.currency,
    this.priceRange,
    required this.totalStock,
    required this.availableStock,
    required this.totalSold,
    this.lastOrderedAt,
    required this.variants,
  });

  factory ProductInventory.fromJson(Map<String, dynamic> j) =>
      ProductInventory(
        price: (j['price'] as num? ?? 0).toDouble(),
        listedPrice: (j['listedPrice'] as num? ?? 0).toDouble(),
        currency: j['currency'] as String? ?? 'NGN',
        priceRange: j['priceRange'] != null
            ? PriceRange.fromJson(j['priceRange'] as Map<String, dynamic>)
            : null,
        totalStock: j['totalStock'] as int? ?? 0,
        availableStock: j['availableStock'] as int? ?? 0,
        totalSold: j['totalSold'] as int? ?? 0,
        lastOrderedAt: j['lastOrderedAt'] != null
            ? DateTime.tryParse(j['lastOrderedAt'] as String)
            : null,
        variants: (j['variants'] as List<dynamic>? ?? [])
            .map((v) => ProductVariantItem.fromJson(v as Map<String, dynamic>))
            .toList(),
      );
}

class ReviewBreakdown {
  final int one, two, three, four, five;

  const ReviewBreakdown({
    required this.one,
    required this.two,
    required this.three,
    required this.four,
    required this.five,
  });

  factory ReviewBreakdown.fromJson(Map<String, dynamic> j) =>
      ReviewBreakdown(
        one: j['1'] as int? ?? 0,
        two: j['2'] as int? ?? 0,
        three: j['3'] as int? ?? 0,
        four: j['4'] as int? ?? 0,
        five: j['5'] as int? ?? 0,
      );

  int get total => one + two + three + four + five;
}

class ProductReviewSummary {
  final double average;
  final int count;
  final ReviewBreakdown breakdown;

  const ProductReviewSummary({
    required this.average,
    required this.count,
    required this.breakdown,
  });

  factory ProductReviewSummary.fromJson(Map<String, dynamic> j) =>
      ProductReviewSummary(
        average: (j['average'] as num? ?? 0).toDouble(),
        count: j['count'] as int? ?? 0,
        breakdown: ReviewBreakdown.fromJson(
          j['breakdown'] as Map<String, dynamic>? ?? {},
        ),
      );
}

class ProductSpecification {
  final String key;
  final String value;

  const ProductSpecification({required this.key, required this.value});

  factory ProductSpecification.fromJson(Map<String, dynamic> j) =>
      ProductSpecification(
        key: j['key'] as String,
        value: j['value'] as String,
      );
}

class ReviewBuyer {
  final String name;
  final String? avatar;

  const ReviewBuyer({required this.name, this.avatar});

  factory ReviewBuyer.fromJson(Map<String, dynamic> j) =>
      ReviewBuyer(
        name: j['name'] as String? ?? 'Anonymous',
        avatar: j['avatar'] as String?,
      );
}

class ReviewItem {
  final String id;
  final int rating;
  final String? comment;
  final ReviewBuyer buyer;
  final DateTime createdAt;
  final int helpfulCount;
  final bool verified;

  const ReviewItem({
    required this.id,
    required this.rating,
    this.comment,
    required this.buyer,
    required this.createdAt,
    this.helpfulCount = 0,
    this.verified = false,
  });

  factory ReviewItem.fromJson(Map<String, dynamic> j) =>
      ReviewItem(
        id: j['id'] as String? ?? j['_id'] as String? ?? '',
        rating: j['rating'] as int? ?? 0,
        comment: j['comment'] as String? ?? j['text'] as String?,
        buyer: ReviewBuyer.fromJson(
          j['buyer'] as Map<String, dynamic>? ??
              j['user'] as Map<String, dynamic>? ??
              {'name': 'Anonymous'},
        ),
        createdAt:
        DateTime.tryParse(j['createdAt'] as String? ?? '') ?? DateTime.now(),
        helpfulCount: j['helpfulCount'] as int? ?? 0,
        verified: j['verified'] as bool? ?? false,
      );
}

class ReviewsResponse {
  final ProductReviewSummary summary;
  final List<ReviewItem> reviews;
  final int total;
  final int page;
  final int pages;
  final bool hasMore;

  const ReviewsResponse({
    required this.summary,
    required this.reviews,
    required this.total,
    required this.page,
    required this.pages,
    required this.hasMore,
  });

  factory ReviewsResponse.fromJson(Map<String, dynamic> j) {
    final pag = j['pagination'] as Map<String, dynamic>? ?? {};
    return ReviewsResponse(
      summary: ProductReviewSummary.fromJson(
        j['summary'] as Map<String, dynamic>? ?? {},
      ),
      reviews: (j['reviews'] as List<dynamic>? ?? [])
          .map((r) => ReviewItem.fromJson(r as Map<String, dynamic>))
          .toList(),
      total: pag['total'] as int? ?? 0,
      page: pag['page'] as int? ?? 1,
      pages: pag['pages'] as int? ?? 1,
      hasMore: pag['hasMore'] as bool? ?? false,
    );
  }
}

class ProductsListResponse {
  final List<SellerProduct> products;
  final int total;
  final int page;
  final int pages;
  final Map<String, int> counts;

  const ProductsListResponse({
    required this.products,
    required this.total,
    required this.page,
    required this.pages,
    required this.counts,
  });

  factory ProductsListResponse.fromJson(Map<String, dynamic> j) {
    final pag = j['pagination'] as Map<String, dynamic>? ?? {};
    final rawCounts = j['counts'] as Map<String, dynamic>? ?? {};
    return ProductsListResponse(
      products: (j['data'] as List<dynamic>? ?? [])
          .map((p) => SellerProduct.fromJson(p as Map<String, dynamic>))
          .toList(),
      total: (pag['total'] as int?) ?? (j['totalProducts'] as int?) ?? 0,
      page: (pag['page'] as int?) ?? (j['currentPage'] as int?) ?? 1,
      pages: (pag['pages'] as int?) ?? (j['totalPages'] as int?) ?? 1,
      counts: rawCounts.map((k, v) => MapEntry(k, (v as num).toInt())),
    );
  }
}

class SellerProduct {
  final String id;
  final String title;
  final String? slug;
  final String? sku;
  final String? description;
  final String? brand;
  final double price;
  final double listedPrice;
  final String currency;
  final String imageUrl;
  final List<String> images;
  final String? video;
  final int stock;
  final int sold;
  final int views;
  final String productType;
  final int variantCount;
  final List<ProductOptionType> optionTypes;
  final PriceRange? priceRange;
  final List<ProductVariantItem> variants;
  final String status;
  final String displayStatus;
  final String statusLabel;
  final ProductRating rating;
  final SellerProductCategory? category;
  final bool isFeatured;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String availableForLabel;
  final List<ProductSpecification> specifications;

  final ProductOverview? overview;
  final ProductInventory? inventory;
  final ProductReviewSummary? reviewSummary;

  SellerProduct({
    required this.id,
    required this.title,
    this.slug,
    this.sku,
    this.description,
    this.brand,
    required this.price,
    required this.listedPrice,
    this.currency = 'NGN',
    required this.imageUrl,
    required this.images,
    this.video,
    required this.stock,
    required this.sold,
    this.views = 0,
    required this.productType,
    this.variantCount = 0,
    this.optionTypes = const [],
    this.priceRange,
    this.variants = const [],
    required this.status,
    required this.displayStatus,
    required this.statusLabel,
    required this.rating,
    this.category,
    this.isFeatured = false,
    this.createdAt,
    this.updatedAt,
    this.availableForLabel = 'Delivery & Pick-up',
    this.specifications = const [],
    this.overview,
    this.inventory,
    this.reviewSummary,
  });

  SellerProductStatus get sellerProductStatus {
    switch (displayStatus) {
      case 'hidden':
        return SellerProductStatus.hidden;
      case 'out_of_stock':
        return SellerProductStatus.outOfStock;
      default:
        return SellerProductStatus.active;
    }
  }

  bool get isSingle => productType == 'single';

  bool get isVariable => productType == 'variable';


  factory SellerProduct.fromJson(Map<String, dynamic> j) =>
      SellerProduct(
        id: j['id'] as String? ?? j['_id'] as String? ?? '',
        title: j['title'] as String? ?? '',
        slug: j['slug'] as String?,
        sku: j['sku'] as String?,
        description: j['description'] as String?,
        brand: j['brand'] as String?,
        price: (j['price'] as num? ?? 0).toDouble(),
        listedPrice: (j['listedPrice'] as num? ?? j['price'] as num? ?? 0)
            .toDouble(),
        currency: j['currency'] as String? ?? 'NGN',
        imageUrl: j['image'] as String? ?? '',
        images: (j['images'] as List<dynamic>? ?? []).cast<String>(),
        video: j['video'] as String?,
        stock: j['stock'] as int? ?? 0,
        sold: j['sold'] as int? ?? 0,
        views: j['views'] as int? ?? 0,
        productType: j['productType'] as String? ?? 'single',
        variantCount: j['variantCount'] as int? ?? 0,
        optionTypes: (j['optionTypes'] as List<dynamic>? ?? [])
            .map((o) => ProductOptionType.fromJson(o as Map<String, dynamic>))
            .toList(),
        priceRange: j['priceRange'] != null
            ? PriceRange.fromJson(j['priceRange'] as Map<String, dynamic>)
            : null,
        variants: (j['variants'] as List<dynamic>? ?? [])
            .map((v) => ProductVariantItem.fromJson(v as Map<String, dynamic>))
            .toList(),
        status: j['status'] as String? ?? 'active',
        displayStatus: j['displayStatus'] as String? ?? 'active',
        statusLabel: j['statusLabel'] as String? ?? 'Active',
        rating: j['rating'] != null
            ? ProductRating.fromJson(j['rating'] as Map<String, dynamic>)
            : const ProductRating(average: 0, count: 0),
        category: j['category'] != null
            ? SellerProductCategory.fromJson(
            j['category'] as Map<String, dynamic>)
            : null,
        isFeatured: j['isFeatured'] as bool? ?? false,
        createdAt: j['createdAt'] != null
            ? DateTime.tryParse(j['createdAt'] as String)
            : null,
        updatedAt: j['updatedAt'] != null
            ? DateTime.tryParse(j['updatedAt'] as String)
            : null,
        availableForLabel:
        j['availableForLabel'] as String? ?? 'Delivery & Pick-up',
        specifications: (j['specifications'] as List<dynamic>? ?? [])
            .whereType<Map<String, dynamic>>()
            .map((s) => ProductSpecification.fromJson(s))
            .toList(),
        overview: j['overview'] != null
            ? ProductOverview.fromJson(j['overview'] as Map<String, dynamic>)
            : null,
        inventory: j['inventory'] != null
            ? ProductInventory.fromJson(j['inventory'] as Map<String, dynamic>)
            : null,
        reviewSummary: j['reviews'] != null
            ? ProductReviewSummary.fromJson(
            j['reviews'] as Map<String, dynamic>)
            : null,
      );

  SellerProduct copyWith({
    String? status,
    String? displayStatus,
    String? statusLabel,
    List<ProductVariantItem>? variants,
    double? price,
    int? stock,
    ProductInventory? inventory,
  }) =>
      SellerProduct(
        id: id,
        title: title,
        slug: slug,
        sku: sku,
        description: description,
        brand: brand,
        price: price ?? this.price,
        listedPrice: listedPrice,
        currency: currency,
        imageUrl: imageUrl,
        images: images,
        video: video,
        stock: stock ?? this.stock,
        sold: sold,
        views: views,
        productType: productType,
        variantCount: variantCount,
        optionTypes: optionTypes,
        priceRange: priceRange,
        variants: variants ?? this.variants,
        status: status ?? this.status,
        displayStatus: displayStatus ?? this.displayStatus,
        statusLabel: statusLabel ?? this.statusLabel,
        rating: rating,
        category: category,
        isFeatured: isFeatured,
        createdAt: createdAt,
        updatedAt: updatedAt,
        availableForLabel: availableForLabel,
        specifications: specifications,
        overview: overview,
        inventory: inventory ?? this.inventory,
        reviewSummary: reviewSummary,
      );
}
