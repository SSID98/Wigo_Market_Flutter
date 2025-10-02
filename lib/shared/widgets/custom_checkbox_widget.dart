import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class CustomCheckBox extends StatelessWidget {
  const CustomCheckBox({
    super.key,
    this.sizedBoxHeight,
    this.activeColor = AppColors.primaryDarkGreen,
    this.borderColor = AppColors.textIconGrey,
    required this.value,
    required this.onChanged,
  });

  final double? sizedBoxHeight;
  final Color activeColor;
  final Color borderColor;
  final bool value;
  final void Function(bool?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 0.8,
      child: SizedBox(
        height: sizedBoxHeight,
        width: 10,
        child: Checkbox(
          activeColor: activeColor,
          value: value,
          onChanged: onChanged,
          side: BorderSide(color: borderColor),
        ),
      ),
    );
  }
}
