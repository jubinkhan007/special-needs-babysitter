import 'package:flutter/material.dart';
import '../../../domain/job_details.dart';
import '../../../domain/job.dart';
import 'package:intl/intl.dart';

class JobDetailsUiModel {
  final String id;
  final bool isActive;
  final String title;
  final String postedAgoText;
  final List<MapEntry<String, String>> childDetailsRows;
  final String dateRangeText;
  final String timeRangeText;
  final String addressText;
  final String emergencyName;
  final String emergencyPhone;
  final String emergencyRelation;
  final String additionalNotes;
  final String hourlyRateText;
  final String applicantsTotalText;

  const JobDetailsUiModel({
    required this.id,
    required this.isActive,
    required this.title,
    required this.postedAgoText,
    required this.childDetailsRows,
    required this.dateRangeText,
    required this.timeRangeText,
    required this.addressText,
    required this.emergencyName,
    required this.emergencyPhone,
    required this.emergencyRelation,
    required this.additionalNotes,
    required this.hourlyRateText,
    required this.applicantsTotalText,
  });

  factory JobDetailsUiModel.fromDomain(JobDetails job) {
    // Helper formats
    final dateFormat = DateFormat('d MMM');
    final timeFormat = DateFormat('hh a');

    // 1. Posted Ago
    final diff = DateTime.now().difference(job.postedAt);
    String postedText;
    if (diff.inHours < 24) {
      postedText = 'Job posted ${diff.inHours} hour ago';
    } else {
      postedText = 'Job posted ${diff.inDays} days ago';
    }

    // 2. Children Rows
    final List<MapEntry<String, String>> kidsRows = [];
    kidsRows.add(MapEntry('No. Of Children', job.children.length.toString()));
    for (var child in job.children) {
      kidsRows.add(
          MapEntry(child.name, '${child.ageYears} years')); // "Ally", "4 years"
    }

    // 3. Date Range
    final dateRange =
        '${dateFormat.format(job.scheduleStartDate)} - ${dateFormat.format(job.scheduleEndDate)}';

    // 4. Time Range
    // Note: TimeOfDay formatting manual or via custom helper
    String formatTime(TimeOfDay t) {
      final now = DateTime.now();
      final dt = DateTime(now.year, now.month, now.day, t.hour, t.minute);
      return timeFormat.format(dt);
    }

    final timeRange =
        '${formatTime(job.scheduleStartTime)} - ${formatTime(job.scheduleEndTime)}';

    // 5. Applicants (leading zero)
    final applicants = job.applicantsCount.toString().padLeft(2, '0');

    return JobDetailsUiModel(
      id: job.id,
      isActive: job.status == JobStatus.active,
      title: job.title,
      postedAgoText: postedText,
      childDetailsRows: kidsRows,
      dateRangeText: dateRange,
      timeRangeText: timeRange,
      addressText: job.address,
      emergencyName: job.emergencyContactName,
      emergencyPhone: job.emergencyContactPhone,
      emergencyRelation: job.emergencyContactRelation,
      additionalNotes: job.additionalNotes,
      hourlyRateText: '\$${job.hourlyRate.toInt()}',
      applicantsTotalText: applicants,
    );
  }
}
