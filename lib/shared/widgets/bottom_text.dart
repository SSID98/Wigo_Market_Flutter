import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';

class BottomTextBuilder {
  static Widget _buildBottomText({required double textSize}) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: ClipRect(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 15.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.transparent),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.center,
              colors: [
                Colors.black.withValues(alpha: 0.1),
                // Start with more transparent black
                Colors.black.withValues(alpha: 0.8),
                // End with more opaque black
              ],
              stops: const [0.0, 1.0],
            ),
          ),
          child: Text(
            'WIGOMARKET connects students, sellers, and local businesses—shop, earn, and grow on one seamless platform.',
            textAlign: TextAlign.left,
            style: GoogleFonts.hind(
              textStyle: TextStyle(
                color: AppColors.textWhite,
                fontSize: textSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget buildMobileBottomText() => _buildBottomText(textSize: 17.0);

  static Widget buildWebBottomText() => _buildBottomText(textSize: 24.0);
}
