import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:auth/auth.dart';
import '../../../../../constants/app_constants.dart';
import '../../../domain/applications/application_item.dart';
import '../../../domain/job_details.dart';
import '../../../data/jobs_data_di.dart';
import '../../../domain/applications/booking_application.dart';
import '../../../domain/applications/applications_repository.dart';
import '../../../data/datasources/applications_remote_datasource.dart';
import '../../../data/repositories/applications_repository_impl.dart';

/// Authenticated Dio provider for Applications API.
final applicationsDioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: AppConstants.baseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));

  // Add Auth Interceptor
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      final authState = ref.read(authNotifierProvider);
      var session = authState.valueOrNull;

      if (session == null) {
        final storedToken =
            await ref.read(sessionStoreProvider).getAccessToken();
        if (storedToken != null && storedToken.isNotEmpty) {
          options.headers['Cookie'] = 'session_id=$storedToken';
        }
      } else {
        options.headers['Cookie'] = 'session_id=${session.accessToken}';
      }
      return handler.next(options);
    },
    onError: (DioException e, handler) {
      print('DEBUG: Applications API Error: ${e.response?.statusCode}');
      print('DEBUG: Applications API Error Data: ${e.response?.data}');
      return handler.next(e);
    },
  ));

  return dio;
});

/// Provider for ApplicationsRemoteDataSource.
final applicationsRemoteDataSourceProvider =
    Provider<ApplicationsRemoteDataSource>((ref) {
  return ApplicationsRemoteDataSource(ref.watch(applicationsDioProvider));
});

/// Provider for ApplicationsRepository.
final applicationsRepositoryProvider = Provider<ApplicationsRepository>((ref) {
  return ApplicationsRepositoryImpl(
      ref.watch(applicationsRemoteDataSourceProvider));
});

/// Provider for fetching applications for a specific job.
final applicationsProvider =
    FutureProvider.family<List<ApplicationItem>, String>((ref, jobId) async {
  print('DEBUG: applicationsProvider called with jobId: $jobId');
  final repository = ref.watch(applicationsRepositoryProvider);
  try {
    final result = await repository.getApplications(jobId);
    print('DEBUG: applicationsProvider got ${result.length} applications');
    return result;
  } catch (e, stack) {
    print('DEBUG: applicationsProvider error: $e');
    print('DEBUG: applicationsProvider stack: $stack');
    rethrow;
  }
});

/// Provider for fetching a single application's details.
/// Argument class for application details.
class ApplicationDetailArgs {
  final String jobId;
  final String applicationId;

  const ApplicationDetailArgs({
    required this.jobId,
    required this.applicationId,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ApplicationDetailArgs &&
        other.jobId == jobId &&
        other.applicationId == applicationId;
  }

  @override
  int get hashCode => jobId.hashCode ^ applicationId.hashCode;
}

/// Provider for fetching a single application's details.
final applicationDetailProvider = FutureProvider.autoDispose
    .family<BookingApplication, ApplicationDetailArgs>((ref, args) async {
  print(
      'DEBUG: applicationDetailProvider called with jobId: ${args.jobId}, id: ${args.applicationId}');

  final jobsRepo = ref.watch(jobsRepositoryProvider);
  final applicationsRepo = ref.watch(applicationsRepositoryProvider);

  try {
    // Parallel fetch
    final results = await Future.wait([
      jobsRepo.getJobDetails(args.jobId),
      applicationsRepo.getApplications(args.jobId),
    ]);

    final jobDetails = results[0] as JobDetails;
    final applications = results[1] as List<ApplicationItem>;

    // Find the specific application
    final appItem = applications.firstWhere(
      (app) => app.id == args.applicationId,
      orElse: () => throw Exception('Application not found'),
    );

    // Map to BookingApplication
    return BookingApplication(
      id: appItem.id,
      sitterName: appItem.sitterName,
      avatarUrl: appItem.avatarUrl.isNotEmpty
          ? appItem.avatarUrl
          : 'https://via.placeholder.com/150',
      isVerified: appItem.isVerified,
      distanceMiles: appItem.distanceMiles,
      reliabilityRatePercent: appItem.reliabilityRatePercent,
      responseRatePercent: appItem.responseRatePercent,
      rating: appItem.rating > 0 ? appItem.rating : 5.0,
      experienceYears: appItem.experienceYears,
      skills: appItem.skills ?? [],
      coverLetter: appItem.coverLetter ?? 'No cover letter provided.',
      status: appItem.status,
      familyName: 'The Family', // Not available in JobDetails
      numberOfChildren: jobDetails.children.length,
      startDate: jobDetails.scheduleStartDate,
      endDate: jobDetails.scheduleEndDate,
      startTime: DateTime(
        jobDetails.scheduleStartDate.year,
        jobDetails.scheduleStartDate.month,
        jobDetails.scheduleStartDate.day,
        jobDetails.scheduleStartTime.hour,
        jobDetails.scheduleStartTime.minute,
      ),
      endTime: DateTime(
        jobDetails.scheduleEndDate.year,
        jobDetails.scheduleEndDate.month,
        jobDetails.scheduleEndDate.day,
        jobDetails.scheduleEndTime.hour,
        jobDetails.scheduleEndTime.minute,
      ),
      hourlyRate: jobDetails.hourlyRate, // Use Job's rate
      numberOfDays: jobDetails.scheduleEndDate
              .difference(jobDetails.scheduleStartDate)
              .inDays +
          1,
      additionalNotes: jobDetails.additionalNotes,
      address: jobDetails.address.fullAddress,
      transportationModes: [], // Not available
      equipmentAndSafety: [], // Not available
      pickupDropoffDetails: [], // Not available
    );
  } catch (e) {
    print('DEBUG: applicationDetailProvider error: $e');
    rethrow;
  }
});
