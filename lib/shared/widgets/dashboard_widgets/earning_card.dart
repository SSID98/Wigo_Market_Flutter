import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';

class EarningCard extends StatelessWidget {
  final String title;
  final Widget leadingIcon;
  final Widget? watermarkIcon;
  final Widget amountWidget;
  final Color? borderColor;
  final Color titleColor;
  final Color? backgroundColor;
  final double borderRadius;
  final double borderWidth;
  final double titleFontSize;
  final FontWeight titleFontWeight;
  final double? stackTop, stackBottom, stackRight, stackLeft;
  final bool iSeller;
  final Gradient? gradient;

  const EarningCard({
    super.key,
    required this.leadingIcon,
    this.watermarkIcon,
    this.borderColor = Colors.transparent,
    required this.titleColor,
    required this.title,
    required this.amountWidget,
    this.backgroundColor = Colors.transparent,
    this.borderRadius = 15.0,
    this.borderWidth = 1.0,
    this.titleFontSize = 12.0,
    this.titleFontWeight = FontWeight.w700,
    this.stackTop,
    this.stackBottom,
    this.stackRight,
    this.stackLeft,
    this.iSeller = false,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (watermarkIcon != null)
          Positioned(
            right: stackRight,
            bottom: stackBottom,
            top: stackTop,
            left: stackLeft,
            child: watermarkIcon!,
          ),
        Container(
          width: 200,
          padding: const EdgeInsets.symmetric(horizontal: 11.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: borderColor!, width: borderWidth),
            gradient: gradient,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.hind(
                      fontSize: titleFontSize,
                      fontWeight: titleFontWeight,
                      color: titleColor,
                    ),
                  ),
                  iSeller
                      ? Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: AppColors.backgroundWhite,
                          borderRadius: BorderRadius.circular(67.14),
                        ),
                        child: Center(child: leadingIcon),
                      )
                      : leadingIcon,
                ],
              ),
              amountWidget,
            ],
          ),
        ),
        if (watermarkIcon != null && iSeller)
          Positioned(
            right: stackRight,
            bottom: stackBottom,
            top: stackTop,
            left: stackLeft,
            child: watermarkIcon!,
          ),
      ],
    );
  }
}
