import 'package:dio/dio.dart';
import 'package:data/data.dart';
import 'package:domain/domain.dart';

class SavedJobsRemoteDataSource {
  final Dio _dio;

  SavedJobsRemoteDataSource(this._dio);

  Future<List<Job>> getSavedJobs() async {
    try {
      print('DEBUG: Saved Jobs Request: GET /sitters/saved-jobs');
      final response = await _dio.get('/sitters/saved-jobs');
      print('DEBUG: Saved Jobs Response Status: ${response.statusCode}');

      final data = response.data;
      _logSavedJobsResponseShape(data);
      dynamic list;
      if (data is Map<String, dynamic>) {
        final dataField = data['data'];
        if (dataField is Map<String, dynamic>) {
          list = dataField['jobs'] ??
              dataField['savedJobs'] ??
              dataField['items'] ??
              dataField['bookmarks'];
        } else {
          list = dataField;
        }
      } else {
        list = data;
      }

      if (list is! List) {
        return [];
      }

      final jobs = <Job>[];
      for (var i = 0; i < list.length; i++) {
        final item = list[i];
        if (item is! Map<String, dynamic>) {
          continue;
        }
        final jobJson = _extractJobJson(item);
        if (jobJson == null) {
          final fallback = _fallbackJobFromJson(item);
          if (fallback != null) {
            jobs.add(fallback);
          }
          continue;
        }
        final normalizedJobJson = _normalizeJobJson(jobJson);
        try {
          final dto = JobDto.fromJson(normalizedJobJson);
          var job = dto.toDomain();
          
          // Hydrate job if children are missing but we have an ID
          if (job.children.isEmpty && (job.id?.isNotEmpty ?? false)) {
            try {
               final detailedJob = await _hydrateJobWithDetails(job.id!);
               if (detailedJob != null) {
                 job = detailedJob;
               }
            } catch (e) {
              print('DEBUG: Failed to hydrate job ${job.id}: $e');
            }
          }
          jobs.add(job);
        } catch (e) {
          final fallback = _fallbackJobFromJson(normalizedJobJson);
          if (fallback != null) {
             // Try to hydrate fallback too
             if (fallback.children.isEmpty && (fallback.id?.isNotEmpty ?? false)) {
               try {
                  final detailedJob = await _hydrateJobWithDetails(fallback.id!);
                  if (detailedJob != null) {
                    jobs.add(detailedJob);
                    continue;
                  }
               } catch (_) {}
             }
            jobs.add(fallback);
          }
        }
      }
      return jobs;
    } catch (e) {
      if (e is DioException) {
// ... existing error handling ...
      }
      rethrow;
    }
  }

  Future<Job?> _hydrateJobWithDetails(String jobId) async {
    try {
      final response = await _dio.get('/jobs/$jobId');
      if (response.data['success'] == true) {
        final jobData = response.data['data']['job'];
        if (jobData != null) {
           return JobDto.fromJson(jobData).toDomain();
        }
      }
    } catch (e) {
      print('DEBUG: Error fetching details for job $jobId: $e');
    }
    return null;
  }

  Map<String, dynamic>? _extractJobJson(Map<String, dynamic> item) {
    if (item['job'] is Map<String, dynamic>) {
      return item['job'] as Map<String, dynamic>;
    }
    if (item['jobDetails'] is Map<String, dynamic>) {
      return item['jobDetails'] as Map<String, dynamic>;
    }
    if (item['jobId'] != null && item['title'] == null) {
      return null;
    }
    return item;
  }

