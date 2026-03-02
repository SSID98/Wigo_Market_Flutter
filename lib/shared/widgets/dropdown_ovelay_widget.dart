import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wigo_flutter/features/seller/presentation/widgets/mobile_filters_dropdown_menu.dart';

import '../../features/buyer/presentation/widgets/custom_dropdown_menu.dart';
import '../../features/buyer/presentation/widgets/user_dropdown_menu.dart';
import '../models/dropdown_overlay_state.dart';
import '../viewmodels/dropdown_overlay_viewmodel.dart';

class DropdownOverlay extends ConsumerWidget {
  final DropdownType type;
  final VoidCallback onClose;
  final VoidCallback onToggleCategories;
  final bool isBuyer;

  const DropdownOverlay({
    super.key,
    required this.type,
    required this.onClose,
    required this.onToggleCategories,
    this.isBuyer = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dropdownOverlayProvider);

    return isBuyer
        ? Stack(
          children: [
            type == DropdownType.menu
                ? Positioned.fill(
                  child: GestureDetector(
                    onTap: onClose,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                      child: Container(
                        color: Colors.black.withValues(alpha: 0.02),
                      ),
                    ),
                  ),
                )
                : Positioned.fill(
                  child: GestureDetector(
                    onTap: onClose,
                    child: Container(color: Colors.transparent),
                  ),
                ),
            Positioned(
              top: type == DropdownType.menu ? 60 : 90,
              right: type == DropdownType.menu ? 16 : 120,
              child:
                  type == DropdownType.menu
                      ? CustomDropdownMenu(
                        onClose: onClose,
                        onCategoriesPress: onToggleCategories,
                        showCategories: state.showCategories,
                      )
                      : UserDropDownMenu(onAction: onClose),
            ),
          ],
        )
        : Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: onClose,
                child: Container(color: Colors.transparent),
              ),
            ),
            Positioned(
              top: type == DropdownType.mobileFilter ? 128 : 90,
              right: type == DropdownType.mobileFilter ? 95 : 120,
              child:
                  type == DropdownType.mobileFilter
                      ? MobileFiltersDropDownMenu(onClose: onClose)
                      : UserDropDownMenu(onAction: onClose),
            ),
          ],
        );
  }
}
