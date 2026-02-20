import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:dio/dio.dart';
import 'package:domain/domain.dart';
import 'package:data/data.dart';
import 'package:auth/auth.dart';
import 'package:babysitter_app/src/constants/app_constants.dart';
import 'package:geolocator/geolocator.dart';

import '../../data/dtos/sitter_job_preview_dto.dart';
import '../../domain/entities/job_preview.dart';
import '../../domain/entities/job_search_filters.dart';
import 'package:flutter/foundation.dart';

/// User authentificated Dio for Sitter Home
final sitterHomeDioProvider = Provider<Dio>((ref) {
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
      var session = authState.value;

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
      debugPrint('DEBUG: Sitter Home API Error: ${e.message}');
      debugPrint('DEBUG: Endpoint: ${e.requestOptions.uri}');
      if (e.response != null) {
        debugPrint('DEBUG: Status Code: ${e.response?.statusCode}');
        debugPrint('DEBUG: Response Data: ${e.response?.data}');
      }
      return handler.next(e);
    },
  ));

  return dio;
});

final sitterJobRemoteDataSourceProvider = Provider<JobRemoteDataSource>((ref) {
  return JobRemoteDataSource(ref.watch(sitterHomeDioProvider));
});

final sitterJobLocalDataSourceProvider = Provider<JobLocalDataSource>((ref) {
  return JobLocalDataSource();
});

final sitterJobRepositoryProvider = Provider<JobRepository>((ref) {
  final remote = ref.watch(sitterJobRemoteDataSourceProvider);
  final local = ref.watch(sitterJobLocalDataSourceProvider);
  return JobRepositoryImpl(remote, local);
});

/// Provider for current device location
final deviceLocationProvider = FutureProvider<Position?>((ref) async {
  try {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.medium,
      timeLimit: const Duration(seconds: 10),
    );
  } catch (e) {
    debugPrint('DEBUG: Error getting device location: $e');
    return null;
  }
});

/// Provider for job search filters state
final jobSearchFiltersProvider =
    StateNotifierProvider<JobSearchFiltersNotifier, JobSearchFilters>((ref) {
  return JobSearchFiltersNotifier(ref);
});

/// Notifier for managing job search filters
class JobSearchFiltersNotifier extends StateNotifier<JobSearchFilters> {
  final Ref _ref;

  JobSearchFiltersNotifier(this._ref) : super(const JobSearchFilters());

  /// Update location from device
  Future<void> updateLocationFromDevice() async {
    final position = await _ref.read(deviceLocationProvider.future);
    if (position != null) {
      // Only update if location actually changed
      if (state.latitude != position.latitude || 
          state.longitude != position.longitude) {
        state = state.copyWith(
          latitude: position.latitude,
          longitude: position.longitude,
        );
        // Refresh jobs with new location
        await _ref.read(jobSearchNotifierProvider.notifier).refresh();
      }
    }
  }

  /// Update search query
  void setSearchQuery(String? query) {
    state = state.copyWith(
      searchQuery: query,
      offset: 0, // Reset pagination on new search
      clearSearch: query == null || query.isEmpty,
    );
  }

  /// Update max distance filter
  void setMaxDistance(int? distance) {
    state = state.copyWith(
      maxDistance: distance,
      offset: 0,
      clearMaxDistance: distance == null,
    );
  }

  /// Update pay rate range
  void setPayRateRange({double? min, double? max}) {
    state = state.copyWith(
      minPayRate: min,
      maxPayRate: max,
      offset: 0,
      clearMinPayRate: min == null,
      clearMaxPayRate: max == null,
    );
  }

  /// Update special needs filter
  void setSpecialNeeds(List<String> needs) {
    state = state.copyWith(specialNeeds: needs, offset: 0);
  }

  /// Update age groups filter
  void setAgeGroups(List<String> groups) {
    state = state.copyWith(ageGroups: groups, offset: 0);
  }

  /// Update availability date
  void setAvailabilityDate(DateTime? date) {
    state = state.copyWith(
      availabilityDate: date,
      offset: 0,
      clearAvailabilityDate: date == null,
    );
  }

