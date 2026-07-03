import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:intl/intl.dart';

import '../../features/seller/models/product_category.dart';
import '../constants/app_colors.dart';

void showLoadingDialog(BuildContext context) {
  showDialog(
    barrierColor: AppColors.backgroundWhite.withValues(alpha: 0.2),
    context: context,
    barrierDismissible: false,
    builder: (context) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Center(
        child: SizedBox(
          height: 50,
          width: 50,
          child: CircularProgressIndicator(
            color: AppColors.primaryDarkGreen,
            strokeWidth: 8,
          ),
        ),
      ),
    ),
  );
}

List<ProductCategory> filterCategories(
  List<ProductCategory> categories,
  String query,
) {
  if (query.isEmpty) return categories;

  final lowerQuery = query.toLowerCase();

  return categories
      .map((cat) {
        final matchesCategory = cat.name.toLowerCase().contains(lowerQuery);

        final filteredSubs = cat.subCategories
            .where((sub) => sub.toLowerCase().contains(lowerQuery))
            .toList();

        if (matchesCategory) {
          return ProductCategory(cat.name, cat.subCategories);
        }

        if (filteredSubs.isNotEmpty) {
          return ProductCategory(cat.name, filteredSubs);
        }

        return null;
      })
      .whereType<ProductCategory>()
      .toList();
}

final isCategoryOpenProvider = StateProvider<bool>((ref) => false);
final expandedCategoryProvider = StateProvider<String?>((ref) => null);
final categorySearchQueryProvider = StateProvider.autoDispose<String>(
  (ref) => '',
);

MenuStyle anchorMenuStyle({
  double? verticalPad = 8,
  double? horizontalPad = 16,
}) {
  return MenuStyle(
    backgroundColor: WidgetStateProperty.all(AppColors.backgroundWhite),
    elevation: WidgetStateProperty.all(6),
    shape: WidgetStateProperty.all(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    padding: WidgetStateProperty.all(
      EdgeInsets.symmetric(vertical: verticalPad!, horizontal: horizontalPad!),
    ),
  );
}

class MaskedEmail {
  static String maskEmail(String email) {
    if (email.isEmpty) {
      return '';
    }

    // Find the position of the '@' symbol
    final atIndex = email.indexOf('@');
    if (atIndex == -1) {
      // Return a masked version of the whole string if it's not a valid email format
      return '***';
    }

    final username = email.substring(0, atIndex);
    final domain = email.substring(atIndex);

    // Define how many characters to show at the start
    final unmaskedLength = 3;

    // If the username is too short to mask, just show the first part
    if (username.length <= unmaskedLength) {
      return '${username.substring(0, 1)}**$domain';
    }

    final maskedUsername =
        '${username.substring(0, unmaskedLength)}****${username.substring(username.length - 1)}';

    return '$maskedUsername$domain';
  }
}

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

String extractName(String fullName) {
  if (fullName.isEmpty) return 'Guest';

  // Split by whitespace
  final parts = fullName.trim().split(' ');

  // If there's more than one name, return the last one (e.g., "Smith")
  // If there's only one name, return that one
  return parts.length > 1 ? parts.last : parts.first;
}

String capitalizeFirst(String value) {
  if (value.isEmpty) return value;
  return value[0].toUpperCase() + value.substring(1);
}

String formatRole(String role) {
  switch (role.toLowerCase()) {
    case "dispatch":
      return "Rider";
    default:
      return capitalizeFirst(role);
  }
}

String parseError(dynamic error) {
  if (error is DioException) {
    final response = error.response;
    final data = response?.data;

    if (data is Map<String, dynamic>) {
      return data['message'] ??
          data['msg'] ??
          data['error'] ??
          data['errors']?.toString() ??
          "Something went wrong";
    }

    if (data is String && data.isNotEmpty) {
      return data;
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return "Connection timed out. Please check your internet.";
      case DioExceptionType.receiveTimeout:
        return "Server took too long to respond";
      case DioExceptionType.sendTimeout:
        return "Request timed out while sending data.";
      case DioExceptionType.badCertificate:
        return "Bad certificate";
      case DioExceptionType.connectionError:
        return "No internet connection";
      case DioExceptionType.badResponse:
        return error.response?.data['message'] ?? "Server error occurred.";
      case DioExceptionType.cancel:
        return "Request was cancelled";
      default:
        return error.message ?? "Network error";
    }
  }

  return error.toString();
}

class DateHelpers {
  /// Converts a DateTime to the ISO 8601 string the backend expects.
  /// e.g. DateTime(2056, 10, 1) → "2056-10-01"
  static String toApiDateString(DateTime dt) {
    return '${dt.year.toString().padLeft(4, '0')}-'
        '${dt.month.toString().padLeft(2, '0')}-'
        '${dt.day.toString().padLeft(2, '0')}';
  }

  /// Tries to parse a backend date string back into DateTime.
  /// Returns null if the string is null, empty, or unparseable.
  static DateTime? fromApiDateString(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;
    try {
      return DateTime.parse(dateString);
    } catch (_) {
      return null;
    }
  }

  /// Handles full ISO timestamps ("2026-06-07T00:00:00.000Z") gracefully.
  /// Returns empty string if input is null, empty, or unparseable.
  static String normalizeToDateOnly(String? raw) {
    if (raw == null || raw.isEmpty) return '';
    final dt = fromApiDateString(raw);
    if (dt == null) return '';
    return toApiDateString(dt);
  }
}

String userKey(String key, [String? userId]) {
  if (userId == null || userId.isEmpty) return key;
  return '${key}_$userId';
}
