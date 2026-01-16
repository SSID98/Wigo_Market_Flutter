import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/features/buyer/presentation/widgets/icon_text_row.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/helper_methods.dart';
import '../../../../core/utils/price_formatter.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../models/product_model.dart';
import '../../viewmodels/saved_products_viewmodel.dart';

class ProductCard extends ConsumerWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWeb = MediaQuery.of(context).size.width > 600;
    final isSaved = ref
        .watch(savedProductsProvider)
        .any((item) => item.productName == product.productName);
    return InkWell(
      onTap: () async {
        // showLoadingDialog(context);
        // await Future.delayed(const Duration(seconds: 1));
        // if (!context.mounted) return;
        // Navigator.of(context, rootNavigator: true).pop();
        // context.push('/buyer/product-details', extra: {'product': product});
      },
      child: Container(
        padding: EdgeInsets.zero,
        margin: const EdgeInsets.only(left: 2, bottom: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Image.network(
                product.imageUrl,
                height: double.infinity,
                width: double.infinity,
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
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 10.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                product.productName,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.hind(
                                  fontSize: isWeb ? 14 : 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textBlueishBlack,
                                ),
                                maxLines: 2,
                              ),
                            ),
                            const SizedBox(width: 5),
                            GestureDetector(
                              onTap: () async {
                                final wasAdded = await ref
                                    .read(savedProductsProvider.notifier)
                                    .toggleFavorite(product);
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(
                                  context,
                                ).hideCurrentSnackBar();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: AppColors.primaryDarkGreen,
                                    duration: const Duration(seconds: 2),
                                    content: Text(
                                      wasAdded
                                          ? "Product Successfully Saved"
                                          : "Product Was Removed Successfully",
                                      style: GoogleFonts.hind(
                                        color: AppColors.textWhite,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: Icon(
                                isSaved
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                size: 18,
                                weight: 1,
                                color:
                                    isSaved
                                        ? AppColors.accentLightGold
                                        : AppColors.primaryDarkGreen,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                formatPrice(product.price),
                                style: GoogleFonts.hind(
                                  fontSize: isWeb ? 18 : 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textBlack,
                                ),
                              ),
                            ),
                            Text(
                              '#${product.slashedAmount}',
                              style: GoogleFonts.hind(
                                decoration: TextDecoration.lineThrough,
                                fontSize: isWeb ? 14 : 12,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textBodyText,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomButton(
                              padding: EdgeInsets.zero,
                              fontSize: isWeb ? 10 : 8,
                              fontWeight: FontWeight.w700,
                              onPressed: () async {
                                showLoadingDialog(context);
                                await Future.delayed(
                                  const Duration(seconds: 1),
                                );
                                if (!context.mounted) return;
                                Navigator.of(
                                  context,
                                  rootNavigator: true,
                                ).pop();
                                context.push(
                                  '/buyer/product-details',
                                  extra: {'product': product},
                                );
                              },
                              text: 'Add to Cart',
                              width: 79,
                              height: 24,
                              borderRadius: 16,
                            ),
                            SizedBox(
                              width: 65,
                              child: IconTextRow(
                                text:
                                    "${product.rating} (${product.reviews.toString()})",
                                icon: AppAssets.icons.star.svg(height: 9),
                                fontSize: isWeb ? 10 : 8,
                                textBlack: true,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
