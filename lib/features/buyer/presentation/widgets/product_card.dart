import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/features/buyer/presentation/widgets/icon_text_row.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../shared/widgets/custom_button.dart';

class ProductCard extends StatelessWidget {
  final String productName;
  final String amount;
  final String categoryName;
  final String slashedAmount;
  final VoidCallback onPressed;
  final VoidCallback onCardPress;
  final String imageUrl;
  final VoidCallback onPress;
  final double rating;
  final int reviews;

  const ProductCard({
    super.key,
    required this.productName,
    required this.slashedAmount,
    required this.amount,
    required this.onPressed,
    required this.imageUrl,
    required this.onPress,
    required this.onCardPress,
    required this.rating,
    required this.reviews,
    required this.categoryName,
  });

  // String formatNumber(String numberString) {
  //   final number = double.parse(numberString);
  //   final formatter = NumberFormat('##,##0', 'en_NG');
  //   return formatter.format(number);
  // }

  @override
  Widget build(BuildContext context) {
    // String formattedAmount = formatNumber(amount);
    // String formattedSlashedAmount = formatNumber(slashedAmount);
    final isWeb = MediaQuery.of(context).size.width > 600;
    return InkWell(
      onTap: () {
        context.push(
          '/buyer/product-details',
          extra: {
            'productName': productName,
            'imageUrl': imageUrl,
            'price': amount,
            'categoryName': categoryName,
          },
        );
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder:
        //         (_) => ProductDetailsPage(
        //           productName: productName,
        //           imageUrl: imageUrl,
        //           price: amount,
        //           categoryName: categoryName,
        //         ),
        //   ),
        // );
      },
      child: Container(
        padding: EdgeInsets.zero,
        // color: AppColors.backgroundWhite,
        margin: const EdgeInsets.only(left: 2, bottom: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Image.network(
                imageUrl,
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
                                productName,
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
                              onTap: onPress,
                              child: Icon(
                                Icons.favorite_border,
                                size: 18,
                                weight: 1,
                                color: AppColors.primaryDarkGreen,
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
                                '#$amount',
                                style: GoogleFonts.hind(
                                  fontSize: isWeb ? 18 : 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textBlack,
                                ),
                              ),
                            ),
                            Text(
                              '#$slashedAmount',
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
                              onPressed: onPressed,
                              text: 'Add to Cart',
                              width: 79,
                              height: 24,
                              borderRadius: 16,
                            ),
                            SizedBox(
                              width: 65,
                              child: IconTextRow(
                                text: "$rating (${reviews.toString()})",
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

// Positioned(
//   top: 10,
//   right: 10,
//   child: Container(
//     width: 20,
//     height: 20,
//     decoration: BoxDecoration(
//       color: Colors.white,
//       shape: BoxShape.circle,
//       boxShadow: [
//         BoxShadow(
//           color: Colors.black.withValues(alpha: 0.2),
//           blurRadius: 4,
//           spreadRadius: 2,
//           offset: const Offset(0, 2),
//         ),
//       ],
//     ),
//     child: Align(
//       alignment: Alignment.center,
//       child: IconButton(
//         icon: const Icon(
//           Icons.favorite_border,
//           size: 13,
//           weight: 2,
//           color: Colors.indigoAccent,
//         ),
//         padding: EdgeInsets.zero,
//         constraints: const BoxConstraints(),
//         onPressed: onPress,
//       ),
//     ),
//   ),
// ),
