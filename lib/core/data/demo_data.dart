import 'package:flutter/material.dart';

import '../models/activity_item.dart';
import '../models/stat_item.dart';

/// Demo data for the starter template
class DemoData {
  /// Recent activities for the activity feed
  static const List<ActivityItem> recentActivities = [
    ActivityItem(
      id: '1',
      title: 'Profile Updated',
      description: 'You updated your profile information',
      timestamp: '2 hours ago',
      icon: Icons.person,
      type: ActivityType.profile,
      color: Colors.blue,
    ),
    ActivityItem(
      id: '2',
      title: 'Settings Changed',
      description: 'Theme preference updated to dark mode',
      timestamp: '1 day ago',
      icon: Icons.settings,
      type: ActivityType.settings,
      color: Colors.orange,
    ),
    ActivityItem(
      id: '3',
      title: 'Security Update',
      description: 'Password was successfully changed',
      timestamp: '2 days ago',
      icon: Icons.security,
      type: ActivityType.security,
      color: Colors.green,
    ),
    ActivityItem(
      id: '4',
      title: 'New Feature',
      description: 'Dashboard analytics feature is now available',
      timestamp: '3 days ago',
      icon: Icons.new_releases,
      type: ActivityType.feature,
      color: Colors.purple,
    ),
    ActivityItem(
      id: '5',
      title: 'Data Sync',
      description: 'Your data has been synchronized across devices',
      timestamp: '1 week ago',
      icon: Icons.sync,
      type: ActivityType.data,
      color: Colors.teal,
    ),
    ActivityItem(
      id: '6',
      title: 'System Update',
      description: 'App updated to version 2.1.0',
      timestamp: '1 week ago',
      icon: Icons.system_update,
      type: ActivityType.system,
      color: Colors.indigo,
    ),
  ];

  /// Dashboard statistics
  static const List<StatItem> dashboardStats = [
    StatItem(
      id: '1',
      title: 'Total Users',
      value: '1,234',
      subtitle: 'Active users',
      change: '+12%',
      trendDirection: TrendDirection.up,
      icon: Icons.people,
      color: Colors.blue,
      progress: 0.75,
    ),
    StatItem(
      id: '2',
      title: 'Active Sessions',
      value: '89',
      subtitle: 'Current sessions',
      change: '+5%',
      trendDirection: TrendDirection.up,
      icon: Icons.trending_up,
      color: Colors.green,
      progress: 0.45,
    ),
    StatItem(
      id: '3',
      title: 'Revenue',
      value: '\$12.5K',
      subtitle: 'This month',
      change: '+8%',
      trendDirection: TrendDirection.up,
      icon: Icons.attach_money,
      color: Colors.orange,
      progress: 0.82,
    ),
    StatItem(
      id: '4',
      title: 'Performance',
      value: '98.5%',
      subtitle: 'Uptime',
      change: '-0.2%',
      trendDirection: TrendDirection.down,
      icon: Icons.speed,
      color: Colors.red,
      progress: 0.985,
    ),
  ];

  /// Quick action items for navigation cards
  static const List<QuickAction> quickActions = [
    QuickAction(
      id: 'profile',
      title: 'Profile',
      description: 'Manage your account',
      icon: Icons.person,
      color: Colors.blue,
      route: '/profile',
    ),
    QuickAction(
      id: 'settings',
      title: 'Settings',
      description: 'App preferences',
      icon: Icons.settings,
      color: Colors.grey,
      route: '/settings',
    ),
    QuickAction(
      id: 'analytics',
      title: 'Analytics',
      description: 'View insights',
      icon: Icons.analytics,
      color: Colors.purple,
      route: null, // Coming soon
    ),
    QuickAction(
      id: 'notifications',
      title: 'Notifications',
      description: 'Manage alerts',
      icon: Icons.notifications,
      color: Colors.orange,
      route: null, // Coming soon
    ),
  ];

  /// Feature showcase items
  static const List<FeatureItem> featuresShowcase = [
    FeatureItem(
      id: '1',
      title: 'Clean Architecture',
      description:
          'Built with clean architecture principles for maintainability',
      icon: Icons.architecture,
      color: Colors.blue,
    ),
    FeatureItem(
      id: '2',
      title: 'Responsive Design',
      description: 'Adapts beautifully to all screen sizes and devices',
      icon: Icons.devices,
      color: Colors.green,
    ),
    FeatureItem(
      id: '3',
      title: 'Accessibility',
      description: 'Full accessibility support for all users',
      icon: Icons.accessibility,
      color: Colors.orange,
    ),
    FeatureItem(
      id: '4',
      title: 'State Management',
      description: 'Powered by Riverpod for efficient state management',
      icon: Icons.memory,
      color: Colors.purple,
    ),
    FeatureItem(
      id: '5',
      title: 'Theme Support',
      description: 'Light and dark themes with Material 3 design',
      icon: Icons.palette,
      color: Colors.pink,
    ),
    FeatureItem(
      id: '6',
      title: 'Offline Support',
      description: 'Works seamlessly even without internet connection',
      icon: Icons.offline_bolt,
      color: Colors.teal,
    ),
  ];

  /// Sample user data for demo purposes
  static const Map<String, dynamic> sampleUserData = {
    'totalLogins': 127,
    'lastLoginDays': 2,
    'favoriteFeatures': ['Dashboard', 'Profile', 'Settings'],
    'completedTasks': 45,
    'totalTasks': 60,
    'streakDays': 7,
    'badgesEarned': 12,
  };
}

/// Quick action model for navigation cards
class QuickAction {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String? route;

  const QuickAction({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    this.route,
  });

  /// Whether this action is available (has a route)
  bool get isAvailable => route != null;

  /// Whether this action is coming soon
  bool get isComingSoon => route == null;
}

/// Feature item model for feature showcase
class FeatureItem {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const FeatureItem({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}
