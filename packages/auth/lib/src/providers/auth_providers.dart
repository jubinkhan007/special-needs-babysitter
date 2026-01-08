import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:domain/domain.dart';
import 'package:data/data.dart';

import '../session_store.dart';

import 'package:dio/dio.dart'; // Added dio import

/// Provider for SessionStore
final sessionStoreProvider = Provider<SessionStore>((ref) {
  print('>>> BUILD sessionStoreProvider');
  return SessionStore();
});

/// Provider for Auth Dio
final authDioProvider = Provider<Dio>((ref) {
  // Use the same base URL as the rest of the app
  return Dio(BaseOptions(
    baseUrl: 'https://sns-apis.tausifk.com/api',
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));
});

/// Provider for AuthRemoteDataSource
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource(ref.watch(authDioProvider));
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
  // Ideally this should also be real, but let's stick to fixing Auth first
  return ref.watch(fakeProfileRepositoryProvider);
});

/// Provider for AuthRepository (REAL implementation)
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  print('>>> BUILD authRepositoryProvider (REAL)');
  final sessionStore = ref.watch(sessionStoreProvider);
  final profileRepo = ref.watch(fakeProfileRepositoryProvider);
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);

  return AuthRepositoryImpl(
    remoteDataSource: remoteDataSource,
    onSessionChanged: (session) async {
      // Changed callback signature to match AuthRepositoryImpl (User? user is not passed in Real impl)
      // Real impl calculates user from session.
      // But wait: AuthRepositoryImpl._onSessionChanged signature is (AuthSession?)
      // FakeAuthRepositoryImpl was (AuthSession?, {User? user})
      // So we need to adapt.

      if (session != null) {
        await sessionStore.saveSession(session);
        // Helper to update profile cache from session user
        profileRepo.setCachedUser(session.user);
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
    print('DEBUG: AuthNotifier.build called');
    final session = await ref.read(authRepositoryProvider).getCurrentSession();
    print('DEBUG: AuthNotifier.build session loaded: ${session != null}');
    return session;
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    print('DEBUG: AuthNotifier.signIn called');
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final res = await ref.read(signInUseCaseProvider).call(
            SignInParams(email: email, password: password),
          );
      print('DEBUG: AuthNotifier.signIn success. Res: $res');
      return res;
    });
    if (state.hasError) {
      print('DEBUG: AuthNotifier.signIn ERROR: ${state.error}');
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required UserRole role,
  }) async {
    print('DEBUG: AuthNotifier.signUp called');
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final res = await ref.read(signUpUseCaseProvider).call(
            SignUpParams(
              email: email,
              password: password,
              firstName: firstName,
              lastName: lastName,
              role: role,
            ),
          );
      print('DEBUG: AuthNotifier.signUp success. Res: $res');
      return res;
    });
    if (state.hasError) {
      print('DEBUG: AuthNotifier.signUp ERROR: ${state.error}');
    }
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    await ref.read(signOutUseCaseProvider).call(const NoParams());
    state = const AsyncValue.data(null);
  }

  Future<void> verifyOtp({
    required String code,
    String? email,
    String? phone,
    String? userId,
  }) async {
    print('DEBUG: AuthNotifier.verifyOtp called');
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final session = await ref.read(verifyOtpUseCaseProvider).call(
            OtpVerifyPayload(
              code: code,
              email: email,
              phone: phone,
              userId: userId,
            ),
          );

      print(
          'DEBUG: AuthNotifier.verifyOtp success. Session: ${session.accessToken}');

      // CRITICAL: Manually save session as RegistrationRepository doesn't do it
      await ref.read(sessionStoreProvider).saveSession(session);

      return session;
    });

    if (state.hasError) {
      print('DEBUG: AuthNotifier.verifyOtp ERROR: ${state.error}');
    }
  }
}

/// Provider for RegistrationRemoteDataSource
final registrationRemoteDataSourceProvider =
    Provider<RegistrationRemoteDataSource>((ref) {
  return RegistrationRemoteDataSource(ref.watch(authDioProvider));
});

/// Provider for RegistrationRepository
final registrationRepositoryProvider = Provider<RegistrationRepository>((ref) {
  return RegistrationRepositoryImpl(
      ref.watch(registrationRemoteDataSourceProvider));
});

/// Provider for VerifyOtpUseCase
final verifyOtpUseCaseProvider = Provider<VerifyOtpUseCase>((ref) {
  return VerifyOtpUseCase(ref.watch(registrationRepositoryProvider));
});

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
