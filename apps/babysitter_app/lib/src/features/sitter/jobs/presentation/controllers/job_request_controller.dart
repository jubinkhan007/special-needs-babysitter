import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/job_request_repository.dart';

/// Controller for managing job request actions (accept/decline).
class JobRequestController extends StateNotifier<AsyncValue<void>> {
  final JobRequestRepository _repository;

  JobRequestController(this._repository) : super(const AsyncValue.data(null));

  /// Accept a job invitation.
  Future<void> acceptJobInvitation(String applicationId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.acceptJobInvitation(applicationId);
    });
  }

  /// Decline a job invitation.
  Future<void> declineJobInvitation(String applicationId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.declineJobInvitation(applicationId);
    });
  }
}
