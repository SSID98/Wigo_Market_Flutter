import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';
import 'package:wigo_flutter/shared/widgets/custom_button.dart';
import 'package:wigo_flutter/shared/widgets/custom_dropdown.dart';

import '../../models/earnings_formatters.dart';

class EarningsDateRangePicker extends StatefulWidget {
  const EarningsDateRangePicker({
    super.key,
    required this.onApply,
    this.initialStart,
    this.initialEnd,
    this.onClear,
  });

  final DateTime? initialStart;
  final DateTime? initialEnd;
  final void Function(DateTime start, DateTime end) onApply;
  final VoidCallback? onClear;

  @override
  State<EarningsDateRangePicker> createState() =>
      _EarningsDateRangePickerState();
}

class _EarningsDateRangePickerState extends State<EarningsDateRangePicker> {
  late final DateTime _today;
  late DateTime _viewDate;
  DateTime? _start;
  DateTime? _end;

  static const _months = [
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
  ];

  @override
  void initState() {
    super.initState();
    _today = _day(DateTime.now());
    _start = widget.initialStart == null ? null : _day(widget.initialStart!);
    _end = widget.initialEnd == null ? null : _day(widget.initialEnd!);
    final anchor = _start ?? _today;
    _viewDate = DateTime(anchor.year, anchor.month, 1);
  }

  DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);

  bool _same(DateTime a, DateTime? b) =>
      b != null && a.year == b.year && a.month == b.month && a.day == b.day;

  int _monthIndex(DateTime d) => d.year * 12 + d.month;

  bool get _canGoNext => _monthIndex(_viewDate) < _monthIndex(_today);

  void _moveMonth(int offset) {
    if (offset > 0 && !_canGoNext) return;
    setState(() {
      _viewDate = DateTime(_viewDate.year, _viewDate.month + offset, 1);
    });
  }

  void _onDateTap(DateTime date) {
    setState(() {
      if (_start == null || _end != null) {
        _start = date;
        _end = null;
      } else if (date.isBefore(_start!)) {
        _end = _start;
        _start = date;
      } else {
        _end = date;
      }
    });
  }

  String get _summaryText {
    final start = _start;
    if (start == null) return 'Select a start and end date';
    final end = _end;
    if (end == null || _same(start, end)) return formatShortDate(start);
    return '${formatShortDate(start)} – ${formatShortDate(end)}';
  }

  void _apply() {
    final start = _start;
    if (start == null) return;
    widget.onApply(start, _end ?? start);
  }

  Widget _buildNavArrow(IconData icon, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.backgroundWhite,
        ),
        child: Icon(
          icon,
          size: 24,
          color: onTap == null
              ? AppColors.textIconGrey.withValues(alpha: 0.4)
              : AppColors.textBlackGrey,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final firstYear = math.min(_today.year - 5, _viewDate.year);
    final yearCount = _today.year - firstYear + 1;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildNavArrow(Icons.chevron_left_rounded, () => _moveMonth(-1)),
        Row(
          children: [
            AppDropdown(
              value: _viewDate.month,
              items: List.generate(12, (i) => i + 1),
              labelBuilder: (m) => _months[m - 1],
              onSelected: (m) =>
                  setState(() => _viewDate = DateTime(_viewDate.year, m, 1)),
            ),
            const SizedBox(width: 8),
            AppDropdown(
              value: _viewDate.year,
              items: List.generate(yearCount, (i) => firstYear + i),
              labelBuilder: (y) => '$y',
              onSelected: (y) => setState(() {
                final month = y == _today.year
                    ? math.min(_viewDate.month, _today.month)
                    : _viewDate.month;
                _viewDate = DateTime(y, month, 1);
              }),
            ),
          ],
        ),
        _buildNavArrow(
          Icons.chevron_right_rounded,
          _canGoNext ? () => _moveMonth(1) : null,
        ),
      ],
    );
  }

  Widget _buildWeekdayLabels() {
    const labels = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
    return Row(
      children: [
        for (var i = 0; i < labels.length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          Expanded(
            child: Text(
              labels[i],
              textAlign: TextAlign.center,
              style: GoogleFonts.hind(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: AppColors.textNeutral950,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDayCell(DateTime date) {
    final isCurrentMonth = date.month == _viewDate.month;
    final isDisabled = date.isAfter(_today);
    final isEdge = isCurrentMonth && (_same(date, _start) || _same(date, _end));
    final start = _start;
    final end = _end;
    final inRange =
        isCurrentMonth &&
        start != null &&
        end != null &&
        date.isAfter(start) &&
        date.isBefore(end);

    final Color background = isEdge
        ? AppColors.buttonOrange
        : inRange
        ? AppColors.buttonOrange.withValues(alpha: 0.15)
        : isCurrentMonth
        ? AppColors.backgroundWhite
        : Colors.transparent;

    final Color textColor = isEdge
        ? AppColors.textWhite
        : !isCurrentMonth
        ? AppColors.textIconGrey.withValues(alpha: 0.5)
        : isDisabled
        ? AppColors.textIconGrey.withValues(alpha: 0.5)
        : AppColors.textBlackGrey;

    return GestureDetector(
      onTap: (isCurrentMonth && !isDisabled) ? () => _onDateTap(date) : null,
      child: Container(
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(4.73),
        ),
        alignment: Alignment.center,
        child: Text(
          '${date.day}',
          style: GoogleFonts.lexend(
            fontSize: 14.18,
            color: textColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final firstOfMonth = DateTime(_viewDate.year, _viewDate.month, 1);
    final leadingDays = firstOfMonth.weekday - 1;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: Container(
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
              itemCount: 42,
              itemBuilder: (context, index) {
                final date = DateTime(
                  _viewDate.year,
                  _viewDate.month,
                  1 - leadingDays + index,
                );
                return _buildDayCell(date);
              },
            ),
            const Divider(),
            const SizedBox(height: 5),
            Text(
              _summaryText,
              textAlign: TextAlign.center,
              style: GoogleFonts.hind(
                fontSize: 14,
                color: AppColors.textBodyText,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.onClear != null) ...[
                  TextButton(
                    onPressed: widget.onClear,
                    child: Text(
                      'Clear',
                      style: GoogleFonts.hind(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textBlackGrey,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                CustomButton(
                  text: 'Apply Now',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  onPressed: _apply,
                  height: 40,
                  width: 179,
                  borderRadius: 6,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
