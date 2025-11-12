import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';

import '../../../../gen/assets.gen.dart';

class CategoriesDropdownMenu extends StatelessWidget {
  // final VoidCallback onClose;

  const CategoriesDropdownMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {
        'icon': AppAssets.icons.home3.svg(),
        'label': 'Home Improvement and Lighting',
      },
      {
        'icon': AppAssets.icons.womenCloth.svg(height: 18),
        'label': 'Women’s Clothing',
      },
      {'icon': AppAssets.icons.droplet.svg(), 'label': 'Beauty & Self Care'},
      {
        'icon': AppAssets.icons.vegetarianFood.svg(),
        'label': 'Food & Groceries',
      },
      {'icon': AppAssets.icons.tv.svg(), 'label': 'Electronics & Appliances'},
      {'icon': AppAssets.icons.wrench.svg(), 'label': 'Tools and Gadgets'},
      {
        'icon': AppAssets.icons.distribution.svg(),
        'label': 'School & Office Supplies',
      },
      {'icon': AppAssets.icons.givePill.svg(), 'label': 'Health & Wellness'},
      {'icon': AppAssets.icons.shirt.svg(), 'label': 'Men’s Clothing'},
      {'icon': AppAssets.icons.rubiksCube.svg(), 'label': 'Toys & Games'},
      {'icon': AppAssets.icons.babyBottle.svg(), 'label': 'Baby & Maternity'},
      {'icon': AppAssets.icons.computer.svg(), 'label': 'Computer Appliances'},
      {
        'icon': AppAssets.icons.underpants.svg(),
        'label': 'Lingerie & Lounge wear',
      },
      {'icon': AppAssets.icons.smartWatch.svg(), 'label': 'Jewelry & Watches'},
      {'icon': AppAssets.icons.runningShoes.svg(), 'label': 'Shoes'},
      {'icon': AppAssets.icons.chair.svg(), 'label': 'Furniture'},
      {'icon': AppAssets.icons.bone.svg(), 'label': 'Pet Supplies'},
      {'icon': AppAssets.icons.dumbbell.svg(), 'label': 'Gym & Fitness'},
    ];

    return Material(
      color: Colors.transparent,
      child: Container(
        width: 300,
        color: AppColors.backgroundWhite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Category list
            ...categories.map((item) {
              return InkWell(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 5,
                  ),
                  child: Row(
                    children: [
                      item['icon'] as SvgPicture,
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          item['label'] as String,
                          style: GoogleFonts.hind(
                            fontSize: 15,
                            color: AppColors.textBlack,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
