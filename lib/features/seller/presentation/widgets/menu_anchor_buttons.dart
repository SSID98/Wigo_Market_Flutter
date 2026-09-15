import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../viewmodels/dropdown_providers.dart';

Widget buildMenuItem({
  required void Function()? onPressed,
  required itemText,
  Widget? trailingIcon,
  bool isNotAccordion = false,
  bool isSelected = false,
}) {
  return MenuItemButton(
    onPressed: onPressed,
    trailingIcon: isSelected ? trailingIcon : const SizedBox(width: 16),
    child: Padding(
      padding: EdgeInsets.only(left: isNotAccordion ? 0 : 35),
      child: Text(
        itemText,
        style: GoogleFonts.hind(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: isNotAccordion
              ? AppColors.textBlackGrey
              : AppColors.textBodyText,
        ),
      ),
    ),
  );
}

Widget buildMenuButton({
  required bool isExpanded,
  required String menuText,
  required WidgetRef ref,
  required String sectionKey,
  bool isSelected = true,
  Color? newColor,
  void Function()? onTap,
  String? selectedValue,
}) {
  final hasValue = selectedValue != null && selectedValue.isNotEmpty;
  return InkWell(
    onTap:
        onTap ??
        () {
          final notifier = ref.read(expandedIdProvider.notifier);
          notifier.state = isExpanded ? null : sectionKey;
        },
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: isSelected
            ? isExpanded
                  ? AppColors.tableHeader
                  : Colors.transparent
            : newColor,
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 15,
          bottom: 15,
          left: 12,
          right: 12,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    menuText,
                    style: GoogleFonts.hind(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textBlackGrey,
                    ),
                  ),
                  if (hasValue)
                    Text(
                      selectedValue,
                      style: GoogleFonts.hind(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryDarkGreen,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 100),
            Icon(
              isExpanded
                  ? Icons.keyboard_arrow_up_rounded
                  : Icons.keyboard_arrow_down_rounded,
            ),
          ],
        ),
      ),
    ),
  );
}
