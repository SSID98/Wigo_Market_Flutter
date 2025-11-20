import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../models/product_model.dart';

class SavedProductSection extends StatelessWidget {
  final List<Product> products;

  const SavedProductSection({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 800;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'You Saved this Products',
              style: GoogleFonts.hind(
                fontSize: isWeb ? 20 : 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textBlackGrey,
              ),
            ),
            Row(
              children: [
                Text(
                  'View More',
                  style: GoogleFonts.hind(
                    fontWeight: FontWeight.w400,
                    fontSize: isWeb ? 18 : 14,
                    color: AppColors.textBlackGrey,
                  ),
                ),
                const SizedBox(width: 1),
                Icon(
                  Icons.keyboard_arrow_right_rounded,
                  size: 20,
                  color: AppColors.textBlackGrey,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        // GridView.builder(
        //   primary: false,
        //   shrinkWrap: true,
        //   itemCount: filtered.length,
        //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //     crossAxisCount: isWeb ? 5 : 2,
        //     crossAxisSpacing: 12,
        //     mainAxisSpacing: 12,
        //     childAspectRatio: 0.8,
        //   ),
        //   itemBuilder: (context, index) {
        //     final product = filtered[index];
        //     return ProductCard(
        //       productName: product.productName,
        //       slashedAmount: product.slashedAmount,
        //       amount: product.amount,
        //       onPressed: () {},
        //       imageUrl: product.imageUrl,
        //       onPress: () {},
        //       onCardPress: () {},
        //       rating: product.rating,
        //       reviews: product.reviews,
        //       categoryName: product.categoryName,
        //     );
        //   },
        // ),
      ],
    );
  }
}
