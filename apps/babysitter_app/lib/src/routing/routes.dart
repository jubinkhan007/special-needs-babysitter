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
  static const String parentBookings = '/parent/bookings';
  static const String bookingDetails =
      '/parent/booking-details'; // /parent/booking-details?id=...&status=...
  static const String activeBooking = '/parent/active-booking';
  static const String mapRoute = '/parent/map-route';
  static const String jobDetails = '/parent/jobs/details';
  static const String applications = '/parent/jobs/applications';
  static const String bookingApplication = '/parent/jobs/applications/details';

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

  // Sitter shell routes
  static const String sitterHome = '/sitter/home';
  static const String sitterJobs = '/sitter/jobs';
  static const String sitterBookings = '/sitter/bookings';
  static const String sitterMessages = '/sitter/messages';
  static const String sitterAccount = '/sitter/account';

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
