import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';

class QuickActionCard extends StatelessWidget {
  final String text;
  final Widget icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color borderColor;
  final double? titleTextSize;

  const QuickActionCard({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
    this.backgroundColor,
    required this.icon,
    required this.borderColor,
    this.titleTextSize,
  });

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 600;
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: isWeb ? 180 : 160,
        child: Card(
          color: backgroundColor ?? AppColors.backgroundWhite,
          elevation: 0,
          margin: const EdgeInsets.symmetric(horizontal: 9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: isSelected ? borderColor : AppColors.borderColor,
              width: isSelected ? 1.0 : 1.0,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                icon,
                const SizedBox(width: 10),
                Text(
                  text,
                  style: GoogleFonts.hind(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppColors.textBlackGrey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
