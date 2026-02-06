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
      final normalized =
          statusStr.toLowerCase().replaceAll(RegExp(r'[\s_-]'), '');
      switch (normalized) {
        case 'active':
        case 'inprogress':
          return JobStatus.active;
        case 'completed':
        case 'closed':
          return JobStatus.closed;
        case 'posted':
        case 'draft':
        case 'pending':
        default:
          return JobStatus.pending;
      }
    }

    // Helper to check if job is in draft status (needs payment)
    bool isDraftStatus(String statusStr) {
      final normalized = statusStr.toLowerCase().trim();
      return normalized == 'draft';
    }

    final childCount = childIds.length;
    final children = childCount > 0
        ? [
            ChildDetail(
              name: '$childCount ${childCount == 1 ? 'Child' : 'Children'}',
              ageYears: -1,
            ),
          ]
        : <ChildDetail>[];

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
      childIds: childIds,
      // Show a count-based placeholder in list views when only IDs are available.
      children: children,
      isDraft: isDraftStatus(status),
      parentUserId: parentUserId,
    );
  }

  JobDetails toJobDetails({
    String? emergencyContactName,
    String? emergencyContactPhone,
    String? emergencyContactRelation,
    List<dynamic>? childrenData,
  }) {
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
      final normalized =
          statusStr.toLowerCase().replaceAll(RegExp(r'[\s_-]'), '');
      switch (normalized) {
        case 'active':
        case 'inprogress':
          return JobStatus.active;
        case 'completed':
        case 'closed':
          return JobStatus.closed;
        case 'posted':
        case 'draft':
        case 'pending':
        default:
          return JobStatus.pending;
      }
    }

    // Helper to check if job is in draft status (needs payment)
    bool isDraftStatus(String statusStr) {
      final normalized = statusStr.toLowerCase().trim();
      return normalized == 'draft';
    }

    final trimmedEmergencyName = (emergencyContactName ?? '').trim();
    final trimmedEmergencyPhone = (emergencyContactPhone ?? '').trim();
    final trimmedEmergencyRelation = (emergencyContactRelation ?? '').trim();

    List<ChildDetail> mappedChildren = [];
    if (childrenData != null && childrenData.isNotEmpty) {
      mappedChildren = childrenData.map((c) {
        if (c is Map<String, dynamic>) {
          final name = c['firstName'] ?? c['name'] ?? c['fullName'] ?? 'Child';
          final age = c['age'] ?? c['ageYears'];
          final ageInt = age is int
              ? age
              : (age is String ? int.tryParse(age) : 0) ?? 0;
          return ChildDetail(name: name.toString(), ageYears: ageInt);
        }
        return const ChildDetail(name: 'Child', ageYears: 0);
      }).toList();
    } else {
      mappedChildren = childIds
          .map((id) => const ChildDetail(name: 'Child', ageYears: 0))
          .toList();
    }

    return JobDetails(
      id: id,
      status: mapStatus(status),
      title: title,
      postedAt: DateTime.parse(postedAt ?? createdAt),
      children: mappedChildren,
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
      emergencyContactName:
          trimmedEmergencyName.isEmpty ? 'Not Provided' : trimmedEmergencyName,
      emergencyContactPhone: trimmedEmergencyPhone,
      emergencyContactRelation: trimmedEmergencyRelation,
      additionalNotes: additionalDetails ?? '',
      hourlyRate: payRate,
      applicantsCount: applicantIds.length,
      isDraft: isDraftStatus(status),
      parentUserId: parentUserId,
    );
  }
}
