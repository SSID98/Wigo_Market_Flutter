import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';
import 'package:wigo_flutter/features/buyer/presentation/widgets/icon_text_row.dart';

import '../../../../gen/assets.gen.dart';

class PopularVendorsCard extends StatelessWidget {
  final String vendorName;
  final String vendorCategory;
  final double rating;
  final int reviews;
  final String deliveryFee;
  final String deliveryTime;
  final VoidCallback onCardPress;
  final String imageUrl;
  final VoidCallback onPress;

  const PopularVendorsCard({
    super.key,
    required this.vendorName,
    required this.vendorCategory,
    required this.imageUrl,
    required this.onPress,
    required this.onCardPress,
    required this.deliveryFee,
    required this.reviews,
    required this.rating,
    required this.deliveryTime,
  });

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 600;
    return InkWell(
      onTap: onCardPress,
      child: Container(
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: AppColors.borderColor),
        ),
        margin: const EdgeInsets.only(left: 2, bottom: 15),
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: 200,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(92),
                      bottomLeft: Radius.circular(8),
                      topLeft: Radius.circular(8),
                    ),
                    child: Image.network(
                      imageUrl,
                      height: double.infinity,
                      width: double.infinity,
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
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vendorName,
                          style: GoogleFonts.hind(
                            fontSize: isWeb ? 23 : 18,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textBlack,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: AppColors.clampBgColor,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 1.5),
                            child: Text(
                              vendorCategory,
                              style: GoogleFonts.hind(
                                fontSize: isWeb ? 15.57 : 11.57,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textBlack,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 3),
                        IconTextRow(
                          isAmount: true,
                          text: '₦$deliveryFee',
                          icon: AppAssets.icons.smallPackage.svg(height: 12.63),
                          fontSize: isWeb ? 16 : 12,
                        ),
                        IconTextRow(
                          text: deliveryTime,
                          icon: AppAssets.icons.time.svg(height: 11.67),
                          fontSize: isWeb ? 16 : 12,
                        ),
                        const SizedBox(height: 7),
                        SizedBox(
                          width: 76,
                          child: IconTextRow(
                            text: "$rating (${reviews.toString()})",
                            icon: AppAssets.icons.star.svg(
                              height: isWeb ? 14 : 12,
                            ),
                            fontSize: isWeb ? 15 : 12,
                            isRating: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3.89),
                  color: AppColors.backgroundWhite,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 4,
                      spreadRadius: 2,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: IconButton(
                    icon: const Icon(
                      Icons.favorite_border,
                      size: 13,
                      weight: 2,
                      color: AppColors.radioOrange,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: onPress,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
