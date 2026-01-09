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
import '../features/auth/presentation/screens/sign_up/sign_up_flow.dart';
import '../features/parent_profile_setup/presentation/screens/profile_setup_flow.dart';
import '../features/parent/parent_shell.dart';
import '../features/parent/home/parent_home_screen.dart';
import '../features/parent/messages/parent_messages_screen.dart';
import '../features/parent/bookings/parent_bookings_screen.dart';
import '../features/parent/jobs/parent_jobs_screen.dart';
import '../features/parent/account/parent_account_screen.dart';
import '../features/parent/account/profile_details/presentation/profile_details_screen.dart';
import 'package:babysitter_app/src/features/parent/sitter_profile/presentation/screens/sitter_profile_view.dart';
import 'package:babysitter_app/src/features/parent/home/presentation/models/home_mock_models.dart';
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

/// Flag to indicate sign-up is in progress (set before OTP verification)
/// When true, router will redirect to profileSetup instead of home
/// Using a simple global variable to avoid any provider scope issues
bool _signUpInProgress = false;

/// Getter/Setter for sign-up progress flag
bool get isSignUpInProgress => _signUpInProgress;
set isSignUpInProgress(bool value) {
  print('DEBUG: Setting signUpInProgress = $value');
  _signUpInProgress = value;
}

/// Provider version for backwards compatibility (deprecated, use global)
final signUpInProgressProvider = StateProvider<bool>((ref) => false);

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

      // DEBUG: Log every redirect call
      print(
          'DEBUG ROUTER REDIRECT: location=$location, isLoading=${authState.isLoading}, hasValue=${authState.hasValue}, isSignUpInProgress=$isSignUpInProgress');

      // Check authentication from session
      final session = authState.valueOrNull;
      final isAuthenticated = session != null;
      final isAuthRoute = Routes.isAuthRoute(location);
      final isSplash = location == Routes.splash;
      final isOnboarding = location == Routes.onboarding;

      // Still loading auth state - stay on splash
      if (authState.isLoading) {
        if (!isSplash) {
          print('DEBUG ROUTER: isLoading, returning /splash');
          return Routes.splash;
        }
        print('DEBUG ROUTER: isLoading and on splash, returning null');
        return null;
      }

      // Not authenticated
      if (!isAuthenticated) {
        // Allow splash, onboarding, and auth routes
        if (isSplash || isOnboarding || isAuthRoute) {
          print(
              'DEBUG ROUTER: Not authenticated, on allowed route, returning null');
          return null;
        }
        // Redirect to onboarding
        print('DEBUG ROUTER: Not authenticated, returning /onboarding');
        return Routes.onboarding;
      }

      // Authenticated - get user from session (avoids currentUserProvider cycle)
      final user = session.user;
      print(
          'DEBUG ROUTER: Authenticated, user.isProfileComplete=${user.isProfileComplete}, user.role=${user.role}');

      // Authenticated but on auth/onboarding route, redirect to appropriate home
      if (isAuthRoute || isSplash || isOnboarding) {
        // ALLOW profile setup to proceed if we are already there
        if (location == Routes.profileSetup) {
          print('DEBUG ROUTER: Already on profileSetup, returning null');
          return null;
        }

        // Check if sign-up is in progress - always go to profile setup
        if (isSignUpInProgress && user.role == UserRole.parent) {
          print(
              'DEBUG ROUTER: signUpInProgress=true, returning /auth/profile-setup');
          isSignUpInProgress = false;
          return Routes.profileSetup;
        }

        // If coming from sign-up, always go to profile setup (new user flow)
        if (location == Routes.signUp && user.role == UserRole.parent) {
          print(
              'DEBUG ROUTER: On sign-up route, returning /auth/profile-setup');
          return Routes.profileSetup;
        }

        // For other auth routes (sign-in, etc.), check profile completion
        if (!user.isProfileComplete && user.role == UserRole.parent) {
          print(
              'DEBUG ROUTER: Profile incomplete, returning /auth/profile-setup');
          return Routes.profileSetup;
        }

        final home = user.role == UserRole.parent
            ? Routes.parentHome
            : Routes.sitterHome;
        print('DEBUG ROUTER: Redirecting to home=$home');
        return home;
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
      GoRoute(
        path: Routes.profileSetup,
        builder: (context, state) => const ProfileSetupFlow(),
      ),
      // Home alias route - redirects based on role
      GoRoute(
        path: Routes.home,
        redirect: (context, state) {
          // This will be caught by the main redirect and sent to appropriate home
          return Routes.parentHome;
        },
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
            routes: [
              GoRoute(
                path: 'profile', // /account/profile
                builder: (context, state) => const ProfileDetailsScreen(),
              ),
            ],
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
