import 'package:equatable/equatable.dart';

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
  final List<String> childIds;
  final String title;
  final String startDate; // Represented as YYYY-MM-DD
  final String endDate; // Represented as YYYY-MM-DD
  final String startTime; // Represented as HH:mm
  final String endTime; // Represented as HH:mm
  final JobAddress address;
  final JobLocation? location;
  final String additionalDetails;
  final double payRate;
  final bool saveAsDraft;

  const Job({
    this.id,
    required this.childIds,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.address,
    this.location,
    required this.additionalDetails,
    required this.payRate,
    this.saveAsDraft = false,
  });

  @override
  List<Object?> get props => [
        id,
        childIds,
        title,
        startDate,
        endDate,
        startTime,
        endTime,
        address,
        location,
        additionalDetails,
        payRate,
        saveAsDraft,
      ];
}
