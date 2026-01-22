import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:equatable/equatable.dart';
import '../../../application/data/models/application_model.dart';
import '../../../application/presentation/providers/application_providers.dart';

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
    return repository.getApplications(
      status: filter.status,
      type: filter.type,
    );
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
        print('DEBUG: Failed to fetch direct bookings: $error');
        return <ApplicationModel>[];
      }),
    ]);

    // Combine the results
    final invitations = results[0];
    final directBookings = results[1];

    return [...invitations, ...directBookings];
  } catch (e) {
    // If fetching invitations fails, just return invitations
    print('DEBUG: Error in sitterJobRequestsProvider: $e');
    return repository.getApplications(type: 'invited');
  }
});
