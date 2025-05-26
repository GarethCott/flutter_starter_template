import 'package:intl/intl.dart';

/// Formatting utilities for common data formatting needs
class FormatHelpers {
  // Private constructor to prevent instantiation
  FormatHelpers._();

  // Currency Formatting

  /// Formats a number as currency
  static String formatCurrency(
    double amount, {
    String symbol = '\$',
    int decimalDigits = 2,
    String locale = 'en_US',
  }) {
    final formatter = NumberFormat.currency(
      symbol: symbol,
      decimalDigits: decimalDigits,
      locale: locale,
    );
    return formatter.format(amount);
  }

  /// Formats a number as compact currency (e.g., $1.2K, $1.5M)
  static String formatCompactCurrency(
    double amount, {
    String symbol = '\$',
    String locale = 'en_US',
  }) {
    final formatter = NumberFormat.compactCurrency(
      symbol: symbol,
      locale: locale,
    );
    return formatter.format(amount);
  }

  // Number Formatting

  /// Formats a number with thousand separators
  static String formatNumber(
    num number, {
    int? decimalDigits,
    String locale = 'en_US',
  }) {
    final formatter = NumberFormat(
        '#,##0${decimalDigits != null ? '.${'0' * decimalDigits}' : ''}',
        locale);
    return formatter.format(number);
  }

  /// Formats a number as a percentage
  static String formatPercentage(
    double value, {
    int decimalDigits = 1,
    String locale = 'en_US',
  }) {
    final formatter = NumberFormat.percentPattern(locale);
    formatter.minimumFractionDigits = decimalDigits;
    formatter.maximumFractionDigits = decimalDigits;
    return formatter.format(value);
  }

  /// Formats a number in compact form (e.g., 1.2K, 1.5M, 2.1B)
  static String formatCompactNumber(num number, {String locale = 'en_US'}) {
    final formatter = NumberFormat.compact(locale: locale);
    return formatter.format(number);
  }

  /// Formats bytes to human readable format
  static String formatBytes(int bytes, {int decimals = 1}) {
    if (bytes <= 0) return '0 B';

    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB', 'PB'];
    final i = (bytes.bitLength - 1) ~/ 10;
    final size = bytes / (1 << (i * 10));

    return '${size.toStringAsFixed(decimals)} ${suffixes[i]}';
  }

  // Date and Time Formatting

  /// Formats a DateTime as a readable date string
  static String formatDate(
    DateTime date, {
    String pattern = 'MMM dd, yyyy',
    String? locale,
  }) {
    final formatter = DateFormat(pattern, locale);
    return formatter.format(date);
  }

  /// Formats a DateTime as a readable time string
  static String formatTime(
    DateTime time, {
    String pattern = 'h:mm a',
    String? locale,
  }) {
    final formatter = DateFormat(pattern, locale);
    return formatter.format(time);
  }

  /// Formats a DateTime as a readable date and time string
  static String formatDateTime(
    DateTime dateTime, {
    String pattern = 'MMM dd, yyyy \'at\' h:mm a',
    String? locale,
  }) {
    final formatter = DateFormat(pattern, locale);
    return formatter.format(dateTime);
  }

  /// Formats a duration in human readable format
  static String formatDuration(Duration duration) {
    final days = duration.inDays;
    final hours = duration.inHours.remainder(24);
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    final parts = <String>[];

    if (days > 0) parts.add('${days}d');
    if (hours > 0) parts.add('${hours}h');
    if (minutes > 0) parts.add('${minutes}m');
    if (seconds > 0 && parts.isEmpty) parts.add('${seconds}s');

    return parts.isEmpty ? '0s' : parts.join(' ');
  }

  // Text Formatting

  /// Capitalizes the first letter of a string
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  /// Converts text to title case
  static String toTitleCase(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map(capitalize).join(' ');
  }

