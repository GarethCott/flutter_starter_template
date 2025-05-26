import 'package:intl/intl.dart';

/// DateTime extensions for formatting and utility functions
extension DateTimeExtensions on DateTime {
  /// Formats the date as a readable string (e.g., "Jan 15, 2024")
  String get toReadableDate {
    return DateFormat('MMM dd, yyyy').format(this);
  }

  /// Formats the date as a short string (e.g., "01/15/24")
  String get toShortDate {
    return DateFormat('MM/dd/yy').format(this);
  }

  /// Formats the time as a readable string (e.g., "2:30 PM")
  String get toReadableTime {
    return DateFormat('h:mm a').format(this);
  }

  /// Formats the date and time as a readable string (e.g., "Jan 15, 2024 at 2:30 PM")
  String get toReadableDateTime {
    return DateFormat('MMM dd, yyyy \'at\' h:mm a').format(this);
  }

  /// Formats the date in ISO 8601 format
  String get toIso8601String {
    return toUtc().toIso8601String();
  }

  /// Returns a relative time string (e.g., "2 hours ago", "in 3 days")
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.isNegative) {
      // Future date
      final futureDifference = this.difference(now);
      return _formatFutureDifference(futureDifference);
    }

    return _formatPastDifference(difference);
  }

  /// Returns true if the date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Returns true if the date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Returns true if the date is tomorrow
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year &&
        month == tomorrow.month &&
        day == tomorrow.day;
  }

  /// Returns true if the date is in the current week
  bool get isThisWeek {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
        isBefore(endOfWeek.add(const Duration(days: 1)));
  }

  /// Returns true if the date is in the current month
  bool get isThisMonth {
    final now = DateTime.now();
    return year == now.year && month == now.month;
  }

  /// Returns true if the date is in the current year
  bool get isThisYear {
    final now = DateTime.now();
    return year == now.year;
  }

  /// Returns the start of the day (00:00:00)
  DateTime get startOfDay {
    return DateTime(year, month, day);
  }

  /// Returns the end of the day (23:59:59.999)
  DateTime get endOfDay {
    return DateTime(year, month, day, 23, 59, 59, 999);
  }

  /// Returns the start of the week (Monday)
  DateTime get startOfWeek {
    return subtract(Duration(days: weekday - 1)).startOfDay;
  }

  /// Returns the end of the week (Sunday)
  DateTime get endOfWeek {
    return add(Duration(days: 7 - weekday)).endOfDay;
  }

  /// Returns the start of the month
  DateTime get startOfMonth {
    return DateTime(year, month, 1);
  }

  /// Returns the end of the month
  DateTime get endOfMonth {
    return DateTime(year, month + 1, 1)
        .subtract(const Duration(days: 1))
        .endOfDay;
  }

  /// Returns the start of the year
  DateTime get startOfYear {
    return DateTime(year, 1, 1);
  }

  /// Returns the end of the year
  DateTime get endOfYear {
    return DateTime(year, 12, 31).endOfDay;
  }

  /// Returns the age in years from this date to now
  int get ageInYears {
    final now = DateTime.now();
    int age = now.year - year;
    if (now.month < month || (now.month == month && now.day < day)) {
      age--;
    }
    return age;
  }

  /// Returns the number of days in the current month
  int get daysInMonth {
    return DateTime(year, month + 1, 0).day;
  }

  /// Returns true if the year is a leap year
  bool get isLeapYear {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  }

  /// Returns the quarter of the year (1-4)
  int get quarter {
    return ((month - 1) / 3).floor() + 1;
  }

  /// Returns the week number of the year
  int get weekOfYear {
    final firstDayOfYear = DateTime(year, 1, 1);
    final daysSinceFirstDay = difference(firstDayOfYear).inDays;
    return ((daysSinceFirstDay + firstDayOfYear.weekday) / 7).ceil();
  }

  /// Adds business days (excluding weekends)
  DateTime addBusinessDays(int days) {
    DateTime result = this;
    int addedDays = 0;

    while (addedDays < days) {
      result = result.add(const Duration(days: 1));
      if (result.weekday < 6) {
        // Monday = 1, Friday = 5
        addedDays++;
      }
    }

    return result;
  }

  /// Returns true if the date is a weekend (Saturday or Sunday)
  bool get isWeekend {
    return weekday == DateTime.saturday || weekday == DateTime.sunday;
  }

  /// Returns true if the date is a weekday (Monday to Friday)
  bool get isWeekday {
    return !isWeekend;
  }

  /// Formats the date according to the given pattern
  String format(String pattern) {
    return DateFormat(pattern).format(this);
  }

  /// Returns a copy of this DateTime with the time set to the specified values
  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) {
    return DateTime(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour ?? this.hour,
      minute ?? this.minute,
      second ?? this.second,
      millisecond ?? this.millisecond,
      microsecond ?? this.microsecond,
    );
  }

  /// Helper method to format past differences
  String _formatPastDifference(Duration difference) {
    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }

  /// Helper method to format future differences
  String _formatFutureDifference(Duration difference) {
    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return 'in $years ${years == 1 ? 'year' : 'years'}';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return 'in $months ${months == 1 ? 'month' : 'months'}';
    } else if (difference.inDays > 0) {
      return 'in ${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'}';
    } else if (difference.inHours > 0) {
      return 'in ${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'}';
    } else if (difference.inMinutes > 0) {
      return 'in ${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'}';
    } else {
      return 'In a moment';
    }
  }
}
