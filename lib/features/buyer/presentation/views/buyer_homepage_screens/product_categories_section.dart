import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';
import 'package:wigo_flutter/shared/widgets/custom_text_field.dart';

import '../../../../../core/constants/url.dart';
import '../../../../../shared/widgets/custom_carousel.dart';
import '../../widgets/categories_card.dart';

class CategoryItem {
  final String imageUrl;
  final String categoryName;
  final String price;

  CategoryItem({
    required this.imageUrl,
    required this.categoryName,
    required this.price,
  });
}

final List<CategoryItem> dummyCategories = [
  CategoryItem(
    imageUrl: '$networkImageUrl/phones.png',
    categoryName: 'Phones',
    price: '10,027.61',
  ),
  CategoryItem(
    imageUrl: '$networkImageUrl/shoe.png',
    categoryName: 'Shoes',
    price: '10,027.61',
  ),
  CategoryItem(
    imageUrl: '$networkImageUrl/speaker.png',
    categoryName: 'Electronics',
    price: '10,027.61',
  ),
  CategoryItem(
    imageUrl: '$networkImageUrl/gamePad.png',
    categoryName: 'Gadgets',
    price: '10,027.61',
  ),
  CategoryItem(
    imageUrl: '$networkImageUrl/shirt.png',
    categoryName: 'Clothes',
    price: '10,027.61',
  ),
  CategoryItem(
    imageUrl: '$networkImageUrl/glasses.png',
    categoryName: 'Accessories',
    price: '10,027.61',
  ),
  CategoryItem(
    imageUrl: '$networkImageUrl/shoe.png',
    categoryName: 'Books',
    price: '10,027.61',
  ),
  CategoryItem(
    imageUrl: '$networkImageUrl/gamePad.png',
    categoryName: 'Gaming',
    price: '10,027.61',
  ),
];

class ProductCategoriesSection extends StatelessWidget {
  const ProductCategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 600;
    return Container(
      color: AppColors.backgroundPurple.withValues(alpha: 0.62),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Image.network('$networkImageUrl/productOverlay.png'),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Product Categories',
                          style: GoogleFonts.openSans(
                            fontWeight: FontWeight.w700,
                            fontSize: isWeb ? 25.61 : 18,
                            color: AppColors.textBlackGrey,
                          ),
                        ),
                        Text(
                          'See Top products Categories and Sub Categories',
                          style: GoogleFonts.hind(
                            fontSize: isWeb ? 14 : 12,
                            color: AppColors.textBlack,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    // const SizedBox(width: 30),
                    SizedBox(
                      width: isWeb ? 92 : 79,
                      child: CustomDropdownField(
                        fillColor: Colors.transparent,
                        hintFontSize: isWeb ? 14 : 12,
                        hintTextColor: AppColors.textBlackGrey,
                        menuItemPadding: EdgeInsets.only(left: 5),
                        sizeBoxHeight: 37,
                        iconHeight: 14,
                        iconWidth: 14,
                        itemsFontSize: isWeb ? 14 : 12,
                        hintText: 'Sort by',
                        items: <String>[
                          'Popularity',
                          'Weakest',
                          'Strongest',
                          'Newest',
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              CustomCarouselWidget<CategoryItem>(
                items: dummyCategories,
                pageViewBuilderHeight: isWeb ? 225 : 210,
                viewportFraction: isWeb ? 0.50 : 0.44,
                itemBuilder: (item) {
                  return CategoriesCard(
                    imageUrl: item.imageUrl,
                    name: item.categoryName,
                    amount: item.price,
                    onPressed: () {},
                  );
                },
              ),
              const SizedBox(height: 15),
            ],
          ),
        ],
      ),
    );
  }
}
