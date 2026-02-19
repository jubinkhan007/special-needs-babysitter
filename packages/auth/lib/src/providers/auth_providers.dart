import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:domain/domain.dart';
import 'package:data/data.dart';
import 'package:notifications/notifications.dart';

import '../session_store.dart';

import 'package:dio/dio.dart';
import 'package:core/core.dart'; // For EnvConfig.apiBaseUrl
import 'package:flutter/foundation.dart';

/// Provider for SessionStore
final sessionStoreProvider = Provider<SessionStore>((ref) {
  debugPrint('>>> BUILD sessionStoreProvider');
  return SessionStore();
});

/// Provider for Auth Dio
final authDioProvider = Provider<Dio>((ref) {
  // Use centralized base URL from core package
  final dio = Dio(BaseOptions(
    baseUrl: EnvConfig.apiBaseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ),);

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
      debugPrint('DEBUG: AuthDio API Error: ${e.message} ${e.response?.statusCode}');

      // Handle 401 Unauthorized (Token Expired)
      if (e.response?.statusCode == 401) {
        // Skip token refresh for auth endpoints (login, register, etc.)
        // These 401s are for invalid credentials, not expired sessions
        final path = e.requestOptions.path;
        if (path.startsWith('/auth/')) {
          debugPrint(
              'DEBUG: AuthDio 401 on auth endpoint ($path), skipping refresh',);
          return handler.next(e);
        }

        debugPrint('DEBUG: AuthDio encountered 401. Attempting token refresh...');
        final sessionStore = ref.read(sessionStoreProvider);
        final refreshToken = await sessionStore.getRefreshToken();

        if (refreshToken != null && refreshToken.isNotEmpty) {
          try {
            // Create a temporary Dio to avoid circular interceptor issues
            final tempDio = Dio(BaseOptions(
              baseUrl: EnvConfig.apiBaseUrl,
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              },
            ),);

            debugPrint('DEBUG: AuthDio calling refresh endpoint...');
            // Manually recreate AuthRemoteDataSource to use its valid logic including DTO parsing
            final tempDataSource = AuthRemoteDataSource(tempDio);
            final newSessionDto =
                await tempDataSource.refreshToken(refreshToken);

            debugPrint('DEBUG: AuthDio token refresh SUCCESS.');

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
            debugPrint('DEBUG: AuthDio token refresh FAILED: $refreshError');
            // If refresh fails, clear session and let the 401 propagate
            await sessionStore.clearSession();
            // Invalidate auth state to trigger router redirect to login
            ref.invalidate(authNotifierProvider);
          }
        } else {
          debugPrint('DEBUG: AuthDio No refresh token available.');
          await sessionStore.clearSession();
          // Invalidate auth state to trigger router redirect to login
          ref.invalidate(authNotifierProvider);
        }
      }

      return handler.next(e);
    },
  ),);

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
  debugPrint('>>> BUILD profileRepositoryProvider (REAL)');
  return ProfileRepositoryImpl(
      remoteDataSource: ref.watch(profileRemoteDataSourceProvider),);
});

