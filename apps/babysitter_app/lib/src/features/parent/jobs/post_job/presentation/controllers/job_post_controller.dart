import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:domain/domain.dart';
import 'package:equatable/equatable.dart';

/// State for the job posting flow.
class JobPostState extends Equatable {
  final List<String> childIds;
  final String title;
  final String startDate;
  final String endDate;
  final String startTime;
  final String endTime;
  final String streetAddress;
  final String? aptUnit;
  final String city;
  final String state;
  final String zipCode;
  final String additionalDetails;
  final double payRate;
  final bool isLoading;
  final String? error;
  final String? jobId;
  final double? latitude;
  final double? longitude;
  final DateTime? rawStartDate;
  final DateTime? rawEndDate;

  const JobPostState({
    this.childIds = const [],
    this.title = '',
    this.startDate = '',
    this.endDate = '',
    this.startTime = '',
    this.endTime = '',
    this.streetAddress = '',
    this.aptUnit,
    this.city = '',
    this.state = '',
    this.zipCode = '',
    this.additionalDetails = '',
    this.payRate = 18.0, // Default pay rate
    this.isLoading = false,
    this.error,
    this.jobId,
    this.latitude,
    this.longitude,
    this.rawStartDate,
    this.rawEndDate,
  });

  JobPostState copyWith({
    List<String>? childIds,
    String? title,
    String? startDate,
    String? endDate,
    String? startTime,
    String? endTime,
    String? streetAddress,
    String? aptUnit,
    String? city,
    String? state,
    String? zipCode,
    String? additionalDetails,
    double? payRate,
    bool? isLoading,
    String? error,
    String? jobId,
    double? latitude,
    double? longitude,
    DateTime? rawStartDate,
    DateTime? rawEndDate,
  }) {
    return JobPostState(
      childIds: childIds ?? this.childIds,
      title: title ?? this.title,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      streetAddress: streetAddress ?? this.streetAddress,
      aptUnit: aptUnit ?? this.aptUnit,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      additionalDetails: additionalDetails ?? this.additionalDetails,
      payRate: payRate ?? this.payRate,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      jobId: jobId ?? this.jobId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      rawStartDate: rawStartDate ?? this.rawStartDate,
      rawEndDate: rawEndDate ?? this.rawEndDate,
    );
  }

  @override
  List<Object?> get props => [
        childIds,
        title,
        startDate,
        endDate,
        startTime,
        endTime,
        streetAddress,
        aptUnit,
        city,
        state,
        zipCode,
        additionalDetails,
        payRate,
        isLoading,
        error,
        jobId,
        latitude,
        longitude,
        rawStartDate,
        rawEndDate,
      ];
}

/// Controller for managing the job posting flow state.
class JobPostController extends StateNotifier<JobPostState> {
  final CreateJobUseCase _createJobUseCase;
  final UpdateJobUseCase _updateJobUseCase;
  final SaveLocalDraftUseCase _saveLocalDraftUseCase;
  final GetLocalDraftUseCase _getLocalDraftUseCase;
  final ClearLocalDraftUseCase _clearLocalDraftUseCase;

  JobPostController(
    this._createJobUseCase,
    this._updateJobUseCase,
    this._saveLocalDraftUseCase,
    this._getLocalDraftUseCase,
    this._clearLocalDraftUseCase,
  ) : super(const JobPostState());

  // ... (previous methods omitted for brevity in replace call, only matching necessary parts if possible)

  // Wait, I need to match a large block or multiple blocks. I'll do this in chunks.
  // Chunk 1: Constructor and Fields.

  void updateChildIds(List<String> childIds) {
    state = state.copyWith(childIds: childIds);
  }

  void updateJobDetails({
    String? title,
    String? startDate,
    String? endDate,
    String? startTime,
    String? endTime,
    DateTime? rawStartDate,
    DateTime? rawEndDate,
  }) {
    final current = state;
    state = current.copyWith(
      title: title ?? current.title,
      startDate: startDate ?? current.startDate,
      endDate: endDate ?? current.endDate,
      startTime: startTime ?? current.startTime,
      endTime: endTime ?? current.endTime,
      rawStartDate: rawStartDate ?? current.rawStartDate,
      rawEndDate: rawEndDate ?? current.rawEndDate,
    );
  }

  void updateLocation({
    String? streetAddress,
    String? aptUnit,
    String? city,
    String? state,
    String? zipCode,
    double? latitude,
    double? longitude,
  }) {
    final current = this.state;
    this.state = current.copyWith(
      streetAddress: streetAddress ?? current.streetAddress,
      aptUnit: aptUnit ?? current.aptUnit,
      city: city ?? current.city,
      state: state ?? current.state,
      zipCode: zipCode ?? current.zipCode,
      latitude: latitude ?? current.latitude,
      longitude: longitude ?? current.longitude,
    );
  }

  void updateAdditionalDetails(String details) {
    state = state.copyWith(additionalDetails: details);
  }

  void updatePayRate(double payRate) {
    state = state.copyWith(payRate: payRate);
  }

  Future<bool> submitJob() async {
    return _saveJob(isDraft: false);
  }

