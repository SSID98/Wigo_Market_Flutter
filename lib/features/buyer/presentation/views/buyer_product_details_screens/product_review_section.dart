import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';

import '../../../../../shared/widgets/custom_button.dart';
import '../../../../../shared/widgets/custom_text_field.dart';

class ProductReviewSection extends StatelessWidget {
  const ProductReviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 600;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What do you think about this Product?',
            style: GoogleFonts.hind(
              fontWeight: FontWeight.w600,
              fontSize: isWeb ? 24 : 18,
              color: AppColors.textBlackGrey,
            ),
          ),
          const SizedBox(height: 20),
          CustomTextField(
            fillColor: AppColors.backgroundWhite,
            label: 'Name',
            labelFontSize: 14,
            hintText: 'Enter Your Name',
            focusedBorderColor: AppColors.borderColor1,
            enabledBorderColor: AppColors.borderColor1,
            borderRadius: 16,
            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 8),
          ),
          const SizedBox(height: 10),
          CustomTextField(
            label: 'Description',
            hintText: 'What do you think about this Product?',
            fillColor: AppColors.backgroundWhite,
            focusedBorderColor: AppColors.borderColor,
            enabledBorderColor: AppColors.borderColor,
            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 8),
            minLines: 6,
            maxLines: 8,
            labelFontSize: 14,
            borderRadius: 16,
          ),
          const SizedBox(height: 15),
          CustomButton(
            text: 'Submit Review',
            onPressed: () {},
            fontSize: 16,
            fontWeight: FontWeight.w500,
            height: 50,
            width: isWeb ? 551 : double.infinity,
            borderRadius: 16,
          ),
        ],
      ),
    );
  }
}
