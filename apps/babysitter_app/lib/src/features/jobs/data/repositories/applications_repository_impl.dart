import '../../domain/applications/application_item.dart';
import '../../domain/applications/applications_repository.dart';
import '../../domain/applications/booking_application.dart';
import '../datasources/applications_remote_datasource.dart';
import '../models/application_detail_dto.dart';
import '../models/application_dto.dart';

/// Implementation of [ApplicationsRepository].
class ApplicationsRepositoryImpl implements ApplicationsRepository {
  final ApplicationsRemoteDataSource _remoteDataSource;

  ApplicationsRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<ApplicationItem>> getApplications(String jobId) async {
    final dtos = await _remoteDataSource.getApplications(jobId);
    return dtos.map(_mapToEntity).toList();
  }

  @override
  Future<void> acceptApplication({
    required String jobId,
    required String applicationId,
  }) async {
    await _remoteDataSource.respondToApplication(
      jobId: jobId,
      applicationId: applicationId,
      action: 'accept',
    );
  }

  @override
  Future<void> declineApplication({
    required String jobId,
    required String applicationId,
    required String reason,
  }) async {
    await _remoteDataSource.respondToApplication(
      jobId: jobId,
      applicationId: applicationId,
      action: 'reject',
      declineReason: reason,
    );
  }

  @override
  Future<BookingApplication> getApplicationDetail({
    required String jobId,
    required String applicationId,
  }) async {
    try {
      final dto = await _remoteDataSource.getApplicationDetail(
        jobId: jobId,
        applicationId: applicationId,
      );
      return _mapDetailToEntity(dto);
    } catch (e) {
      rethrow;
    }
  }

  /// Maps DTO to domain entity.
  ApplicationItem _mapToEntity(ApplicationDto dto) {
    return ApplicationItem(
      id: dto.id,
      sitterName: dto.sitter.fullName,
      avatarUrl: dto.sitter.photoUrl ?? '',
      isVerified: true, // API doesn't provide this, default to true
      distanceMiles: 0.0, // API doesn't provide this
      rating: 0.0, // API doesn't provide this
      responseRatePercent: 0, // API doesn't provide this
      reliabilityRatePercent: dto.sitter.reliabilityScore ?? 0,
      experienceYears: 0, // Will parse from yearsOfExperience string if needed
      jobTitle: '', // Will be set from context
      scheduledDate: DateTime.now(), // Will be set from context
      isApplication: !dto.isInvitation,
      status: dto.status,
      sitterId: dto.sitter.userId,
      coverLetter: dto.coverLetter,
      skills: dto.sitter.skills,
    );
  }

  BookingApplication _mapDetailToEntity(ApplicationDetailDto dto) {
    final job = dto.job;
    final sitter = dto.sitter;

    // Helper to parse DateTime safely
    DateTime parseDate(String? dateStr) {
      if (dateStr == null) return DateTime.now();
      try {
        return DateTime.parse(dateStr);
      } catch (_) {
        return DateTime.now();
      }
    }

    // Combine date and time if possible or just use what we have
    // Start/End dates are YYYY-MM-DD usually, times are HH:MM
    // For now, using fallback logic similar to how UI expects
    DateTime startDate = parseDate(job.startDate);
    DateTime endDate = parseDate(job.endDate);

    // If times are provided, try to fuse them with dates
    // Simplified for now: Just standard check

    return BookingApplication(
      id: dto.id,
      // Sitter
      sitterName: sitter?.fullName ?? 'Unknown Sitter',
      avatarUrl: sitter?.photoUrl ?? '',
      isVerified: true, // Default
      distanceMiles: job.distance ?? 0.0,
      rating: 0.0, // Default
      responseRatePercent: 0, // Default
      reliabilityRatePercent: sitter?.reliabilityScore ?? 0,
      experienceYears: 0, // Default or parse
      skills: sitter?.skills ?? [],

      // Application
      coverLetter: dto.coverLetter ?? 'No cover letter provided.',

      // Job/Service
      familyName: job.familyName ?? 'Family',
      numberOfChildren: job.childrenCount ?? (job.children?.length ?? 0),
      startDate: startDate,
      endDate: endDate,
      startTime: startDate, // Placeholder, usually would combine date+time
      endTime: endDate, // Placeholder
      hourlyRate: sitter?.hourlyRate ?? job.payRate ?? 0.0,
      numberOfDays: 1, // Calculate difference if needed
      additionalNotes: job.additionalDetails ?? '',
      address: job.fullAddress ?? job.location ?? '',

      // Preferences - mapping from job children requirements or defaults
      transportationModes: job.children
              ?.expand((c) => c.transportationModes ?? <String>[])
              .toSet()
              .toList() ??
          [],
      equipmentAndSafety: job.children
              ?.expand((c) => c.equipmentSafety ?? <String>[])
              .toSet()
              .toList() ??
          [],
      pickupDropoffDetails: job.children
              ?.map((c) {
                final pickup = c.pickupLocation;
                final dropoff = c.dropoffLocation;
                if (pickup != null || dropoff != null) {
                  return '${c.firstName}: Pickup(${pickup ?? "None"}), Dropoff(${dropoff ?? "None"})';
                }
                return null;
              })
              .whereType<String>()
              .toList() ??
          [],
    );
  }
}
