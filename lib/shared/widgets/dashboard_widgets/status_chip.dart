import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatusChip extends StatelessWidget {
  final String status;
  final Color statusColor, containerColor;
  final Widget? prefixIcon;
  final double? prefixIconWidth, fontSize;
  final double? width, height;
  final Alignment? alignment;

  const StatusChip({
    super.key,
    required this.statusColor,
    required this.containerColor,
    required this.status,
    this.prefixIcon,
    this.prefixIconWidth,
    this.width,
    this.height,
    this.alignment,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 24,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (prefixIcon != null) ...[
            prefixIcon!,
            SizedBox(width: prefixIconWidth ?? 8),
          ],
          Align(
            alignment: alignment ?? Alignment.center,
            child: Text(
              status,
              style: GoogleFonts.hind(
                fontSize: fontSize ?? 12,
                fontWeight: FontWeight.w500,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
