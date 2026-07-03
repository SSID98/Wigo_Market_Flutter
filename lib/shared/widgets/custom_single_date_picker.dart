import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';
import 'package:wigo_flutter/shared/widgets/custom_button.dart';

import 'custom_dropdown.dart';

class CustomSingleDatePicker extends StatefulWidget {
  final DateTime? initialSelectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final VoidCallback onApply;

  const CustomSingleDatePicker({
    super.key,
    this.initialSelectedDate,
    required this.onDateSelected,
    required this.onApply,
  });

  @override
  State<CustomSingleDatePicker> createState() => _CustomSingleDatePickerState();
}

class _CustomSingleDatePickerState extends State<CustomSingleDatePicker> {
  late DateTime _viewDate;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialSelectedDate;
    _viewDate = widget.initialSelectedDate ?? DateTime.now();
  }

  void _moveMonth(int offset) => setState(() {
    _viewDate = DateTime(_viewDate.year, _viewDate.month + offset, 1);
  });

  String _getMonthName(int month) => [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ][month - 1];

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildNavArrow(Icons.chevron_left_rounded, () => _moveMonth(-1)),
        Row(
          children: [
            AppDropdown(
              value: _viewDate.month,
              items: List.generate(12, (i) => i + 1),
              labelBuilder: (m) => _getMonthName(m),
              onSelected: (m) =>
                  setState(() => _viewDate = DateTime(_viewDate.year, m, 1)),
            ),
            const SizedBox(width: 8),
            AppDropdown(
              value: _viewDate.year,
              items: List.generate(32, (i) => DateTime.now().year + i),
              labelBuilder: (y) => '$y',
              onSelected: (y) =>
                  setState(() => _viewDate = DateTime(y, _viewDate.month, 1)),
            ),
          ],
        ),
        _buildNavArrow(Icons.chevron_right_rounded, () => _moveMonth(1)),
      ],
    );
  }

  Widget _buildNavArrow(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.backgroundWhite,
        ),
        child: Icon(icon, size: 24, color: AppColors.textBlackGrey),
      ),
    );
  }

  Widget _buildWeekdayLabels() {
    final labels = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: labels
          .map(
            (l) => SizedBox(
              width: 40,
              child: Text(
                l,
                textAlign: TextAlign.center,
                style: GoogleFonts.hind(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: AppColors.textNeutral950,
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final firstDayOfMonth = DateTime(_viewDate.year, _viewDate.month, 1);
    final firstDayOffset = firstDayOfMonth.weekday - 1;
    const int totalCells = 42;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(12.61),
        border: Border.all(color: AppColors.borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            spreadRadius: 1,
            blurRadius: 1,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          _buildWeekdayLabels(),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 12,
              crossAxisSpacing: 8,
              childAspectRatio: 1.15,
            ),
            itemCount: totalCells,
            itemBuilder: (context, index) {
              final date = firstDayOfMonth.add(
                Duration(days: index - firstDayOffset),
              );
              final isCurrentMonth = date.month == _viewDate.month;
              final isSelected =
                  _selectedDate != null &&
                  _selectedDate!.year == date.year &&
                  _selectedDate!.month == date.month &&
                  _selectedDate!.day == date.day;

              return GestureDetector(
                onTap: () {
                  if (!isCurrentMonth) return;
                  setState(() => _selectedDate = date);
                  widget.onDateSelected(date);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryDarkGreen
                        : isCurrentMonth
                        ? AppColors.backgroundWhite
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(4.73),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${date.day}',
                    style: GoogleFonts.lexend(
                      fontSize: 14.18,
                      color: isSelected
                          ? AppColors.textWhite
                          : isCurrentMonth
                          ? AppColors.textBlackGrey
                          : AppColors.textIconGrey.withValues(alpha: 0.5),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            },
          ),
          const Divider(),
          const SizedBox(height: 5),
          Text(
            'Tap a date then press Apply',
            style: GoogleFonts.hind(
              fontSize: 14,
              color: AppColors.textBodyText,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 15),
          CustomButton(
            text: 'Apply',
            fontSize: 16,
            fontWeight: FontWeight.w500,
            // Disabled until a date is selected
            onPressed: _selectedDate != null ? widget.onApply : null,
            height: 40,
            width: 179,
            borderRadius: 6,
          ),
        ],
      ),
    );
  }
}

/// Shows [CustomSingleDatePicker] in a dialog and returns the selected [DateTime],
/// or null if the user dismissed without applying.
Future<DateTime?> showSingleDatePickerModal(
  BuildContext context, {
  DateTime? initialDate,
}) {
  return showDialog<DateTime>(
    context: context,
    barrierDismissible: true,
    builder: (ctx) {
      DateTime? picked = initialDate;
      return Dialog(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 380),
          child: SingleChildScrollView(
            child: CustomSingleDatePicker(
              initialSelectedDate: initialDate,
              onDateSelected: (date) => picked = date,
              onApply: () => Navigator.pop(ctx, picked),
            ),
          ),
        ),
      );
    },
  );
}
