/// Comprehensive form validators for common validation needs
class FormValidators {
  // Private constructor to prevent instantiation
  FormValidators._();

  // Email Validation

  /// Validates email address format
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  /// Validates email with custom error messages
  static String? validateEmailWithMessages(
    String? value, {
    String? requiredMessage,
    String? invalidMessage,
  }) {
    if (value == null || value.isEmpty) {
      return requiredMessage ?? 'Email is required';
    }

    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return invalidMessage ?? 'Please enter a valid email address';
    }

    return null;
  }

  // Password Validation

  /// Validates password with basic requirements
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }

    if (!RegExp(r'[a-zA-Z]').hasMatch(value)) {
      return 'Password must contain at least one letter';
    }

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }

    return null;
  }

  /// Validates strong password with comprehensive requirements
  static String? validateStrongPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }

    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }

    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }

    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Password must contain at least one special character';
    }

    return null;
  }

  /// Validates password confirmation
  static String? validatePasswordConfirmation(
    String? value,
    String? originalPassword,
  ) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != originalPassword) {
      return 'Passwords do not match';
    }

    return null;
  }

  // Phone Number Validation

  /// Validates phone number format
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    // Remove all non-digit characters for validation
    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');

    if (digitsOnly.length < 10) {
      return 'Phone number must be at least 10 digits';
    }

    if (digitsOnly.length > 15) {
      return 'Phone number cannot exceed 15 digits';
    }

    return null;
  }

  /// Validates US phone number format
  static String? validateUSPhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');

    if (digitsOnly.length == 10) {
      return null; // Valid 10-digit US number
    } else if (digitsOnly.length == 11 && digitsOnly.startsWith('1')) {
      return null; // Valid 11-digit US number with country code
    } else {
      return 'Please enter a valid US phone number';
    }
  }

  // Name Validation

  /// Validates first name
  static String? validateFirstName(String? value) {
    if (value == null || value.isEmpty) {
      return 'First name is required';
    }

    if (value.length < 2) {
      return 'First name must be at least 2 characters long';
    }

    if (value.length > 50) {
      return 'First name cannot exceed 50 characters';
    }

    if (!RegExp(r"^[a-zA-Z\s\-'\.]+$").hasMatch(value)) {
      return 'First name can only contain letters, spaces, hyphens, apostrophes, and periods';
    }

    return null;
  }

  /// Validates last name
  static String? validateLastName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Last name is required';
    }

    if (value.length < 2) {
      return 'Last name must be at least 2 characters long';
    }

    if (value.length > 50) {
      return 'Last name cannot exceed 50 characters';
    }

    if (!RegExp(r"^[a-zA-Z\s\-'\.]+$").hasMatch(value)) {
      return 'Last name can only contain letters, spaces, hyphens, apostrophes, and periods';
    }

    return null;
  }

  /// Validates full name
  static String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Full name is required';
    }

    if (value.trim().split(' ').length < 2) {
      return 'Please enter your full name (first and last name)';
    }

    if (value.length < 3) {
      return 'Full name must be at least 3 characters long';
    }

    if (value.length > 100) {
      return 'Full name cannot exceed 100 characters';
    }

    if (!RegExp(r"^[a-zA-Z\s\-'\.]+$").hasMatch(value)) {
      return 'Name can only contain letters, spaces, hyphens, apostrophes, and periods';
    }

    return null;
  }

  // Username Validation

  /// Validates username
  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }

    if (value.length < 3) {
      return 'Username must be at least 3 characters long';
    }

    if (value.length > 30) {
      return 'Username cannot exceed 30 characters';
    }

    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
      return 'Username can only contain letters, numbers, and underscores';
    }

    if (RegExp(r'^[0-9]').hasMatch(value)) {
      return 'Username cannot start with a number';
    }

    return null;
  }

  // URL Validation

  /// Validates URL format
  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return 'URL is required';
    }

    final urlRegex = RegExp(r'^https?:\/\/[^\s/$.?#].[^\s]*$');
    if (!urlRegex.hasMatch(value)) {
      return 'Please enter a valid URL';
    }

    return null;
  }

  // Numeric Validation

  /// Validates that input is a number
  static String? validateNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }

    if (double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }

    return null;
  }

  /// Validates integer
  static String? validateInteger(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }

    if (int.tryParse(value) == null) {
      return 'Please enter a valid integer';
    }

    return null;
  }

  /// Validates positive number
  static String? validatePositiveNumber(String? value) {
    final numberValidation = validateNumber(value);
    if (numberValidation != null) return numberValidation;

    final number = double.parse(value!);
    if (number <= 0) {
      return 'Please enter a positive number';
    }

    return null;
  }

  /// Validates number within range
  static String? validateNumberInRange(
    String? value,
    double min,
    double max,
  ) {
    final numberValidation = validateNumber(value);
    if (numberValidation != null) return numberValidation;

    final number = double.parse(value!);
    if (number < min || number > max) {
      return 'Please enter a number between $min and $max';
    }

    return null;
  }

  // Length Validation

  /// Validates minimum length
  static String? validateMinLength(String? value, int minLength) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }

    if (value.length < minLength) {
      return 'Must be at least $minLength characters long';
    }

    return null;
  }

  /// Validates maximum length
  static String? validateMaxLength(String? value, int maxLength) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }

    if (value.length > maxLength) {
      return 'Cannot exceed $maxLength characters';
    }

    return null;
  }

  /// Validates exact length
  static String? validateExactLength(String? value, int exactLength) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }

    if (value.length != exactLength) {
      return 'Must be exactly $exactLength characters long';
    }

    return null;
  }

  // Required Field Validation

  /// Validates that field is not empty
  static String? validateRequired(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }

    return null;
  }

  // Date Validation

  /// Validates date format (YYYY-MM-DD)
  static String? validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Date is required';
    }

    try {
      DateTime.parse(value);
      return null;
    } catch (e) {
      return 'Please enter a valid date (YYYY-MM-DD)';
    }
  }

  /// Validates age (must be 18 or older)
  static String? validateAge(String? value) {
    final dateValidation = validateDate(value);
    if (dateValidation != null) return dateValidation;

    final birthDate = DateTime.parse(value!);
    final today = DateTime.now();
    final age = today.year - birthDate.year;

    if (age < 18) {
      return 'You must be at least 18 years old';
    }

    return null;
  }

  // Credit Card Validation

  /// Validates credit card number using Luhn algorithm
  static String? validateCreditCard(String? value) {
    if (value == null || value.isEmpty) {
      return 'Credit card number is required';
    }

    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');

    if (digitsOnly.length < 13 || digitsOnly.length > 19) {
      return 'Please enter a valid credit card number';
    }

    // Luhn algorithm
    int sum = 0;
    bool alternate = false;

    for (int i = digitsOnly.length - 1; i >= 0; i--) {
      int digit = int.parse(digitsOnly[i]);

      if (alternate) {
        digit *= 2;
        if (digit > 9) {
          digit = (digit % 10) + 1;
        }
      }

      sum += digit;
      alternate = !alternate;
    }

    if (sum % 10 != 0) {
      return 'Please enter a valid credit card number';
    }

    return null;
  }

  /// Validates CVV
  static String? validateCVV(String? value) {
    if (value == null || value.isEmpty) {
      return 'CVV is required';
    }

    if (!RegExp(r'^[0-9]{3,4}$').hasMatch(value)) {
      return 'CVV must be 3 or 4 digits';
    }

    return null;
  }

  // Custom Validators

  /// Creates a custom validator that combines multiple validators
  static String? Function(String?) combineValidators(
    List<String? Function(String?)> validators,
  ) {
    return (String? value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) return result;
      }
      return null;
    };
  }

  /// Creates a conditional validator
  static String? Function(String?) conditionalValidator(
    bool Function() condition,
    String? Function(String?) validator,
  ) {
    return (String? value) {
      if (condition()) {
        return validator(value);
      }
      return null;
    };
  }
}
