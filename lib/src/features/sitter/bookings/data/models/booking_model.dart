import 'package:equatable/equatable.dart';

/// Model for a single booking item.
class BookingModel extends Equatable {
  final String id;
  final String applicationId;
  final String title;
  final String familyName;
  final int childrenCount;
  final String location;
  final double? distance;
  final double payRate;
  final String startDate;
  final String endDate;
  final String startTime;
  final String endTime;
  final bool isToday;
  final double? hoursUntilStart;
  final String? status;

  const BookingModel({
    required this.id,
    required this.applicationId,
    required this.title,
    required this.familyName,
    required this.childrenCount,
    required this.location,
    this.distance,
    required this.payRate,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.isToday,
    this.hoursUntilStart,
    this.status,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] as String,
      applicationId: json['applicationId'] as String,
      title: json['title'] as String,
      familyName: json['familyName'] as String,
      childrenCount: json['childrenCount'] as int,
      location: json['location'] as String,
      distance: json['distance'] != null ? (json['distance'] as num).toDouble() : null,
      payRate: (json['payRate'] as num).toDouble(),
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      isToday: json['isToday'] as bool,
      hoursUntilStart: json['hoursUntilStart'] != null
          ? (json['hoursUntilStart'] as num).toDouble()
          : null,
      status: json['status'] as String?,
    );
  }

  BookingModel copyWith({
    String? id,
    String? applicationId,
    String? title,
    String? familyName,
    int? childrenCount,
    String? location,
    double? distance,
    double? payRate,
    String? startDate,
    String? endDate,
    String? startTime,
    String? endTime,
    bool? isToday,
    double? hoursUntilStart,
    String? status,
  }) {
    return BookingModel(
      id: id ?? this.id,
      applicationId: applicationId ?? this.applicationId,
      title: title ?? this.title,
      familyName: familyName ?? this.familyName,
      childrenCount: childrenCount ?? this.childrenCount,
      location: location ?? this.location,
      distance: distance ?? this.distance,
      payRate: payRate ?? this.payRate,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isToday: isToday ?? this.isToday,
      hoursUntilStart: hoursUntilStart ?? this.hoursUntilStart,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'applicationId': applicationId,
      'title': title,
      'familyName': familyName,
      'childrenCount': childrenCount,
      'location': location,
      'distance': distance,
      'payRate': payRate,
      'startDate': startDate,
      'endDate': endDate,
      'startTime': startTime,
      'endTime': endTime,
      'isToday': isToday,
      'hoursUntilStart': hoursUntilStart,
      'status': status,
    };
  }

  @override
  List<Object?> get props => [
        id,
        applicationId,
        title,
        familyName,
        childrenCount,
        location,
        distance,
        payRate,
        startDate,
        endDate,
        startTime,
        endTime,
        isToday,
        hoursUntilStart,
        status,
      ];
}
