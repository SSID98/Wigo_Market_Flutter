import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';

class AppDropdown<T> extends StatelessWidget {
  final T value;
  final List<T> items;
  final String Function(T) labelBuilder;
  final ValueChanged<T> onSelected;

  const AppDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.labelBuilder,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      crossAxisUnconstrained: true,
      alignmentOffset: const Offset(0, 3),
      style: MenuStyle(
        backgroundColor: WidgetStateProperty.all(AppColors.backgroundWhite),
      ),
      builder: (context, controller, child) {
        return InkWell(
          onTap: () {
            controller.isOpen ? controller.close() : controller.open();
          },
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 70),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: AppColors.backgroundWhite,
                borderRadius: BorderRadius.circular(4.73),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    labelBuilder(value),
                    style: GoogleFonts.hind(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: AppColors.textBlackGrey,
                    ),
                  ),
                  const SizedBox(width: 3),
                  const Icon(Icons.keyboard_arrow_down_rounded, size: 15),
                ],
              ),
            ),
          ),
        );
      },
      menuChildren:
          items.map((item) {
            return MenuItemButton(
              onPressed: () => onSelected(item),
              child: Text(
                labelBuilder(item),
                style: GoogleFonts.hind(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: AppColors.textBlackGrey,
                ),
              ),
            );
          }).toList(),
    );
  }
}
