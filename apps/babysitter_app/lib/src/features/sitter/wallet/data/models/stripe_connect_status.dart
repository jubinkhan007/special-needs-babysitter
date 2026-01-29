/// Enum for Stripe Connect onboarding status
enum StripeConnectStatusType {
  notStarted,
  pending,
  restricted,
  complete,
}

/// Model representing the Stripe Connect account status
class StripeConnectStatus {
  final StripeConnectStatusType status;
  final bool chargesEnabled;
  final bool payoutsEnabled;
  final bool detailsSubmitted;
  final String? accountId;

  const StripeConnectStatus({
    required this.status,
    this.chargesEnabled = false,
    this.payoutsEnabled = false,
    this.detailsSubmitted = false,
    this.accountId,
  });

  factory StripeConnectStatus.fromJson(Map<String, dynamic> json) {
    final chargesEnabled = json['chargesEnabled'] as bool? ?? false;
    final payoutsEnabled = json['payoutsEnabled'] as bool? ?? false;
    final detailsSubmitted = json['detailsSubmitted'] as bool? ?? false;
    final accountId = json['accountId'] as String?;

    // Determine status based on the response fields
    StripeConnectStatusType status;

    if (accountId == null || accountId.isEmpty) {
      status = StripeConnectStatusType.notStarted;
    } else if (chargesEnabled && payoutsEnabled) {
      status = StripeConnectStatusType.complete;
    } else if (detailsSubmitted) {
      // Details submitted but not fully enabled - pending verification
      status = StripeConnectStatusType.pending;
    } else {
      // Account exists but setup is incomplete
      status = StripeConnectStatusType.restricted;
    }

    // Allow explicit status override from API if provided
    final explicitStatus = json['status'] as String?;
    if (explicitStatus != null) {
      status = _parseStatus(explicitStatus);
    }

    return StripeConnectStatus(
      status: status,
      chargesEnabled: chargesEnabled,
      payoutsEnabled: payoutsEnabled,
      detailsSubmitted: detailsSubmitted,
      accountId: accountId,
    );
  }

  static StripeConnectStatusType _parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'complete':
      case 'enabled':
      case 'active':
        return StripeConnectStatusType.complete;
      case 'pending':
      case 'in_progress':
        return StripeConnectStatusType.pending;
      case 'restricted':
      case 'incomplete':
        return StripeConnectStatusType.restricted;
      case 'not_started':
      default:
        return StripeConnectStatusType.notStarted;
    }
  }

  /// Returns true if the account is fully set up and can receive payouts
  bool get isFullyOnboarded =>
      status == StripeConnectStatusType.complete && payoutsEnabled;

  /// Returns true if onboarding has been started but not completed
  bool get needsAttention =>
      status == StripeConnectStatusType.pending ||
      status == StripeConnectStatusType.restricted;
}
