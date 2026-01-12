// cart_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/url.dart';
import '../../../../../core/utils/helper_methods.dart';
import '../../../models/cart_model.dart';
import '../../../viewmodels/buyer_cart_viewmodel.dart';
import 'cart_item_card.dart';
import 'order_summary_card.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
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
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child:
            isWeb
                ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: _buildCartItemList(cartItems, isWeb),
                    ),
                    const SizedBox(width: 30),
                    if (cartItems.isNotEmpty)
                      Expanded(flex: 2, child: OrderSummaryCard()),
                  ],
                )
                : Column(
                  children: [
                    _buildCartItemList(cartItems, isWeb),
                    const SizedBox(height: 30),
                    if (cartItems.isNotEmpty) OrderSummaryCard(),
                  ],
                ),
      ),
    );
  }

  Widget _buildCartItemList(List<CartState> items, bool isWeb) {
    if (items.isEmpty) {
      return Column(
        children: [
          Center(
            child: Image.network(
              '$networkImageUrl/box.png',
              height: isWeb ? 200.18 : 121.02,
              width: isWeb ? 306 : 185,
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
          const SizedBox(height: 10),
          Center(
            child: Text(
              'Your Cart is Empty!',
              style: GoogleFonts.hind(
                fontSize: isWeb ? 40 : 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textBlackGrey,
              ),
            ),
          ),
          SizedBox(height: isWeb ? 10 : 15),
          Center(
            child: Text(
              'Items you add to cart would appear here.',
              style: GoogleFonts.hind(
                fontSize: isWeb ? 24 : 16,
                fontWeight: FontWeight.w400,
                color: AppColors.textBlackGrey,
              ),
            ),
          ),
          SizedBox(height: 200),
        ],
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return CartItemCard(
          productName: item.product.productName,
          price: item.product.price,
          imageUrl: item.product.imageUrl,
          stock: item.product.stock,
          colorName: item.colorName,
          size: item.size,
        );
      },
    );
  }
}
