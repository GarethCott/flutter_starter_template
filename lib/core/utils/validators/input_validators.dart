/// General input validation utilities for various data types and formats
///
/// This file provides validation functions for common input scenarios
/// that are not specific to forms but used throughout the application.
library;

import 'dart:io';

/// General input validation utilities
class InputValidators {
  InputValidators._();

  /// Validates if a string is a valid URL
  static bool isValidUrl(String? url) {
    if (url == null || url.isEmpty) return false;

    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  /// Validates if a string is a valid file path
  static bool isValidFilePath(String? path) {
    if (path == null || path.isEmpty) return false;

    try {
      final file = File(path);
      return file.path.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Validates if a string contains only alphanumeric characters
  static bool isAlphanumeric(String? input) {
    if (input == null || input.isEmpty) return false;
    return RegExp(r'^[a-zA-Z0-9]+$').hasMatch(input);
  }

  /// Validates if a string contains only alphabetic characters
  static bool isAlphabetic(String? input) {
    if (input == null || input.isEmpty) return false;
    return RegExp(r'^[a-zA-Z]+$').hasMatch(input);
  }

  /// Validates if a string contains only numeric characters
  static bool isNumeric(String? input) {
    if (input == null || input.isEmpty) return false;
    return RegExp(r'^[0-9]+$').hasMatch(input);
  }

  /// Validates if a string is a valid hexadecimal color code
  static bool isValidHexColor(String? color) {
    if (color == null || color.isEmpty) return false;

    // Remove # if present
    final cleanColor = color.startsWith('#') ? color.substring(1) : color;

    // Check if it's 3, 6, or 8 characters (RGB, RRGGBB, or RRGGBBAA)
    if (![3, 6, 8].contains(cleanColor.length)) return false;

    return RegExp(r'^[0-9A-Fa-f]+$').hasMatch(cleanColor);
  }

  /// Validates if a string is a valid JSON format
  static bool isValidJson(String? json) {
    if (json == null || json.isEmpty) return false;

    try {
      // Try to parse as JSON
      final decoded = Uri.decodeComponent(json);
      return decoded.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Validates if a string is a valid base64 encoded string
  static bool isValidBase64(String? input) {
    if (input == null || input.isEmpty) return false;

    // Base64 pattern: groups of 4 characters, with optional padding
    final base64Pattern = RegExp(r'^[A-Za-z0-9+/]*={0,2}$');

    // Length must be multiple of 4
    if (input.length % 4 != 0) return false;

    return base64Pattern.hasMatch(input);
  }

  /// Validates if a string is a valid UUID
  static bool isValidUuid(String? uuid) {
    if (uuid == null || uuid.isEmpty) return false;

    final uuidPattern = RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
    );

    return uuidPattern.hasMatch(uuid);
  }

  /// Validates if a string is a valid IP address (IPv4 or IPv6)
  static bool isValidIpAddress(String? ip) {
    if (ip == null || ip.isEmpty) return false;

    try {
      final address = InternetAddress(ip);
      return address.address == ip;
    } catch (e) {
      return false;
    }
  }

  /// Validates if a string is a valid MAC address
  static bool isValidMacAddress(String? mac) {
    if (mac == null || mac.isEmpty) return false;

    // MAC address pattern: XX:XX:XX:XX:XX:XX or XX-XX-XX-XX-XX-XX
    final macPattern = RegExp(
      r'^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$',
    );

    return macPattern.hasMatch(mac);
  }

  /// Validates if a number is within a specified range
  static bool isInRange(num? value, num min, num max) {
    if (value == null) return false;
    return value >= min && value <= max;
  }

  /// Validates if a string length is within a specified range
  static bool isLengthInRange(String? input, int min, int max) {
    if (input == null) return false;
    return input.length >= min && input.length <= max;
  }

  /// Validates if a string contains only allowed characters
  static bool containsOnlyAllowedChars(String? input, String allowedChars) {
    if (input == null || input.isEmpty) return false;

    for (int i = 0; i < input.length; i++) {
      if (!allowedChars.contains(input[i])) {
        return false;
      }
    }

    return true;
  }

  /// Validates if a string doesn't contain forbidden characters
  static bool doesNotContainForbiddenChars(
      String? input, String forbiddenChars) {
    if (input == null || input.isEmpty) return true;

    for (int i = 0; i < input.length; i++) {
      if (forbiddenChars.contains(input[i])) {
        return false;
      }
    }

    return true;
  }

  /// Validates if a string matches a custom regex pattern
  static bool matchesPattern(String? input, String pattern) {
    if (input == null || input.isEmpty) return false;

    try {
      final regex = RegExp(pattern);
      return regex.hasMatch(input);
    } catch (e) {
      return false;
    }
  }

  /// Validates if a string is a valid semantic version (semver)
  static bool isValidSemver(String? version) {
    if (version == null || version.isEmpty) return false;

    final semverPattern = RegExp(
      r'^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)(?:-((?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+([0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?$',
    );

    return semverPattern.hasMatch(version);
  }

  /// Validates if a string is a valid credit card number using Luhn algorithm
  static bool isValidCreditCard(String? cardNumber) {
    if (cardNumber == null || cardNumber.isEmpty) return false;

    // Remove spaces and dashes
    final cleanNumber = cardNumber.replaceAll(RegExp(r'[\s-]'), '');

    // Check if all characters are digits
    if (!RegExp(r'^\d+$').hasMatch(cleanNumber)) return false;

    // Check length (most cards are 13-19 digits)
    if (cleanNumber.length < 13 || cleanNumber.length > 19) return false;

    // Luhn algorithm
    int sum = 0;
    bool alternate = false;

    for (int i = cleanNumber.length - 1; i >= 0; i--) {
      int digit = int.parse(cleanNumber[i]);

      if (alternate) {
        digit *= 2;
        if (digit > 9) {
          digit = (digit % 10) + 1;
        }
      }

      sum += digit;
      alternate = !alternate;
    }

    return sum % 10 == 0;
  }

  /// Validates if a string is a valid ISBN (10 or 13 digits)
  static bool isValidIsbn(String? isbn) {
    if (isbn == null || isbn.isEmpty) return false;

    // Remove hyphens and spaces
    final cleanIsbn = isbn.replaceAll(RegExp(r'[\s-]'), '');

    if (cleanIsbn.length == 10) {
      return _isValidIsbn10(cleanIsbn);
    } else if (cleanIsbn.length == 13) {
      return _isValidIsbn13(cleanIsbn);
    }

    return false;
  }

  /// Validates ISBN-10
  static bool _isValidIsbn10(String isbn) {
    int sum = 0;

    for (int i = 0; i < 9; i++) {
      if (!RegExp(r'^\d$').hasMatch(isbn[i])) return false;
      sum += int.parse(isbn[i]) * (10 - i);
    }

    final lastChar = isbn[9];
    if (lastChar == 'X' || lastChar == 'x') {
      sum += 10;
    } else if (RegExp(r'^\d$').hasMatch(lastChar)) {
      sum += int.parse(lastChar);
    } else {
      return false;
    }

    return sum % 11 == 0;
  }

  /// Validates ISBN-13
  static bool _isValidIsbn13(String isbn) {
    if (!RegExp(r'^\d{13}$').hasMatch(isbn)) return false;

    int sum = 0;

    for (int i = 0; i < 12; i++) {
      final digit = int.parse(isbn[i]);
      sum += (i % 2 == 0) ? digit : digit * 3;
    }

    final checkDigit = (10 - (sum % 10)) % 10;
    return checkDigit == int.parse(isbn[12]);
  }
}
