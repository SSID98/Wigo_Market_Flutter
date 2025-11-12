import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';
import 'package:wigo_flutter/shared/widgets/custom_button.dart';

class CategoriesCard extends StatelessWidget {
  final String name, amount;
  final VoidCallback onPressed;
  final String imageUrl;

  const CategoriesCard({
    super.key,
    required this.name,
    required this.amount,
    required this.onPressed,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 600;
    return Container(
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(12.56),
      ),
      margin: const EdgeInsets.only(left: 2, bottom: 15),
      child: Column(
        children: [
          const SizedBox(height: 10),
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
          CustomButton(
            text: name,
            fontSize: isWeb ? 20 : 14,
            height: isWeb ? 28.3 : 25.3,
            width: isWeb ? 138.36 : 115.36,
            fontWeight: FontWeight.w600,
            buttonColor: AppColors.textOrange,
            onPressed: () {},
            // foregroundColor: AppColors.textOrange,
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              '#$amount',
              textAlign: TextAlign.center,
              style: GoogleFonts.hind(
                fontSize: isWeb ? 20 : 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textBlackGrey,
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
