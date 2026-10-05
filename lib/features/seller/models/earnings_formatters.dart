String formatNaira(double amount, {bool trimWhole = false}) {
  final isNegative = amount < 0;
  final abs = amount.abs();
  final fixed = (trimWhole && abs == abs.roundToDouble())
      ? abs.toStringAsFixed(0)
      : abs.toStringAsFixed(2);
  final parts = fixed.split('.');
  final intPart = parts.first.replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => ',',
  );
  final decimals = parts.length > 1 ? '.${parts[1]}' : '';
  return '${isNegative ? '-' : ''}₦$intPart$decimals';
}

String formatChangePercent(double percent) {
  final text = percent == percent.roundToDouble()
      ? percent.toStringAsFixed(0)
      : percent.toStringAsFixed(1);
  return percent > 0 ? '+$text%' : '$text%';
}

const _shortMonths = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

String formatShortDate(DateTime date) =>
    '${_shortMonths[date.month - 1]} ${date.day}, ${date.year}';

String formatApiDate(DateTime date) {
  final m = date.month.toString().padLeft(2, '0');
  final d = date.day.toString().padLeft(2, '0');
  return '${date.year.toString().padLeft(4, '0')}-$m-$d';
}
