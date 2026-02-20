import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../domain/applications/applications_repository.dart';

import '../providers/applications_providers.dart';

// Controller for managing application actions (accept/reject)
class ApplicationsController extends StateNotifier<AsyncValue<void>> {
  final ApplicationsRepository _repository;

  ApplicationsController(this._repository) : super(const AsyncData(null));

  Future<void> acceptApplication(String jobId, String applicationId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repository.acceptApplication(
          jobId: jobId,
          applicationId: applicationId,
        ));
  }

  Future<void> declineApplication(
      String jobId, String applicationId, String reason) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repository.declineApplication(
          jobId: jobId,
          applicationId: applicationId,
          reason: reason,
        ));
  }
}

final applicationsControllerProvider =
    StateNotifierProvider<ApplicationsController, AsyncValue<void>>((ref) {
  return ApplicationsController(ref.watch(applicationsRepositoryProvider));
});
