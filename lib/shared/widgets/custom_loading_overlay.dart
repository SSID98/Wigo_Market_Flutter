import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class LoadingOverlay {
  static OverlayEntry? _overlay;

  static void show(BuildContext context, {Widget? spinner}) {
    _overlay?.remove();
    _overlay = null;

    _overlay = OverlayEntry(
      builder: (_) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          color: AppColors.backgroundWhite.withValues(alpha: 0.2),
          child: Center(child: spinner ?? const CircularProgressIndicator()),
        ),
      ),
    );
    Overlay.of(context).insert(_overlay!);
  }

  static void hide() {
    _overlay?.remove();
    _overlay = null;
  }
}

Future<T> runWithOverlay<T>(
  BuildContext context,
  Future<T> Function() asyncFunction, {
  Widget? spinner,
}) async {
  LoadingOverlay.show(context, spinner: spinner);
  try {
    return await asyncFunction();
  } finally {
    LoadingOverlay.hide();
  }
}
