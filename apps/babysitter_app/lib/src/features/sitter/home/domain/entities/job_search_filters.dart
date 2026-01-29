import 'package:equatable/equatable.dart';

/// Model to hold all job search and filter parameters for sitters.
class JobSearchFilters extends Equatable {
  final String? searchQuery;
  final double? latitude;
  final double? longitude;
  final int? maxDistance; // in miles
  final double? minPayRate;
  final double? maxPayRate;
  final List<String> specialNeeds;
  final List<String> ageGroups;
  final DateTime? availabilityDate;
  final int limit;
  final int offset;

  const JobSearchFilters({
    this.searchQuery,
    this.latitude,
    this.longitude,
    this.maxDistance,
    this.minPayRate,
    this.maxPayRate,
    this.specialNeeds = const [],
    this.ageGroups = const [],
    this.availabilityDate,
    this.limit = 20,
    this.offset = 0,
  });

  /// Returns true if any filter is active (excluding pagination)
  bool get hasActiveFilters =>
      (searchQuery != null && searchQuery!.isNotEmpty) ||
      maxDistance != null ||
      minPayRate != null ||
      maxPayRate != null ||
      specialNeeds.isNotEmpty ||
      ageGroups.isNotEmpty ||
      availabilityDate != null;

  /// Count of active filters
  int get activeFilterCount {
    int count = 0;
    if (maxDistance != null) count++;
    if (minPayRate != null || maxPayRate != null) count++;
    if (specialNeeds.isNotEmpty) count++;
    if (ageGroups.isNotEmpty) count++;
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
    if (maxDistance != null) {
      params['maxDistance'] = maxDistance;
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
    if (ageGroups.isNotEmpty) {
      params['ageGroups'] = ageGroups.join(',');
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
    int? maxDistance,
    double? minPayRate,
    double? maxPayRate,
    List<String>? specialNeeds,
    List<String>? ageGroups,
    DateTime? availabilityDate,
    int? limit,
    int? offset,
    bool clearSearch = false,
    bool clearMaxDistance = false,
    bool clearMinPayRate = false,
    bool clearMaxPayRate = false,
    bool clearAvailabilityDate = false,
  }) {
    return JobSearchFilters(
      searchQuery: clearSearch ? null : (searchQuery ?? this.searchQuery),
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      maxDistance: clearMaxDistance ? null : (maxDistance ?? this.maxDistance),
      minPayRate: clearMinPayRate ? null : (minPayRate ?? this.minPayRate),
      maxPayRate: clearMaxPayRate ? null : (maxPayRate ?? this.maxPayRate),
      specialNeeds: specialNeeds ?? this.specialNeeds,
      ageGroups: ageGroups ?? this.ageGroups,
      availabilityDate: clearAvailabilityDate
          ? null
          : (availabilityDate ?? this.availabilityDate),
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
    );
  }

  /// Reset all filters to defaults
  JobSearchFilters reset() {
    return JobSearchFilters(
      latitude: latitude,
      longitude: longitude,
    );
  }

  @override
  List<Object?> get props => [
        searchQuery,
        latitude,
        longitude,
        maxDistance,
        minPayRate,
        maxPayRate,
        specialNeeds,
        ageGroups,
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

/// Predefined age group options
class AgeGroupOptions {
  static const List<String> all = [
    'Infant (0-1)',
    'Toddler (1-3)',
    'Preschool (3-5)',
    'School Age (5-12)',
    'Teen (13-17)',
  ];
}
