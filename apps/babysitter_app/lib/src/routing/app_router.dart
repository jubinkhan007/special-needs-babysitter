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
import '../features/bookings/domain/booking_status.dart';
import '../features/parent/jobs/parent_jobs_screen.dart';
import '../features/messages/presentation/chat_thread_screen.dart';
import '../features/parent/account/parent_account_screen.dart';
import '../features/parent/account/profile_details/presentation/profile_details_screen.dart';

import '../features/sitter/sitter_shell.dart';
import '../features/sitter/home/sitter_home_screen.dart';
import '../features/sitter/jobs/sitter_jobs_screen.dart';
import '../features/sitter/bookings/sitter_bookings_screen.dart';
import '../features/sitter/bookings/presentation/screens/sitter_booking_details_screen.dart';
import '../features/sitter/bookings/presentation/screens/sitter_active_booking_screen.dart';
import '../features/sitter/messages/sitter_messages_screen.dart';
import '../features/sitter/account/sitter_account_screen.dart';
import '../features/sitter/account/presentation/profile_details/presentation/sitter_profile_details_screen.dart';
import '../features/sitter/account/presentation/screens/sitter_reviews_screen.dart';
import '../features/sitter/saved_jobs/presentation/screens/sitter_saved_jobs_screen.dart';
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
import '../features/jobs/presentation/edit_job/edit_job_screen.dart';
import '../features/jobs/presentation/applications/applications_screen.dart';
import '../features/jobs/presentation/applications/booking_application_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../features/account/payment/presentation/payment_screen.dart';
import '../features/sitters/presentation/saved/saved_sitters_screen.dart';
import '../features/sitters/presentation/reviews/reviews_screen.dart';
import '../features/calls/presentation/audio_call_screen.dart';
import '../features/calls/presentation/video_call_screen.dart';
import '../features/support/presentation/support_chat_screen.dart';
import '../features/messages/domain/chat_thread_args.dart';
import '../features/calls/domain/audio_call_args.dart';
import '../features/calls/domain/video_call_args.dart';
import '../features/support/domain/support_chat_args.dart';
import '../features/sitter/job_details/presentation/screens/sitter_job_details_screen.dart';
import '../features/sitter/jobs/presentation/screens/sitter_application_details_screen.dart';
import '../features/sitter/jobs/presentation/screens/sitter_job_request_details_screen.dart';
import '../features/sitter/application/presentation/screens/sitter_application_preview_screen.dart';
import '../features/sitter/background_check/presentation/screens/verify_identity_screen.dart';
import '../features/sitter/background_check/presentation/screens/background_check_screen.dart';
import '../features/sitter/background_check/presentation/screens/background_check_complete_screen.dart';

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
        // Allow auth routes to handle their own loading state (spinners etc)
        if (isAuthRoute) {
          print('DEBUG ROUTER: isLoading, but on auth route, returning null');
          return null;
        }

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
          'DEBUG ROUTER: Authenticated, user.id=${user.id}, user.isProfileComplete=${user.isProfileComplete}, user.role=${user.role}');
      if (!user.isProfileComplete) {
        print(
            'DEBUG ROUTER: User object details for incomplete profile: firstName=${user.firstName}, lastName=${user.lastName}, email=${user.email}');
      }

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
        builder: (context, state) {
          final role = state.uri.queryParameters['role'] ?? 'parent';
          return SignInScreen(initialRole: role);
        },
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
            routes: [
              GoRoute(
                path: 'chat/:id', // matches /parent/messages/chat/:id
                parentNavigatorKey: rootNavigatorKey, // Hide bottom nav
                builder: (context, state) {
                  final args = state.extra as ChatThreadArgs?;
                  final id = state.pathParameters['id'] ?? '';
                  return ChatThreadScreen(
                    args: args ?? ChatThreadArgs(
                      otherUserId: id,
                      otherUserName: 'Chat',
                    ),
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: Routes.parentBookings,
            pageBuilder: (context, state) {
              final rawTab = state.uri.queryParameters['tab'];
              BookingStatus? initialTab;
              if (rawTab != null && rawTab.trim().isNotEmpty) {
                final normalized =
                    rawTab.toLowerCase().replaceAll(RegExp(r'[\s_-]'), '');
                switch (normalized) {
                  case 'active':
                    initialTab = BookingStatus.active;
                    break;
                  case 'clockedout':
                    initialTab = BookingStatus.clockedOut;
                    break;
                  case 'upcoming':
                    initialTab = BookingStatus.upcoming;
                    break;
                  case 'pending':
                    initialTab = BookingStatus.pending;
                    break;
                  case 'completed':
                    initialTab = BookingStatus.completed;
                    break;
                  case 'cancelled':
                  case 'canceled':
                    initialTab = BookingStatus.cancelled;
                    break;
                }
              }
              return NoTransitionPage(
                child: BookingsScreen(initialTab: initialTab),
              );
            },
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
                path: 'profile', // /parent/account/profile
                builder: (context, state) => const ProfileDetailsScreen(),
              ),
              GoRoute(
                path: 'settings', // /parent/account/settings
                builder: (context, state) => const SettingsScreen(),
              ),
              GoRoute(
                path: 'payment', // /parent/account/payment
                builder: (context, state) => const PaymentScreen(),
              ),
            ],
          ),
        ],
      ),

      // Saved Sitters Route
      GoRoute(
        path: Routes.parentSavedSitters,
        builder: (context, state) => const SavedSittersScreen(),
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

      // Sitter Reviews
      GoRoute(
        path: Routes.sitterReviews, // e.g. /parent/sitter/reviews
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final sitterId = state.uri.queryParameters['id'] ?? '';
          final name = extra?['name'] as String? ?? 'Krystina';
          return ReviewsScreen(sitterId: sitterId, sitterName: name);
        },
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

      GoRoute(
        path: Routes.jobDetails,
        builder: (context, state) {
          final extra = state.extra;
          String? jobId;
          if (extra is JobDetails) {
            jobId = extra.id;
          } else if (extra is String) {
            jobId = extra;
          }

          if (jobId == null) {
            return const Scaffold(
              body: Center(child: Text('Error: Missing job ID')),
            );
          }
          return JobDetailsScreen(jobId: jobId);
        },
      ),

      // Edit Job
      GoRoute(
        path: Routes.editJob,
        builder: (context, state) {
          final jobId = state.extra as String?;
          if (jobId == null) {
            return const Scaffold(
              body: Center(child: Text('Error: Missing job ID')),
            );
          }
          return EditJobScreen(jobId: jobId);
        },
      ),

      GoRoute(
        path: Routes.applications,
        builder: (context, state) {
          final jobId = state.extra as String? ?? '';
          return ApplicationsScreen(jobId: jobId);
        },
      ),
      GoRoute(
        path: Routes.bookingApplication,
        builder: (context, state) {
          final extras = state.extra as Map<String, String>;
          return BookingApplicationScreen(
            jobId: extras['jobId']!,
            applicationId: extras['applicationId']!,
          );
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
      GoRoute(
        path: Routes.sitterReview,
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
      GoRoute(
        path: Routes.sitterSavedJobs,
        builder: (context, state) => const SitterSavedJobsScreen(),
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

      // Audio Call Screen
      GoRoute(
        path: Routes.audioCall,
        parentNavigatorKey: rootNavigatorKey, // Full screen, no bottom nav
        builder: (context, state) {
          final args = state.extra as AudioCallArgs?;
          if (args == null) {
            return const Scaffold(
                body: Center(child: Text('Error: Missing audio call args')));
          }
          return AudioCallScreen(args: args);
        },
      ),

      // Video Call Screen
      GoRoute(
        path: Routes.videoCall,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final args = state.extra as VideoCallArgs?;
          if (args == null) {
            return const Scaffold(
                body: Center(child: Text('Error: Missing video call args')));
          }
          return VideoCallScreen(args: args);
        },
      ),

      // Support Chat Screen
      GoRoute(
        path: Routes.supportChat,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final args =
              state.extra as SupportChatArgs? ?? const SupportChatArgs();
          return SupportChatScreen(args: args);
        },
      ),

      // Sitter Profile View (outside shell for full-screen experience)
      GoRoute(
        path: '${Routes.sitterProfile}/:sitterId',
        builder: (context, state) {
          final sitterId = state.pathParameters['sitterId'] ?? '';
          return SitterProfilePage(sitterId: sitterId);
        },
      ),

      // Sitter Job Details (outside shell for full-screen experience)
      GoRoute(
        path: '${Routes.sitterJobDetails}/:jobId',
        builder: (context, state) {
          final jobId = state.pathParameters['jobId'] ?? '';
          return SitterJobDetailsScreen(jobId: jobId);
        },
        routes: [
          GoRoute(
            path: 'application-preview',
            builder: (context, state) {
              final jobId = state.pathParameters['jobId']!;
              final coverLetter = state.extra as String? ?? '';
              return SitterApplicationPreviewScreen(
                jobId: jobId,
                coverLetter: coverLetter,
              );
            },
          ),
        ],
      ),
      // Sitter Application Details (viewing an already-submitted application)
      GoRoute(
        path: '${Routes.sitterApplicationDetails}/:applicationId',
        builder: (context, state) {
          final applicationId = state.pathParameters['applicationId'] ?? '';
          return SitterApplicationDetailsScreen(applicationId: applicationId);
        },
      ),
      // Sitter Job Request Details (viewing an invitation to a job)
      GoRoute(
        path: '${Routes.sitterJobRequestDetails}/:applicationId',
        builder: (context, state) {
          final applicationId = state.pathParameters['applicationId'] ?? '';
          final type = state.uri.queryParameters['type'];
          final status = state.uri.queryParameters['status'];
          return SitterJobRequestDetailsScreen(
            applicationId: applicationId,
            initialApplicationType: type,
            initialApplicationStatus: status,
          );
        },
      ),
      // Sitter Booking Details (viewing an upcoming/confirmed booking)
      GoRoute(
        path: '${Routes.sitterBookingDetails}/:applicationId',
        builder: (context, state) {
          final applicationId = state.pathParameters['applicationId'] ?? '';
          final status = state.uri.queryParameters['status'];
          return SitterBookingDetailsScreen(
            applicationId: applicationId,
            initialStatus: status,
          );
        },
      ),
      // Sitter Active Booking (active session with timer and tracking)
      GoRoute(
        path: '${Routes.sitterActiveBooking}/:applicationId',
        builder: (context, state) {
          final applicationId = state.pathParameters['applicationId'] ?? '';
          return SitterActiveBookingScreen(
            applicationId: applicationId,
          );
        },
      ),
      GoRoute(
        path: Routes.sitterVerifyIdentity,
        builder: (context, state) => const VerifyIdentityScreen(),
      ),
      GoRoute(
        path: Routes.sitterBackgroundCheck,
        builder: (context, state) => const BackgroundCheckScreen(),
      ),
      GoRoute(
        path: Routes.sitterBackgroundCheckComplete,
        builder: (context, state) => const BackgroundCheckCompleteScreen(),
      ),

      // Sitter Profile Details (full screen, outside shell)
      GoRoute(
        path: Routes.sitterProfileDetails,
        builder: (context, state) => const SitterProfileDetailsScreen(),
      ),
      GoRoute(
        path: Routes.sitterRatingsReviews,
        builder: (context, state) => const SitterReviewsScreen(),
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
            routes: [
              GoRoute(
                path: 'chat/:id', // matches /sitter/messages/chat/:id
                parentNavigatorKey: rootNavigatorKey, // Hide bottom nav
                builder: (context, state) {
                  final args = state.extra as ChatThreadArgs?;
                  final id = state.pathParameters['id'] ?? '';
                  return ChatThreadScreen(
                    args: args ?? ChatThreadArgs(
                      otherUserId: id,
                      otherUserName: 'Chat',
                    ),
                  );
                },
              ),
            ],
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
