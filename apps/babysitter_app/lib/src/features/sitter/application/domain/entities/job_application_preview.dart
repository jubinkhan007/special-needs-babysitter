import 'package:equatable/equatable.dart';

import '../../../job_details/domain/entities/sitter_job_details.dart';

/// Entity representing the application preview data.
class JobApplicationPreview extends Equatable {
  final String jobId;
  final SitterJobDetails jobDetails;
  final String coverLetter;

  const JobApplicationPreview({
    required this.jobId,
    required this.jobDetails,
    required this.coverLetter,
  });

  @override
  List<Object?> get props => [jobId, jobDetails, coverLetter];

  JobApplicationPreview copyWith({
    String? jobId,
    SitterJobDetails? jobDetails,
    String? coverLetter,
  }) {
    return JobApplicationPreview(
      jobId: jobId ?? this.jobId,
      jobDetails: jobDetails ?? this.jobDetails,
      coverLetter: coverLetter ?? this.coverLetter,
    );
  }
}
