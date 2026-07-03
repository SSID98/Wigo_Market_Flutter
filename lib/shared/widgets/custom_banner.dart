import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';

void showErrorBanner(String message, BuildContext context) {
  showTopSnackBar(
    Overlay.of(context),
    SizedBox(
      height: 50,
      child: CustomSnackBar.error(
        message: message,
        textStyle: GoogleFonts.hind(
          color: AppColors.textWhite,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}

void showSuccessBanner(String message, BuildContext context) {
  showTopSnackBar(
    Overlay.of(context),
    SizedBox(
      height: 50,
      child: CustomSnackBar.success(
        message: message,
        textStyle: GoogleFonts.hind(
          color: AppColors.textWhite,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}
