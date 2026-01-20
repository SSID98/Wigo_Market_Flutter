import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';

import '../../../../core/utils/helper_methods.dart';
import 'categories_dropdown_menu.dart';

class CustomDropdownMenu extends StatelessWidget {
  final VoidCallback onClose;
  final VoidCallback onCategoriesPress;
  final bool showCategories;

  const CustomDropdownMenu({
    super.key,
    required this.onClose,
    required this.onCategoriesPress,
    required this.showCategories,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 6,
      color: AppColors.backgroundWhite,
      child: Container(
        width: 350,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: onClose,
              ),
            ),
            const Divider(color: AppColors.clampBgColor),
            _menuItem('Latest', onTap: () {}),
            _menuItem(
              'Categories',
              onTap: onCategoriesPress,
              hasDropDown: true,
            ),
            // Animated dropdown area
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: const Padding(
                padding: EdgeInsets.only(left: 16.0, bottom: 8),
                child: CategoriesDropdownMenu(),
              ),
              crossFadeState:
                  showCategories
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 250),
            ),

            _menuItem('About', onTap: () {}),
            _menuItem(
              'Support',
              onTap: () async {
                showLoadingDialog(context);
                await Future.delayed(const Duration(seconds: 1));
                if (!context.mounted) return;
                Navigator.of(context, rootNavigator: true).pop();
                context.push('/buyer/support');
              },
            ),
            _menuItem('Become a Seller', onTap: () {}),
            _menuItem('For Riders', onTap: () {}),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(
    String text, {
    required VoidCallback onTap,
    bool hasDropDown = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Text(
              text,
              style: GoogleFonts.hind(
                fontSize: 16,
                color: AppColors.textBlack,
                fontWeight: FontWeight.w400,
              ),
            ),
            if (hasDropDown) ...[
              const SizedBox(width: 4),
              showCategories
                  ? Icon(Icons.keyboard_arrow_up_rounded, size: 14)
                  : Icon(Icons.keyboard_arrow_down_rounded, size: 14),
            ],
          ],
        ),
      ),
    );
  }
}
