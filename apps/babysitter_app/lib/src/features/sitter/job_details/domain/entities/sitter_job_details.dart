import 'package:equatable/equatable.dart';

/// Child information for job details.
class JobChildInfo extends Equatable {
  final String name;
  final int age;

  const JobChildInfo({required this.name, required this.age});

  @override
  List<Object?> get props => [name, age];
}

/// Sitter job details entity.
class SitterJobDetails extends Equatable {
  final String id;
  final String title;
  final String postedTimeAgo;
  final bool isBookmarked;

  // Family info
  final String familyName;
  final String? familyAvatarUrl;
  final int childrenCount;
  final List<JobChildInfo> children;

  // Location
  final String location;
  final String distance;

  // Service details
  final String dateRange;
  final String timeRange;
  final String personality;
  final String allergies;
  final String triggers;
  final String calmingMethods;
  final String additionalNotes;

  // Transportation preferences
  final List<String> transportationModes;

  // Equipment & Safety
  final List<String> equipmentSafety;

  // Pickup / Drop-off
  final List<String> pickupDropoffDetails;

  // Skills
  final List<String> requiredSkills;

  // Rate
  final double hourlyRate;

  const SitterJobDetails({
    required this.id,
    required this.title,
    required this.postedTimeAgo,
    this.isBookmarked = false,
    required this.familyName,
    this.familyAvatarUrl,
    required this.childrenCount,
    required this.children,
    required this.location,
    required this.distance,
    required this.dateRange,
    required this.timeRange,
    required this.personality,
    required this.allergies,
    required this.triggers,
    required this.calmingMethods,
    required this.additionalNotes,
    required this.transportationModes,
    required this.equipmentSafety,
    required this.pickupDropoffDetails,
    required this.requiredSkills,
    required this.hourlyRate,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        postedTimeAgo,
        isBookmarked,
        familyName,
        familyAvatarUrl,
        childrenCount,
        children,
        location,
        distance,
        dateRange,
        timeRange,
        personality,
        allergies,
        triggers,
        calmingMethods,
        additionalNotes,
        transportationModes,
        equipmentSafety,
        pickupDropoffDetails,
        requiredSkills,
        hourlyRate,
      ];
}
