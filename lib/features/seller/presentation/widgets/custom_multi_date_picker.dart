import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';
import 'package:wigo_flutter/shared/widgets/custom_button.dart';
import 'package:wigo_flutter/shared/widgets/custom_dropdown.dart';

class CustomMultiDatePicker extends StatefulWidget {
  final Set<DateTime> initialSelectedDates;
  final Function(DateTime) onDateToggled;
  final VoidCallback onApply;

  const CustomMultiDatePicker({
    super.key,
    required this.initialSelectedDates,
    required this.onDateToggled,
    required this.onApply,
  });

  @override
  State<CustomMultiDatePicker> createState() => _CustomMultiDatePickerState();
}

class _CustomMultiDatePickerState extends State<CustomMultiDatePicker> {
  late DateTime _viewDate;

  @override
  void initState() {
    super.initState();
    _viewDate =
        widget.initialSelectedDates.isNotEmpty
            ? widget.initialSelectedDates.first
            : DateTime.now();
  }

  void _moveMonth(int offset) {
    setState(() {
      _viewDate = DateTime(_viewDate.year, _viewDate.month + offset, 1);
    });
  }

  String _getMonthName(int month) {
    return [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ][month - 1];
  }

  // --- UI Components ---

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildNavArrow(Icons.chevron_left_rounded, () => _moveMonth(-1)),
        // Month & Year Selectors
        Row(
          children: [
            AppDropdown(
              value: _viewDate.month,
              items: List.generate(12, (i) => i + 1),
              labelBuilder: (m) => _getMonthName(m),
              onSelected:
                  (m) => setState(
                    () => _viewDate = DateTime(_viewDate.year, m, 1),
                  ),
            ),
            const SizedBox(width: 8),
            AppDropdown(
              value: _viewDate.year,
              items: List.generate(10, (i) => DateTime.now().year - 6 + i),
              labelBuilder: (y) => "$y",
              onSelected:
                  (y) => setState(
                    () => _viewDate = DateTime(y, _viewDate.month, 1),
                  ),
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
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.backgroundWhite,
        ),
        child: Icon(icon, size: 24, color: AppColors.textBlackGrey),
      ),
    );
  }

  Widget _buildWeekdayLabels() {
    final labels = ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children:
          labels
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
    // 1. Get the first day of the current view month
    final firstDayOfMonth = DateTime(_viewDate.year, _viewDate.month, 1);

    // 2. Find how many days to show from the PREVIOUS month
    // If month starts on Monday (1), offset is 0. If Sunday (7), offset is 6.
    final firstDayOffset = firstDayOfMonth.weekday - 1;

    // 3. To make a perfect square, we show 6 rows (42 days total)
    const int totalCells = 42;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(12.61),
        border: BoxBorder.all(color: AppColors.borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 0),
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

              final isSelected = widget.initialSelectedDates.any(
                (d) =>
                    d.year == date.year &&
                    d.month == date.month &&
                    d.day == date.day,
              );

              return GestureDetector(
                onTap: () {
                  if (isCurrentMonth) {
                    widget.onDateToggled(date);
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? AppColors.buttonOrange
                            : isCurrentMonth
                            ? AppColors.backgroundWhite
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(4.73),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "${date.day}",
                    style: GoogleFonts.lexend(
                      fontSize: 14.18,
                      color:
                          isSelected
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
            "You can choose multiple date",
            style: GoogleFonts.hind(
              fontSize: 14,
              color: AppColors.textBodyText,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 15),
          CustomButton(
            text: "Apply Now",
            fontSize: 16,
            fontWeight: FontWeight.w500,
            onPressed: widget.onApply,
            height: 40,
            width: 179,
            borderRadius: 6,
          ),
        ],
      ),
    );
  }
}
