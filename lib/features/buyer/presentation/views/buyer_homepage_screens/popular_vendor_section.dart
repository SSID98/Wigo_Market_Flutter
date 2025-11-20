import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';
import 'package:wigo_flutter/features/buyer/presentation/widgets/popular_vendors_card.dart';

import '../../../../../core/constants/url.dart';
import '../../../../../shared/widgets/custom_carousel.dart';

class PopularVendorsItem {
  final String imageUrl;
  final String vendorName;
  final String vendorCategory;
  final double rating;
  final int reviews;
  final String deliveryFee;
  final String deliveryTime;

  PopularVendorsItem({
    required this.imageUrl,
    required this.deliveryFee,
    required this.deliveryTime,
    required this.vendorName,
    required this.rating,
    required this.reviews,
    required this.vendorCategory,
  });
}

final List<PopularVendorsItem> dummyPopularVendors = [
  PopularVendorsItem(
    imageUrl: '$networkImageUrl/sharwama.png',
    deliveryFee: '1000',
    deliveryTime: '30-45 mins',
    vendorName: 'Manny’s Grills and Lounge',
    rating: 4.0,
    reviews: 67,
    vendorCategory: 'Restaurant',
  ),
  PopularVendorsItem(
    imageUrl: '$networkImageUrl/manikin.png',
    deliveryFee: '1000',
    deliveryTime: '30-45 mins',
    vendorName: 'Manny’s Girls and Lounge',
    rating: 4.0,
    reviews: 67,
    vendorCategory: 'Makeup & Spa',
  ),
  PopularVendorsItem(
    imageUrl: '$networkImageUrl/manikin2.png',
    deliveryFee: '1000',
    deliveryTime: '30-45 mins',
    vendorName: 'Manny’s Comrades and Lounge',
    rating: 4.0,
    reviews: 67,
    vendorCategory: 'Men’s Clothing',
  ),
];

class PopularVendorsSection extends StatelessWidget {
  const PopularVendorsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 600;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Popular Vendors',
                style: GoogleFonts.hind(
                  fontWeight: FontWeight.w600,
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
        ),
        const SizedBox(height: 16),
        CustomCarouselWidget(
          visibleItemsPerPage: 1,
          pageViewBuilderHeight: 245,
          viewportFraction: 1.0,
          dotColor: AppColors.clampValueColor,
          items: dummyPopularVendors,
          itemBuilder: (item) {
            return PopularVendorsCard(
              imageUrl: item.imageUrl,
              vendorName: item.vendorName,
              vendorCategory: item.vendorCategory,
              rating: item.rating,
              reviews: item.reviews,
              deliveryFee: item.deliveryFee,
              deliveryTime: item.deliveryTime,
              onCardPress: () {},
              onPress: () {},
            );
          },
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
