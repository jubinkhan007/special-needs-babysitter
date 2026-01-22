import 'package:equatable/equatable.dart';

class ApplicationModel extends Equatable {
  final String id;
  final String status;
  final bool isInvitation;
  final String applicationType;
  final String? coverLetter;
  final DateTime createdAt;
  final ApplicationJobModel job;

  const ApplicationModel({
    required this.id,
    required this.status,
    required this.isInvitation,
    required this.applicationType,
    this.coverLetter,
    required this.createdAt,
    required this.job,
  });

  factory ApplicationModel.fromJson(Map<String, dynamic> json) {
    return ApplicationModel(
      id: json['id'] as String,
      status: json['status'] as String,
      isInvitation: json['isInvitation'] as bool,
      applicationType: json['applicationType'] as String,
      coverLetter: json['coverLetter'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      job: ApplicationJobModel.fromJson(json['job'] as Map<String, dynamic>),
    );
  }

  @override
  List<Object?> get props => [
        id,
        status,
        isInvitation,
        applicationType,
        coverLetter,
        createdAt,
        job,
      ];
}

class ApplicationJobModel extends Equatable {
  final String id;
  final String title;
  final String familyName;
  final String? familyPhotoUrl;
  final String location;
  final double payRate;
  final String startDate;
  final String endDate;
  final String startTime;
  final String endTime;
  final int estimatedDuration;
  final double estimatedTotal;
  final int childrenCount;
  final List<ApplicationChildModel> children;
  final String? additionalDetails;
  final String? fullAddress;

  const ApplicationJobModel({
    required this.id,
    required this.title,
    required this.familyName,
    this.familyPhotoUrl,
    required this.location,
    required this.payRate,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.estimatedDuration,
    required this.estimatedTotal,
    required this.childrenCount,
    required this.children,
    this.additionalDetails,
    this.fullAddress,
  });

  factory ApplicationJobModel.fromJson(Map<String, dynamic> json) {
    return ApplicationJobModel(
      id: json['id'] as String,
      title: json['title'] as String,
      familyName: json['familyName'] as String,
      familyPhotoUrl: json['familyPhotoUrl'] as String?,
      location: json['location'] as String,
      payRate: (json['payRate'] as num).toDouble(),
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      estimatedDuration: json['estimatedDuration'] as int,
      estimatedTotal: (json['estimatedTotal'] as num).toDouble(),
      childrenCount: json['childrenCount'] as int,
      children: (json['children'] as List)
          .map((e) => ApplicationChildModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      additionalDetails: json['additionalDetails'] as String?,
      fullAddress: json['fullAddress'] as String?,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        familyName,
        familyPhotoUrl,
        location,
        payRate,
        startDate,
        endDate,
        startTime,
        endTime,
        estimatedDuration,
        estimatedTotal,
        childrenCount,
        children,
        additionalDetails,
        fullAddress,
      ];
}

class ApplicationChildModel extends Equatable {
  final String id;
  final String firstName;
  final String? lastName;
  final int age;
  final String? specialNeedsDiagnosis;
  final String? personalityDescription;
  final String? medicationDietaryNeeds;
  final bool hasAllergies;
  final List<String> allergyTypes;
  final bool hasTriggers;
  final List<String> triggerTypes;
  final String? triggers;
  final String? calmingMethods;
  final List<String> transportationModes;
  final List<String> equipmentSafety;
  final bool needsDropoff;
  final String? pickupLocation;
  final String? dropoffLocation;
  final String? transportSpecialInstructions;

  const ApplicationChildModel({
    required this.id,
    required this.firstName,
    this.lastName,
    required this.age,
    this.specialNeedsDiagnosis,
    this.personalityDescription,
    this.medicationDietaryNeeds,
    required this.hasAllergies,
    required this.allergyTypes,
    required this.hasTriggers,
    required this.triggerTypes,
    this.triggers,
    this.calmingMethods,
    required this.transportationModes,
    required this.equipmentSafety,
    required this.needsDropoff,
    this.pickupLocation,
    this.dropoffLocation,
    this.transportSpecialInstructions,
  });

  factory ApplicationChildModel.fromJson(Map<String, dynamic> json) {
    return ApplicationChildModel(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String?,
      age: json['age'] as int,
      specialNeedsDiagnosis: json['specialNeedsDiagnosis'] as String?,
      personalityDescription: json['personalityDescription'] as String?,
      medicationDietaryNeeds: json['medicationDietaryNeeds'] as String?,
      hasAllergies: json['hasAllergies'] as bool? ?? false,
      allergyTypes: (json['allergyTypes'] as List?)?.cast<String>() ?? [],
      hasTriggers: json['hasTriggers'] as bool? ?? false,
      triggerTypes: (json['triggerTypes'] as List?)?.cast<String>() ?? [],
      triggers: json['triggers'] as String?,
      calmingMethods: json['calmingMethods'] as String?,
      transportationModes: (json['transportationModes'] as List?)?.cast<String>() ?? [],
      equipmentSafety: (json['equipmentSafety'] as List?)?.cast<String>() ?? [],
      needsDropoff: json['needsDropoff'] as bool? ?? false,
      pickupLocation: json['pickupLocation'] as String?,
      dropoffLocation: json['dropoffLocation'] as String?,
      transportSpecialInstructions: json['transportSpecialInstructions'] as String?,
    );
  }

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        age,
        specialNeedsDiagnosis,
        personalityDescription,
        medicationDietaryNeeds,
        hasAllergies,
        allergyTypes,
        hasTriggers,
        triggerTypes,
        triggers,
        calmingMethods,
        transportationModes,
        equipmentSafety,
        needsDropoff,
        pickupLocation,
        dropoffLocation,
        transportSpecialInstructions,
      ];
}
