enum RejectionReason {
  scheduleConflict,
  notTheRightFit,
  experienceMismatch,
  communicationConcerns,
  payRateIssue,
  other,
}

extension RejectionReasonX on RejectionReason {
  String get displayLabel {
    switch (this) {
      case RejectionReason.scheduleConflict:
        return 'Schedule Conflict';
      case RejectionReason.notTheRightFit:
        return 'Not the Right Fit';
      case RejectionReason.experienceMismatch:
        return 'Experience Mismatch';
      case RejectionReason.communicationConcerns:
        return 'Communication Concerns';
      case RejectionReason.payRateIssue:
        return 'Pay / Rate Issue';
      case RejectionReason.other:
        return 'Other';
    }
  }
}
