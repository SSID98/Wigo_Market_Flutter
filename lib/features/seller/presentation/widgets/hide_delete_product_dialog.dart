// dialog_utils.dart
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/features/seller/models/seller_product_model.dart';
import 'package:wigo_flutter/features/seller/presentation/widgets/custom_toast.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../models/seller_product_task_state.dart';
import '../../viewmodels/seller_product_task_viewmodel.dart';

class DialogUtils {
  static Future<void> showHideDeleteProductDialog(
    BuildContext context,
    bool isWeb,
    SellerProductTaskViewmodel vm,
    SellerProductTaskState state, {
    SellerProduct? sellerProduct,
    bool isHideProduct = false,
    bool isBulkHideProducts = false,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
            contentPadding: EdgeInsets.only(left: 16, right: 16, bottom: 15),
            insetPadding: EdgeInsets.zero,
            iconPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: AppColors.backgroundWhite,
            titlePadding: EdgeInsets.zero,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 15),
                Padding(
                  padding: EdgeInsets.only(right: isWeb ? 0 : 25, top: 10),
                  child: GestureDetector(
                    child: const Icon(Icons.close, size: 30),
                    onTap: () {
                      Navigator.of(dialogContext).pop();
                    },
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
                  isHideProduct || isBulkHideProducts
                      ? AppAssets.icons.hideThisProduct.svg()
                      : AppAssets.icons.deleteProduct.svg(),
                  const SizedBox(height: 20),
                  Text(
                    isHideProduct
                        ? "Hide this product from buyers?"
                        : isBulkHideProducts
                        ? "Hide these products from buyers?"
                        : "Delete Product?",
                    style: GoogleFonts.hind(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color:
                          isHideProduct || isBulkHideProducts
                              ? AppColors.textBlackGrey
                              : AppColors.textRed,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    textAlign: TextAlign.center,
                    isHideProduct || isBulkHideProducts
                        ? "Buyers will no longer see this product in your storefront? Hidden products stay in your inventory but cannot be purchased until you unhide them."
                        : "Are you sure you want to delete this product? This action cannot be undone. The product will be removed from your inventory and will no longer appear on your dashboard.",
                    style: GoogleFonts.hind(
                      fontWeight: FontWeight.w400,
                      fontSize: isWeb ? 16 : 14,
                      color:
                          isWeb
                              ? AppColors.textBodyText
                              : AppColors.textBlueishBlack,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Divider(),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: 'Cancel',
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                          },
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
                          text:
                              isHideProduct
                                  ? 'Hide Product'
                                  : isBulkHideProducts
                                  ? "Hide (${state.selectedProductIds.length}) Products"
                                  : 'Delete Product',
                          width: double.infinity,
                          onPressed:
                              isHideProduct
                                  ? () {
                                    Navigator.of(dialogContext).pop();
                                    sellerProduct != null
                                        ? vm.hideSingleProduct(
                                          sellerProduct.productId,
                                        )
                                        : null;
                                    // cartNotifier.removeItem(productName);
                                    showCustomToast(
                                      context,
                                      isHideProduct,
                                      isBulkHideProducts,
                                    );
                                  }
                                  : isBulkHideProducts
                                  ? state.selectedProductIds.isEmpty
                                      ? null // Disable button if nothing is selected
                                      : () {
                                        Navigator.of(dialogContext).pop();
                                        vm.hideSelectedProducts();
                                        showCustomToast(
                                          context,
                                          isHideProduct,
                                          isBulkHideProducts,
                                        );
                                      }
                                  : null,
                          borderRadius: 6,
                          fontSize: 16,
                          height: 48,
                          fontWeight: FontWeight.w500,
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
}
