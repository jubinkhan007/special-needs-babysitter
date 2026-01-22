import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:domain/domain.dart';
import 'package:data/data.dart';

import '../session_store.dart';

import 'package:dio/dio.dart';
import 'package:core/core.dart'; // For Constants.baseUrl

/// Provider for SessionStore
final sessionStoreProvider = Provider<SessionStore>((ref) {
  print('>>> BUILD sessionStoreProvider');
  return SessionStore();
});

/// Provider for Auth Dio
final authDioProvider = Provider<Dio>((ref) {
  // Use centralized base URL from core package
  final dio = Dio(BaseOptions(
    baseUrl: Constants.baseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));

  // Add Auth Interceptor to inject Session ID
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      // Avoid circular dependency by reading session store directly if needed,
      // or handling async reading carefully.
      // BUT: authNotifierProvider depends on authRepositoryProvider -> authRemoteDataSourceProvider -> authDioProvider.
      // CIRCULAR DEPENDENCY ALERT!

      // We cannot read authNotifierProvider here because it depends on this provider.
      // We must read backing storage (SessionStore).

      final sessionStore = ref.read(sessionStoreProvider);
      final storedToken = await sessionStore.getAccessToken();

      if (storedToken != null && storedToken.isNotEmpty) {
        options.headers['Cookie'] = 'session_id=$storedToken';
      }

      return handler.next(options);
    },
    onError: (DioException e, handler) async {
      print('DEBUG: AuthDio API Error: ${e.message} ${e.response?.statusCode}');

      // Handle 401 Unauthorized (Token Expired)
      if (e.response?.statusCode == 401) {
        // Skip token refresh for auth endpoints (login, register, etc.)
        // These 401s are for invalid credentials, not expired sessions
        final path = e.requestOptions.path;
        if (path.startsWith('/auth/')) {
          print('DEBUG: AuthDio 401 on auth endpoint ($path), skipping refresh');
          return handler.next(e);
        }

        print('DEBUG: AuthDio encountered 401. Attempting token refresh...');
        final sessionStore = ref.read(sessionStoreProvider);
        final refreshToken = await sessionStore.getRefreshToken();

        if (refreshToken != null && refreshToken.isNotEmpty) {
          try {
            // Create a temporary Dio to avoid circular interceptor issues
            final tempDio = Dio(BaseOptions(
              baseUrl: Constants.baseUrl,
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              },
            ));

            print('DEBUG: AuthDio calling refresh endpoint...');
            // Manually recreate AuthRemoteDataSource to use its valid logic including DTO parsing
            final tempDataSource = AuthRemoteDataSource(tempDio);
            final newSessionDto =
                await tempDataSource.refreshToken(refreshToken);

            print('DEBUG: AuthDio token refresh SUCCESS.');

            // Map to domain entity
            final newSession = AuthMappers.authSessionFromDto(newSessionDto);

            // Update session store
            await sessionStore.saveSession(newSession);

            // Retry original request with new token
            final options = e.requestOptions;
            // Update cookie header
            options.headers['Cookie'] = 'session_id=${newSession.accessToken}';

            // Retry request using the main dio instance
            final cloneReq = await dio.fetch(options);
            return handler.resolve(cloneReq);
          } catch (refreshError) {
            print('DEBUG: AuthDio token refresh FAILED: $refreshError');
            // If refresh fails, clear session and let the 401 propagate
            await sessionStore.clearSession();
            // Invalidate auth state to trigger router redirect to login
            ref.invalidate(authNotifierProvider);
          }
        } else {
          print('DEBUG: AuthDio No refresh token available.');
          await sessionStore.clearSession();
          // Invalidate auth state to trigger router redirect to login
          ref.invalidate(authNotifierProvider);
        }
      }

      return handler.next(e);
    },
  ));

  return dio;
});

/// Provider for AuthRemoteDataSource
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource(ref.watch(authDioProvider));
});

