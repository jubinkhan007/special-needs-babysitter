/// Represents a job preview for the sitter home screen.
class JobPreview {
  final String id;
  final String title;
  final String familyName;
  final String? familyAvatarUrl;
  final int childrenCount;
  final List<ChildInfo> children;
  final String location;
  final String distance;
  final List<String> requiredSkills;
  final double hourlyRate;
  final bool isBookmarked;

  const JobPreview({
    required this.id,
    required this.title,
    required this.familyName,
    this.familyAvatarUrl,
    required this.childrenCount,
    required this.children,
    required this.location,
    required this.distance,
    required this.requiredSkills,
    required this.hourlyRate,
    this.isBookmarked = false,
  });
}

/// Child information for job preview.
class ChildInfo {
  final String name;
  final int age;

  const ChildInfo({required this.name, required this.age});
}
