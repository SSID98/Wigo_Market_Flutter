import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';

class RoleCard extends StatelessWidget {
  final String title;
  final String description;
  final String icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color radioColor;
  final double iconHeight, iconWidth, descriptionTextSize, titleTextSize;

  const RoleCard({
    super.key,
    required this.title,
    required this.description,
    required this.isSelected,
    required this.onTap,
    required this.backgroundColor,
    required this.icon,
    required this.radioColor,
    required this.iconHeight,
    required this.iconWidth,
    required this.descriptionTextSize,
    required this.titleTextSize,
  });

  @override
  Widget build(BuildContext context) {
    final Color borderColor = radioColor;
    final Color unselectedCardBorderColor = Colors.transparent;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: backgroundColor,
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: isSelected ? borderColor : unselectedCardBorderColor,
            width: isSelected ? 1.0 : 1.0, // Thicker border when selected
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 15, 10, 15),
          child: Row(
            children: [
              SvgPicture.asset(icon, height: iconHeight, width: iconWidth),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.hind(
                        fontWeight: FontWeight.w600,
                        fontSize: titleTextSize,
                        color: AppColors.textBlackLight,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: GoogleFonts.hind(
                        fontWeight: FontWeight.w400,
                        fontSize: descriptionTextSize,
                        color: AppColors.textBlackLight,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 3),
              Radio<bool>(
                value: true,
                groupValue: isSelected,
                onChanged: (bool? value) {
                  if (value == true) {
                    onTap();
                  }
                },
                fillColor: WidgetStateProperty.resolveWith<Color>((
                  Set<WidgetState> states,
                ) {
                  if (states.contains(WidgetState.selected)) {
                    return borderColor;
                  }
                  return borderColor;
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
