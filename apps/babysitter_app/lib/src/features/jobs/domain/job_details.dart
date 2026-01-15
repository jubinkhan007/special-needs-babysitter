import 'package:flutter/material.dart';
import 'job.dart';

class JobDetails {
  final String id;
  final JobStatus status;
  final String title;
  final DateTime postedAt;
  final List<ChildDetail> children;
  final DateTime scheduleStartDate;
  final DateTime scheduleEndDate;
  final TimeOfDay scheduleStartTime;
  final TimeOfDay scheduleEndTime;
  final Address address;
  final String emergencyContactName;
  final String emergencyContactPhone;
  final String emergencyContactRelation;
  final String additionalNotes;
  final double hourlyRate;
  final int applicantsCount;

  const JobDetails({
    required this.id,
    required this.status,
    required this.title,
    required this.postedAt,
    required this.children,
    required this.scheduleStartDate,
    required this.scheduleEndDate,
    required this.scheduleStartTime,
    required this.scheduleEndTime,
    required this.address,
    required this.emergencyContactName,
    required this.emergencyContactPhone,
    required this.emergencyContactRelation,
    required this.additionalNotes,
    required this.hourlyRate,
    required this.applicantsCount,
  });
}
