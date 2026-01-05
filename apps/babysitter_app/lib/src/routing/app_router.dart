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
import '../features/auth/sign_up_screen.dart';
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
  final refreshNotifier = RouterRefreshNotifier(ref);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: Routes.splash,
    debugLogDiagnostics: true,
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final authState = ref.read(authNotifierProvider);
      final userAsync = ref.read(currentUserProvider);
      final location = state.matchedLocation;

      // Check authentication
      final isAuthenticated = authState.valueOrNull != null;
      final isAuthRoute = Routes.isAuthRoute(location);
      final isSplash = location == Routes.splash;
      final isOnboarding = location == Routes.onboarding;

      // Not authenticated
      if (!isAuthenticated) {
        // Allow splash, onboarding, and auth routes
        if (isSplash || isOnboarding || isAuthRoute) {
          return null;
        }
        // Redirect to onboarding
        return Routes.onboarding;
      }

      // Authenticated - check user profile
      if (userAsync.isLoading) {
        // Still loading profile, stay on splash
        if (!isSplash) {
          return Routes.splash;
        }
        return null;
      }

      if (userAsync.hasError || userAsync.valueOrNull == null) {
        // Error loading profile, redirect to sign in
        return Routes.signIn;
      }

      final user = userAsync.valueOrNull!;

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
        builder: (context, state) => OnboardingScreen(
          onFamilySelected: () {
            // For Option B (role chosen at signup): go to signup with role preselected
            context.go('${Routes.signUp}?role=parent');
          },
          onBabysitterSelected: () {
            context.go('${Routes.signUp}?role=sitter');
          },
          onGetStarted: () {
            context.go(Routes.signUp);
          },
          onLogIn: () {
            context.go(Routes.signIn);
          },
          onLookingForJobs: () {
            // Usually sitter path:
            context.go('${Routes.signUp}?role=sitter');
          },
        ),
      ),

      // Auth routes
      GoRoute(
        path: Routes.signIn,
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: Routes.signUp,
        builder: (context, state) => const SignUpScreen(),
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

/// Notifier that triggers router refresh on auth/user changes
class RouterRefreshNotifier extends ChangeNotifier {
  late final StreamSubscription<dynamic> _authSubscription;
  late final ProviderSubscription<AsyncValue<User?>> _userSubscription;

  RouterRefreshNotifier(Ref ref) {
    // Listen to auth state changes
    _authSubscription = ref
        .read(authRepositoryProvider)
        .authStateChanges
        .listen((_) => notifyListeners());

    // Listen to user provider changes
    _userSubscription = ref.listen<AsyncValue<User?>>(
      currentUserProvider,
      (previous, next) => notifyListeners(),
    );
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    _userSubscription.close();
    super.dispose();
  }
}
