import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';

class IconTextRow extends StatelessWidget {
  const IconTextRow({
    super.key,
    required this.text,
    required this.icon,
    this.isRating = false,
    this.isAmount = false,
    this.textBlack = false,
    required this.fontSize,
    this.padding,
    this.textPadding,
  });

  final String text;
  final Widget icon;
  final bool isRating;
  final bool isAmount;
  final double fontSize;
  final bool textBlack;
  final EdgeInsetsGeometry? padding;
  final double? textPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isRating ? AppColors.textFieldColor : Colors.transparent,
        borderRadius: BorderRadius.circular(3.89),
      ),
      child: Row(
        children: [
          icon,
          SizedBox(width: isRating ? 4 : 2),
          Padding(
            padding: EdgeInsets.only(top: textPadding ?? 0),
            child: Text(
              text,
              style:
                  isAmount
                      ? GoogleFonts.notoSans(
                        color:
                            isRating
                                ? AppColors.textBlack
                                : AppColors.textBodyText,
                        fontWeight: FontWeight.w500,
                        fontSize: fontSize,
                      )
                      : GoogleFonts.hind(
                        color:
                            isRating
                                ? AppColors.textBlack
                                : textBlack
                                ? AppColors.textBlack
                                : AppColors.textBodyText,
                        fontWeight: FontWeight.w500,
                        fontSize: fontSize,
                      ),
            ),
          ),
        ],
      ),
    );
  }
}
