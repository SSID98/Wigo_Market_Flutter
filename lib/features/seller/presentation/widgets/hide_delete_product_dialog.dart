import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/features/seller/models/seller_product_model.dart';
import 'package:wigo_flutter/shared/widgets/custom_banner.dart';
import 'package:wigo_flutter/shared/widgets/custom_loading_overlay.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../models/seller_product_task_state.dart';
import '../../viewmodels/seller_product_task_viewmodel.dart';

enum ProductDialogAction {
  hideSingle,
  unhideSingle,
  hideMultiple,
  unhideMultiple,
  deleteSingle,
  deleteMultiple,
}

class DialogUtils {
  static Future<void> showHideDeleteProductDialog(
    BuildContext context,
    bool isWeb,
    SellerProductTaskViewmodel vm,
    SellerProductTaskState state, {
    SellerProduct? sellerProduct,
    ProductDialogAction action = ProductDialogAction.hideSingle,
  }) {
    final isHideOrUnhide =
        action == ProductDialogAction.hideSingle ||
        action == ProductDialogAction.unhideSingle ||
        action == ProductDialogAction.hideMultiple ||
        action == ProductDialogAction.unhideMultiple;

    final isBulk =
        action == ProductDialogAction.hideMultiple ||
        action == ProductDialogAction.deleteMultiple;

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
            contentPadding: const EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 15,
            ),
            insetPadding: EdgeInsets.zero,
            iconPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: AppColors.backgroundWhite,
            titlePadding: EdgeInsets.zero,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: isWeb ? 8 : 16, top: 10),
                  child: GestureDetector(
                    onTap: () => Navigator.of(dialogContext).pop(),
                    child: const Icon(Icons.close, size: 30),
                  ),
                ),
              ],
            ),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.85,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  (isHideOrUnhide)
                      ? AppAssets.icons.hideThisProduct.svg()
                      : AppAssets.icons.deleteProduct.svg(),
                  const SizedBox(height: 20),
                  Text(
                    _titleText(action, state.selectedProductIds.length),
                    style: GoogleFonts.hind(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: (isHideOrUnhide)
                          ? AppColors.textBlackGrey
                          : AppColors.textRed,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _bodyText(action),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.hind(
                      fontWeight: FontWeight.w400,
                      fontSize: isWeb ? 16 : 14,
                      color: isWeb
                          ? AppColors.textBodyText
                          : AppColors.textBlueishBlack,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Divider(),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: 'Cancel',
                          onPressed: () => Navigator.of(dialogContext).pop(),
                          fontSize: 16,
                          height: 48,
                          fontWeight: FontWeight.w500,
                          buttonColor: AppColors.backgroundLight,
                          textColor: AppColors.textBlackGrey,
                          borderRadius: 6,
                          width: double.infinity,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: CustomButton(
                          text: _buttonText(
                            action,
                            state.selectedProductIds.length,
                          ),
                          width: double.infinity,
                          onPressed: isBulk && state.selectedProductIds.isEmpty
                              ? null
                              : () async {
                                  Navigator.of(dialogContext).pop();
                                  bool success = false;

                                  switch (action) {
                                    case ProductDialogAction.hideSingle:
                                      if (sellerProduct != null) {
                                        success = await runWithOverlay(
                                          context,
                                          () async {
                                            return await vm.hideSingleProduct(
                                              sellerProduct.id,
                                              context,
                                            );
                                          },
                                        );
                                        if (success && context.mounted) {
                                          showSuccessBanner(
                                            "Product hidden successfully",
                                            context,
                                          );
                                        }
                                      }
                                      break;

                                    case ProductDialogAction.hideMultiple:
                                      success = await runWithOverlay(
                                        context,
                                        () async {
                                          return await vm.bulkHide(context);
                                        },
                                      );
                                      if (success && context.mounted) {
                                        showSuccessBanner(
                                          "Products hidden successfully",
                                          context,
                                        );
                                      }
                                      break;

                                    case ProductDialogAction.deleteSingle:
                                      if (sellerProduct != null) {
                                        success = await runWithOverlay(
                                          context,
                                          () async {
                                            return await vm.deleteSingleProduct(
                                              sellerProduct.id,
                                              context,
                                            );
                                          },
                                        );
                                        if (success && context.mounted) {
                                          showSuccessBanner(
                                            'Product deleted successfully',
                                            context,
                                          );
                                        }
                                      }
                                      break;

                                    case ProductDialogAction.deleteMultiple:
                                      success = await runWithOverlay(
                                        context,
                                        () async {
                                          return await vm.bulkDelete(context);
                                        },
                                      );
                                      if (success && context.mounted) {
                                        showSuccessBanner(
                                          'Products deleted successfully',
                                          context,
                                        );
                                      }
                                      break;

                                    case ProductDialogAction.unhideSingle:
                                      if (sellerProduct != null) {
                                        success = await runWithOverlay(
                                          context,
                                          () async {
                                            return await vm.hideSingleProduct(
                                              sellerProduct.id,
                                              context,
                                            );
                                          },
                                        );
                                        if (success && context.mounted) {
                                          showSuccessBanner(
                                            "Product unhidden successfully",
                                            context,
                                          );
                                        }
                                      }
                                      break;

                                    case ProductDialogAction.unhideMultiple:
                                      success = await runWithOverlay(
                                        context,
                                        () async {
                                          return await vm.bulkUnhide(context);
                                        },
                                      );
                                      if (success && context.mounted) {
                                        showSuccessBanner(
                                          "Products unhidden successfully",
                                          context,
                                        );
                                      }
                                      break;
                                  }
                                },
                          borderRadius: 6,
                          fontSize: 16,
                          height: 48,
                          fontWeight: FontWeight.w500,
                          buttonColor: (isHideOrUnhide)
                              ? AppColors.primaryDarkGreen
                              : AppColors.accentRed,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static String _titleText(ProductDialogAction action, int selectedCount) {
    switch (action) {
      case ProductDialogAction.hideSingle:
        return 'Hide this product from buyers?';
      case ProductDialogAction.hideMultiple:
        return 'Hide $selectedCount product${selectedCount > 1 ? 's' : ''} from buyers?';
      case ProductDialogAction.deleteSingle:
        return 'Delete Product?';
      case ProductDialogAction.deleteMultiple:
        return 'Delete $selectedCount Product${selectedCount > 1 ? 's' : ''}?';
      case ProductDialogAction.unhideSingle:
        return 'Unhide this product?';
      case ProductDialogAction.unhideMultiple:
        return 'Unhide $selectedCount product${selectedCount > 1 ? 's' : ''}?';
    }
  }

  static String _bodyText(ProductDialogAction action) {
    switch (action) {
      case ProductDialogAction.hideSingle:
      case ProductDialogAction.hideMultiple:
        return 'Buyers will no longer see this product on your storefront. Hidden products stay in your inventory and can be restored any time.';
      case ProductDialogAction.deleteSingle:
      case ProductDialogAction.deleteMultiple:
        return 'This permanently deletes the product, all its reviews, and removes it from any active carts. This action cannot be undone.';
      case ProductDialogAction.unhideSingle:
      case ProductDialogAction.unhideMultiple:
        return 'This product will become visible to buyers on your storefront again.';
    }
  }

  static String _buttonText(ProductDialogAction action, int selectedCount) {
    switch (action) {
      case ProductDialogAction.hideSingle:
        return 'Hide Product';
      case ProductDialogAction.hideMultiple:
        return 'Hide ($selectedCount) Products';
      case ProductDialogAction.deleteSingle:
        return 'Delete Product';
      case ProductDialogAction.deleteMultiple:
        return 'Delete ($selectedCount) Products';
      case ProductDialogAction.unhideSingle:
        return 'Unhide Product';
      case ProductDialogAction.unhideMultiple:
        return 'Unhide ($selectedCount) Products';
    }
  }
}
