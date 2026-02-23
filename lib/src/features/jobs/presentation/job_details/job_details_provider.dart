import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:babysitter_app/src/features/jobs/domain/job_details.dart';
import 'package:babysitter_app/src/features/jobs/data/jobs_data_di.dart';

final jobDetailsProvider = FutureProvider.family
    .autoDispose<JobDetails, String>((ref, uniqueId) async {
  final repository = ref.watch(jobsRepositoryProvider);
  return repository.getJobDetails(uniqueId);
});
