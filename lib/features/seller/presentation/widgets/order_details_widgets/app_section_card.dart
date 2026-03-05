import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';

class AppSectionCard extends StatelessWidget {
  final Widget child;

  const AppSectionCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }
}