/// Provider for ProfileRemoteDataSource
final profileRemoteDataSourceProvider =
    Provider<ProfileRemoteDataSource>((ref) {
  return ProfileRemoteDataSource(ref.watch(authDioProvider));
});

/// Provider for ProfileRepository (REAL implementation)
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  print('>>> BUILD profileRepositoryProvider (REAL)');
  return ProfileRepositoryImpl(
      remoteDataSource: ref.watch(profileRemoteDataSourceProvider));
});

/// Provider for AuthRepository (REAL implementation)
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  print('>>> BUILD authRepositoryProvider (REAL)');
  final sessionStore = ref.watch(sessionStoreProvider);
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);

  return AuthRepositoryImpl(
    remoteDataSource: remoteDataSource,
    onSessionChanged: (session) async {
      if (session != null) {
        await sessionStore.saveSession(session);
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

    // If we have a session, refresh the user profile to ensure up-to-date status
    if (session != null) {
      try {
        print('DEBUG: AuthNotifier refreshing user profile...');
        final profileRepo = ref.read(profileRepositoryProvider);
        final freshUser = await profileRepo.getMe();

        // If profile status changed, update session
        if (freshUser.isProfileComplete != session.user.isProfileComplete ||
            freshUser.role != session.user.role) {
          print(
              'DEBUG: AuthNotifier detected stale session data. freshUser.isProfileComplete=${freshUser.isProfileComplete}, session.user.isProfileComplete=${session.user.isProfileComplete}');
          final updatedSession = session.copyWith(user: freshUser);
          await ref.read(sessionStoreProvider).saveSession(updatedSession);
          return updatedSession;
        }
      } catch (e) {
        print('DEBUG: AuthNotifier failed to refresh profile: $e');
        // Continue with stored session if fetch fails (offline etc)
      }
    }

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
    UserRole? role, // Added optional role
  }) async {
    print('DEBUG: AuthNotifier.verifyOtp called with role=$role');
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

      // PRE-SAVE SESSION: Save initial session so token is available for API calls
      // This fixes the 401 error when fetching using authDio which relies on sessionStore/headers
      await ref.read(sessionStoreProvider).saveSession(session);

      // Force fetch full profile to ensure role is correct
      // This fixes the issue where verifyOtp response might contain partial user data (role: parent default)
      User user = session.user;
      try {
        final profileRepo = ref.read(profileRepositoryProvider);
        // Only fetch if we have a token (which we should)
        user = await profileRepo.getMe();
        print(
            'DEBUG: AuthNotifier.verifyOtp Fetched Profile: Role=${user.role}');
      } catch (e) {
        print('DEBUG: Failed to fetch profile after OTP: $e');
        // Fallback to session user
      }

      // FALLBACK: If fetched user is parent but we KNOW it should be sitter (passed in param),
      // force update the user object. This handles backend returning default/wrong role.
      if (role != null && user.role != role) {
        print(
            'DEBUG: AuthNotifier FORCE PATCHING role from ${user.role} to $role');
        user = user.copyWith(role: role);
      }

      final updatedSession = session.copyWith(user: user);

      // Save session with FULL user profile
      await ref.read(sessionStoreProvider).saveSession(updatedSession);

      return updatedSession;
    });

    if (state.hasError) {
      print('DEBUG: AuthNotifier.verifyOtp ERROR: ${state.error}');
    }
  }

  Future<void> refreshProfile() async {
    final session = state.valueOrNull;
    if (session == null) return;

    try {
      print('DEBUG: AuthNotifier.refreshProfile called');
      final profileRepo = ref.read(profileRepositoryProvider);
      final freshUser = await profileRepo.getMe();

      final updatedSession = session.copyWith(user: freshUser);
      await ref.read(sessionStoreProvider).saveSession(updatedSession);
      state = AsyncValue.data(updatedSession);
      print(
          'DEBUG: AuthNotifier.refreshProfile success. isProfileComplete=${freshUser.isProfileComplete}');
    } catch (e, st) {
      print('DEBUG: AuthNotifier.refreshProfile failed: $e');
      // If we can't refresh, keep the state as is
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
