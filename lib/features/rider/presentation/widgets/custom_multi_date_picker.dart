import 'package:flutter/material.dart';

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
  // This tracks which month the calendar is currently showing
  late DateTime _viewDate;

  @override
  void initState() {
    super.initState();
    // Start by showing the current month, or the first selected date if available
    _viewDate =
        widget.initialSelectedDates.isNotEmpty
            ? widget.initialSelectedDates.first
            : DateTime.now();
  }

  // --- Helper Methods ---

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
        // Left Arrow
        _buildNavArrow(Icons.chevron_left, () => _moveMonth(-1)),

        // Month & Year Selectors
        Row(
          children: [
            _buildDropdown<int>(
              value: _viewDate.month,
              items: List.generate(12, (i) => i + 1),
              labelBuilder: (m) => _getMonthName(m),
              onChanged:
                  (m) => setState(
                    () => _viewDate = DateTime(_viewDate.year, m!, 1),
                  ),
            ),
            const SizedBox(width: 8),
            _buildDropdown<int>(
              value: _viewDate.year,
              items: List.generate(10, (i) => DateTime.now().year - 6 + i),
              labelBuilder: (y) => "$y",
              onChanged:
                  (y) => setState(
                    () => _viewDate = DateTime(y!, _viewDate.month, 1),
                  ),
            ),
          ],
        ),

        // Right Arrow
        _buildNavArrow(Icons.chevron_right, () => _moveMonth(1)),
      ],
    );
  }

  Widget _buildNavArrow(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 20, color: Colors.black87),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required T value,
    required List<T> items,
    required String Function(T) labelBuilder,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<T>(
        value: value,
        underline: const SizedBox(),
        icon: const Icon(Icons.keyboard_arrow_down, size: 18),
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        items:
            items
                .map(
                  (item) => DropdownMenuItem(
                    value: item,
                    child: Text(labelBuilder(item)),
                  ),
                )
                .toList(),
        onChanged: onChanged,
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
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                ),
              )
              .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Logic to calculate the grid
    final daysInMonth = DateTime(_viewDate.year, _viewDate.month + 1, 0).day;
    // weekday returns 1 for Monday, 7 for Sunday.
    // We adjust it so the grid starts on the correct column.
    final firstDayOffset =
        DateTime(_viewDate.year, _viewDate.month, 1).weekday - 1;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          _buildWeekdayLabels(),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: daysInMonth + firstDayOffset,
            itemBuilder: (context, index) {
              if (index < firstDayOffset) return const SizedBox.shrink();

              final day = index - firstDayOffset + 1;
              final date = DateTime(_viewDate.year, _viewDate.month, day);
              // We compare normalized dates (year, month, day only)
              final isSelected = widget.initialSelectedDates.any(
                (d) =>
                    d.year == date.year &&
                    d.month == date.month &&
                    d.day == date.day,
              );

              return GestureDetector(
                onTap: () => widget.onDateToggled(date),
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? const Color(0xffE08D40)
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "$day",
                    style: TextStyle(
                      fontSize: 15,
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          const Text(
            "You can choose multiple date",
            style: TextStyle(color: Colors.black45, fontSize: 13),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.onApply,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff688E33),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                "Apply Now",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
