import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:auth/auth.dart';
import 'package:domain/domain.dart';

import '../../data/sources/saved_jobs_remote_datasource.dart';
import '../../data/repositories/saved_jobs_repository_impl.dart';
import '../../domain/repositories/saved_jobs_repository.dart';

class SavedJobsState {
  final Set<String> savedJobIds;
  final Set<String> updatingJobIds;
  final String? error;

  const SavedJobsState({
    this.savedJobIds = const {},
    this.updatingJobIds = const {},
    this.error,
  });

  SavedJobsState copyWith({
    Set<String>? savedJobIds,
    Set<String>? updatingJobIds,
    String? error,
    bool clearError = false,
  }) {
    return SavedJobsState(
      savedJobIds: savedJobIds ?? this.savedJobIds,
      updatingJobIds: updatingJobIds ?? this.updatingJobIds,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class SavedJobsController extends StateNotifier<SavedJobsState> {
  SavedJobsController(this._repository) : super(const SavedJobsState());

  final SavedJobsRepository _repository;

  bool isSaved(String jobId) => state.savedJobIds.contains(jobId);

  bool isUpdating(String jobId) => state.updatingJobIds.contains(jobId);

  void setSavedJobIds(Set<String> ids) {
    state = state.copyWith(savedJobIds: ids, clearError: true);
  }

  Future<bool> toggleSaved(String jobId) async {
    if (jobId.isEmpty) {
      throw Exception('Missing job ID');
    }
    if (isUpdating(jobId)) {
      return isSaved(jobId);
    }

    final wasSaved = isSaved(jobId);
    final nextSaved = {...state.savedJobIds};
    if (wasSaved) {
      nextSaved.remove(jobId);
    } else {
      nextSaved.add(jobId);
    }

    final nextUpdating = {...state.updatingJobIds, jobId};
    state = state.copyWith(
      savedJobIds: nextSaved,
      updatingJobIds: nextUpdating,
      clearError: true,
    );

    try {
      if (wasSaved) {
        await _repository.removeJob(jobId);
      } else {
        await _repository.saveJob(jobId);
      }
      return !wasSaved;
    } catch (e) {
      final message = e.toString();
      final lowered = message.toLowerCase();
      if (!wasSaved &&
          (lowered.contains('already saved') ||
              lowered.contains('already exists'))) {
        final ensured = {...state.savedJobIds, jobId};
        state = state.copyWith(savedJobIds: ensured, clearError: true);
        return true;
      }
      if (wasSaved &&
          (lowered.contains('not saved') ||
              lowered.contains('not found') ||
              lowered.contains('already removed'))) {
        final ensured = {...state.savedJobIds}..remove(jobId);
        state = state.copyWith(savedJobIds: ensured, clearError: true);
        return false;
      }
      final rollback = {...state.savedJobIds};
      if (wasSaved) {
        rollback.add(jobId);
      } else {
        rollback.remove(jobId);
      }
      state = state.copyWith(
        savedJobIds: rollback,
        error: message.replaceFirst('Exception: ', ''),
      );
      rethrow;
    } finally {
      final updated = {...state.updatingJobIds}..remove(jobId);
      state = state.copyWith(updatingJobIds: updated);
    }
  }
}

final savedJobsRemoteDataSourceProvider =
    Provider<SavedJobsRemoteDataSource>((ref) {
  final dio = ref.watch(authDioProvider);
  return SavedJobsRemoteDataSource(dio);
});

final savedJobsRepositoryProvider = Provider<SavedJobsRepository>((ref) {
  final remote = ref.watch(savedJobsRemoteDataSourceProvider);
  return SavedJobsRepositoryImpl(remote);
});

final savedJobsControllerProvider =
    StateNotifierProvider<SavedJobsController, SavedJobsState>((ref) {
  final repository = ref.watch(savedJobsRepositoryProvider);
  return SavedJobsController(repository);
});

final savedJobsListProvider =
    FutureProvider.autoDispose<List<Job>>((ref) async {
  final repository = ref.watch(savedJobsRepositoryProvider);
  final jobs = await repository.getSavedJobs();
  final ids = jobs
      .map((job) => job.id ?? '')
      .where((id) => id.isNotEmpty)
      .toSet();
  ref.read(savedJobsControllerProvider.notifier).setSavedJobIds(ids);
  return jobs;
});
