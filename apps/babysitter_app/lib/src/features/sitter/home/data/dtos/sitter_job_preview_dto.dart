import '../../domain/entities/job_preview.dart';

/// DTO for child info in the sitter jobs list API response
class ChildInfoDto {
  final String? firstName;
  final int? age;

  const ChildInfoDto({
    this.firstName,
    this.age,
  });

  factory ChildInfoDto.fromJson(Map<String, dynamic> json) {
    return ChildInfoDto(
      firstName: json['firstName'] as String?,
      age: json['age'] as int?,
    );
  }

  ChildInfo toDomain() => ChildInfo(
        name: firstName ?? 'Child',
        age: age ?? 0,
      );
}

/// DTO for the sitter jobs list API response
/// This matches the actual API response structure from GET /jobs?status=posted
class SitterJobPreviewDto {
  final String id;
  final String title;
  final String? familyName;
  final String? familyPhotoUrl;
  final int childrenCount;
  final List<ChildInfoDto> children;
  final String? location;
  final String? distance;
  final List<String> requiredSkills;
  final double payRate;
  final String? startDate;
  final String? endDate;
  final String? startTime;
  final String? endTime;
  final DateTime? postedAt;
  final bool hasApplied;
  final bool isSaved;

  const SitterJobPreviewDto({
    required this.id,
    required this.title,
    this.familyName,
    this.familyPhotoUrl,
    this.childrenCount = 0,
    this.children = const [],
    this.location,
    this.distance,
    this.requiredSkills = const [],
    this.payRate = 0.0,
    this.startDate,
    this.endDate,
    this.startTime,
    this.endTime,
    this.postedAt,
    this.hasApplied = false,
    this.isSaved = false,
  });

  factory SitterJobPreviewDto.fromJson(Map<String, dynamic> json) {
    // Parse children list
    final childrenJson = json['children'] as List<dynamic>? ?? [];
    final children = childrenJson
        .map((c) => ChildInfoDto.fromJson(c as Map<String, dynamic>))
        .toList();

    // Parse requiredSkills list
    final skillsJson = json['requiredSkills'] as List<dynamic>? ?? [];
    final skills = skillsJson.map((s) => s.toString()).toList();

    return SitterJobPreviewDto(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      familyName: json['familyName'] as String?,
      familyPhotoUrl: json['familyPhotoUrl'] as String?,
      childrenCount: json['childrenCount'] as int? ?? 0,
      children: children,
      location: json['location'] as String?,
      distance: json['distance'] as String?,
      requiredSkills: skills,
      payRate: (json['payRate'] as num?)?.toDouble() ?? 0.0,
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      startTime: json['startTime'] as String?,
      endTime: json['endTime'] as String?,
      postedAt: json['postedAt'] != null
          ? DateTime.tryParse(json['postedAt'] as String)
          : null,
      hasApplied: json['hasApplied'] as bool? ?? false,
      isSaved: json['isSaved'] as bool? ?? false,
    );
  }

  JobPreview toDomain() => JobPreview(
        id: id,
        title: title,
        familyName: familyName ?? 'Family',
        childrenCount: childrenCount,
        children: children.map((c) => c.toDomain()).toList(),
        location: location ?? '',
        distance: distance ?? '',
        requiredSkills: requiredSkills,
        hourlyRate: payRate,
        isBookmarked: isSaved,
      );
}
