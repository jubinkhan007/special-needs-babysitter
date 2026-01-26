import 'package:equatable/equatable.dart';
import 'job_child_model.dart';
import 'job_coordinates_model.dart';

/// Model representing detailed job request information
class JobRequestDetailsModel extends Equatable {
  final String id;
  final String applicationId;
  final String applicationType;
  final String title;
  final String familyName;
  final int childrenCount;
  final List<JobChildModel> children;
  final String location;
  final String fullAddress;
  final double? distance;
  final double payRate;
  final String startDate;
  final String endDate;
  final String startTime;
  final String endTime;
  final int numberOfDays;
  final String? additionalNotes;
  final List<String> transportationModes;
  final List<String> equipmentSafety;
  final String? pickupLocation;
  final String? dropoffLocation;
  final String? transportSpecialInstructions;
  final List<String> sitterSkills;
  final bool isToday;
  final bool canClockIn;
  final String? clockInMessage;
  final DateTime? clockInAt;
  final JobCoordinatesModel? jobCoordinates;
  final int? geofenceRadiusMeters;
  final double? subTotal;
  final double? totalHours;
  final double? platformFee;
  final double? discount;

  const JobRequestDetailsModel({
    required this.id,
    required this.applicationId,
    required this.applicationType,
    required this.title,
    required this.familyName,
    required this.childrenCount,
    required this.children,
    required this.location,
    required this.fullAddress,
    this.distance,
    required this.payRate,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.numberOfDays,
    this.additionalNotes,
    this.transportationModes = const [],
    this.equipmentSafety = const [],
    this.pickupLocation,
    this.dropoffLocation,
    this.transportSpecialInstructions,
    this.sitterSkills = const [],
    required this.isToday,
    required this.canClockIn,
    this.clockInMessage,
    this.clockInAt,
    this.jobCoordinates,
    this.geofenceRadiusMeters,
    this.subTotal,
    this.totalHours,
    this.platformFee,
    this.discount,
  });

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is String) {
      final trimmed = value.trim();
      if (trimmed.isEmpty) {
        return null;
      }
      return DateTime.tryParse(trimmed);
    }
    if (value is num) {
      final milliseconds = value > 1000000000000 ? value : value * 1000;
      return DateTime.fromMillisecondsSinceEpoch(milliseconds.toInt());
    }
    return null;
  }

  factory JobRequestDetailsModel.fromJson(Map<String, dynamic> json) {
    final clockInRaw = json['clockInAt'] ??
        json['clockInTime'] ??
        json['clockedInAt'] ??
        json['clockedInTime'];

    return JobRequestDetailsModel(
      id: json['id'] as String,
      applicationId: json['applicationId'] as String,
      applicationType: json['applicationType'] as String? ?? 'invited',
      title: json['title'] as String,
      familyName: json['familyName'] as String,
      childrenCount: json['childrenCount'] as int,
      children: (json['children'] as List)
          .map((e) => JobChildModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      location: json['location'] as String,
      fullAddress: json['fullAddress'] as String,
      distance: json['distance'] as double?,
      payRate: (json['payRate'] as num).toDouble(),
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      numberOfDays: json['numberOfDays'] as int,
      additionalNotes: json['additionalNotes'] as String?,
      transportationModes:
          (json['transportationModes'] as List?)?.cast<String>() ?? [],
      equipmentSafety:
          (json['equipmentSafety'] as List?)?.cast<String>() ?? [],
      pickupLocation: json['pickupLocation'] as String?,
      dropoffLocation: json['dropoffLocation'] as String?,
      transportSpecialInstructions:
          json['transportSpecialInstructions'] as String?,
      sitterSkills: (json['sitterSkills'] as List?)?.cast<String>() ?? [],
      isToday: json['isToday'] as bool,
      canClockIn: json['canClockIn'] as bool,
      clockInMessage: json['clockInMessage'] as String?,
      clockInAt: _parseDateTime(clockInRaw),
      jobCoordinates: json['jobCoordinates'] != null
          ? JobCoordinatesModel.fromJson(
              json['jobCoordinates'] as Map<String, dynamic>)
          : null,
      geofenceRadiusMeters: json['geofenceRadiusMeters'] as int?,
      subTotal: (json['subTotal'] as num?)?.toDouble(),
      totalHours: (json['totalHours'] as num?)?.toDouble(),
      platformFee: (json['platformFee'] as num?)?.toDouble(),
      discount: (json['discount'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'applicationId': applicationId,
      'applicationType': applicationType,
      'title': title,
      'familyName': familyName,
      'childrenCount': childrenCount,
      'children': children.map((e) => e.toJson()).toList(),
      'location': location,
      'fullAddress': fullAddress,
      'distance': distance,
      'payRate': payRate,
      'startDate': startDate,
      'endDate': endDate,
      'startTime': startTime,
      'endTime': endTime,
      'numberOfDays': numberOfDays,
      'additionalNotes': additionalNotes,
      'transportationModes': transportationModes,
      'equipmentSafety': equipmentSafety,
      'pickupLocation': pickupLocation,
      'dropoffLocation': dropoffLocation,
      'transportSpecialInstructions': transportSpecialInstructions,
      'sitterSkills': sitterSkills,
      'isToday': isToday,
      'canClockIn': canClockIn,
      'clockInMessage': clockInMessage,
      'clockInAt': clockInAt?.toIso8601String(),
      'jobCoordinates': jobCoordinates?.toJson(),
      'geofenceRadiusMeters': geofenceRadiusMeters,
      'subTotal': subTotal,
      'totalHours': totalHours,
      'platformFee': platformFee,
      'discount': discount,
    };
  }

  @override
  List<Object?> get props => [
        id,
        applicationId,
        applicationType,
        title,
        familyName,
        childrenCount,
        children,
        location,
        fullAddress,
        distance,
        payRate,
        startDate,
        endDate,
        startTime,
        endTime,
        numberOfDays,
        additionalNotes,
        transportationModes,
        equipmentSafety,
        pickupLocation,
        dropoffLocation,
        transportSpecialInstructions,
        sitterSkills,
        isToday,
        canClockIn,
        clockInMessage,
        clockInAt,
        jobCoordinates,
        geofenceRadiusMeters,
        subTotal,
        totalHours,
        platformFee,
        discount,
      ];
}
