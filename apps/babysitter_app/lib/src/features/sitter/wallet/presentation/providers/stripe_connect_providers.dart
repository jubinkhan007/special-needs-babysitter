import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auth/auth.dart';

import '../../data/models/stripe_connect_status.dart';
import '../../data/sources/stripe_connect_remote_datasource.dart';

/// Provider for the Stripe Connect remote data source
final stripeConnectRemoteDataSourceProvider =
    Provider<StripeConnectRemoteDataSource>((ref) {
  final dio = ref.watch(authDioProvider);
  return StripeConnectRemoteDataSource(dio);
});

/// Provider for fetching the current Stripe Connect status
final stripeConnectStatusProvider =
    FutureProvider.autoDispose<StripeConnectStatus>((ref) async {
  final remote = ref.watch(stripeConnectRemoteDataSourceProvider);
  return remote.getConnectStatus();
});

/// State for the onboarding controller
class StripeConnectOnboardingState {
  final bool isLoading;
  final String? url;
  final String? error;

  const StripeConnectOnboardingState({
    this.isLoading = false,
    this.url,
    this.error,
  });

  StripeConnectOnboardingState copyWith({
    bool? isLoading,
    String? url,
    String? error,
  }) {
    return StripeConnectOnboardingState(
      isLoading: isLoading ?? this.isLoading,
      url: url ?? this.url,
      error: error,
    );
  }
}

/// Controller for handling Stripe Connect onboarding actions
class StripeConnectOnboardingController
    extends StateNotifier<StripeConnectOnboardingState> {
  final StripeConnectRemoteDataSource _remote;
  final Ref _ref;

  StripeConnectOnboardingController(this._remote, this._ref)
      : super(const StripeConnectOnboardingState());

  /// Start or continue the onboarding process
  Future<String?> startOnboarding() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final url = await _remote.getOnboardingUrl();
      state = state.copyWith(isLoading: false, url: url);
      return url;
    } catch (e) {
      final errorMessage = _parseError(e);
      state = state.copyWith(isLoading: false, error: errorMessage);
      return null;
    }
  }

  /// Get the Stripe dashboard URL for fully onboarded users
  Future<String?> openDashboard() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final url = await _remote.getDashboardUrl();
      state = state.copyWith(isLoading: false, url: url);
      return url;
    } catch (e) {
      final errorMessage = _parseError(e);
      state = state.copyWith(isLoading: false, error: errorMessage);
      return null;
    }
  }

  /// Refresh the status after returning from Stripe
  void refreshStatus() {
    _ref.invalidate(stripeConnectStatusProvider);
  }

  String _parseError(dynamic e) {
    if (e is Exception) {
      final message = e.toString();
      if (message.startsWith('Exception: ')) {
        return message.substring(11);
      }
      return message;
    }
    return 'An unexpected error occurred. Please try again.';
  }
}

/// Provider for the onboarding controller
final stripeConnectOnboardingControllerProvider = StateNotifierProvider
    .autoDispose<StripeConnectOnboardingController, StripeConnectOnboardingState>(
  (ref) {
    final remote = ref.watch(stripeConnectRemoteDataSourceProvider);
    return StripeConnectOnboardingController(remote, ref);
  },
);
