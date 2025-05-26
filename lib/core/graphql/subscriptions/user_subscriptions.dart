/// User-related GraphQL subscriptions
class UserSubscriptions {
  // Private constructor to prevent instantiation
  UserSubscriptions._();

  /// Subscribe to current user profile changes
  static const String subscribeToUserProfile = '''
    subscription SubscribeToUserProfile(\$userId: uuid!) {
      users_by_pk(id: \$userId) {
        id
        email
        name
        avatar_url
        updated_at
      }
    }
  ''';

  /// Subscribe to user status changes (online/offline)
  static const String subscribeToUserStatus = '''
    subscription SubscribeToUserStatus(\$userId: uuid!) {
      users_by_pk(id: \$userId) {
        id
        last_seen
        is_online
      }
    }
  ''';

  /// Subscribe to new users (admin only)
  static const String subscribeToNewUsers = '''
    subscription SubscribeToNewUsers {
      users(order_by: {created_at: desc}, limit: 10) {
        id
        email
        name
        avatar_url
        created_at
      }
    }
  ''';

  /// Subscribe to user activity feed
  static const String subscribeToUserActivity = '''
    subscription SubscribeToUserActivity(\$userId: uuid!) {
      user_activities(
        where: {user_id: {_eq: \$userId}},
        order_by: {created_at: desc},
        limit: 20
      ) {
        id
        activity_type
        description
        metadata
        created_at
        user {
          id
          name
          avatar_url
        }
      }
    }
  ''';

  /// Subscribe to user notifications
  static const String subscribeToUserNotifications = '''
    subscription SubscribeToUserNotifications(\$userId: uuid!) {
      notifications(
        where: {user_id: {_eq: \$userId}, is_read: {_eq: false}},
        order_by: {created_at: desc}
      ) {
        id
        title
        message
        type
        is_read
        created_at
        metadata
      }
    }
  ''';
}
