import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../domain/repositories/job_request_repository.dart';

/// Controller for managing job request actions (accept/decline).
class JobRequestController extends StateNotifier<AsyncValue<void>> {
  final JobRequestRepository _repository;

  JobRequestController(this._repository) : super(const AsyncValue.data(null));

  /// Accept a job invitation or direct booking.
  Future<void> acceptJobInvitation(
    String applicationId, {
    required String applicationType,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.acceptJobInvitation(
        applicationId,
        applicationType: applicationType,
      );
    });
  }

  /// Decline a job invitation or direct booking.
  Future<void> declineJobInvitation(
    String applicationId, {
    required String applicationType,
    required String reason,
    String? otherReason,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.declineJobInvitation(
        applicationId,
        applicationType: applicationType,
        reason: reason,
        otherReason: otherReason,
      );
    });
  }
}
