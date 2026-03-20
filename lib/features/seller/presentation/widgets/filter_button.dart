import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../gen/assets.gen.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({super.key, required this.label, this.icon});

  final String label;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 800;
    return Container(
      height: 40,
      width: isWeb ? 140 : 170,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isWeb ? AppColors.buttonLighterGreen : AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!isWeb && icon != null) icon!,
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.hind(
              fontWeight: FontWeight.w500,
              fontSize: isWeb ? 14 : 16,
              color: AppColors.textBlackGrey,
            ),
          ),
          const SizedBox(width: 6),
          AppAssets.icons.arrowDown.svg(height: 14),
        ],
      ),
    );
  }
}
