import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/url.dart';
import '../../../../core/utils/helper_methods.dart';
import '../../viewmodels/saved_products_viewmodel.dart';
import '../widgets/product_card.dart';

class SavedProductsView extends ConsumerWidget {
  final bool isPreview;

  const SavedProductsView({super.key, this.isPreview = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedProducts = ref.watch(savedProductsProvider);
    final notifier = ref.read(savedProductsProvider.notifier);
    final isWeb = MediaQuery.of(context).size.width > 600;
    final previewItems = savedProducts.take(isWeb? 10: 6).toList();
    if (previewItems.isEmpty) return const SizedBox.shrink();

    if (!notifier.isInitialized && savedProducts.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return savedProducts.isEmpty
        ? _buildEmptyState(isWeb)
        : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'You Saved these Products',
                  style: GoogleFonts.hind(
                    fontSize: isWeb ? 32 : 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textBlackGrey,
                  ),
                ),
                if (isPreview)
                  GestureDetector(
                    onTap: () async {
                      showLoadingDialog(context);
                      await Future.delayed(const Duration(seconds: 1));
                      if (!context.mounted) return;
                      Navigator.of(context, rootNavigator: true).pop();
                      context.push('/buyer/SavedItems');
                    },
                    child: Row(
                      children: [
                        Text(
                          'View More',
                          style: GoogleFonts.hind(
                            fontWeight: FontWeight.w400,
                            fontSize: isWeb ? 22 : 18,
                            color: AppColors.textBlackGrey,
                          ),
                        ),
                        const SizedBox(width: 1),
                        Icon(
                          Icons.keyboard_arrow_right_rounded,
                          size: 23,
                          color: AppColors.textBlackGrey,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            GridView.builder(
              primary: false,
              shrinkWrap: true,
              itemCount: isPreview ? previewItems.length : savedProducts.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isWeb ? 5 : 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.8,
              ),
              itemBuilder: (context, index) {
                return ProductCard(product: savedProducts[index]);
              },
            ),
          ],
        );
  }

  Widget _buildEmptyState(bool isWeb) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Image.network(
            '$networkImageUrl/searchFailed.png',
            height: isWeb ? 237 : 137,
            width: isWeb ? 321 : 185,
            errorBuilder: (
              BuildContext context,
              Object exception,
              StackTrace? stackTrace,
            ) {
              return const Center(
                child: Icon(
                  Icons.broken_image,
                  color: AppColors.textIconGrey,
                  size: 50.0,
                ),
              );
            },
          ),
        ),
        if (!isWeb) const SizedBox(height: 10),
        Center(
          child: Text(
            "No saved products yet!",
            style: GoogleFonts.hind(
              fontSize: isWeb ? 40 : 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textBlackGrey,
            ),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}
