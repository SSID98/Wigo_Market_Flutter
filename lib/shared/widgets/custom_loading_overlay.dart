import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
          child: Center(
            child:
                spinner ??
                const SpinKitDualRing(color: AppColors.primaryDarkGreen),
          ),
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

class LoadingOverlayWidget extends StatelessWidget {
  final Widget? spinner;
  final bool visible;

  const LoadingOverlayWidget({super.key, this.spinner, this.visible = true});

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Container(
        color: AppColors.backgroundWhite.withValues(alpha: 0.2),
        child: Center(
          child:
              spinner ??
              const SpinKitDualRing(color: AppColors.primaryDarkGreen),
        ),
      ),
    );
  }
}
