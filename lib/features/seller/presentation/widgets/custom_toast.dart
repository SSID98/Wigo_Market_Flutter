import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../gen/assets.gen.dart';

void showCustomToast(
  BuildContext context,
  bool isHideProduct,
  bool isBulkHideProducts,
) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder:
        (context) => Positioned(
          bottom: 0,
          left: 5,
          right: 5,
          child: Material(
            color: Colors.transparent,
            child: _buildCustomToast(isHideProduct, isBulkHideProducts),
          ),
        ),
  );

  overlay.insert(overlayEntry);

  Future.delayed(const Duration(seconds: 3), () {
    overlayEntry.remove();
  });
}

Widget _buildCustomToast(bool isHideProduct, bool isBulkHideProducts) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: AppColors.backGroundOverlay,
      border: Border.all(color: Color(0xff83C9A5)),
      borderRadius: BorderRadius.circular(5.99),
    ),
    child: Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xffCAE8D9),
              borderRadius: BorderRadius.horizontal(right: Radius.circular(30)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 6,
              ),
              child: AppAssets.icons.doubleTickToast.svg(),
            ),
          ),

          const SizedBox(width: 16),
          Text(
            isHideProduct
                ? "Product is now hidden from your storefront."
                : isBulkHideProducts
                ? "Products are now hidden from your storefront."
                : "Product deleted successfully.",
            style: GoogleFonts.hind(
              color: AppColors.textBlackGrey,
              fontSize: isBulkHideProducts ? 14 : 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ),
  );
}
