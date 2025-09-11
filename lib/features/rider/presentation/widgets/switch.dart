import 'dart:math' as math;

import 'package:flutter/material.dart';

class CustomSwitch extends StatelessWidget {
  const CustomSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.width = 52,
    this.height = 32,
    this.thumbDiameter = 20,
    this.activeColor,
    this.inactiveColor,
    this.thumbColour,
    this.duration = const Duration(milliseconds: 180),
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final double width;
  final double height;
  final double thumbDiameter;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? thumbColour;
  final Duration duration;

  void _toggle() => onChanged(!value);

  @override
  Widget build(BuildContext context) {
    final active = value;
    final trackColor =
        active
            ? activeColor ?? Theme.of(context).colorScheme.primary
            : inactiveColor ??
                Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.9);

    final thumbColor = thumbColour ?? Theme.of(context).colorScheme.onPrimary;

    final horizontalPad = math.max(3.3, (height - thumbDiameter) / 2);

    return Semantics(
      toggled: active,
      button: true,
      child: GestureDetector(
        onTap: _toggle,
        onHorizontalDragEnd: (_) => _toggle(),
        child: AnimatedContainer(
          width: width,
          height: height,
          duration: duration,
          curve: Curves.easeOut,
          padding: EdgeInsets.symmetric(horizontal: horizontalPad),
          decoration: BoxDecoration(
            color: trackColor,
            borderRadius: BorderRadius.circular(height / 2),
          ),
          child: Align(
            alignment: active ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: thumbDiameter,
              height: thumbDiameter,
              decoration: BoxDecoration(
                color: thumbColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