  /// Truncates text with ellipsis
  static String truncateText(String text, int maxLength,
      {String ellipsis = '...'}) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength - ellipsis.length)}$ellipsis';
  }

  /// Formats a phone number
  static String formatPhoneNumber(String phoneNumber) {
    // Remove all non-digit characters
    final digits = phoneNumber.replaceAll(RegExp(r'\D'), '');

    if (digits.length == 10) {
      // US format: (123) 456-7890
      return '(${digits.substring(0, 3)}) ${digits.substring(3, 6)}-${digits.substring(6)}';
    } else if (digits.length == 11 && digits.startsWith('1')) {
      // US format with country code: +1 (123) 456-7890
      return '+1 (${digits.substring(1, 4)}) ${digits.substring(4, 7)}-${digits.substring(7)}';
    }

    // Return original if format not recognized
    return phoneNumber;
  }

  /// Masks sensitive information (e.g., credit card, SSN)
  static String maskSensitiveInfo(
    String text, {
    int visibleStart = 4,
    int visibleEnd = 4,
    String maskChar = '*',
  }) {
    if (text.length <= visibleStart + visibleEnd) return text;

    final start = text.substring(0, visibleStart);
    final end = text.substring(text.length - visibleEnd);
    final middle = maskChar * (text.length - visibleStart - visibleEnd);

    return '$start$middle$end';
  }

  // List Formatting

  /// Formats a list of strings into a readable sentence
  static String formatList(
    List<String> items, {
    String separator = ', ',
    String lastSeparator = ' and ',
  }) {
    if (items.isEmpty) return '';
    if (items.length == 1) return items.first;
    if (items.length == 2) return '${items.first}$lastSeparator${items.last}';

    final allButLast = items.sublist(0, items.length - 1).join(separator);
    return '$allButLast$lastSeparator${items.last}';
  }

  // Address Formatting

  /// Formats an address into a single line
  static String formatAddress({
    String? street,
    String? city,
    String? state,
    String? zipCode,
    String? country,
  }) {
    final parts = <String>[];

    if (street?.isNotEmpty == true) parts.add(street!);
    if (city?.isNotEmpty == true) parts.add(city!);
    if (state?.isNotEmpty == true) parts.add(state!);
    if (zipCode?.isNotEmpty == true) parts.add(zipCode!);
    if (country?.isNotEmpty == true) parts.add(country!);

    return parts.join(', ');
  }

  // Name Formatting

  /// Formats a full name from first and last name
  static String formatFullName({
    String? firstName,
    String? lastName,
    String? middleName,
  }) {
    final parts = <String>[];

    if (firstName?.isNotEmpty == true) parts.add(firstName!);
    if (middleName?.isNotEmpty == true) parts.add(middleName!);
    if (lastName?.isNotEmpty == true) parts.add(lastName!);

    return parts.join(' ');
  }

  /// Gets initials from a full name
  static String getInitials(String fullName, {int maxInitials = 2}) {
    final words = fullName.trim().split(RegExp(r'\s+'));
    final initials = words
        .take(maxInitials)
        .map((word) => word.isNotEmpty ? word[0].toUpperCase() : '')
        .where((initial) => initial.isNotEmpty)
        .join();

    return initials;
  }

  // Color Formatting

  /// Converts a Color to hex string
  static String colorToHex(int color) {
    return '#${color.toRadixString(16).padLeft(8, '0').substring(2)}';
  }

  /// Converts hex string to Color value
  static int? hexToColor(String hex) {
    final hexCode = hex.replaceAll('#', '');
    if (hexCode.length == 6) {
      return int.tryParse('FF$hexCode', radix: 16);
    } else if (hexCode.length == 8) {
      return int.tryParse(hexCode, radix: 16);
    }
    return null;
  }

  // Validation Helpers

  /// Checks if a string is a valid email format
  static bool isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email);
  }

  /// Checks if a string is a valid URL format
  static bool isValidUrl(String url) {
    return RegExp(r'^https?:\/\/[^\s/$.?#].[^\s]*$').hasMatch(url);
  }

  /// Checks if a string contains only numeric characters
  static bool isNumeric(String str) {
    return RegExp(r'^[0-9]+$').hasMatch(str);
  }
}
