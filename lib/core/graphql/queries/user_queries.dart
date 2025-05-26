/// User-related GraphQL queries
class UserQueries {
  // Private constructor to prevent instantiation
  UserQueries._();

  /// Get current user profile
  static const String getCurrentUser = '''
    query GetCurrentUser {
      users_by_pk(id: \$userId) {
        id
        email
        name
        avatar_url
        created_at
        updated_at
      }
    }
  ''';

  /// Get user by ID
  static const String getUserById = '''
    query GetUserById(\$id: uuid!) {
      users_by_pk(id: \$id) {
        id
        email
        name
        avatar_url
        created_at
        updated_at
      }
    }
  ''';

  /// Get users list with pagination
  static const String getUsers = '''
    query GetUsers(\$limit: Int!, \$offset: Int!, \$where: users_bool_exp) {
      users(limit: \$limit, offset: \$offset, where: \$where, order_by: {created_at: desc}) {
        id
        email
        name
        avatar_url
        created_at
        updated_at
      }
      users_aggregate(where: \$where) {
        aggregate {
          count
        }
      }
    }
  ''';

  /// Search users by name or email
  static const String searchUsers = '''
    query SearchUsers(\$searchTerm: String!, \$limit: Int!) {
      users(
        where: {
          _or: [
            {name: {_ilike: \$searchTerm}},
            {email: {_ilike: \$searchTerm}}
          ]
        },
        limit: \$limit,
        order_by: {name: asc}
      ) {
        id
        email
        name
        avatar_url
        created_at
        updated_at
      }
    }
  ''';

  /// Get user profile with posts
  static const String getUserWithPosts = '''
    query GetUserWithPosts(\$userId: uuid!, \$postsLimit: Int!) {
      users_by_pk(id: \$userId) {
        id
        email
        name
        avatar_url
        created_at
        updated_at
        posts(limit: \$postsLimit, order_by: {created_at: desc}) {
          id
          title
          content
          created_at
          updated_at
        }
        posts_aggregate {
          aggregate {
            count
          }
        }
      }
    }
  ''';
}
