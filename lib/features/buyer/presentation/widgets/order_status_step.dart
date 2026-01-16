import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import 'custom_dashedline.dart';

class OrderStatusStep extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? date;
  final bool isCompleted;
  final bool isDelivered;
  final bool isLast;
  final int dashCount;

  const OrderStatusStep({
    super.key,
    required this.title,
    this.subtitle,
    this.date,
    required this.isCompleted,
    this.isLast = false,
    this.isDelivered = false,
    this.dashCount = 12,
  });

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 800;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isCompleted ? AppColors.textOrange : AppColors.textBlack,
              size: isWeb ? 32 : 20,
            ),
            if (!isLast) DashedLine(height: 40, dashCount: dashCount),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.hind(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textBlack,
                  fontSize: isWeb ? 20 : 15,
                ),
              ),
              if (!isDelivered) ...[
                const SizedBox(height: 10),
                if (date != null)
                  Text(
                    date!,
                    style: GoogleFonts.hind(
                      fontWeight: FontWeight.w400,
                      color: AppColors.primaryDarkGreen,
                      fontSize: isWeb ? 16 : 14,
                    ),
                  ),
                if (subtitle != null) const SizedBox(height: 10),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: GoogleFonts.hind(
                      fontWeight: FontWeight.w400,
                      color: AppColors.textBlack,
                      fontSize: isWeb ? 16 : 14,
                    ),
                  ),
              ],
              const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }
}