  Job? _fallbackJobFromJson(Map<String, dynamic> json) {
    final id = (json['id'] ??
            json['_id'] ??
            json['jobId'] ??
            json['job_id'])
        ?.toString();
    if (id == null || id.isEmpty) {
      return null;
    }
    final title = (json['title'] ?? json['jobTitle'] ?? '').toString();
    final locationText = _extractLocationText(json);
    final cityState = _splitCityState(locationText);
    final address = JobAddress(
      streetAddress: '',
      city: cityState.$1,
      state: cityState.$2,
      zipCode: '',
      latitude: _toDouble(json['latitude'] ?? json['lat']),
      longitude: _toDouble(json['longitude'] ?? json['lng']),
    );

    final childIds = _extractChildIds(json['childIds'], json['children']);
    
    // Attempt to parse children if available
    final List<Child> children = [];
    if (json['children'] is List) {
      try {
        children.addAll((json['children'] as List)
            .map((e) => ChildDto.fromJson(e as Map<String, dynamic>).toDomain())
            .toList());
      } catch (_) {
        // Ignore parsing errors for children in fallback
      }
    }

    final payRate = _toDouble(json['payRate'] ?? json['hourlyRate']) ?? 0;

    String? parentUserId;
    final rawParentId = json['parentUserId'] ?? json['parentId'];
    if (rawParentId is Map<String, dynamic>) {
      parentUserId = rawParentId['_id'] as String? ?? rawParentId['id'] as String?;
    } else {
      parentUserId = rawParentId?.toString();
    }

    return Job(
      id: id,
      parentUserId: parentUserId,
      childIds: childIds,
      children: children,
      title: title,
      startDate: (json['startDate'] ?? '').toString(),
      endDate: (json['endDate'] ?? '').toString(),
      startTime: (json['startTime'] ?? '').toString(),
      endTime: (json['endTime'] ?? '').toString(),
      address: address,
      location: _toDouble(json['latitude'] ?? json['lat']) != null &&
              _toDouble(json['longitude'] ?? json['lng']) != null
          ? JobLocation(
              latitude: _toDouble(json['latitude'] ?? json['lat'])!,
              longitude: _toDouble(json['longitude'] ?? json['lng'])!,
            )
          : null,
      additionalDetails: (json['additionalDetails'] ?? '').toString(),
      payRate: payRate,
      status: (json['status'] ?? '').toString(),
      estimatedDuration: _toInt(json['estimatedDuration']),
      estimatedTotal: _toDouble(json['estimatedTotal']),
      createdAt: _toDateTime(json['createdAt']),
      postedAt: _toDateTime(json['postedAt']),
    );
  }

  Map<String, dynamic> _normalizeJobJson(Map<String, dynamic> json) {
    final normalized = Map<String, dynamic>.from(json);

    final id = _knownId(normalized['id'] ?? normalized['_id']);
    if (id != null) {
      normalized['id'] = id;
    }

    final parentUserId =
        _knownId(normalized['parentUserId'] ?? normalized['parentId']);
    if (parentUserId != null) {
      normalized['parentUserId'] = parentUserId;
    }

    final childIds = _normalizeIdList(normalized['childIds']);
    if (childIds != null) {
      normalized['childIds'] = childIds;
    } else {
      final childrenIds = _normalizeIdList(normalized['children']);
      if (childrenIds != null) {
        normalized['childIds'] = childrenIds;
      }
    }

    final applicantIds = _normalizeIdList(normalized['applicantIds']);
    if (applicantIds != null) {
      normalized['applicantIds'] = applicantIds;
    }

    final acceptedSitterId = _knownId(normalized['acceptedSitterId']);
    if (acceptedSitterId != null) {
      normalized['acceptedSitterId'] = acceptedSitterId;
    }

    final createdAt = _normalizeDateValue(normalized['createdAt']);
    if (createdAt != null) {
      normalized['createdAt'] = createdAt;
    }

    final postedAt = _normalizeDateValue(normalized['postedAt']);
    if (postedAt != null) {
      normalized['postedAt'] = postedAt;
    }

    final addressValue = normalized['address'];
    if (addressValue is Map<String, dynamic>) {
      if (_looksLikeGeoJson(addressValue)) {
        normalized['address'] = null;
      } else if (_looksLikeAddressPayload(addressValue)) {
        final addressMap = Map<String, dynamic>.from(addressValue);
        addressMap.putIfAbsent('streetAddress', () => '');
        addressMap.putIfAbsent('city', () => '');
        addressMap.putIfAbsent('state', () => '');
        addressMap.putIfAbsent('zipCode', () => '');
        normalized['address'] = addressMap;
      } else {
        normalized['address'] = null;
      }
    } else if (addressValue != null) {
      normalized['address'] = null;
    }

    return normalized;
  }

