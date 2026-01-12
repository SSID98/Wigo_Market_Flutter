import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/price_formatter.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../models/product_model.dart';

class ProductCard extends StatelessWidget {
  final VoidCallback onPressed;
  final VoidCallback onPress;
  final Product product;

  const ProductCard({
    super.key,
    required this.onPressed,
    required this.onPress,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 600;
    return isWeb
        ? Row(
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
            const SizedBox(width: 5),
            _itemDetails(isWeb),
            const SizedBox(width: 5),
            _itemPrice(isWeb),
            const SizedBox(width: 5),
            _itemDetails(isWeb, isStatus: true),
            const SizedBox(width: 5),
            _itemPrice(isWeb, isDelivery: true),
            const SizedBox(width: 5),
            _customButton(isWeb),
          ],
        )
        : Row(
          children: [
            Column(
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
                const SizedBox(height: 10),
                _itemPrice(isWeb),
                const SizedBox(height: 10),
                _itemPrice(isWeb, isDelivery: true),
              ],
            ),
            Column(
              children: [
                _itemDetails(isWeb),
                const SizedBox(height: 10),
                _itemDetails(isWeb, isStatus: true),
                const SizedBox(height: 10),
                _customButton(isWeb),
              ],
            ),
          ],
        );
  }

  Widget _itemDetails(bool isWeb, {bool isStatus = false}) {
    return Column(
      children: [
        Text(
          isStatus ? 'Status' : product.productName,
          style: GoogleFonts.hind(
            fontSize:
                isStatus
                    ? isWeb
                        ? 18
                        : 14
                    : isWeb
                    ? 20
                    : 16,
            fontWeight: isStatus ? FontWeight.w500 : FontWeight.w400,
            color: AppColors.textBlack,
          ),
        ),
        const SizedBox(height: 20),
        if (!isStatus)
          Row(
            children: [
              Text(
                '| ${product.productName}',
                style: GoogleFonts.hind(
                  fontSize: isWeb ? 20 : 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textBlack,
                ),
              ),
              Text(
                '| ${product.productName}',
                style: GoogleFonts.hind(
                  fontSize: isWeb ? 16 : 12,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textBodyText,
                ),
              ),
            ],
          ),
        if (isStatus)
          Container(
            height: isWeb ? 36 : 27,
            width: isWeb ? 134 : 94,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.backgroundLightPink,
              borderRadius: BorderRadius.circular(62),
            ),
            child: Text(
              'On Delivery',
              style: GoogleFonts.hind(
                fontSize: isWeb ? 16 : 12,
                fontWeight: FontWeight.w400,
                color: AppColors.textBlack,
              ),
            ),
          ),
      ],
    );
  }

  Widget _itemPrice(bool isWeb, {bool isDelivery = false}) {
    return Column(
      children: [
        Text(
          isDelivery ? 'Expected Delivery' : formatPrice(product.price),
          style: GoogleFonts.hind(
            fontSize: isWeb ? 20 : 16,
            fontWeight: isDelivery ? FontWeight.w500 : FontWeight.w600,
            color: AppColors.textBlack,
          ),
        ),
        const SizedBox(height: 20),
        Align(
          alignment:
              isDelivery
                  ? AlignmentDirectional.centerStart
                  : AlignmentDirectional.centerEnd,
          child: Text(
            isDelivery ? '12 April - 14 April 2025' : 'Qty: 1',
            style: GoogleFonts.hind(
              fontSize: isWeb ? 16 : 12,
              fontWeight: isDelivery ? FontWeight.w500 : FontWeight.w400,
              color: AppColors.textBodyText,
            ),
          ),
        ),
      ],
    );
  }

  Widget _customButton(bool isWeb) {
    return CustomButton(
      text: 'Track Order',
      fontSize: isWeb ? 16 : 12,
      fontWeight: FontWeight.w400,
      borderRadius: isWeb ? 16 : 8,
      height: isWeb ? 50 : 35,
      width: isWeb ? 144 : 123,
      onPressed: () {},
    );
  }
}

// onTap: () async {
// showLoadingDialog(context);
// await Future.delayed(const Duration(seconds: 1));
// if (!context.mounted) return;
// Navigator.of(context, rootNavigator: true).pop();
// context.push('/buyer/product-details', extra: {'product': product});
// },
