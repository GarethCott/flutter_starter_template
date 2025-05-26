/// User-related GraphQL mutations
class UserMutations {
  // Private constructor to prevent instantiation
  UserMutations._();

  /// Update user profile
  static const String updateUserProfile = '''
    mutation UpdateUserProfile(\$id: uuid!, \$changes: users_set_input!) {
      update_users_by_pk(pk_columns: {id: \$id}, _set: \$changes) {
        id
        email
        name
        avatar_url
        updated_at
      }
    }
  ''';

  /// Create new user
  static const String createUser = '''
    mutation CreateUser(\$user: users_insert_input!) {
      insert_users_one(object: \$user) {
        id
        email
        name
        avatar_url
        created_at
        updated_at
      }
    }
  ''';

  /// Delete user account
  static const String deleteUser = '''
    mutation DeleteUser(\$id: uuid!) {
      delete_users_by_pk(id: \$id) {
        id
        email
        name
      }
    }
  ''';

  /// Update user avatar
  static const String updateUserAvatar = '''
    mutation UpdateUserAvatar(\$id: uuid!, \$avatarUrl: String!) {
      update_users_by_pk(pk_columns: {id: \$id}, _set: {avatar_url: \$avatarUrl}) {
        id
        avatar_url
        updated_at
      }
    }
  ''';

  /// Update user password (if handled by Hasura)
  static const String updateUserPassword = '''
    mutation UpdateUserPassword(\$id: uuid!, \$passwordHash: String!) {
      update_users_by_pk(pk_columns: {id: \$id}, _set: {password_hash: \$passwordHash}) {
        id
        updated_at
      }
    }
  ''';

  /// Update user email
  static const String updateUserEmail = '''
    mutation UpdateUserEmail(\$id: uuid!, \$email: String!) {
      update_users_by_pk(pk_columns: {id: \$id}, _set: {email: \$email, email_verified: false}) {
        id
        email
        email_verified
        updated_at
      }
    }
  ''';

  /// Verify user email
  static const String verifyUserEmail = '''
    mutation VerifyUserEmail(\$id: uuid!) {
      update_users_by_pk(pk_columns: {id: \$id}, _set: {email_verified: true}) {
        id
        email
        email_verified
        updated_at
      }
    }
  ''';
}
