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

  JobPreview copyWith({
    String? id,
    String? title,
    String? familyName,
    String? familyAvatarUrl,
    int? childrenCount,
    List<ChildInfo>? children,
    String? location,
    String? distance,
    List<String>? requiredSkills,
    double? hourlyRate,
    bool? isBookmarked,
  }) {
    return JobPreview(
      id: id ?? this.id,
      title: title ?? this.title,
      familyName: familyName ?? this.familyName,
      familyAvatarUrl: familyAvatarUrl ?? this.familyAvatarUrl,
      childrenCount: childrenCount ?? this.childrenCount,
      children: children ?? this.children,
      location: location ?? this.location,
      distance: distance ?? this.distance,
      requiredSkills: requiredSkills ?? this.requiredSkills,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }
}

/// Child information for job preview.
class ChildInfo {
  final String name;
  final int age;

  const ChildInfo({required this.name, required this.age});
}
