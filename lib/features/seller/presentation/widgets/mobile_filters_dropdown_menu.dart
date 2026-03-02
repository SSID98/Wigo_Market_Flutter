import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';
import 'package:wigo_flutter/features/seller/presentation/widgets/options_dropdown_menu.dart';
import 'package:wigo_flutter/shared/viewmodels/dropdown_overlay_viewmodel.dart';
import 'package:wigo_flutter/shared/widgets/custom_button.dart';

import '../../../../shared/models/dropdown_overlay_state.dart';

class MobileFiltersDropDownMenu extends ConsumerWidget {
  final VoidCallback onClose;

  final DropdownType? active;

  const MobileFiltersDropDownMenu({
    super.key,
    required this.onClose,
    this.active,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.read(dropdownOverlayProvider.notifier);
    final state = ref.read(dropdownOverlayProvider);
    return Material(
      borderRadius: BorderRadius.circular(8),
      elevation: 6,
      color: AppColors.backgroundWhite,
      child: SizedBox(
        width: 300,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _menuItem(
                    'Date',
                    onTap: () {
                      vm.toggleSubMenu(DropdownType.date);
                    },
                    hasDropDown: true,
                    isOpen: state.openedSubMenu == DropdownType.date,
                  ),
                  AnimatedCrossFade(
                    firstChild: const SizedBox.shrink(),
                    secondChild: Padding(
                      padding: const EdgeInsets.only(left: 30.0, bottom: 8),
                      child: OptionsDropDownMenu(
                        onClose: onClose,
                        isDate: true,
                      ),
                    ),
                    crossFadeState:
                        state.openedSubMenu == DropdownType.date
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 250),
                  ),

                  _menuItem(
                    'Order Status',
                    onTap: () {
                      vm.toggleSubMenu(DropdownType.orderStatus);
                    },
                    hasDropDown: true,
                    isOpen: state.openedSubMenu == DropdownType.orderStatus,
                  ),
                  // Animated dropdown area
                  AnimatedCrossFade(
                    firstChild: const SizedBox.shrink(),
                    secondChild: Padding(
                      padding: const EdgeInsets.only(left: 30.0, bottom: 8),
                      child: OptionsDropDownMenu(
                        onClose: onClose,
                        isOrderStatus: true,
                      ),
                    ),
                    crossFadeState:
                        state.openedSubMenu == DropdownType.orderStatus
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 250),
                  ),
                  _menuItem('Order Type', onTap: () {}, hasDropDown: true),
                ],
              ),
            ),
            if (state.openedSubMenu == DropdownType.orderStatus) ...[
              Divider(),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 25),
                child: CustomButton(
                  text: 'Apply Now',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  height: 42,
                  width: 179,
                  onPressed: () {},
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _menuItem(
    String text, {
    required VoidCallback onTap,
    bool hasDropDown = false,
    bool isOpen = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 45,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: isOpen ? AppColors.buyerCardColor : Colors.transparent,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                style: GoogleFonts.hind(
                  fontSize: 16,
                  color: AppColors.textBodyText,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (hasDropDown) ...[
                isOpen
                    ? Icon(Icons.keyboard_arrow_up_rounded, size: 20)
                    : Icon(Icons.keyboard_arrow_down_rounded, size: 20),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
