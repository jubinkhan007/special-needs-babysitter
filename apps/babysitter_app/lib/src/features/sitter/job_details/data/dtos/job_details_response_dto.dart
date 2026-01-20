/// DTO for job details API response.
class JobDetailsResponseDto {
  final bool success;
  final JobDetailsDataDto data;

  const JobDetailsResponseDto({
    required this.success,
    required this.data,
  });

  factory JobDetailsResponseDto.fromJson(Map<String, dynamic> json) {
    return JobDetailsResponseDto(
      success: json['success'] as bool? ?? false,
      data: JobDetailsDataDto.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class JobDetailsDataDto {
  final JobDetailDto job;
  final List<JobChildDto>? children; // May come from job.children or top-level

  const JobDetailsDataDto({
    required this.job,
    this.children,
  });

  factory JobDetailsDataDto.fromJson(Map<String, dynamic> json) {
    final jobJson = json['job'] as Map<String, dynamic>;

    // Children can be at top level OR inside job object
    List<JobChildDto> parsedChildren = [];

    // Try top-level children first
    if (json['children'] != null) {
      parsedChildren = (json['children'] as List<dynamic>)
          .map((e) => JobChildDto.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    // If not, try job.children
    else if (jobJson['children'] != null) {
      parsedChildren = (jobJson['children'] as List<dynamic>)
          .map((e) => JobChildDto.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return JobDetailsDataDto(
      job: JobDetailDto.fromJson(jobJson),
      children: parsedChildren,
    );
  }
}

class JobDetailDto {
  final String id;
  final String? parentUserId;
  final List<String>? childIds;
  final String title;
  final String? familyName;
  final String? familyPhotoUrl;
  final String? familyBio;
  final int? childrenCount;
  final String? startDate;
  final String? endDate;
  final String? startTime;
  final String? endTime;
  final String? location;
  final double? distance;
  final JobAddressDto? address;
  final String? additionalDetails;
  final double payRate;
  final String? status;
  final int? estimatedDuration;
  final double? estimatedTotal;
  final List<String>? applicantIds;
  final String? acceptedSitterId;
  final String? createdAt;
  final String? updatedAt;
  final String? postedAt;
  final String? cancelledAt;

  const JobDetailDto({
    required this.id,
    this.parentUserId,
    this.childIds,
    required this.title,
    this.familyName,
    this.familyPhotoUrl,
    this.familyBio,
    this.childrenCount,
    this.startDate,
    this.endDate,
    this.startTime,
    this.endTime,
    this.location,
    this.distance,
    this.address,
    this.additionalDetails,
    required this.payRate,
    this.status,
    this.estimatedDuration,
    this.estimatedTotal,
    this.applicantIds,
    this.acceptedSitterId,
    this.createdAt,
    this.updatedAt,
    this.postedAt,
    this.cancelledAt,
  });

  factory JobDetailDto.fromJson(Map<String, dynamic> json) {
    return JobDetailDto(
      id: json['id'] as String,
      parentUserId: json['parentUserId'] as String?,
      childIds: (json['childIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      title: json['title'] as String? ?? 'Untitled Job',
      familyName: json['familyName'] as String?,
      familyPhotoUrl: json['familyPhotoUrl'] as String?,
      familyBio: json['familyBio'] as String?,
      childrenCount: json['childrenCount'] as int?,
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      startTime: json['startTime'] as String?,
      endTime: json['endTime'] as String?,
      location: json['location'] as String?,
      distance: (json['distance'] as num?)?.toDouble(),
      address: json['address'] != null
          ? JobAddressDto.fromJson(json['address'] as Map<String, dynamic>)
          : null,
      additionalDetails: json['additionalDetails'] as String?,
      payRate: (json['payRate'] as num?)?.toDouble() ?? 0,
      status: json['status'] as String?,
      estimatedDuration: json['estimatedDuration'] as int?,
      estimatedTotal: (json['estimatedTotal'] as num?)?.toDouble(),
      applicantIds: (json['applicantIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      acceptedSitterId: json['acceptedSitterId'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      postedAt: json['postedAt'] as String?,
      cancelledAt: json['cancelledAt'] as String?,
    );
  }
}

class JobAddressDto {
  final String? streetAddress;
  final String? aptUnit;
  final String? city;
  final String? state;
  final String? zipCode;
  final double? latitude;
  final double? longitude;
  final String? publicLocation;

  const JobAddressDto({
    this.streetAddress,
    this.aptUnit,
    this.city,
    this.state,
    this.zipCode,
    this.latitude,
    this.longitude,
    this.publicLocation,
  });

  factory JobAddressDto.fromJson(Map<String, dynamic> json) {
    return JobAddressDto(
      streetAddress: json['streetAddress'] as String?,
      aptUnit: json['aptUnit'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      zipCode: json['zipCode'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      publicLocation: json['publicLocation'] as String?,
    );
  }
}

class JobChildDto {
  final String? id;
  final String firstName;
  final String? lastName;
  final int age;
  final String? specialNeedsDiagnosis;
  final String? personalityDescription;
  final bool? hasAllergies;
  final List<String>? allergyTypes;
  final bool? hasTriggers;
  final String? triggers;
  final String? calmingMethods;
  final List<String>? transportationModes;
  final List<String>? equipmentSafety;
  final bool? needsDropoff;
  final String? pickupLocation;
  final String? dropoffLocation;

  const JobChildDto({
    this.id,
    required this.firstName,
    this.lastName,
    required this.age,
    this.specialNeedsDiagnosis,
    this.personalityDescription,
    this.hasAllergies,
    this.allergyTypes,
    this.hasTriggers,
    this.triggers,
    this.calmingMethods,
    this.transportationModes,
    this.equipmentSafety,
    this.needsDropoff,
    this.pickupLocation,
    this.dropoffLocation,
  });

  factory JobChildDto.fromJson(Map<String, dynamic> json) {
    return JobChildDto(
      id: json['id'] as String?,
      firstName: json['firstName'] as String? ?? 'Child',
      lastName: json['lastName'] as String?,
      age: json['age'] as int? ?? 0,
      specialNeedsDiagnosis: json['specialNeedsDiagnosis'] as String?,
      personalityDescription: json['personalityDescription'] as String?,
      hasAllergies: json['hasAllergies'] as bool?,
      allergyTypes: (json['allergyTypes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      hasTriggers: json['hasTriggers'] as bool?,
      triggers: json['triggers'] as String?,
      calmingMethods: json['calmingMethods'] as String?,
      transportationModes: (json['transportationModes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      equipmentSafety: (json['equipmentSafety'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      needsDropoff: json['needsDropoff'] as bool?,
      pickupLocation: json['pickupLocation'] as String?,
      dropoffLocation: json['dropoffLocation'] as String?,
    );
  }
}
