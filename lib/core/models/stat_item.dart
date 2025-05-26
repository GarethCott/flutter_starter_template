import 'package:flutter/material.dart';

/// Trend direction for statistics
enum TrendDirection {
  up,
  down,
  neutral,
}

/// Statistic item model for dashboard demo data
class StatItem {
  final String id;
  final String title;
  final String value;
  final String? subtitle;
  final String? change;
  final TrendDirection? trendDirection;
  final IconData icon;
  final Color? color;
  final double? progress;
  final String? unit;

  const StatItem({
    required this.id,
    required this.title,
    required this.value,
    this.subtitle,
    this.change,
    this.trendDirection,
    required this.icon,
    this.color,
    this.progress,
    this.unit,
  });

  /// Whether the trend is positive (up)
  bool get isPositive => trendDirection == TrendDirection.up;

  /// Whether the trend is negative (down)
  bool get isNegative => trendDirection == TrendDirection.down;

  /// Whether the trend is neutral
  bool get isNeutral => trendDirection == TrendDirection.neutral;

  /// Get trend icon based on direction
  IconData get trendIcon {
    switch (trendDirection) {
      case TrendDirection.up:
        return Icons.trending_up;
      case TrendDirection.down:
        return Icons.trending_down;
      case TrendDirection.neutral:
        return Icons.trending_flat;
      case null:
        return Icons.remove;
    }
  }

  /// Get trend color based on direction
  Color getTrendColor(BuildContext context) {
    switch (trendDirection) {
      case TrendDirection.up:
        return Colors.green;
      case TrendDirection.down:
        return Colors.red;
      case TrendDirection.neutral:
        return Theme.of(context).colorScheme.onSurfaceVariant;
      case null:
        return Theme.of(context).colorScheme.onSurfaceVariant;
    }
  }

  StatItem copyWith({
    String? id,
    String? title,
    String? value,
    String? subtitle,
    String? change,
    TrendDirection? trendDirection,
    IconData? icon,
    Color? color,
    double? progress,
    String? unit,
  }) {
    return StatItem(
      id: id ?? this.id,
      title: title ?? this.title,
      value: value ?? this.value,
      subtitle: subtitle ?? this.subtitle,
      change: change ?? this.change,
      trendDirection: trendDirection ?? this.trendDirection,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      progress: progress ?? this.progress,
      unit: unit ?? this.unit,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StatItem &&
        other.id == id &&
        other.title == title &&
        other.value == value &&
        other.subtitle == subtitle &&
        other.change == change &&
        other.trendDirection == trendDirection &&
        other.icon == icon &&
        other.color == color &&
        other.progress == progress &&
        other.unit == unit;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      title,
      value,
      subtitle,
      change,
      trendDirection,
      icon,
      color,
      progress,
      unit,
    );
  }

  @override
  String toString() {
    return 'StatItem(id: $id, title: $title, value: $value, trend: $trendDirection)';
  }
}
