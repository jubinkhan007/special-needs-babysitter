import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/jobs_data_di.dart';
import '../../domain/job.dart';

final allJobsProvider = FutureProvider<List<Job>>((ref) async {
  final repository = ref.watch(jobsRepositoryProvider);
  return repository.getJobs();
});
