import 'package:equatable/equatable.dart';

/// Model to hold all job search and filter parameters for sitters.
class JobSearchFilters extends Equatable {
  final String? searchQuery;
  final double? latitude;
  final double? longitude;
  final double? minPayRate;
  final double? maxPayRate;
  final List<String> specialNeeds;
  final List<String> languages;
  final DateTime? availabilityDate;
  final int limit;
  final int offset;

  const JobSearchFilters({
    this.searchQuery,
    this.latitude,
    this.longitude,
    this.minPayRate,
    this.maxPayRate,
    this.specialNeeds = const [],
    this.languages = const [],
    this.availabilityDate,
    this.limit = 20,
    this.offset = 0,
  });

  /// Returns true if any filter is active (excluding pagination)
  bool get hasActiveFilters =>
      (searchQuery != null && searchQuery!.isNotEmpty) ||
      minPayRate != null ||
      maxPayRate != null ||
      specialNeeds.isNotEmpty ||
      languages.isNotEmpty ||
      availabilityDate != null;

  /// Count of active filters
  int get activeFilterCount {
    int count = 0;
    if (minPayRate != null || maxPayRate != null) count++;
    if (specialNeeds.isNotEmpty) count++;
    if (languages.isNotEmpty) count++;
    if (availabilityDate != null) count++;
    return count;
  }

  /// Convert to query parameters for API call
  Map<String, dynamic> toQueryParameters() {
    final params = <String, dynamic>{
      'status': 'posted',
      'limit': limit,
      'offset': offset,
    };

    if (searchQuery != null && searchQuery!.isNotEmpty) {
      params['search'] = searchQuery;
    }
    if (latitude != null) {
      params['latitude'] = latitude;
    }
    if (longitude != null) {
      params['longitude'] = longitude;
    }
    if (minPayRate != null) {
      params['minPayRate'] = minPayRate;
    }
    if (maxPayRate != null) {
      params['maxPayRate'] = maxPayRate;
    }
    if (specialNeeds.isNotEmpty) {
      params['specialNeeds'] = specialNeeds.join(',');
    }
    if (languages.isNotEmpty) {
      params['languages'] = languages.join(',');
    }
    if (availabilityDate != null) {
      params['availabilityDate'] =
          availabilityDate!.toIso8601String().split('T').first;
    }

    return params;
  }

  JobSearchFilters copyWith({
    String? searchQuery,
    double? latitude,
    double? longitude,
    double? minPayRate,
    double? maxPayRate,
    List<String>? specialNeeds,
    List<String>? languages,
    DateTime? availabilityDate,
    int? limit,
    int? offset,
    bool clearSearch = false,
    bool clearMinPayRate = false,
    bool clearMaxPayRate = false,
    bool clearAvailabilityDate = false,
  }) {
    return JobSearchFilters(
      searchQuery: clearSearch ? null : (searchQuery ?? this.searchQuery),
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      minPayRate: clearMinPayRate ? null : (minPayRate ?? this.minPayRate),
      maxPayRate: clearMaxPayRate ? null : (maxPayRate ?? this.maxPayRate),
      specialNeeds: specialNeeds ?? this.specialNeeds,
      languages: languages ?? this.languages,
      availabilityDate: clearAvailabilityDate
          ? null
          : (availabilityDate ?? this.availabilityDate),
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
    );
  }

  /// Reset all filters to defaults (clears everything including location)
  JobSearchFilters reset() {
    return const JobSearchFilters();
  }

  @override
  List<Object?> get props => [
        searchQuery,
        latitude,
        longitude,
        minPayRate,
        maxPayRate,
        specialNeeds,
        languages,
        availabilityDate,
        limit,
        offset,
      ];
}

/// Predefined special needs options
class SpecialNeedsOptions {
  static const List<String> all = [
    'Autism',
    'ADHD',
    'Down Syndrome',
    'Cerebral Palsy',
    'Sensory Processing',
    'Speech Delay',
    'Learning Disability',
    'Physical Disability',
    'Behavioral',
    'Medical Needs',
  ];
}

/// Predefined language options
class LanguageOptions {
  static const List<String> all = [
    'English',
    'Spanish',
    'French',
    'Mandarin',
    'Arabic',
    'ASL (Sign Language)',
    'Portuguese',
    'Korean',
    'Hindi',
    'Other',
  ];
}
