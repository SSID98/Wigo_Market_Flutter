import 'package:flutter/material.dart';
import 'package:wigo_flutter/features/buyer/presentation/views/buyer_product_details_screens/product_images_section.dart';
import 'package:wigo_flutter/features/buyer/presentation/views/buyer_product_details_screens/product_info_section.dart';
import 'package:wigo_flutter/features/buyer/presentation/views/buyer_product_details_screens/product_review_section.dart';
import 'package:wigo_flutter/features/buyer/presentation/views/buyer_product_details_screens/product_specfics_section.dart';
import 'package:wigo_flutter/features/buyer/presentation/views/saved_product_view.dart';

import '../../../../../core/utils/helper_methods.dart';
import '../../../models/product_model.dart';
import '../../widgets/self_delivery_card.dart';
import 'comment_review_section.dart';

class ProductDetailsPage extends StatelessWidget {
  final Product product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 600;
    bool isHandlingBack = false;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (isHandlingBack || didPop) return;
        isHandlingBack = true;
        showLoadingDialog(context);
        await Future.delayed(const Duration(seconds: 1));
        if (!context.mounted) return;
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.of(context).pop(result);
      },
      child: isWeb ? _buildWebLayout(context) : _buildMobileLayout(context),
    );
  }

  Widget _buildWebLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: ProductImagesSection(imageUrl: product.imageUrl),
          ),
          const SizedBox(width: 30),
          Expanded(flex: 3, child: ProductInfoSection(product: product)),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ProductImagesSection(imageUrl: product.imageUrl),
          const SizedBox(height: 20),
          ProductInfoSection(product: product),
          const SizedBox(height: 80),
          DescriptionAndProductSpecificsSection(),
          const SizedBox(height: 80),
          CommentsAndReviewSection(),
          const SizedBox(height: 20),
          ProductReviewSection(),
          const SizedBox(height: 50),
          SavedProductsView(isPreview: true),
          const SizedBox(height: 80),
          SelfDeliveryPromoCard(),
        ],
      ),
    );
  }
}