  /// Apply multiple filters at once
  void applyFilters({
    int? maxDistance,
    double? minPayRate,
    double? maxPayRate,
    List<String>? specialNeeds,
    List<String>? ageGroups,
    DateTime? availabilityDate,
  }) {
    state = state.copyWith(
      maxDistance: maxDistance,
      minPayRate: minPayRate,
      maxPayRate: maxPayRate,
      specialNeeds: specialNeeds ?? state.specialNeeds,
      ageGroups: ageGroups ?? state.ageGroups,
      availabilityDate: availabilityDate,
      offset: 0,
      clearMaxDistance: maxDistance == null,
      clearMinPayRate: minPayRate == null,
      clearMaxPayRate: maxPayRate == null,
      clearAvailabilityDate: availabilityDate == null,
    );
  }

  /// Reset all filters
  void resetFilters() {
    state = state.reset();
  }

  /// Increment offset for pagination
  void loadNextPage() {
    state = state.copyWith(offset: state.offset + state.limit);
  }

  /// Reset pagination
  void resetPagination() {
    state = state.copyWith(offset: 0);
  }
}

/// State for paginated job results
class JobSearchState {
  final List<JobPreview> jobs;
  final bool isLoading;
  final bool hasMore;
  final String? error;
  final int totalCount;

  const JobSearchState({
    this.jobs = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.error,
    this.totalCount = 0,
  });

  JobSearchState copyWith({
    List<JobPreview>? jobs,
    bool? isLoading,
    bool? hasMore,
    String? error,
    int? totalCount,
    bool clearError = false,
  }) {
    return JobSearchState(
      jobs: jobs ?? this.jobs,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      error: clearError ? null : (error ?? this.error),
      totalCount: totalCount ?? this.totalCount,
    );
  }
}

/// Notifier for job search with filters and pagination
class JobSearchNotifier extends StateNotifier<JobSearchState> {
  final Ref _ref;
  int _requestId = 0; // Track request ID to ignore stale responses

  JobSearchNotifier(this._ref) : super(const JobSearchState());

  /// Fetch jobs with current filters (replaces existing results)
  /// Optionally accepts [filtersOverride] to use specific filters instead of reading from provider
  Future<void> fetchJobs({JobSearchFilters? filtersOverride}) async {
    // Increment request ID to invalidate any in-flight requests
    final currentRequestId = ++_requestId;

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final dio = _ref.read(sitterHomeDioProvider);
      final JobSearchFilters filters = filtersOverride ?? _ref.read(jobSearchFiltersProvider);

      debugPrint(
          'DEBUG: Fetching jobs with filters: ${filters.toQueryParameters()} (request #$currentRequestId)');

      final response = await dio.get(
        '/jobs',
        queryParameters: filters.toQueryParameters(),
      );

      // Ignore response if a newer request was made
      if (currentRequestId != _requestId) {
        debugPrint('DEBUG: Ignoring stale response for request #$currentRequestId (current is #$_requestId)');
        return;
      }

      if (response.data['success'] == true) {
        final List<dynamic> jobsJson = response.data['data']['jobs'];
        final total = response.data['data']['total'] as int? ?? jobsJson.length;

        debugPrint('DEBUG: API returned ${jobsJson.length} jobs, total: $total');

        final previews = <JobPreview>[];
        for (final json in jobsJson) {
          try {
            final dto =
                SitterJobPreviewDto.fromJson(json as Map<String, dynamic>);
            previews.add(dto.toDomain());
          } catch (e, stack) {
            debugPrint('Warning: Failed to parse job preview: $e');
            debugPrint('Stack: $stack');
          }
        }

        debugPrint('DEBUG: Parsed ${previews.length} job previews');

        state = state.copyWith(
          jobs: previews,
          isLoading: false,
          hasMore: previews.length >= filters.limit,
          totalCount: total,
        );

        debugPrint('DEBUG: Updated state with ${state.jobs.length} jobs');
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Failed to fetch jobs',
        );
      }
    } catch (e) {
      // Ignore errors from stale requests
      if (currentRequestId != _requestId) return;

      debugPrint('DEBUG: Error fetching jobs: $e');
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Load more jobs (pagination)
  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true);

    try {
      final dio = _ref.read(sitterHomeDioProvider);
      final filters = _ref.read(jobSearchFiltersProvider);

      // Create new filters with incremented offset
      final paginatedFilters = filters.copyWith(
        offset: state.jobs.length,
      );

      debugPrint('DEBUG: Loading more jobs with offset: ${paginatedFilters.offset}');

      final response = await dio.get(
        '/jobs',
        queryParameters: paginatedFilters.toQueryParameters(),
      );

      if (response.data['success'] == true) {
        final List<dynamic> jobsJson = response.data['data']['jobs'];
        final total = response.data['data']['total'] as int? ?? 0;

        final newPreviews = <JobPreview>[];
        for (final json in jobsJson) {
          try {
            final dto =
                SitterJobPreviewDto.fromJson(json as Map<String, dynamic>);
            newPreviews.add(dto.toDomain());
          } catch (e) {
            debugPrint('Warning: Failed to parse job preview: $e');
          }
        }

        state = state.copyWith(
          jobs: [...state.jobs, ...newPreviews],
          isLoading: false,
          hasMore: newPreviews.length >= filters.limit,
          totalCount: total,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      debugPrint('DEBUG: Error loading more jobs: $e');
      state = state.copyWith(isLoading: false);
    }
  }

  /// Refresh jobs (reset pagination and fetch)
  Future<void> refresh() async {
    // Get current filters and reset pagination
    final currentFilters = _ref.read(jobSearchFiltersProvider);
    final refreshedFilters = currentFilters.copyWith(offset: 0);

    // Update the provider state
    _ref.read(jobSearchFiltersProvider.notifier).state = refreshedFilters;

    // Pass filters directly to avoid timing issues
    await fetchJobs(filtersOverride: refreshedFilters);
  }

  /// Complete reset - clears state and fetches fresh like home screen
  Future<void> resetAndFetch() async {
    // Get current filters and create reset version
    final currentFilters = _ref.read(jobSearchFiltersProvider);
    debugPrint('DEBUG resetAndFetch: currentFilters=${currentFilters.toQueryParameters()}');
    final resetFilters = currentFilters.reset();
    debugPrint('DEBUG resetAndFetch: resetFilters=${resetFilters.toQueryParameters()}');

    // Update the provider state
    _ref.read(jobSearchFiltersProvider.notifier).state = resetFilters;

    // Pass reset filters directly to avoid any state read timing issues
    await fetchJobs(filtersOverride: resetFilters);
  }
}

