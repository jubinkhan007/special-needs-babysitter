import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:equatable/equatable.dart';
import '../../../application/data/models/application_model.dart';
import '../../../application/presentation/providers/application_providers.dart';
import 'package:flutter/foundation.dart';

class ApplicationsFilter extends Equatable {
  final String? status;
  final String? type;

  const ApplicationsFilter({this.status, this.type});

  @override
  List<Object?> get props => [status, type];
}

final sitterJobApplicationsProvider = FutureProvider.family
    .autoDispose<List<ApplicationModel>, ApplicationsFilter>(
  (ref, filter) async {
    final repository = ref.watch(applicationRepositoryProvider);
    final now = DateTime.now();
    final statusFilter = filter.status?.toLowerCase();
    final typeFilter = filter.type?.toLowerCase();

    if (statusFilter == 'completed') {
      final completed = await repository.getApplications(
        status: filter.status,
        type: filter.type,
      );
      List<ApplicationModel> clockedOut = [];
      try {
        clockedOut = await repository.getApplications(
          status: 'clocked_out',
          type: filter.type,
        );
      } catch (e) {
        debugPrint('DEBUG: Failed to fetch clocked_out applications: $e');
        clockedOut = [];
      }

      final filteredClockedOut = clockedOut
          .where((app) => _isClockedOutPast(app, now))
          .toList();
      return _dedupeApplications([...completed, ...filteredClockedOut]);
    }

    final applications = await repository.getApplications(
      status: filter.status,
      type: filter.type,
    );

    if (typeFilter == 'applied') {
      return applications
          .where((app) => !_isClockedOutPast(app, now))
          .toList();
    }

    return applications;
  },
);

/// Provider for fetching both invitations and direct bookings for the Requests tab
final sitterJobRequestsProvider =
    FutureProvider.autoDispose<List<ApplicationModel>>((ref) async {
  final repository = ref.watch(applicationRepositoryProvider);

  try {
    // Try to fetch both invitations and direct bookings
    final results = await Future.wait([
      repository.getApplications(type: 'invited'),
      repository.getApplications(type: 'direct_booking').catchError((error) {
        // If direct_booking fails (e.g., 400 error), log and return empty list
        debugPrint('DEBUG: Failed to fetch direct bookings: $error');
        return <ApplicationModel>[];
      }),
    ]);

    // Combine the results
    final invitations = results[0];
    final directBookings = results[1];

    return [...invitations, ...directBookings];
  } catch (e) {
    // If fetching invitations fails, just return invitations
    debugPrint('DEBUG: Error in sitterJobRequestsProvider: $e');
    return repository.getApplications(type: 'invited');
  }
});

List<ApplicationModel> _dedupeApplications(List<ApplicationModel> items) {
  final seen = <String>{};
  final result = <ApplicationModel>[];
  for (final item in items) {
    if (seen.add(item.id)) {
      result.add(item);
    }
  }
  return result;
}

bool _isClockedOutPast(ApplicationModel app, DateTime now) {
  if (!_isClockedOutStatus(app.status)) {
    return false;
  }
  final endDateTime = _parseEndDateTime(app.job.endDate, app.job.endTime);
  if (endDateTime == null) {
    return false;
  }
  return now.isAfter(endDateTime) || now.isAtSameMomentAs(endDateTime);
}

bool _isClockedOutStatus(String status) {
  final normalized = status.toLowerCase().replaceAll(RegExp(r'[\s_-]'), '');
  return normalized == 'clockedout';
}

DateTime? _parseEndDateTime(String dateValue, String timeValue) {
  final date = _parseDate(dateValue);
  final minutes = _parseTimeToMinutes(timeValue);
  if (date == null || minutes == null) {
    return null;
  }
  return DateTime(
    date.year,
    date.month,
    date.day,
    minutes ~/ 60,
    minutes % 60,
  );
}

DateTime? _parseDate(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) {
    return null;
  }
  try {
    final parsed = DateTime.parse(trimmed);
    return DateTime(parsed.year, parsed.month, parsed.day);
  } catch (_) {
    return null;
  }
}

int? _parseTimeToMinutes(String value) {
  try {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    final lower = trimmed.toLowerCase();
    final isAm = lower.contains('am');
    final isPm = lower.contains('pm');
    final sanitized = lower.replaceAll(RegExp(r'[^0-9:]'), '');
    if (sanitized.isEmpty) {
      return null;
    }
    final parts = sanitized.split(':');
    final hour = int.parse(parts[0]);
    final minute = parts.length > 1 ? int.parse(parts[1]) : 0;
    var adjustedHour = hour;
    if (isPm && adjustedHour < 12) {
      adjustedHour += 12;
    }
    if (isAm && adjustedHour == 12) {
      adjustedHour = 0;
    }
    return adjustedHour * 60 + minute;
  } catch (_) {
    return null;
  }
}
