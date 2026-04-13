import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/seller/models/product_category.dart';
import '../constants/app_colors.dart';

void showLoadingDialog(BuildContext context) {
  showDialog(
    barrierColor: AppColors.backgroundWhite.withValues(alpha: 0.2),
    context: context,
    barrierDismissible: false,
    builder: (context) => BackdropFilter(
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

List<ProductCategory> filterCategories(
  List<ProductCategory> categories,
  String query,
) {
  if (query.isEmpty) return categories;

  final lowerQuery = query.toLowerCase();

  return categories
      .map((cat) {
        final matchesCategory = cat.name.toLowerCase().contains(lowerQuery);

        final filteredSubs = cat.subCategories
            .where((sub) => sub.toLowerCase().contains(lowerQuery))
            .toList();

        if (matchesCategory) {
          return ProductCategory(cat.name, cat.subCategories);
        }

        if (filteredSubs.isNotEmpty) {
          return ProductCategory(cat.name, filteredSubs);
        }

        return null;
      })
      .whereType<ProductCategory>()
      .toList();
}

final isCategoryOpenProvider = StateProvider<bool>((ref) => false);
final expandedCategoryProvider = StateProvider<String?>((ref) => null);
final categorySearchQueryProvider = StateProvider.autoDispose<String>(
  (ref) => '',
);

MenuStyle anchorMenuStyle() {
  return MenuStyle(
    backgroundColor: WidgetStateProperty.all(AppColors.backgroundWhite),
    elevation: WidgetStateProperty.all(6),
    shape: WidgetStateProperty.all(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    padding: WidgetStateProperty.all(
      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    ),
  );
}
