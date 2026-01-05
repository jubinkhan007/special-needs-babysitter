import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:domain/domain.dart';

import 'auth_providers.dart';

/// Provider for current auth session
final authSessionProvider = FutureProvider<AuthSession?>((ref) async {
  return ref.watch(authRepositoryProvider).getCurrentSession();
});

/// Provider for checking if user is authenticated
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.valueOrNull != null;
});

/// Provider for current user's role (null if not authenticated)
final currentUserRoleProvider = Provider<UserRole?>((ref) {
  final userAsync = ref.watch(currentUserProvider);
  return userAsync.valueOrNull?.role;
});

/// Provider for current access token (for use by networking layer)
final accessTokenProvider = Provider<String?>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.valueOrNull?.accessToken;
});
