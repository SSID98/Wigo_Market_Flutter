import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';

class DescriptionAndProductSpecificsSection extends StatelessWidget {
  const DescriptionAndProductSpecificsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 600;
    final headerTextStyle = GoogleFonts.hind(
      fontWeight: FontWeight.w600,
      color: AppColors.textBlack,
      fontSize: isWeb ? 24 : 16,
    );
    final bodyTextStyle = GoogleFonts.hind(
      fontWeight: FontWeight.w400,
      color: AppColors.textBlackGrey,
      fontSize: isWeb ? 20 : 14,
    );
    final productSpecificationFontStyle = GoogleFonts.hind(
      fontWeight: FontWeight.w400,
      color: AppColors.textBlackGrey,
      fontSize: isWeb ? 20 : 18,
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Description', style: headerTextStyle),
          const SizedBox(height: 20),
          Text(
            '6-foot trampoline is typically a smaller, round trampoline designed for compact spaces such as backyards, patios, or small gardens. It features a durable frame, often made of steel, with a jumping surface made from strong, flexible material like polypropy',
            style: bodyTextStyle,
          ),
          const SizedBox(height: 20),
          Text(
            'Limited Time Offer! Get it now at 40% OFF while stocks last!',
            style: GoogleFonts.hind(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppColors.textBlack,
            ),
          ),
          const SizedBox(height: 90),
          Text('Product Specifications', style: headerTextStyle),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  '• ID: GE779SN3JZOMINAFAMZ',
                  style: productSpecificationFontStyle,
                ),
                const SizedBox(height: 10),
                Text('• Model: n/a', style: productSpecificationFontStyle),
                const SizedBox(height: 10),
                Text(
                  '• Size (L x W x H cm): large',
                  style: productSpecificationFontStyle,
                ),
                const SizedBox(height: 10),
                Text(
                  '• Weight (kg): 1.67',
                  style: productSpecificationFontStyle,
                ),
                const SizedBox(height: 10),
                Text('• Color: brown', style: productSpecificationFontStyle),
                const SizedBox(height: 10),
                Text(
                  '• Main Material: kraft paper',
                  style: productSpecificationFontStyle,
                ),
                const SizedBox(height: 10),
                Text(
                  '• Shop Name: Alex Clothing & Packages',
                  style: productSpecificationFontStyle,
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
