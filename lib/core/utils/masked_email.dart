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
