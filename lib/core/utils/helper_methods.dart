import 'dart:ui';

import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

void showLoadingDialog(BuildContext context) {
  showDialog(
    barrierColor: AppColors.backgroundWhite.withValues(alpha: 0.2),
    context: context,
    barrierDismissible: false,
    builder:
        (context) => BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Center(
            child: SizedBox(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(
                color: AppColors.primaryDarkGreen,
                strokeWidth: 8,
              ),
            ),
          ),
        ),
  );
}
