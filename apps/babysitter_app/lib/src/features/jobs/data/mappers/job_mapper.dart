import 'package:flutter/material.dart';
import '../../domain/job_details.dart';
import '../models/job_dto.dart';
import '../../domain/job.dart';

extension JobDtoMapper on JobDto {
  Job toDomain() {
    // Helper to parse dates
    DateTime parseDate(String dateStr) {
      try {
        return DateTime.parse(dateStr);
      } catch (e) {
        return DateTime.now();
      }
    }

    // Helper to map status
    JobStatus mapStatus(String statusStr) {
      switch (statusStr.toLowerCase()) {
        case 'posted':
        case 'active':
          return JobStatus.active;
        case 'completed':
        case 'closed':
          return JobStatus.closed;
        case 'draft':
        case 'pending':
        default:
          return JobStatus.pending;
      }
    }

    return Job(
      id: id,
      title: title,
      status: mapStatus(status),
      // Use publicLocation if available, else combine city/state
      location: location?.type == 'Point' && address?.publicLocation != null
          ? address!.publicLocation
          : '${address?.city ?? "Unknown"}, ${address?.state ?? ""}'.trim(),
      scheduleDate: parseDate(startDate), // API has startDate "2026-01-17"
      rateText: '\$${payRate.toStringAsFixed(0)}/hr', // e.g. $25/hr
      // API does not return child names/ages, only IDs.
      // We return empty list to avoid displaying placeholder data.
      // If needed, we would need to fetch child details separately.
      children: [],
    );
  }

  JobDetails toJobDetails() {
    // Helper to parse dates
    DateTime parseDate(String dateStr) {
      try {
        return DateTime.parse(dateStr);
      } catch (e) {
        return DateTime.now();
      }
    }

    // Helper to parse time string "HH:mm:ss" to TimeOfDay
    TimeOfDay parseTime(String timeStr) {
      try {
        final parts = timeStr.split(':');
        return TimeOfDay(
            hour: int.parse(parts[0]), minute: int.parse(parts[1]));
      } catch (e) {
        return const TimeOfDay(hour: 0, minute: 0);
      }
    }

    // Reuse mapStatus from toDomain if possible or duplicate
    JobStatus mapStatus(String statusStr) {
      switch (statusStr.toLowerCase()) {
        case 'posted':
        case 'active':
          return JobStatus.active;
        case 'completed':
        case 'closed':
          return JobStatus.closed;
        case 'draft':
        case 'pending':
        default:
          return JobStatus.pending;
      }
    }

    return JobDetails(
      id: id,
      status: mapStatus(status),
      title: title,
      postedAt: DateTime.parse(postedAt ?? createdAt),
      children: childIds
          .map((id) => const ChildDetail(name: 'Child', ageYears: 0))
          .toList(),
      scheduleStartDate: parseDate(startDate),
      scheduleEndDate: parseDate(endDate),
      scheduleStartTime: parseTime(startTime),
      scheduleEndTime: parseTime(endTime),
      address: address != null
          ? Address(
              streetAddress: address!.streetAddress,
              aptUnit: address!.aptUnit ?? '',
              city: address!.city,
              state: address!.state,
              zipCode: address!.zipCode,
            )
          : const Address(
              streetAddress: '', aptUnit: '', city: '', state: '', zipCode: ''),
      emergencyContactName: 'Not Provided',
      emergencyContactPhone: '',
      emergencyContactRelation: '',
      additionalNotes: additionalDetails ?? '',
      hourlyRate: payRate,
      applicantsCount: applicantIds.length,
    );
  }
}
