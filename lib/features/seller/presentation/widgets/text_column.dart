import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../gen/assets.gen.dart';

Widget buildTextColumn({
  required String title,
  required double titleFontSize,
  required String subtitle1,
  String? subtitle2,
  bool isMainSubTitle = false,
  bool hasBullet = false,
  double subtitleFontSize = 14,
  FontWeight subtitleFontWeight = FontWeight.w400,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        title,
        style: GoogleFonts.hind(
          fontSize: titleFontSize,
          fontWeight: FontWeight.w700,
          color: AppColors.textBlackGrey,
        ),
      ),
      const SizedBox(height: 10),
      _buildSubtitle(
        subtitle: subtitle1,
        isMainSubTitle: isMainSubTitle,
        hasBullet: hasBullet,
        subtitleFontSize: subtitleFontSize,
        subtitleFontWeight: subtitleFontWeight,
      ),
      if (subtitle2 != null) ...[
        const SizedBox(height: 10),
        _buildSubtitle(
          subtitle: subtitle2,
          isMainSubTitle: isMainSubTitle,
          hasBullet: hasBullet,
          subtitleFontSize: subtitleFontSize,
          subtitleFontWeight: subtitleFontWeight,
        ),
      ],
    ],
  );
}

Widget _buildSubtitle({
  required String subtitle,
  required bool isMainSubTitle,
  required bool hasBullet,
  required double subtitleFontSize,
  required FontWeight subtitleFontWeight,
}) {
  return Column(
    children: [
      if (!hasBullet)
        Text(
          subtitle,
          style: GoogleFonts.hind(
            fontSize: subtitleFontSize,
            fontWeight: subtitleFontWeight,
            color: isMainSubTitle
                ? AppColors.textBlackGrey
                : AppColors.textBodyText,
          ),
        ),
      if (hasBullet)
        Row(
          children: [
            AppAssets.icons.greenBullet.svg(),
            const SizedBox(width: 4),
            Text(
              subtitle,
              style: GoogleFonts.hind(
                fontSize: subtitleFontSize,
                fontWeight: subtitleFontWeight,
                color: isMainSubTitle
                    ? AppColors.textBlackGrey
                    : AppColors.textBodyText,
              ),
            ),
          ],
        ),
    ],
  );
}