  Future<bool> saveJobDraft() async {
    print('DEBUG: JobPostController saving local job draft');
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Get the device timezone in IANA format
      final timezoneInfo = await FlutterTimezone.getLocalTimezone();
      final timezone = timezoneInfo.identifier;

      final job = _buildJobEntity(isDraft: true, timezone: timezone);
      await _saveLocalDraftUseCase(job);
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Job _buildJobEntity({required bool isDraft, String? timezone}) {
    // Format dates to YYYY-MM-DD
    String formatDate(DateTime? dt) {
      if (dt == null) return '';
      return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
    }

    // Format times to HH:mm (removing AM/PM if present)
    String formatTime(String time) {
      final regex = RegExp(r'(\d{1,2}:\d{2})');
      final match = regex.firstMatch(time);
      if (match != null) {
        final parts = match.group(1)!.split(':');
        final hour = parts[0].padLeft(2, '0');
        final minute = parts[1];

        int h = int.parse(hour);
        if (time.toUpperCase().contains('PM') && h < 12) h += 12;
        if (time.toUpperCase().contains('AM') && h == 12) h = 0;

        return '${h.toString().padLeft(2, '0')}:$minute';
      }
      return time;
    }

    // Determine status: 
    // - Draft jobs: always "draft"
    // - New jobs being posted: "draft" initially, will be updated to "posted" after payment
    // - Updating existing job: keep current status
    String? status;
    if (isDraft) {
      status = 'draft';
    } else if (state.jobId != null) {
      // Updating an existing job - keep existing status (could be "posted" or "draft")
      status = 'posted'; // Assume posted for existing jobs, or we could track original status
    } else {
      // New job being posted - start as draft, will update after payment
      status = 'draft';
    }

    return Job(
      id: state.jobId, // Pass existing ID if any
      childIds: state.childIds,
      title: state.title,
      startDate: formatDate(state.rawStartDate),
      endDate: formatDate(state.rawEndDate),
      startTime: formatTime(state.startTime),
      endTime: formatTime(state.endTime),
      timezone: timezone,
      address: JobAddress(
        streetAddress: state.streetAddress,
        aptUnit: state.aptUnit,
        city: state.city,
        state: state.state.length > 2
            ? state.state.substring(0, 2).toUpperCase()
            : state.state.toUpperCase(),
        zipCode: state.zipCode,
        latitude: state.latitude ?? 36.1627,
        longitude: state.longitude ?? -86.7816,
      ),
      location: JobLocation(
        latitude: state.latitude ?? 36.1627,
        longitude: state.longitude ?? -86.7816,
      ),
      additionalDetails: state.additionalDetails,
      payRate: state.payRate,
      saveAsDraft: isDraft,
      status: status,
    );
  }

  Future<bool> _saveJob({required bool isDraft}) async {
    print(
        'DEBUG: JobPostController submitting job to API. isDraft: $isDraft, isUpdate: ${state.jobId != null}');
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Get the device timezone in IANA format (e.g., "America/Los_Angeles")
      final timezoneInfo = await FlutterTimezone.getLocalTimezone();
      final timezone = timezoneInfo.identifier;
      print('DEBUG: Device timezone: $timezone');

      final job = _buildJobEntity(isDraft: isDraft, timezone: timezone);
      print('DEBUG: Job entity built with status: ${job.status}, id: ${job.id}');

      if (state.jobId != null && !isDraft) {
        // Update existing job
        print('DEBUG: Calling updateJobUseCase for existing job');
        await _updateJobUseCase(job);
        // jobId remains same
      } else {
        // Create new job
        print('DEBUG: Calling createJobUseCase for new job');
        final jobId = await _createJobUseCase(job);
        state = state.copyWith(jobId: jobId);
      }

      // If successful, clear local draft
      await _clearLocalDraftUseCase();

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  void resetState() {
    state = const JobPostState();
  }

  Future<void> loadLocalDraft() async {
    try {
      final draft = await _getLocalDraftUseCase();
      if (draft != null) {
        // Map domain Job back to JobPostState
        // Note: rawStartDate/rawEndDate might be tricky if we don't store them in DTO
        // But JobDto has startDate (string). We can parse it.

        DateTime? parseDate(String d) =>
            d.isNotEmpty ? DateTime.tryParse(d) : null;

        state = state.copyWith(
          childIds: draft.childIds,
          title: draft.title,
          startDate: draft.startDate,
          endDate: draft.endDate,
          startTime: draft.startTime,
          endTime: draft.endTime,
          streetAddress: draft.address.streetAddress,
          aptUnit: draft.address.aptUnit,
          city: draft.address.city,
          state: draft.address.state,
          zipCode: draft.address.zipCode,
          additionalDetails: draft.additionalDetails,
          payRate: draft.payRate,
          latitude: draft.address.latitude,
          longitude: draft.address.longitude,
          rawStartDate: parseDate(draft.startDate),
          rawEndDate: parseDate(draft.endDate),
        );
      }
    } catch (e) {
      print('DEBUG: Failed to load local draft: $e');
    }
  }
}

// TODO: Create providers for Repository, UseCase and Controller
