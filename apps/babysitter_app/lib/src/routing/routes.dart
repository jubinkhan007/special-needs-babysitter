/// Route path constants
class Routes {
  Routes._();

  // Root
  static const String splash = '/';
  static const String onboarding = '/onboarding';

  // Auth
  static const String signIn = '/auth/sign-in';
  static const String signUp = '/auth/sign-up';
  static const String forgotPassword = '/auth/forgot-password';
  static const String updatePassword = '/auth/update-password';
  static const String passwordUpdated = '/auth/password-updated';
  static const String profileSetup = '/auth/profile-setup';

  // Alias for home (redirects based on role)
  static const String home = '/home';

  // Parent shell routes
  static const String parentHome = '/parent/home';
  static const String parentMessages = '/parent/messages';
  static const String parentChatThread = 'chat/:id'; // Sub-route of messages
  static const String audioCall = '/audio-call'; // Full screen route
  static const String videoCall = '/video-call'; // Full screen route
  static const String supportChat = '/support-chat'; // Full screen route
  static const String parentBookings = '/parent/bookings';
  static const String bookingDetails =
      '/parent/booking-details'; // /parent/booking-details?id=...&status=...
  static const String activeBooking = '/parent/active-booking';
  static const String mapRoute = '/parent/map-route';
  static const String jobDetails = '/parent/jobs/details';
  static const String applications = '/parent/jobs/applications';
  static const String bookingApplication = '/parent/jobs/applications/details';
  static const String editJob = '/parent/jobs/edit';

  // Review & Report
  static const String parentReview = '/parent/review';
  static const String reportIssue = '/parent/report-issue';
  static const String parentJobs = '/parent/jobs';
  static const String parentAccount = '/parent/account';
  static const String parentSettings = '/parent/account/settings';
  static const String parentPayment = '/parent/account/payment';
  static const String parentSavedSitters = '/parent/saved-sitters';
  static const String parentBookingStep1 = '/parent/booking/step1';
  static const String postJob = '/parent/post-job'; // Job posting flow
  static const String sitterProfile = '/parent/sitter-profile'; // Base path

  /// Generate sitter profile path with ID
  static String sitterProfilePath(String sitterId) =>
      '/parent/sitter-profile/$sitterId';

  static const String sitterSearch = '/parent/search';
  static const String sitterReviews = '/parent/sitter/reviews';

  // Sitter shell routes
  static const String sitterHome = '/sitter/home';
  static const String sitterJobs = '/sitter/jobs';
  static const String sitterBookings = '/sitter/bookings';
  static const String sitterBookingDetails = '/sitter/booking-details';
  static const String sitterMessages = '/sitter/messages';
  static const String sitterAccount = '/sitter/account';
  static const String sitterProfileDetails = '/sitter/account/profile';
  static const String sitterJobDetails = '/sitter/job-details';
  static const String sitterApplicationDetails = '/sitter/application-details';
  static const String sitterJobRequestDetails = '/sitter/job-request-details';
  static const String sitterApplicationPreview = '/sitter/jobs';
  static const String sitterVerifyIdentity =
      '/sitter/background-check/verify-identity';
  static const String sitterBackgroundCheck = '/sitter/background-check/submit';
  static const String sitterBackgroundCheckComplete =
      '/sitter/background-check/complete';

  /// Check if route is an auth route
  static bool isAuthRoute(String path) {
    return path.startsWith('/auth') || path == onboarding;
  }

  /// Check if route is a parent route
  static bool isParentRoute(String path) {
    return path.startsWith('/parent');
  }

  /// Check if route is a sitter route
  static bool isSitterRoute(String path) {
    return path.startsWith('/sitter');
  }
}
