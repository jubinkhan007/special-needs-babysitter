/// DTO for submit application request body.
class SubmitApplicationRequestDto {
  final String jobId;
  final String coverLetter;

  const SubmitApplicationRequestDto({
    required this.jobId,
    required this.coverLetter,
  });

  Map<String, dynamic> toJson() {
    return {
      'jobId': jobId,
      'coverLetter': coverLetter,
    };
  }
}
