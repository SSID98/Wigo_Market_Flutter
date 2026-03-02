import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';
import 'package:wigo_flutter/features/seller/models/order_task_state.dart';

import '../../../../shared/widgets/custom_checkbox_2.dart';
import '../../viewmodels/order_task_viewmodel.dart';

class OptionsDropDownMenu extends ConsumerWidget {
  final VoidCallback onClose;

  final bool isOrderStatus;
  final bool isDate;

  const OptionsDropDownMenu({
    super.key,
    required this.onClose,
    this.isOrderStatus = false,
    // required this.showDateItems,
    this.isDate = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.read(orderTaskProvider.notifier);
    final state = ref.watch(orderTaskProvider);
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 300,
        color: AppColors.backgroundWhite,
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isDate) ...[
              _menuItem(
                'Today',
                onTap: () {
                  vm.setTodayFilter();
                  Navigator.pop(context);
                },
                state: state,
                vm: vm,
              ),
              _menuItem(
                'Custom Date',
                onTap: () async {
                  Navigator.pop(context);
                  final picked = await showDatePicker(
                    context: context,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                    initialDate: DateTime.now(),
                  );
                  if (picked != null) vm.setCustomDate(picked);
                },
                state: state,
                vm: vm,
                hasDropRight: true,
              ),
              // Animated dropdown area
              // AnimatedCrossFade(
              //   firstChild: const SizedBox.shrink(),
              //   secondChild: const Padding(
              //     padding: EdgeInsets.only(left: 16.0, bottom: 8),
              //     child: CategoriesDropdownMenu(),
              //   ),
              //   crossFadeState:
              //   showItems
              //       ? CrossFadeState.showSecond
              //       : CrossFadeState.showFirst,
              //   duration: const Duration(milliseconds: 250),
              // ),
            ],
            if (isOrderStatus) ...[
              _menuItem(
                'Confirmed',
                onTap: () {
                  // vm.toggleSelectStatus;
                },
                state: state,
                vm: vm,
                hasCheckbox: true,
              ),
              _menuItem(
                'Pick up Ready',
                onTap: () {},
                state: state,
                vm: vm,
                hasCheckbox: true,
              ),
              _menuItem(
                'In Transit',
                onTap: () {},
                state: state,
                vm: vm,
                hasCheckbox: true,
              ),
              _menuItem(
                'Delivered',
                onTap: () {},
                state: state,
                vm: vm,
                hasCheckbox: true,
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
    bool hasDropRight = false,
    bool hasCheckbox = false,
    bool isOpen = false,
    required OrderTaskState state,
    required OrderTaskViewmodel vm,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color:
              isOpen || state.selectStatus
                  ? AppColors.buyerCardColor
                  : Colors.transparent,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
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
              if (hasDropRight) ...[
                Icon(Icons.keyboard_arrow_right_rounded, size: 20),
              ],
              if (hasCheckbox)
                CustomCheckbox2(
                  value: state.selectStatus,
                  onChanged: vm.toggleSelectStatus,
                  borderRadius: 2,
                  size: 16,
                  checkSize: 10,
                  borderColor:
                      state.selectStatus
                          ? AppColors.primaryDarkGreen
                          : AppColors.borderColor,
                  checkColor: AppColors.primaryDarkGreen,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