/// Provider for job search with filters and pagination
final jobSearchNotifierProvider =
    StateNotifierProvider<JobSearchNotifier, JobSearchState>((ref) {
  return JobSearchNotifier(ref);
});

/// Notifier for job previews - fetches from API and parses with correct DTO
/// (Keep for backwards compatibility with home screen)
class JobPreviewsNotifier extends AsyncNotifier<List<JobPreview>> {
  @override
  Future<List<JobPreview>> build() async {
    final dio = ref.watch(sitterHomeDioProvider);

    final response = await dio.get(
      '/jobs',
      queryParameters: {'status': 'posted', 'limit': 20, 'offset': 0},
    );

    if (response.data['success'] == true) {
      final List<dynamic> jobsJson = response.data['data']['jobs'];

      final previews = <JobPreview>[];
      for (final json in jobsJson) {
        try {
          final dto =
              SitterJobPreviewDto.fromJson(json as Map<String, dynamic>);
          previews.add(dto.toDomain());
        } catch (e) {
          // Skip jobs that fail to parse
          debugPrint('Warning: Failed to parse job preview: $e');
        }
      }

      return previews;
    } else {
      throw Exception('Failed to fetch jobs');
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build());
  }
}

/// Provider for job previews - use this in the UI
final jobPreviewsNotifierProvider =
    AsyncNotifierProvider<JobPreviewsNotifier, List<JobPreview>>(
        JobPreviewsNotifier.new);

// Keep the old provider for backwards compatibility with other screens
class JobsNotifier extends AsyncNotifier<List<Job>> {
  @override
  Future<List<Job>> build() async {
    final repository = ref.watch(sitterJobRepositoryProvider);
    return repository.getPublicJobs();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(sitterJobRepositoryProvider);
      return repository.getPublicJobs();
    });
  }
}

final jobsNotifierProvider =
    AsyncNotifierProvider<JobsNotifier, List<Job>>(JobsNotifier.new);
