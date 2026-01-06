import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:domain/domain.dart';
import 'package:data/data.dart';

import '../session_store.dart';

/// Provider for SessionStore
final sessionStoreProvider = Provider<SessionStore>((ref) {
  print('>>> BUILD sessionStoreProvider');
  return SessionStore();
});

/// Provider for FakeProfileRepository (shared instance)
final fakeProfileRepositoryProvider =
    Provider<FakeProfileRepositoryImpl>((ref) {
  print('>>> BUILD fakeProfileRepositoryProvider');
  return FakeProfileRepositoryImpl();
});

/// Provider for ProfileRepository
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  print('>>> BUILD profileRepositoryProvider');
  return ref.watch(fakeProfileRepositoryProvider);
});

/// Provider for AuthRepository (fake implementation for now)
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  print('>>> BUILD authRepositoryProvider');
  final sessionStore = ref.watch(sessionStoreProvider);
  final profileRepo = ref.watch(fakeProfileRepositoryProvider);

  return FakeAuthRepositoryImpl(
    onSessionChanged: (session, {User? user}) async {
      if (session != null) {
        await sessionStore.saveSession(session);
        // Also update profile cache
        if (user != null) {
          profileRepo.setCachedUser(user);
        }
      } else {
        await sessionStore.clearSession();
      }
    },
    getStoredSession: () => sessionStore.loadSession(),
  );
});

/// Provider for SignInUseCase
final signInUseCaseProvider = Provider<SignInUseCase>((ref) {
  return SignInUseCase(ref.watch(authRepositoryProvider));
});

/// Provider for SignUpUseCase
final signUpUseCaseProvider = Provider<SignUpUseCase>((ref) {
  return SignUpUseCase(ref.watch(authRepositoryProvider));
});

/// Provider for SignOutUseCase
final signOutUseCaseProvider = Provider<SignOutUseCase>((ref) {
  return SignOutUseCase(ref.watch(authRepositoryProvider));
});

/// Auth state notifier for handling auth operations
class AuthNotifier extends AsyncNotifier<AuthSession?> {
  @override
  Future<AuthSession?> build() async {
    print('>>> BUILD authNotifierProvider');
    return ref.read(authRepositoryProvider).getCurrentSession();
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return ref.read(signInUseCaseProvider).call(
            SignInParams(email: email, password: password),
          );
    });
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required UserRole role,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return ref.read(signUpUseCaseProvider).call(
            SignUpParams(
              email: email,
              password: password,
              firstName: firstName,
              lastName: lastName,
              role: role,
            ),
          );
    });
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    await ref.read(signOutUseCaseProvider).call(const NoParams());
    state = const AsyncValue.data(null);
  }
}

/// Provider for AuthNotifier
final authNotifierProvider =
    AsyncNotifierProvider<AuthNotifier, AuthSession?>(() {
  return AuthNotifier();
});

/// Provider for current authenticated user (fetched from profile)
/// Only attempts fetch when there's an active session
final currentUserProvider = FutureProvider<User?>((ref) async {
  print('>>> BUILD currentUserProvider');
  final authState = ref.watch(authNotifierProvider);

  // Don't fetch if not authenticated
  if (authState.valueOrNull == null) {
    return null;
  }

  // Fetch user profile
  try {
    final profileRepo = ref.read(profileRepositoryProvider);
    return await profileRepo.getMe();
  } catch (e) {
    // Return null on error - let UI handle redirect
    return null;
  }
});