/// Provider for AuthRepository (REAL implementation)
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  debugPrint('>>> BUILD authRepositoryProvider (REAL)');
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
  bool _isRegisteringFcmToken = false;

  @override
  Future<AuthSession?> build() async {
    debugPrint('DEBUG: AuthNotifier.build called');
    final session = await ref.read(authRepositoryProvider).getCurrentSession();
    debugPrint('DEBUG: AuthNotifier.build session loaded: ${session != null}');

    // If we have a session, refresh the user profile to ensure up-to-date status
    if (session != null) {
      try {
        debugPrint('DEBUG: AuthNotifier refreshing user profile...');
        final profileRepo = ref.read(profileRepositoryProvider);
        final freshUser = await profileRepo.getMe();

        // If user data changed (avatar, name, role, etc.), update session
        if (freshUser != session.user) {
          debugPrint(
              'DEBUG: AuthNotifier detected stale session data. Updating session.',);
          final updatedSession = session.copyWith(user: freshUser);
          await ref.read(sessionStoreProvider).saveSession(updatedSession);
          return updatedSession;
        }
      } catch (e) {
        debugPrint('DEBUG: AuthNotifier failed to refresh profile: $e');
        // Continue with stored session if fetch fails (offline etc)
      }
    }

    return session;
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    debugPrint('DEBUG: AuthNotifier.signIn called');
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final res = await ref.read(signInUseCaseProvider).call(
            SignInParams(email: email, password: password),
          );
      debugPrint('DEBUG: AuthNotifier.signIn success. Res: $res');
      return res;
    });
    if (state.hasError) {
      debugPrint('DEBUG: AuthNotifier.signIn ERROR: ${state.error}');
    } else {
      _logFcmFlowAuth('signIn success -> triggering _registerFcmToken');
      unawaited(_registerFcmToken());
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required UserRole role,
  }) async {
    debugPrint('DEBUG: AuthNotifier.signUp called');
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
      debugPrint('DEBUG: AuthNotifier.signUp success. Res: $res');
      return res;
    });
    if (state.hasError) {
      debugPrint('DEBUG: AuthNotifier.signUp ERROR: ${state.error}');
    } else {
      _logFcmFlowAuth('signUp success -> triggering _registerFcmToken');
      unawaited(_registerFcmToken());
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
    debugPrint('DEBUG: AuthNotifier.verifyOtp called with role=$role');
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

      debugPrint(
          'DEBUG: AuthNotifier.verifyOtp success. Session: ${session.accessToken}',);

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
        debugPrint(
            'DEBUG: AuthNotifier.verifyOtp Fetched Profile: Role=${user.role}',);
      } catch (e) {
        debugPrint('DEBUG: Failed to fetch profile after OTP: $e');
        // Fallback to session user
      }

      // FALLBACK: If fetched user is parent but we KNOW it should be sitter (passed in param),
      // force update the user object. This handles backend returning default/wrong role.
      if (role != null && user.role != role) {
        debugPrint(
            'DEBUG: AuthNotifier FORCE PATCHING role from ${user.role} to $role',);
        user = user.copyWith(role: role);
      }

      final updatedSession = session.copyWith(user: user);

      // Save session with FULL user profile
      await ref.read(sessionStoreProvider).saveSession(updatedSession);

      return updatedSession;
    });

    if (state.hasError) {
      debugPrint('DEBUG: AuthNotifier.verifyOtp ERROR: ${state.error}');
    } else {
      _logFcmFlowAuth('verifyOtp success -> triggering _registerFcmToken');
      unawaited(_registerFcmToken());
    }
  }

  Future<void> refreshProfile() async {
    final session = state.valueOrNull;
    if (session == null) return;

    try {
      debugPrint('DEBUG: AuthNotifier.refreshProfile called');
      final profileRepo = ref.read(profileRepositoryProvider);
      final freshUser = await profileRepo.getMe();

      final updatedSession = session.copyWith(user: freshUser);
      await ref.read(sessionStoreProvider).saveSession(updatedSession);
      state = AsyncValue.data(updatedSession);
      debugPrint(
          'DEBUG: AuthNotifier.refreshProfile success. isProfileComplete=${freshUser.isProfileComplete}',);
    } catch (e) {
      debugPrint('DEBUG: AuthNotifier.refreshProfile failed: $e');
      // If we can't refresh, keep the state as is
    }
  }

  Future<void> _registerFcmToken() async {
    if (_isRegisteringFcmToken) {
      _logFcmFlowAuth('_registerFcmToken skipped: already in progress');
      return;
    }
    _isRegisteringFcmToken = true;
    try {
      _logFcmFlowAuth('_registerFcmToken started');
      final notificationsService = ref.read(notificationsServiceProvider);
      String? token = await notificationsService.getToken();
      _logFcmFlowAuth(
        '_registerFcmToken getToken result: ${token == null || token.isEmpty ? "empty" : "len=${token.length}"}',
      );
      if (token == null || token.isEmpty) {
        _logFcmFlowAuth('_registerFcmToken trying forceRefreshToken');
        token = await notificationsService.forceRefreshToken();
        _logFcmFlowAuth(
          '_registerFcmToken forceRefreshToken result: ${token == null || token.isEmpty ? "empty" : "len=${token.length}"}',
        );
      }
      if (token != null && token.isNotEmpty) {
        final dataSource = ref.read(authRemoteDataSourceProvider);
        _logFcmFlowAuth('_registerFcmToken calling registerDeviceToken');
        await dataSource.registerDeviceToken(token);
        developer.log('FCM token registered with backend', name: 'Auth');
        _logFcmFlowAuth('_registerFcmToken backend registration success');
      } else {
        developer.log(
          'FCM token unavailable after forced refresh during auth flow',
          name: 'Auth',
        );
        _logFcmFlowAuth(
          '_registerFcmToken aborted: token unavailable after forced refresh',
        );
      }
    } catch (e, st) {
      developer.log('Failed to register FCM token: $e',
          name: 'Auth', stackTrace: st,);
      _logFcmFlowAuth('_registerFcmToken failed with error=$e');
    } finally {
      _isRegisteringFcmToken = false;
    }
  }

  void _logFcmFlowAuth(String message) {
    developer.log(message, name: 'FCM_FLOW_AUTH');
    debugPrint('[FCM_FLOW_AUTH] $message');
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
      ref.watch(registrationRemoteDataSourceProvider),);
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
  debugPrint('>>> BUILD currentUserProvider');
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
