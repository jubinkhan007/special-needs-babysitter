import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:auth/auth.dart';
import 'package:domain/domain.dart';

import 'routes.dart';
import '../features/splash/splash_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/auth/sign_in_screen.dart';
import '../features/auth/forgot_password_screen.dart';
import '../features/auth/update_password_screen.dart';
import '../features/auth/password_updated_screen.dart';
import '../features/auth/sign_up/sign_up_flow.dart';
import '../features/parent/parent_shell.dart';
import '../features/parent/home/parent_home_screen.dart';
import '../features/parent/messages/parent_messages_screen.dart';
import '../features/parent/bookings/parent_bookings_screen.dart';
import '../features/parent/jobs/parent_jobs_screen.dart';
import '../features/parent/account/parent_account_screen.dart';
import '../features/sitter/sitter_shell.dart';
import '../features/sitter/home/sitter_home_screen.dart';
import '../features/sitter/jobs/sitter_jobs_screen.dart';
import '../features/sitter/bookings/sitter_bookings_screen.dart';
import '../features/sitter/messages/sitter_messages_screen.dart';
import '../features/sitter/account/sitter_account_screen.dart';

/// Global navigator keys
final rootNavigatorKey = GlobalKey<NavigatorState>();
final parentShellNavigatorKey = GlobalKey<NavigatorState>();
final sitterShellNavigatorKey = GlobalKey<NavigatorState>();

/// Provider for GoRouter
final appRouterProvider = Provider<GoRouter>((ref) {
  print('>>> BUILD appRouterProvider');
  final refreshNotifier = ref.watch(routerRefreshNotifierProvider);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: Routes.splash,
    debugLogDiagnostics: true,
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      // IMPORTANT: Only read authNotifierProvider here, not currentUserProvider
      // Reading currentUserProvider would cause circular dependency because it
      // watches authNotifierProvider, creating a rebuild loop during auth changes
      final authState = ref.read(authNotifierProvider);
      final location = state.matchedLocation;

      // Check authentication from session
      final session = authState.valueOrNull;
      final isAuthenticated = session != null;
      final isAuthRoute = Routes.isAuthRoute(location);
      final isSplash = location == Routes.splash;
      final isOnboarding = location == Routes.onboarding;

      // Still loading auth state - stay on splash
      if (authState.isLoading) {
        if (!isSplash) return Routes.splash;
        return null;
      }

      // Not authenticated
      if (!isAuthenticated) {
        // Allow splash, onboarding, and auth routes
        if (isSplash || isOnboarding || isAuthRoute) {
          return null;
        }
        // Redirect to onboarding
        return Routes.onboarding;
      }

      // Authenticated - get user from session (avoids currentUserProvider cycle)
      final user = session.user;

      // Authenticated but on auth/onboarding route, redirect to appropriate home
      if (isAuthRoute || isSplash || isOnboarding) {
        return user.role == UserRole.parent
            ? Routes.parentHome
            : Routes.sitterHome;
      }

      // Check role-based access
      if (user.role == UserRole.parent && Routes.isSitterRoute(location)) {
        return Routes.parentHome;
      }

      if (user.role == UserRole.sitter && Routes.isParentRoute(location)) {
        return Routes.sitterHome;
      }

      return null;
    },
    routes: [
      // Splash route
      GoRoute(
        path: Routes.splash,
        builder: (context, state) => const SplashScreen(),
      ),

      // Onboarding route
      GoRoute(
        path: Routes.onboarding,
        builder: (context, state) => OnboardingScreen(),
      ),

      // Auth routes
      GoRoute(
        path: Routes.signIn,
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: Routes.signUp,
        builder: (context, state) => const SignUpFlow(),
      ),
      GoRoute(
        path: Routes.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: Routes.updatePassword,
        builder: (context, state) => const UpdatePasswordScreen(),
      ),
      GoRoute(
        path: Routes.passwordUpdated,
        builder: (context, state) => const PasswordUpdatedScreen(),
      ),

      // Parent shell
      ShellRoute(
        navigatorKey: parentShellNavigatorKey,
        builder: (context, state, child) => ParentShell(child: child),
        routes: [
          GoRoute(
            path: Routes.parentHome,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ParentHomeScreen(),
            ),
          ),
          GoRoute(
            path: Routes.parentMessages,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ParentMessagesScreen(),
            ),
          ),
          GoRoute(
            path: Routes.parentBookings,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ParentBookingsScreen(),
            ),
          ),
          GoRoute(
            path: Routes.parentJobs,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ParentJobsScreen(),
            ),
          ),
          GoRoute(
            path: Routes.parentAccount,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ParentAccountScreen(),
            ),
          ),
        ],
      ),

      // Sitter shell
      ShellRoute(
        navigatorKey: sitterShellNavigatorKey,
        builder: (context, state, child) => SitterShell(child: child),
        routes: [
          GoRoute(
            path: Routes.sitterHome,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SitterHomeScreen(),
            ),
          ),
          GoRoute(
            path: Routes.sitterJobs,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SitterJobsScreen(),
            ),
          ),
          GoRoute(
            path: Routes.sitterBookings,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SitterBookingsScreen(),
            ),
          ),
          GoRoute(
            path: Routes.sitterMessages,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SitterMessagesScreen(),
            ),
          ),
          GoRoute(
            path: Routes.sitterAccount,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SitterAccountScreen(),
            ),
          ),
        ],
      ),
    ],
  );
});

/// Provider for RouterRefreshNotifier (dedicated provider for proper lifecycle)
final routerRefreshNotifierProvider = Provider<RouterRefreshNotifier>((ref) {
  print('>>> BUILD routerRefreshNotifierProvider');
  final notifier = RouterRefreshNotifier(ref);
  ref.onDispose(notifier.dispose);
  return notifier;
});

/// Notifier that triggers router refresh on auth state changes
/// Uses Future.microtask to break sync re-entrancy and avoid CircularDependencyError
class RouterRefreshNotifier extends ChangeNotifier {
  RouterRefreshNotifier(this.ref) {
    print('>>> RouterRefreshNotifier constructor');
    _sub = ref.listen<AsyncValue<AuthSession?>>(
      authNotifierProvider,
      (_, __) => Future.microtask(notifyListeners), // async break
      fireImmediately: false,
    );
  }

  final Ref ref;
  late final ProviderSubscription<AsyncValue<AuthSession?>> _sub;

  @override
  void dispose() {
    _sub.close();
    super.dispose();
  }
}
