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
      for (final item in list) {
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
        try {
          final dto = JobDto.fromJson(jobJson);
          jobs.add(dto.toDomain());
        } catch (e) {
          print('DEBUG: Failed to parse saved job: $e');
          final fallback = _fallbackJobFromJson(jobJson);
          if (fallback != null) {
            jobs.add(fallback);
          }
        }
      }
      return jobs;
    } catch (e) {
      if (e is DioException) {
        print('DEBUG: Saved Jobs Error: ${e.message}');
        print('DEBUG: Saved Jobs Error Response: ${e.response?.data}');
        final serverMessage = e.response?.data?['error'] as String?;
        if (serverMessage != null) {
          throw Exception(serverMessage);
        }
      }
      rethrow;
    }
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
    final locationText = (json['location'] ?? json['city'] ?? '').toString();
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
    final payRate = _toDouble(json['payRate'] ?? json['hourlyRate']) ?? 0;

    return Job(
      id: id,
      parentUserId: (json['parentUserId'] ?? json['parentId'])?.toString(),
      childIds: childIds,
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
