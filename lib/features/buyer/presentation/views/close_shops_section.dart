import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';
import 'package:wigo_flutter/features/buyer/presentation/widgets/close_shops_card.dart';

import '../../../../core/constants/url.dart';
import '../../../../shared/widgets/custom_carousel.dart';

class CloseShopsItem {
  final String imageUrl;
  final String shopName;
  final String category;
  final double rating;
  final int reviews;
  final String deliveryFee;
  final String deliveryTime;

  CloseShopsItem({
    required this.imageUrl,
    required this.deliveryFee,
    required this.deliveryTime,
    required this.category,
    required this.rating,
    required this.reviews,
    required this.shopName,
  });
}

final List<CloseShopsItem> dummyCloseShops = [
  CloseShopsItem(
    imageUrl: '$networkImageUrl/shopsClosest.png',
    deliveryFee: '1000',
    deliveryTime: '30-45 mins',
    category: 'Women Clothings',
    rating: 4.0,
    reviews: 67,
    shopName: 'Jennis Collectibles',
  ),
  CloseShopsItem(
    imageUrl: '$networkImageUrl/shopsClosest.png',
    deliveryFee: '1000',
    deliveryTime: '30-45 mins',
    category: 'Women Clothings',
    rating: 4.0,
    reviews: 67,
    shopName: 'Jennis Collectibles',
  ),
  CloseShopsItem(
    imageUrl: '$networkImageUrl/shopsClosest.png',
    deliveryFee: '1000',
    deliveryTime: '30-45 mins',
    category: 'Women Clothings',
    rating: 4.0,
    reviews: 67,
    shopName: 'Jennis Collectibles',
  ),
];

class CloseShopSection extends StatelessWidget {
  const CloseShopSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 600;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 11.0, top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Shop Closest to you',
                style: GoogleFonts.hind(
                  fontWeight: FontWeight.w500,
                  fontSize: isWeb ? 20 : 16,
                  color: AppColors.textBlackGrey,
                ),
              ),
              Row(
                children: [
                  Text(
                    'View More',
                    style: GoogleFonts.hind(
                      fontWeight: FontWeight.w400,
                      fontSize: isWeb ? 18.87 : 14,
                      color: AppColors.textOrange,
                    ),
                  ),
                  const SizedBox(width: 1),
                  Icon(
                    Icons.keyboard_arrow_right_rounded,
                    size: 20,
                    color: AppColors.textOrange,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        CustomCarouselWidget(
          visibleItemsPerPage: 1,
          pageViewBuilderHeight: 240,
          viewportFraction: 0.90,
          dotColor: AppColors.clampValueColor,
          items: dummyCloseShops,
          itemBuilder: (item) {
            return CloseShopsCard(
              imageUrl: item.imageUrl,
              shopName: item.shopName,
              category: item.category,
              rating: item.rating,
              reviews: item.reviews,
              deliveryFee: item.deliveryFee,
              deliveryTime: item.deliveryTime,
            );
          },
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
