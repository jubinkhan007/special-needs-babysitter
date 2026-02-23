import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:babysitter_app/src/features/jobs/data/jobs_data_di.dart';
import 'package:babysitter_app/src/features/jobs/domain/job.dart';

final allJobsProvider = FutureProvider<List<Job>>((ref) async {
  final repository = ref.watch(jobsRepositoryProvider);
  return repository.getJobs();
});
