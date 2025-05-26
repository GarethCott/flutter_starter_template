/// String extensions for validation, formatting, and utility functions
extension StringExtensions on String {
  /// Checks if the string is a valid email address
  bool get isValidEmail {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(this);
  }

  /// Checks if the string is a valid phone number (basic validation)
  bool get isValidPhoneNumber {
    return RegExp(r'^\+?[\d\s\-\(\)]{10,}$').hasMatch(this);
  }

  /// Checks if the string is a valid URL
  bool get isValidUrl {
    return RegExp(r'^https?:\/\/[^\s/$.?#].[^\s]*$').hasMatch(this);
  }

  /// Checks if the string contains only alphabetic characters
  bool get isAlphabetic {
    return RegExp(r'^[a-zA-Z]+$').hasMatch(this);
  }

  /// Checks if the string contains only numeric characters
  bool get isNumeric {
    return RegExp(r'^[0-9]+$').hasMatch(this);
  }

  /// Checks if the string contains only alphanumeric characters
  bool get isAlphanumeric {
    return RegExp(r'^[a-zA-Z0-9]+$').hasMatch(this);
  }

  /// Checks if the string is a valid password (at least 8 chars, contains letter and number)
  bool get isValidPassword {
    return length >= 8 &&
        RegExp(r'[a-zA-Z]').hasMatch(this) &&
        RegExp(r'[0-9]').hasMatch(this);
  }

  /// Checks if the string is a strong password (includes special characters)
  bool get isStrongPassword {
    return length >= 8 &&
        RegExp(r'[a-z]').hasMatch(this) &&
        RegExp(r'[A-Z]').hasMatch(this) &&
        RegExp(r'[0-9]').hasMatch(this) &&
        RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(this);
  }

  /// Capitalizes the first letter of the string
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  /// Capitalizes the first letter of each word
  String get titleCase {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  /// Converts string to camelCase
  String get toCamelCase {
    if (isEmpty) return this;
    List<String> words = split(RegExp(r'[\s_-]+'));
    if (words.isEmpty) return this;

    String result = words.first.toLowerCase();
    for (int i = 1; i < words.length; i++) {
      result += words[i].capitalize;
    }
    return result;
  }

  /// Converts string to snake_case
  String get toSnakeCase {
    return replaceAllMapped(
            RegExp(r'[A-Z]'), (match) => '_${match.group(0)!.toLowerCase()}')
        .replaceAll(RegExp(r'[\s-]+'), '_')
        .replaceAll(RegExp(r'^_'), '');
  }

  /// Converts string to kebab-case
  String get toKebabCase {
    return replaceAllMapped(
            RegExp(r'[A-Z]'), (match) => '-${match.group(0)!.toLowerCase()}')
        .replaceAll(RegExp(r'[\s_]+'), '-')
        .replaceAll(RegExp(r'^-'), '');
  }

  /// Removes all whitespace from the string
  String get removeWhitespace {
    return replaceAll(RegExp(r'\s+'), '');
  }

  /// Removes extra whitespace and trims the string
  String get cleanWhitespace {
    return trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  /// Truncates the string to a specified length with optional ellipsis
  String truncate(int maxLength, {String ellipsis = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - ellipsis.length)}$ellipsis';
  }

  /// Masks the string, showing only the first and last few characters
  String mask(
      {int visibleStart = 2, int visibleEnd = 2, String maskChar = '*'}) {
    if (length <= visibleStart + visibleEnd) return this;

    String start = substring(0, visibleStart);
    String end = substring(length - visibleEnd);
    String middle = maskChar * (length - visibleStart - visibleEnd);

    return '$start$middle$end';
  }

  /// Converts the string to a slug (URL-friendly format)
  String get toSlug {
    return toLowerCase()
        .replaceAll(RegExp(r'[^\w\s-]'), '')
        .replaceAll(RegExp(r'[\s_-]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
  }

  /// Reverses the string
  String get reverse {
    return split('').reversed.join('');
  }

  /// Counts the number of words in the string
  int get wordCount {
    if (trim().isEmpty) return 0;
    return trim().split(RegExp(r'\s+')).length;
  }

  /// Extracts numbers from the string
  List<int> get extractNumbers {
    return RegExp(r'\d+')
        .allMatches(this)
        .map((match) => int.parse(match.group(0)!))
        .toList();
  }

  /// Checks if the string contains any of the given substrings
  bool containsAny(List<String> substrings) {
    return substrings.any((substring) => contains(substring));
  }

  /// Checks if the string contains all of the given substrings
  bool containsAll(List<String> substrings) {
    return substrings.every((substring) => contains(substring));
  }

  /// Removes HTML tags from the string
  String get stripHtml {
    return replaceAll(RegExp(r'<[^>]*>'), '');
  }

  /// Converts the string to a boolean value
  bool? get toBool {
    String lower = toLowerCase().trim();
    if (lower == 'true' || lower == '1' || lower == 'yes') return true;
    if (lower == 'false' || lower == '0' || lower == 'no') return false;
    return null;
  }

  /// Safely converts the string to an integer
  int? get toIntSafe {
    return int.tryParse(this);
  }

  /// Safely converts the string to a double
  double? get toDoubleSafe {
    return double.tryParse(this);
  }

  /// Checks if the string is null or empty
  bool get isNullOrEmpty {
    return isEmpty;
  }

  /// Checks if the string is null, empty, or contains only whitespace
  bool get isNullOrWhitespace {
    return trim().isEmpty;
  }

  /// Returns the string if not empty, otherwise returns the default value
  String ifEmpty(String defaultValue) {
    return isEmpty ? defaultValue : this;
  }

  /// Repeats the string a specified number of times
  String repeat(int times) {
    if (times <= 0) return '';
    return List.filled(times, this).join();
  }

  /// Wraps the string with the specified prefix and suffix
  String wrap(String prefix, [String? suffix]) {
    return '$prefix$this${suffix ?? prefix}';
  }

  /// Removes the specified prefix from the string if it exists
  String removePrefix(String prefix) {
    if (startsWith(prefix)) {
      return substring(prefix.length);
    }
    return this;
  }

  /// Removes the specified suffix from the string if it exists
  String removeSuffix(String suffix) {
    if (endsWith(suffix)) {
      return substring(0, length - suffix.length);
    }
    return this;
  }
}
