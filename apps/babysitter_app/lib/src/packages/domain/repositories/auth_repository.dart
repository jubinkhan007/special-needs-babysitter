import '../entities/auth_session.dart';
import '../entities/user_role.dart';

/// Contract for authentication repository
abstract interface class AuthRepository {
  /// Sign in with email and password
  Future<AuthSession> signIn({
    required String email,
    required String password,
  });

  /// Sign up new user with role selection
  Future<AuthSession> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required UserRole role,
  });

  /// Sign out current user
  Future<void> signOut();

  /// Refresh authentication tokens
  Future<AuthSession> refreshToken(String refreshToken);

  /// Get current session if exists
  Future<AuthSession?> getCurrentSession();

  /// Stream of auth state changes
  Stream<AuthSession?> get authStateChanges;
}
