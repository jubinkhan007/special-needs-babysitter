import 'package:equatable/equatable.dart';
import '../../../jobs/data/models/job_coordinates_model.dart';

class BookingSessionChildModel extends Equatable {
  final String firstName;
  final String? lastName;
  final int age;
  final List<String> specialNeeds;

  const BookingSessionChildModel({
    required this.firstName,
    this.lastName,
    required this.age,
    this.specialNeeds = const [],
  });

  factory BookingSessionChildModel.fromJson(Map<String, dynamic> json) {
    return BookingSessionChildModel(
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String?,
      age: json['age'] as int? ?? 0,
      specialNeeds: (json['specialNeeds'] as List?)?.cast<String>() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'age': age,
      'specialNeeds': specialNeeds,
    };
  }

  @override
  List<Object?> get props => [firstName, lastName, age, specialNeeds];
}

class BookingSessionModel extends Equatable {
  final String id;
  final String applicationId;
  final String jobTitle;
  final String familyName;
  final List<BookingSessionChildModel> children;
  final String location;
  final String fullAddress;
  final JobCoordinatesModel? coordinates;
  final double payRate;
  final DateTime? clockInTime;
  final DateTime? scheduledEndTime;
  final bool isPaused;
  final DateTime? pausedAt;
  final int totalPausedDurationSeconds;
  final String? currentBreakReason;
  final List<JobCoordinatesModel> routeCoordinates;

  const BookingSessionModel({
    required this.id,
    required this.applicationId,
    required this.jobTitle,
    required this.familyName,
    required this.children,
    required this.location,
    required this.fullAddress,
    this.coordinates,
    required this.payRate,
    this.clockInTime,
    this.scheduledEndTime,
    this.isPaused = false,
    this.pausedAt,
    this.totalPausedDurationSeconds = 0,
    this.currentBreakReason,
    this.routeCoordinates = const [],
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

  static int _parseDurationSeconds(dynamic value) {
    if (value == null) {
      return 0;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }

  factory BookingSessionModel.fromJson(Map<String, dynamic> json) {
    final clockInRaw = json['clockInTime'] ??
        json['clockInAt'] ??
        json['clockedInAt'] ??
        json['clockedInTime'];
    final scheduledEndRaw = json['scheduledEndTime'] ??
        json['scheduledEndAt'] ??
        json['scheduledEnd'] ??
        json['endTime'];

    return BookingSessionModel(
      id: json['id'] as String? ?? '',
      applicationId: json['applicationId'] as String? ?? '',
      jobTitle: json['jobTitle'] as String? ?? json['title'] as String? ?? '',
      familyName: json['familyName'] as String? ?? '',
      children: (json['children'] as List?)
              ?.map((e) =>
                  BookingSessionChildModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      location: json['location'] as String? ?? '',
      fullAddress: json['fullAddress'] as String? ?? '',
      coordinates: json['coordinates'] != null
          ? JobCoordinatesModel.fromJson(
              json['coordinates'] as Map<String, dynamic>)
          : null,
      payRate: (json['payRate'] as num?)?.toDouble() ?? 0,
      clockInTime: _parseDateTime(clockInRaw),
      scheduledEndTime: _parseDateTime(scheduledEndRaw),
      isPaused: json['isPaused'] as bool? ?? false,
      pausedAt: _parseDateTime(json['pausedAt']),
      totalPausedDurationSeconds:
          _parseDurationSeconds(json['totalPausedDuration']),
      currentBreakReason: json['currentBreakReason'] as String?,
      routeCoordinates: (json['routeCoordinates'] as List?)
              ?.map((e) =>
                  JobCoordinatesModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'applicationId': applicationId,
      'jobTitle': jobTitle,
      'familyName': familyName,
      'children': children.map((e) => e.toJson()).toList(),
      'location': location,
      'fullAddress': fullAddress,
      'coordinates': coordinates?.toJson(),
      'payRate': payRate,
      'clockInTime': clockInTime?.toIso8601String(),
      'scheduledEndTime': scheduledEndTime?.toIso8601String(),
      'isPaused': isPaused,
      'pausedAt': pausedAt?.toIso8601String(),
      'totalPausedDuration': totalPausedDurationSeconds,
      'currentBreakReason': currentBreakReason,
      'routeCoordinates': routeCoordinates.map((e) => e.toJson()).toList(),
    };
  }

  Duration elapsedTime(DateTime now) {
    if (clockInTime == null) {
      return Duration.zero;
    }
    final reference =
        isPaused && pausedAt != null ? pausedAt! : now;
    final rawElapsed = reference.difference(clockInTime!);
    if (rawElapsed.isNegative) {
      return Duration.zero;
    }
    final adjusted = rawElapsed - Duration(seconds: totalPausedDurationSeconds);
    return adjusted.isNegative ? Duration.zero : adjusted;
  }

  BookingSessionModel copyWith({
    String? id,
    String? applicationId,
    String? jobTitle,
    String? familyName,
    List<BookingSessionChildModel>? children,
    String? location,
    String? fullAddress,
    JobCoordinatesModel? coordinates,
    double? payRate,
    DateTime? clockInTime,
    DateTime? scheduledEndTime,
    bool? isPaused,
    DateTime? pausedAt,
    int? totalPausedDurationSeconds,
    String? currentBreakReason,
    List<JobCoordinatesModel>? routeCoordinates,
  }) {
    return BookingSessionModel(
      id: id ?? this.id,
      applicationId: applicationId ?? this.applicationId,
      jobTitle: jobTitle ?? this.jobTitle,
      familyName: familyName ?? this.familyName,
      children: children ?? this.children,
      location: location ?? this.location,
      fullAddress: fullAddress ?? this.fullAddress,
      coordinates: coordinates ?? this.coordinates,
      payRate: payRate ?? this.payRate,
      clockInTime: clockInTime ?? this.clockInTime,
      scheduledEndTime: scheduledEndTime ?? this.scheduledEndTime,
      isPaused: isPaused ?? this.isPaused,
      pausedAt: pausedAt ?? this.pausedAt,
      totalPausedDurationSeconds:
          totalPausedDurationSeconds ?? this.totalPausedDurationSeconds,
      currentBreakReason: currentBreakReason ?? this.currentBreakReason,
      routeCoordinates: routeCoordinates ?? this.routeCoordinates,
    );
  }

  @override
  List<Object?> get props => [
        id,
        applicationId,
        jobTitle,
        familyName,
        children,
        location,
        fullAddress,
        coordinates,
        payRate,
        clockInTime,
        scheduledEndTime,
        isPaused,
        pausedAt,
        totalPausedDurationSeconds,
        currentBreakReason,
        routeCoordinates,
      ];
}
