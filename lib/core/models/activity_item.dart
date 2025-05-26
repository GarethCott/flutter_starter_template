import 'package:flutter/material.dart';

/// Activity types for categorization
enum ActivityType {
  profile,
  settings,
  security,
  notification,
  system,
  user,
  data,
  feature,
}

/// Activity item model for demo data
class ActivityItem {
  final String id;
  final String title;
  final String description;
  final String timestamp;
  final IconData icon;
  final ActivityType type;
  final Color? color;
  final bool isRead;

  const ActivityItem({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.icon,
    required this.type,
    this.color,
    this.isRead = false,
  });

  ActivityItem copyWith({
    String? id,
    String? title,
    String? description,
    String? timestamp,
    IconData? icon,
    ActivityType? type,
    Color? color,
    bool? isRead,
  }) {
    return ActivityItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      timestamp: timestamp ?? this.timestamp,
      icon: icon ?? this.icon,
      type: type ?? this.type,
      color: color ?? this.color,
      isRead: isRead ?? this.isRead,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ActivityItem &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.timestamp == timestamp &&
        other.icon == icon &&
        other.type == type &&
        other.color == color &&
        other.isRead == isRead;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      title,
      description,
      timestamp,
      icon,
      type,
      color,
      isRead,
    );
  }

  @override
  String toString() {
    return 'ActivityItem(id: $id, title: $title, type: $type, isRead: $isRead)';
  }
}
