import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Use case for getting the current authenticated user
class GetCurrentUserUseCase {
  final AuthRepository _repository;

  const GetCurrentUserUseCase(this._repository);

  /// Execute the get current user operation
  Future<User?> call() async {
    try {
      return await _repository.getCurrentUser();
    } catch (e) {
      // Log error if needed, but return null for now
      return null;
    }
  }

  /// Get current user stream
  Stream<User?> get stream => _repository.authStateChanges;
}
