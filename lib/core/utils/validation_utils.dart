const double kMinWithdrawalAmount = 500.0;

class FormValidators {
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Please choose the right email format';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? validatePin(String? value) {
    if (value == null || value.isEmpty) {
      return 'Pin is required';
    } else if (value.length < 4) {
      return 'Pin must be 4 digit';
    }
    return null;
  }

  static String? validateMismatch(String? value, String? value1) {
    if (value != value1) {
      return 'Password Mismatch';
    }
    return null;
  }

  static String? validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Amount is required.';
    }

    final double? enteredAmount = double.tryParse(value);

    if (enteredAmount == null) {
      return 'Amount is required.';
    }

    if (enteredAmount < kMinWithdrawalAmount) {
      return 'Amount cannot be less than ${kMinWithdrawalAmount.toStringAsFixed(0)}.';
    }

    return null;
  }

  static String? validateAccountNo(String? value) {
    if (value == null || value.isEmpty) {
      return 'Account Number is required.';
    } else if (value.length < 10) {
      return 'Please enter the right account number';
    }
    return null;
  }
}