  String? _knownId(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is num) return value.toString();
    if (value is Map) {
      final id = value['id'] ?? value['_id'];
      if (id != null) return id.toString();
    }
    return null;
  }

  List<String>? _normalizeIdList(dynamic value) {
    if (value is! List) return null;
    final ids = <String>[];
    for (final entry in value) {
      final id = _knownId(entry);
      if (id != null && id.isNotEmpty) {
        ids.add(id);
      }
    }
    return ids;
  }

  String? _normalizeDateValue(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is DateTime) return value.toIso8601String();
    if (value is num) {
      final milliseconds = value > 1000000000000 ? value : value * 1000;
      return DateTime.fromMillisecondsSinceEpoch(milliseconds.toInt())
          .toIso8601String();
    }
    return null;
  }

  bool _looksLikeGeoJson(Map<String, dynamic> value) {
    return value['type'] == 'Point' && value['coordinates'] is List;
  }

  bool _looksLikeAddressPayload(Map<String, dynamic> value) {
    return value.containsKey('streetAddress') ||
        value.containsKey('city') ||
        value.containsKey('state') ||
        value.containsKey('zipCode');
  }

  String _extractLocationText(Map<String, dynamic> json) {
    final address = json['address'];
    if (address is Map<String, dynamic>) {
      final city = address['city']?.toString() ?? '';
      final state = address['state']?.toString() ?? '';
      if (city.isNotEmpty || state.isNotEmpty) {
        if (city.isNotEmpty && state.isNotEmpty) {
          return '$city, $state';
        }
        return city.isNotEmpty ? city : state;
      }
    }

    final city = json['city']?.toString() ?? '';
    final state = json['state']?.toString() ?? '';
    if (city.isNotEmpty || state.isNotEmpty) {
      if (city.isNotEmpty && state.isNotEmpty) {
        return '$city, $state';
      }
      return city.isNotEmpty ? city : state;
    }

    final location = json['location'];
    if (location is String) {
      return location;
    }

    return '';
  }

  List<String> _extractChildIds(dynamic childIds, dynamic children) {
    if (childIds is List) {
      return childIds.map((e) => e.toString()).toList();
    }
    if (children is List) {
      return children
          .map((e) =>
              (e is Map<String, dynamic> ? e['id'] ?? e['_id'] : null))
          .where((id) => id != null)
          .map((id) => id.toString())
          .toList();
    }
    return [];
  }

  (String, String) _splitCityState(String raw) {
    if (raw.isEmpty) return ('', '');
    final parts = raw.split(',');
    if (parts.length >= 2) {
      return (parts[0].trim(), parts[1].trim());
    }
    return (raw.trim(), '');
  }

  double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  DateTime? _toDateTime(dynamic value) {
    if (value == null) return null;
    if (value is String) {
      return DateTime.tryParse(value);
    }
    if (value is num) {
      final milliseconds = value > 1000000000000 ? value : value * 1000;
      return DateTime.fromMillisecondsSinceEpoch(milliseconds.toInt());
    }
    return null;
  }

  void _logSavedJobsResponseShape(dynamic data) {
    print('DEBUG: Saved Jobs Response Type: ${data.runtimeType}');
    if (data is Map<String, dynamic>) {
      print('DEBUG: Saved Jobs Response Keys: ${data.keys.toList()}');
      final dataField = data['data'];
      print(
        'DEBUG: Saved Jobs Response data field type: ${dataField.runtimeType}',
      );
      if (dataField is Map<String, dynamic>) {
        print(
          'DEBUG: Saved Jobs Response data keys: ${dataField.keys.toList()}',
        );
      }
    } else if (data is List) {
      print('DEBUG: Saved Jobs Response List length: ${data.length}');
      if (data.isNotEmpty) {
        print(
          'DEBUG: Saved Jobs Response First Item Type: ${data.first.runtimeType}',
        );
      }
    }
  }

  void _logJobJsonTypeMismatches(Map<String, dynamic> jobJson) {
    print('DEBUG: Saved Jobs jobJson keys: ${jobJson.keys.toList()}');

    const stringFields = [
      'id',
      'parentUserId',
      'title',
      'startDate',
      'endDate',
      'startTime',
      'endTime',
      'timezone',
      'additionalDetails',
      'status',
      'acceptedSitterId',
    ];

    for (final field in stringFields) {
      final value = jobJson[field];
      if (value is Map || value is List) {
        print(
          'DEBUG: Saved Jobs unexpected type for "$field": ${value.runtimeType} value: $value',
        );
      }
    }

    final addressValue = jobJson['address'];
    if (addressValue != null && addressValue is! Map<String, dynamic>) {
      print(
        'DEBUG: Saved Jobs unexpected type for "address": ${addressValue.runtimeType} value: $addressValue',
      );
    }

    final childIdsValue = jobJson['childIds'];
    if (childIdsValue != null && childIdsValue is! List) {
      print(
        'DEBUG: Saved Jobs unexpected type for "childIds": ${childIdsValue.runtimeType} value: $childIdsValue',
      );
    } else if (childIdsValue is List) {
      final badChildIds = childIdsValue.where((e) => e is Map || e is List);
      if (badChildIds.isNotEmpty) {
        print(
          'DEBUG: Saved Jobs childIds contains non-String entries: ${badChildIds.map((e) => e.runtimeType).toList()}',
        );
      }
    }

    final applicantIdsValue = jobJson['applicantIds'];
    if (applicantIdsValue != null && applicantIdsValue is! List) {
      print(
        'DEBUG: Saved Jobs unexpected type for "applicantIds": ${applicantIdsValue.runtimeType} value: $applicantIdsValue',
      );
    } else if (applicantIdsValue is List) {
      final badApplicantIds =
          applicantIdsValue.where((e) => e is Map || e is List);
      if (badApplicantIds.isNotEmpty) {
        print(
          'DEBUG: Saved Jobs applicantIds contains non-String entries: ${badApplicantIds.map((e) => e.runtimeType).toList()}',
        );
      }
    }

    final createdAtValue = jobJson['createdAt'];
    if (createdAtValue != null && createdAtValue is! String) {
      print(
        'DEBUG: Saved Jobs unexpected type for "createdAt": ${createdAtValue.runtimeType} value: $createdAtValue',
      );
    }

    final postedAtValue = jobJson['postedAt'];
    if (postedAtValue != null && postedAtValue is! String) {
      print(
        'DEBUG: Saved Jobs unexpected type for "postedAt": ${postedAtValue.runtimeType} value: $postedAtValue',
      );
    }
  }

  Future<void> saveJob(String jobId) async {
    try {
      final payload = {'jobId': jobId};
      print('DEBUG: Save Job Request: POST /sitters/saved-jobs $payload');
      final response = await _dio.post('/sitters/saved-jobs', data: payload);
      print('DEBUG: Save Job Response Status: ${response.statusCode}');
    } catch (e) {
      if (e is DioException) {
        print('DEBUG: Save Job Error: ${e.message}');
        print('DEBUG: Save Job Error Response: ${e.response?.data}');
        final serverMessage = e.response?.data?['error'] as String?;
        if (serverMessage != null) {
          throw Exception(serverMessage);
        }
      }
      rethrow;
    }
  }

  Future<void> removeJob(String jobId) async {
    try {
      final endpoint = '/sitters/saved-jobs/$jobId';
      print('DEBUG: Remove Saved Job Request: DELETE $endpoint');
      final response = await _dio.delete(endpoint);
      print('DEBUG: Remove Saved Job Response Status: ${response.statusCode}');
    } catch (e) {
      if (e is DioException) {
        print('DEBUG: Remove Saved Job Error: ${e.message}');
        print('DEBUG: Remove Saved Job Error Response: ${e.response?.data}');
        final serverMessage = e.response?.data?['error'] as String?;
        if (serverMessage != null) {
          throw Exception(serverMessage);
        }
      }
      rethrow;
    }
  }
}