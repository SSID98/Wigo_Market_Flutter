import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/features/seller/models/seller_product_model.dart';
import 'package:wigo_flutter/features/seller/models/seller_product_task_state.dart';
import 'package:wigo_flutter/features/seller/presentation/widgets/hide_delete_product_dialog.dart';
import 'package:wigo_flutter/features/seller/presentation/widgets/product_status_container.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/price_formatter.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../shared/widgets/custom_checkbox_2.dart';
import '../../../buyer/presentation/widgets/icon_text_row.dart';
import '../../viewmodels/dropdown_providers.dart';
import '../../viewmodels/seller_product_task_viewmodel.dart';

class SellerProductCard extends ConsumerWidget {
  final SellerProduct product;

  const SellerProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWeb = MediaQuery.of(context).size.width > 600;
    final state = ref.watch(sellerProductTaskProvider);
    final vm = ref.read(sellerProductTaskProvider.notifier);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppColors.borderColor, width: 1),
      ),
      elevation: 0,
      margin: EdgeInsets.only(bottom: 15),
      color: AppColors.backgroundWhite,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _buildMobileCard(isWeb, ref, context, state, vm),
      ),
    );
  }

  Widget _buildMobileCard(
    bool isWeb,
    WidgetRef ref,
    BuildContext context,
    SellerProductTaskState state,
    SellerProductTaskViewmodel vm,
  ) {
    return Stack(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3),
                side: BorderSide(color: AppColors.borderColor),
              ),
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  height: 70,
                  width: 60,
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
            ),
            const SizedBox(width: 5),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.productName,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.hind(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textBlackGrey,
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _buildRichText(
                        label: 'SKU',
                        info: product.productId,
                        isIconGrey: true,
                      ),
                      const SizedBox(width: 12),
                      _buildRichText(
                        label: 'Variant',
                        info: product.variant,
                        hasIcon: true,
                        isBolder: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _buildRichText(
                        label: 'Price',
                        info: formatPrice(product.price),
                        isPrice: true,
                        isBolder: true,
                        isIconGrey: false,
                        isBodyText1: false,
                      ),
                      const SizedBox(width: 12),
                      _buildRichText(
                        label: 'Sold',
                        info: product.sold,
                        hasIcon: true,
                        isBolder: true,
                      ),
                      const SizedBox(width: 12),
                      _buildRichText(
                        label: 'Stock',
                        info: product.stock,
                        hasIcon: true,
                        isBolder: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Status: ',
                            style: GoogleFonts.hind(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: AppColors.textBodyText,
                            ),
                          ),
                          const SizedBox(width: 4),
                          SizedBox(
                            width: 75,
                            child: ProductStatusContainer(
                              productStatus: product.sellerProductStatus,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 14),
                      SizedBox(
                        height: 24,
                        child: IconTextRow(
                          text: "${product.rating}/5.0 (${product.reviews})",
                          icon: AppAssets.icons.star.svg(
                            height: isWeb ? 14 : 12,
                            colorFilter: ColorFilter.mode(
                              Color(0xffFF9500),
                              BlendMode.srcIn,
                            ),
                          ),
                          fontSize: isWeb ? 12 : 10,
                          isRating: false,
                          isSeller: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),

        Positioned(
          top: 4,
          right: 5,
          child: Container(
            decoration: BoxDecoration(color: AppColors.sliderDotColor),
            width: 14,
            height: 20,
            child: Align(
              alignment: Alignment.center,
              child: MenuAnchor(
                crossAxisUnconstrained: true,
                alignmentOffset: const Offset(-150, -20),
                builder: (context, controller, child) {
                  return IconButton(
                    icon: AppAssets.icons.moreIcon.svg(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      ref.read(expandedIdProvider.notifier).state = null;
                      controller.isOpen
                          ? controller.close()
                          : controller.open();
                    },
                  );
                },
                style: MenuStyle(
                  backgroundColor: WidgetStateProperty.all(
                    AppColors.backgroundWhite,
                  ),
                  elevation: WidgetStateProperty.all(6),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  ),
                ),
                menuChildren: [
                  MenuItemButton(
                    leadingIcon: AppAssets.icons.viewOrder.svg(),
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (_) => OrderDetailScreen(order: d),
                      //   ),
                      // );
                    },
                    child: Text(
                      "View Detail",
                      style: GoogleFonts.hind(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textBlackGrey,
                      ),
                    ),
                  ),

                  MenuItemButton(
                    leadingIcon: AppAssets.icons.updateStats.svg(),
                    onPressed: () {},
                    child: Text(
                      "Edit Product",
                      style: GoogleFonts.hind(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textBlackGrey,
                      ),
                    ),
                  ),

                  MenuItemButton(
                    leadingIcon: AppAssets.icons.hideProduct.svg(),
                    onPressed: () {
                      DialogUtils.showHideDeleteProductDialog(
                        context,
                        isWeb,
                        vm,
                        state,
                        isHideProduct: true,
                        sellerProduct: product,
                      );
                    },
                    child: Text(
                      "Hide Product",
                      style: GoogleFonts.hind(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textBlackGrey,
                      ),
                    ),
                  ),
                  MenuItemButton(
                    leadingIcon: AppAssets.icons.delete.svg(),
                    onPressed: () {},
                    child: Text(
                      "Delete Product",
                      style: GoogleFonts.hind(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.radioOrange,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        Positioned(
          top: 10,
          left: 10,
          child: CustomCheckbox2(
            value: state.selectedProductIds.contains(product.productId),
            onChanged: (val) => vm.toggleProductSelection(product.productId),
            borderRadius: 2,
            size: 16,
            checkSize: 13,
            borderColor:
                state.selectedProductIds.contains(product.productId)
                    ? AppColors.primaryDarkGreen
                    : AppColors.borderColor1,
            checkColor: AppColors.primaryDarkGreen,
            setBgColor: true,
            fillColor: AppColors.backgroundWhite,
          ),
        ),
      ],
    );
  }

  Widget _buildRichText({
    required String label,
    required String info,
    bool hasIcon = false,
    bool isBodyText = true,
    bool isBodyText1 = true,
    bool isIconGrey = false,
    bool isPrice = false,
    bool isBolder = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (hasIcon) ...[
          AppAssets.icons.squareBullet.svg(),
          const SizedBox(width: 5),
        ],
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '$label: ',
                style: GoogleFonts.hind(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color:
                      isBodyText
                          ? AppColors.textBodyText
                          : AppColors.textBlackGrey,
                ),
              ),
              TextSpan(
                text: info,
                style: GoogleFonts.hind(
                  color:
                      isBodyText1
                          ? AppColors.textBodyText
                          : isIconGrey
                          ? AppColors.textIconGrey
                          : AppColors.textVidaGreen800,
                  fontSize: isPrice ? 14 : 12,
                  fontWeight: isBolder ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
