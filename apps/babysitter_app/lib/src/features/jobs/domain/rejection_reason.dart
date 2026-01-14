enum RejectionReason {
  scheduleConflict,
  experienceMismatch,
  communicationIssues,
  payRateDisagreement,
  notAGoodFit,
  other,
}

extension RejectionReasonX on RejectionReason {
  String get displayLabel {
    switch (this) {
      case RejectionReason.scheduleConflict:
        return 'Schedule Conflict';
      case RejectionReason.experienceMismatch:
        return 'Experience Mismatch';
      case RejectionReason.communicationIssues:
        return 'Communication Issues';
      case RejectionReason.payRateDisagreement:
        return 'Pay Rate Disagreement';
      case RejectionReason.notAGoodFit:
        return 'Not a Good Fit';
      case RejectionReason.other:
        return 'Other';
    }
  }
}
