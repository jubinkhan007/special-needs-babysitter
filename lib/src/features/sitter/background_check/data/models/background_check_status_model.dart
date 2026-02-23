/// Enum for background check status
enum BackgroundCheckStatusType {
  notStarted,
  pending,
  approved,
  rejected,
}

class BackgroundCheckStatus {
  final BackgroundCheckStatusType status;
  final bool hasBackgroundCheck;
  final String? identityStatus;
  final String? backgroundStatus;
  final bool canApplyForJobs;
  final String? rejectionReason;
  final DateTime? submittedAt;
  final DateTime? completedAt;

  const BackgroundCheckStatus({
    required this.status,
    this.hasBackgroundCheck = false,
    this.identityStatus,
    this.backgroundStatus,
    this.canApplyForJobs = false,
    this.rejectionReason,
    this.submittedAt,
    this.completedAt,
  });

  factory BackgroundCheckStatus.fromJson(Map<String, dynamic> json) {
    // Check for direct status field first (legacy support)
    final directStatus = json['status'] as String?;

    if (directStatus != null) {
      return BackgroundCheckStatus(
        status: _parseStatus(directStatus),
        hasBackgroundCheck: json['hasBackgroundCheck'] as bool? ?? false,
        identityStatus: json['identityStatus'] as String?,
        backgroundStatus: json['backgroundStatus'] as String?,
        canApplyForJobs: json['canApplyForJobs'] as bool? ?? false,
        rejectionReason: json['rejectionReason'] as String?,
        submittedAt: json['submittedAt'] != null
            ? DateTime.tryParse(json['submittedAt'])
            : null,
        completedAt: json['completedAt'] != null
            ? DateTime.tryParse(json['completedAt'])
            : null,
      );
    }

    // Parse from the API response structure with separate identity and background statuses
    final hasBackgroundCheck = json['hasBackgroundCheck'] as bool? ?? false;
    final identityStatus = json['identityStatus'] as String?;
    final backgroundStatus = json['backgroundStatus'] as String?;

    // Determine overall status based on the fields
    BackgroundCheckStatusType overallStatus;

    if (hasBackgroundCheck) {
      overallStatus = BackgroundCheckStatusType.approved;
    } else if (identityStatus == 'approved' && backgroundStatus == 'approved') {
      overallStatus = BackgroundCheckStatusType.approved;
    } else if (identityStatus == 'rejected' || backgroundStatus == 'rejected') {
      overallStatus = BackgroundCheckStatusType.rejected;
    } else if (identityStatus == 'pending' || backgroundStatus == 'pending') {
      overallStatus = BackgroundCheckStatusType.pending;
    } else {
      overallStatus = BackgroundCheckStatusType.notStarted;
    }

    return BackgroundCheckStatus(
      status: overallStatus,
      hasBackgroundCheck: hasBackgroundCheck,
      identityStatus: identityStatus,
      backgroundStatus: backgroundStatus,
      canApplyForJobs: json['canApplyForJobs'] as bool? ?? false,
      rejectionReason: json['rejectionReason'] as String?,
      submittedAt: json['submittedAt'] != null
          ? DateTime.tryParse(json['submittedAt'])
          : null,
      completedAt: json['completedAt'] != null
          ? DateTime.tryParse(json['completedAt'])
          : null,
    );
  }

  static BackgroundCheckStatusType _parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
      case 'in_progress':
        return BackgroundCheckStatusType.pending;
      case 'approved':
      case 'verified':
      case 'cleared':
        return BackgroundCheckStatusType.approved;
      case 'rejected':
      case 'failed':
        return BackgroundCheckStatusType.rejected;
      default:
        return BackgroundCheckStatusType.notStarted;
    }
  }
}
