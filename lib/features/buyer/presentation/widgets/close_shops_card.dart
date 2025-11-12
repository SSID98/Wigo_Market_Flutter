import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';

import '../../../../gen/assets.gen.dart';
import 'icon_text_row.dart';

class CloseShopsCard extends StatelessWidget {
  final String imageUrl;
  final String shopName;
  final String category;
  final double rating;
  final int reviews;
  final String deliveryFee;
  final String deliveryTime;

  const CloseShopsCard({
    super.key,
    required this.imageUrl,
    required this.shopName,
    required this.category,
    required this.rating,
    required this.reviews,
    required this.deliveryFee,
    required this.deliveryTime,
  });

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 600;
    return Container(
      padding: EdgeInsets.zero,
      margin: const EdgeInsets.only(left: 2, bottom: 15),
      decoration: BoxDecoration(color: AppColors.backgroundWhite),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              imageUrl,
              height: 140,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                shopName,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.hind(
                  color: AppColors.textBlack,
                  fontWeight: FontWeight.w500,
                  fontSize: isWeb ? 24 : 16,
                ),
                maxLines: 1,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xffFFE566), Color(0xffFFC34D)],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8.3),
                    topRight: Radius.circular(8.3),
                  ),
                ),
                child: Text(
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  category,
                  style: GoogleFonts.hind(
                    fontSize: isWeb ? 12 : 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textBlack,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconTextRow(
                    isAmount: true,
                    text: '₦$deliveryFee',
                    icon: AppAssets.icons.smallPackage.svg(height: 12.63),
                    fontSize: isWeb ? 16 : 12,
                  ),
                  const SizedBox(width: 10),
                  IconTextRow(
                    text: deliveryTime,
                    icon: AppAssets.icons.time.svg(height: 11.67),
                    fontSize: isWeb ? 16 : 12,
                  ),
                ],
              ),
              IconTextRow(
                text: "$rating (${reviews.toString()})",
                icon: AppAssets.icons.star.svg(height: isWeb ? 16 : 13),
                fontSize: isWeb ? 12 : 10,
                isRating: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
