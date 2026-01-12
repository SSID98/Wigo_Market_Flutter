import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class CustomCheckbox2 extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final double size;
  final Color borderColor;
  final Color fillColor;
  final Color checkColor;
  final double checkSize;

  const CustomCheckbox2({
    super.key,
    required this.value,
    required this.onChanged,
    this.size = 24,
    this.borderColor = AppColors.accentRed,
    this.fillColor = Colors.transparent,
    this.checkColor = AppColors.accentRed,
    this.checkSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: value ? fillColor : Colors.transparent,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(5.5),
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child:
                value
                    ? Icon(
                      Icons.check,
                      key: const ValueKey('check'),
                      size: checkSize,
                      color: checkColor,
                    )
                    : const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}
