import 'package:equatable/equatable.dart';
import '../../profile_details/entities/child.dart';

/// Job Address entity representing the location details of a job.
class JobAddress extends Equatable {
  final String streetAddress;
  final String? aptUnit;
  final String city;
  final String state;
  final String zipCode;
  final double? latitude;
  final double? longitude;

  const JobAddress({
    required this.streetAddress,
    this.aptUnit,
    required this.city,
    required this.state,
    required this.zipCode,
    this.latitude,
    this.longitude,
  });

  @override
  List<Object?> get props => [
        streetAddress,
        aptUnit,
        city,
        state,
        zipCode,
        latitude,
        longitude,
      ];
}

/// Job Location entity for simple coordinate representation.
class JobLocation extends Equatable {
  final double latitude;
  final double longitude;

  const JobLocation({
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [latitude, longitude];
}

/// Job entity representing a job posting.
class Job extends Equatable {
  final String? id;
  final String? parentUserId;
  final List<String> childIds;
  final List<Child> children;
  final String title;
  final String startDate; // Represented as YYYY-MM-DD
  final String endDate; // Represented as YYYY-MM-DD
  final String startTime; // Represented as HH:mm
  final String endTime; // Represented as HH:mm
  final String? timezone; // IANA timezone e.g. "America/Los_Angeles"
  final JobAddress address;
  final JobLocation? location;
  final String additionalDetails;
  final double payRate;
  final bool saveAsDraft;
  final String? status;
  final int? estimatedDuration;
  final double? estimatedTotal;
  final List<String> applicantIds;
  final String? acceptedSitterId;
  final DateTime? createdAt;
  final DateTime? postedAt;

  const Job({
    this.id,
    this.parentUserId,
    required this.childIds,
    this.children = const [],
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    this.timezone,
    required this.address,
    this.location,
    required this.additionalDetails,
    required this.payRate,
    this.saveAsDraft = false,
    this.status,
    this.estimatedDuration,
    this.estimatedTotal,
    this.applicantIds = const [],
    this.acceptedSitterId,
    this.createdAt,
    this.postedAt,
  });

  @override
  List<Object?> get props => [
        id,
        parentUserId,
        childIds,
        children,
        title,
        startDate,
        endDate,
        startTime,
        endTime,
        timezone,
        address,
        location,
        additionalDetails,
        payRate,
        saveAsDraft,
        status,
        estimatedDuration,
        estimatedTotal,
        applicantIds,
        acceptedSitterId,
        createdAt,
        postedAt,
      ];
}
