// price_formatter.dart (You will need to import the 'intl' package: flutter pub add intl)
import 'package:intl/intl.dart';

// Use 'en_NG' for Nigerian Naira formatting, which includes the comma separator.
final NumberFormat _currencyFormatter = NumberFormat.currency(
  locale: 'en_NG', // Adjust locale as needed for region/decimal separator
  symbol: '#', // Custom symbol for your currency
  decimalDigits: 0, // Show no decimal points for whole numbers
);

String formatPrice(double price) {
  return _currencyFormatter.format(price);
}

// Helper to safely parse string price back to double (since your CartItemCard was taking String)
double parsePrice(String priceString) {
  // Remove currency symbols, commas, etc., and parse to double
  final cleanedString = priceString.replaceAll(RegExp(r'[^0-9.]'), '');
  return double.tryParse(cleanedString) ?? 0.0;
}
