import 'package:flutter/material.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';
import 'package:wigo_flutter/features/buyer/presentation/views/buyer_product_details_screens/product_images_section.dart';
import 'package:wigo_flutter/features/buyer/presentation/views/buyer_product_details_screens/product_info_section.dart';
import 'package:wigo_flutter/features/buyer/presentation/views/buyer_product_details_screens/product_review_section.dart';
import 'package:wigo_flutter/features/buyer/presentation/views/buyer_product_details_screens/product_specfics_section.dart';
import 'package:wigo_flutter/features/buyer/presentation/widgets/self_delivery_card.dart';

import '../footer_section.dart';
import 'comment_review_section.dart';

class ProductDetailsPage extends StatelessWidget {
  final String productName;
  final String imageUrl;
  final String price;
  final String categoryName;

  const ProductDetailsPage({
    super.key,
    required this.productName,
    required this.imageUrl,
    required this.price,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: isWeb ? _buildWebLayout(context) : _buildMobileLayout(context),
    );
  }

  Widget _buildWebLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 4, child: ProductImagesSection(imageUrl: imageUrl)),
          const SizedBox(width: 30),
          Expanded(
            flex: 3,
            child: ProductInfoSection(
              productName: productName,
              price: price,
              categoryName: categoryName,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ProductImagesSection(imageUrl: imageUrl),
          const SizedBox(height: 20),
          ProductInfoSection(
            productName: productName,
            price: price,
            categoryName: categoryName,
          ),
          const SizedBox(height: 80),
          DescriptionAndProductSpecificsSection(),
          const SizedBox(height: 80),
          CommentsAndReviewSection(),
          const SizedBox(height: 20),
          ProductReviewSection(),
          const SizedBox(height: 80),
          SelfDeliveryPromoCard(onPressed: () {}),
          const SizedBox(height: 20),
          FooterSection(),
        ],
      ),
    );
  }
}
