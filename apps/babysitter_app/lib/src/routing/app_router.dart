import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:auth/auth.dart';
import 'package:domain/domain.dart';

import 'routes.dart';
import '../features/bookings/presentation/review/report_issue_screen.dart';
import '../features/bookings/presentation/review/review_screen.dart';
import '../features/bookings/domain/review/review_args.dart';
import '../features/bookings/domain/review/report_issue_args.dart';
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
import '../features/bookings/presentation/bookings_screen.dart';
import '../features/parent/jobs/parent_jobs_screen.dart';
import '../features/parent/account/parent_account_screen.dart';
import '../features/parent/account/profile_details/presentation/profile_details_screen.dart';

import '../features/sitter/sitter_shell.dart';
import '../features/sitter/home/sitter_home_screen.dart';
import '../features/sitter/jobs/sitter_jobs_screen.dart';
import '../features/sitter/bookings/sitter_bookings_screen.dart';
import '../features/sitter/messages/sitter_messages_screen.dart';
import '../features/sitter/account/sitter_account_screen.dart';
import '../features/parent/jobs/post_job/presentation/screens/job_posting_flow.dart';
import '../features/sitter_profile_setup/presentation/screens/sitter_profile_setup_flow.dart';
import '../features/parent/sitter_profile/presentation/screens/sitter_profile_page.dart';
import '../features/parent/search/presentation/screens/sitter_search_results_screen.dart';
import '../features/parent/booking_flow/presentation/screens/parent_booking_step1_screen.dart';
import '../features/bookings/presentation/booking_details_screen.dart';
import '../features/bookings/domain/booking_details.dart';
import '../features/bookings/presentation/active_booking_details_screen.dart';
import '../features/bookings/presentation/map_route/map_route_screen.dart';
import '../features/jobs/presentation/job_details/job_details_screen.dart';
import '../features/jobs/domain/job_details.dart';
import '../features/jobs/presentation/applications/applications_screen.dart';
import '../features/jobs/presentation/applications/booking_application_screen.dart';
import '../features/jobs/domain/applications/booking_application.dart';

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
        if (isSignUpInProgress) {
          print(
              'DEBUG ROUTER: signUpInProgress=true, returning /auth/profile-setup');
          isSignUpInProgress = false;
          return Routes.profileSetup;
        }

        // If coming from sign-up, always go to profile setup (new user flow)
        if (location == Routes.signUp) {
          print(
              'DEBUG ROUTER: On sign-up route, returning /auth/profile-setup');
          return Routes.profileSetup;
        }

        // For other auth routes (sign-in, etc.), check profile completion
        if (!user.isProfileComplete) {
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
        builder: (context, state) {
          final role = state.uri.queryParameters['role'] ?? 'parent';
          return SignUpFlow(initialRole: role);
        },
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
        builder: (context, state) {
          final user = ref.read(authNotifierProvider).value?.user;
          if (user?.role == UserRole.sitter) {
            return const SitterProfileSetupFlow();
          }
          return const ProfileSetupFlow();
        },
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
              child: BookingsScreen(),
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

      // Booking Flow Step 1
      GoRoute(
        path: Routes.parentBookingStep1,
        builder: (context, state) => const ParentBookingStep1Screen(),
      ),

      // Sitter Search Route
      GoRoute(
        path: Routes.sitterSearch,
        builder: (context, state) => const SitterSearchResultsScreen(),
      ),

      // Booking Details
      GoRoute(
        path: Routes.bookingDetails,
        builder: (context, state) {
          final args = state.extra as BookingDetailsArgs?;
          if (args == null) {
            // Fallback/Error handling
            return const Scaffold(
              body: Center(
                  child: Text('Error: Missing booking details arguments')),
            );
          }
          return BookingDetailsScreen(args: args);
        },
      ),

      // Active Booking Details
      GoRoute(
        path: Routes.activeBooking,
        builder: (context, state) {
          final bookingId = state.extra as String?;
          if (bookingId == null) {
            return const Scaffold(
              body: Center(child: Text('Error: Missing booking ID')),
            );
          }
          return ActiveBookingDetailsScreen(bookingId: bookingId);
        },
      ),

      // Map Route
      GoRoute(
        path: Routes.mapRoute,
        builder: (context, state) {
          final bookingId = state.extra as String?;
          if (bookingId == null) {
            return const Scaffold(
              body: Center(
                  child: Text('Error: Missing booking ID for map route')),
            );
          }
          return MapRouteScreen(bookingId: bookingId);
        },
      ),

      // Job Details
      GoRoute(
        path: Routes.jobDetails,
        builder: (context, state) {
          final job = state.extra as JobDetails?;
          if (job == null) {
            return const Scaffold(
              body: Center(child: Text('Error: Missing job details')),
            );
          }
          return JobDetailsScreen(job: job);
        },
      ),

      GoRoute(
        path: Routes.applications,
        builder: (context, state) => const ApplicationsScreen(),
      ),

      GoRoute(
        path: Routes.applications,
        builder: (context, state) => const ApplicationsScreen(),
      ),

      GoRoute(
        path: Routes.bookingApplication,
        builder: (context, state) {
          final app = state.extra as BookingApplication?;
          if (app == null) {
            return const Scaffold(
              body: Center(
                  child: Text('Error: Missing booking application details')),
            );
          }
          return BookingApplicationScreen(application: app);
        },
      ),

      // Booking Review
      GoRoute(
        path: Routes.parentReview,
        builder: (context, state) {
          final args = state.extra as ReviewArgs?;
          if (args == null) {
            return const Scaffold(
              body: Center(child: Text('Error: Missing review arguments')),
            );
          }
          return ReviewScreen(args: args);
        },
      ),

      // Report Issue
      GoRoute(
        path: Routes.reportIssue,
        builder: (context, state) {
          final args = state.extra as ReportIssueArgs?;
          if (args == null) {
            return const Scaffold(
              body:
                  Center(child: Text('Error: Missing report issue arguments')),
            );
          }
          return ReportIssueScreen(args: args);
        },
      ),

      // Post Job Flow (outside shell for full-screen experience)
      GoRoute(
        path: Routes.postJob,
        builder: (context, state) => const JobPostingFlow(),
      ),

      // Sitter Profile View (outside shell for full-screen experience)
      GoRoute(
        path: '${Routes.sitterProfile}/:sitterId',
        builder: (context, state) {
          final sitterId = state.pathParameters['sitterId'] ?? '';
          return SitterProfilePage(sitterId: sitterId);
        },
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
