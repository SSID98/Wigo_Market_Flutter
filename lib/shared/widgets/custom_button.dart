import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final VoidCallback onPressed;
  final Color? buttonColor;
  final Color? textColor;
  final Color? borderColor;
  final double? borderRadius;
  final double? borderWidth;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final String? prefixIcon, suffixIcon;
  final double? iconHeight, iconWidth;
  final MainAxisAlignment? mainAxisAlignment;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.buttonColor,
    this.textColor,
    this.borderColor,
    this.borderWidth,
    this.height,
    this.width,
    this.padding,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.borderRadius,
    required this.fontSize,
    required this.fontWeight,
    this.iconHeight,
    this.iconWidth,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor ?? AppColors.primaryDarkGreen,
          padding:
              padding ??
              const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          // Default padding
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 8.0),
            side: BorderSide(
              color: borderColor ?? Colors.transparent,
              width: borderWidth ?? 0.0,
            ),
          ),
          elevation: 0,
          minimumSize:
              (width == null && height == null) ? const Size(0, 0) : null,
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: mainAxisAlignment!,
            children: [
              if (prefixIcon != null) ...[
                SvgPicture.asset(
                  prefixIcon!,
                  height: iconHeight,
                  width: iconWidth,
                ),
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: GoogleFonts.hind(
                  textStyle: TextStyle(
                    fontSize: fontSize,
                    fontWeight: fontWeight,
                    color: textColor ?? AppColors.textWhite,
                  ),
                ),
              ),
              if (suffixIcon != null) ...[
                const SizedBox(width: 8),
                SvgPicture.asset(
                  suffixIcon!,
                  height: iconHeight,
                  width: iconWidth,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
