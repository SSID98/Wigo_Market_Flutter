import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/gen/assets.gen.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/utils/price_formatter.dart';
import '../../../../../shared/widgets/custom_button.dart';
import '../../../viewmodels/buyer_cart_viewmodel.dart';

class CartItemCard extends ConsumerWidget {
  final String imageUrl;
  final String productName;
  final String colorName;
  final String size;
  final double price;
  final int stock;

  const CartItemCard({
    super.key,
    required this.imageUrl,
    required this.productName,
    required this.colorName,
    required this.size,
    required this.price,
    required this.stock,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItem = ref
        .watch(cartProvider)
        .firstWhere(
          (item) => item.product.productName == productName,
          orElse: () => throw Exception("Cart item not found!"),
        );
    final bool isOrdered = cartItem.isOrdered;
    final isOutOfStock = stock == 0;
    final isWeb = MediaQuery.of(context).size.width > 600;
    final quantity = cartItem.quantity;
    final cartNotifier = ref.read(cartProvider.notifier);

    return Container(
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  imageUrl,
                  height: 120,
                  width: 120,
                  fit: BoxFit.cover,
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

              const SizedBox(width: 12),

              // Product Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productName,
                      style: GoogleFonts.hind(
                        fontSize: isWeb ? 20 : 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textBlack,
                      ),
                    ),
                    const SizedBox(height: 4),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Size: ',
                            style: GoogleFonts.inter(
                              color: AppColors.textBlack,
                              fontSize: isWeb ? 16 : 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          TextSpan(
                            text: size,
                            style: GoogleFonts.inter(
                              color: AppColors.textBodyText,
                              fontSize: isWeb ? 16 : 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Color: ',
                            style: GoogleFonts.inter(
                              color: AppColors.textBlack,
                              fontSize: isWeb ? 16 : 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          TextSpan(
                            text: colorName,
                            style: GoogleFonts.inter(
                              color: AppColors.textBodyText,
                              fontSize: isWeb ? 16 : 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    // STOCK INFO
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 10,
                      ),
                      margin: EdgeInsets.zero,
                      decoration: BoxDecoration(
                        color:
                            isOutOfStock
                                ? AppColors.accentRed.withValues(alpha: 0.1)
                                : AppColors.backgroundLightPink,
                        borderRadius: BorderRadius.circular(48),
                      ),
                      child: Text(
                        isOutOfStock ? "Out of Stock" : "$stock left in stock",
                        style: GoogleFonts.hind(
                          fontSize: isWeb ? 14 : 12,
                          color:
                              isOutOfStock
                                  ? AppColors.textRed
                                  : AppColors.textBlack,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    if (!isWeb)
                      Text(
                        formatPrice(price),
                        style: GoogleFonts.hind(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textBlack,
                        ),
                      ),
                    if (isWeb)
                      Row(
                        children: [
                          _removeButton(isWeb, () {
                            _showClearConfirmationDialog(
                              context,
                              isWeb,
                              cartNotifier,
                            );
                          }),
                          const SizedBox(width: 4),
                          _orderButton(isWeb, () {
                            ref
                                .read(cartProvider.notifier)
                                .toggleOrderItem(productName);
                          }, isOrdered),
                        ],
                      ),
                  ],
                ),
              ),

              if (isWeb)
                Column(
                  children: [
                    Text(
                      formatPrice(price),
                      style: GoogleFonts.hind(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textBlack,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        _qtyButton(Icons.remove, () {
                          if (quantity > 1) {
                            cartNotifier.updateQuantity(
                              productName,
                              quantity - 1,
                            );
                          }
                        }, isWeb),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            "$quantity",
                            style: GoogleFonts.hind(
                              color: AppColors.textNeutral950,
                              fontWeight: FontWeight.w400,
                              fontSize: isWeb ? 20 : 16,
                            ),
                          ),
                        ),
                        _qtyButton(
                          Icons.add,
                          () => cartNotifier.updateQuantity(
                            productName,
                            quantity + 1,
                          ),
                          isWeb,
                        ),
                      ],
                    ),
                  ],
                ),
            ],
          ),
          if (!isWeb)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _orderButton(isWeb, () {
                      ref
                          .read(cartProvider.notifier)
                          .toggleOrderItem(productName);
                    }, isOrdered),
                    const SizedBox(width: 4),
                    _removeButton(isWeb, () {
                      _showClearConfirmationDialog(
                        context,
                        isWeb,
                        cartNotifier,
                      );
                    }),
                  ],
                ),
                Row(
                  children: [
                    _qtyButton(Icons.remove, () {
                      if (quantity > 1) {
                        cartNotifier.updateQuantity(productName, quantity - 1);
                      }
                    }, isWeb),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        "$quantity",
                        style: GoogleFonts.hind(
                          color: AppColors.textBlack,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    _qtyButton(
                      Icons.add,
                      () => cartNotifier.updateQuantity(
                        productName,
                        quantity + 1,
                      ),
                      isWeb,
                    ),
                  ],
                ),
              ],
            ),
          Divider(),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback onTap, bool isWeb) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isWeb ? 38.69 : 24,
        height: isWeb ? 34 : 24,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Icon(icon, size: isWeb ? 22 : 15),
      ),
    );
  }

  Widget _removeButton(bool isWeb, void Function()? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          AppAssets.icons.delete.svg(height: isWeb ? 18 : 16),
          SizedBox(width: 4),
          Text(
            "Remove",
            style: GoogleFonts.hind(
              color: AppColors.textRed,
              fontSize: isWeb ? 16 : 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _orderButton(bool isWeb, void Function()? onTap, bool isOrdered) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 30,
        width: isWeb ? 150 : 120,
        decoration: BoxDecoration(
          color: AppColors.buttonLighterGreen,
          borderRadius: BorderRadius.circular(48),
          border: BoxBorder.all(color: AppColors.primaryDarkGreen),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isOrdered
                ? AppAssets.icons.cartCheckOut.svg(height: isWeb ? 18 : 16)
                : AppAssets.icons.cartCheckIn.svg(height: isWeb ? 18 : 16),
            SizedBox(width: 4),
            Text(
              isOrdered ? "Remove Order" : "Add Order",
              style: GoogleFonts.hind(
                color: AppColors.textVidaLocaGreen,
                fontSize: isWeb ? 14 : 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showClearConfirmationDialog(
    BuildContext context,
    bool isWeb,
    CartNotifier cartNotifier,
  ) async {
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
                    child: const Icon(Icons.close),
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
                  Text(
                    "Remove from cart",
                    style: GoogleFonts.hind(
                      fontWeight: FontWeight.w700,
                      fontSize: isWeb ? 24 : 16,
                      color: AppColors.textBlackGrey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Are you sure you want to take this item out of your cart?",
                    style: GoogleFonts.hind(
                      fontWeight: FontWeight.w400,
                      fontSize: isWeb ? 16 : 12,
                      color: AppColors.textBlackGrey,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: 'Save it for later',
                          onPressed: () {},
                          fontSize: isWeb ? 18 : 14,
                          height: 50,
                          fontWeight: FontWeight.w600,
                          buttonColor: Colors.transparent,
                          textColor: AppColors.textVidaLocaGreen,
                          borderColor: AppColors.primaryDarkGreen,
                          borderRadius: 16,
                          width: double.infinity,
                          borderWidth: 2,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: CustomButton(
                          text: 'Yes, remove it',
                          width: double.infinity,
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                            cartNotifier.removeItem(productName);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Item successfully removed from cart.",
                                ),
                              ),
                            );
                          },
                          borderRadius: 16,
                          fontSize: isWeb ? 18 : 14,
                          height: 50,
                          fontWeight: FontWeight.w600,
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
