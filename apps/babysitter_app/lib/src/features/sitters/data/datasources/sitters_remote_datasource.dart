import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../models/sitter_dto.dart'; // Adjust path if needed
import '../models/sitter_profile_dto.dart';

// Reusing the dio provider that has AuthInterceptor from BookingsDataDi or similar
// Actually, let's create a simpler provider setup here or reuse global one.
// Let's assume we can get Dio from bookings_data_di for now or create a local provider that uses the same setup.
// To keep it clean, I will just define the class here, and handle DI in a separate DI file or just provider file.

class SittersRemoteDataSource {
  final Dio _dio;

  SittersRemoteDataSource(this._dio);

  Future<List<SitterDto>> fetchSitters({
    required double latitude,
    required double longitude,
    int limit = 20,
    int offset = 0,
    int? maxDistance,
    DateTime? date,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    String? name,
    List<String>? skills,
    double? minRate,
    double? maxRate,
    String? location,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'latitude': latitude,
        'longitude': longitude,
        'limit': limit,
        'offset': offset,
      };

      // Add optional parameters if provided
      if (maxDistance != null) {
        queryParameters['maxDistance'] = maxDistance;
      }
      if (date != null) {
        queryParameters['date'] = _formatDate(date);
      }
      if (startTime != null) {
        queryParameters['startTime'] = _formatTimeOfDay(startTime);
      }
      if (endTime != null) {
        queryParameters['endTime'] = _formatTimeOfDay(endTime);
      }
      if (name != null && name.isNotEmpty) {
        queryParameters['name'] = name;
      }
      if (skills != null && skills.isNotEmpty) {
        queryParameters['skills'] = skills.join(',');
      }
      if (minRate != null) {
        queryParameters['minRate'] = minRate;
      }
      if (maxRate != null) {
        queryParameters['maxRate'] = maxRate;
      }
      if (location != null && location.isNotEmpty) {
        queryParameters['location'] = location;
      }

      final response = await _dio.get(
        '/sitters/browse',
        queryParameters: queryParameters,
      );

      final data = BrowseSittersResponseDto.fromJson(response.data);
      return data.data.sitters;
    } catch (e) {
      // Log error
      rethrow;
    }
  }

  /// Format DateTime to YYYY-MM-DD string
  String _formatDate(DateTime date) {
    return date.toIso8601String().split('T')[0];
  }

  /// Format TimeOfDay to HH:mm string
  String _formatTimeOfDay(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Future<SitterProfileDto> getSitterDetails(String id) async {
    try {
      final response = await _dio.get('/sitters/$id');
      final data = SitterProfileResponseDto.fromJson(response.data);
      return data.data.profile;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> bookmarkSitter(String sitterId) async {
    try {
      final response = await _dio.post(
        '/parents/bookmarked-sitters',
        data: {'sitterUserId': sitterId},
      );
      if (response.data['success'] != true) {
        throw Exception('Failed to bookmark sitter');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeBookmarkedSitter(String sitterId) async {
    try {
      final response = await _dio.delete(
        '/parents/bookmarked-sitters',
        data: {'sitterUserId': sitterId},
      );
      if (response.data['success'] != true) {
        throw Exception('Failed to remove bookmark');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<SitterDto>> getSavedSitters() async {
    try {
      final response = await _dio.get('/parents/bookmarked-sitters');
      if (response.data['success'] == true) {
        final List<dynamic> list = response.data['data']['sitters'] ?? [];
        return list.map((e) => _mapBookmarkedSitterToDto(e)).toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  /// Maps the bookmarked sitter API response to SitterDto.
  /// The API returns sitter data with nested userId object containing user details.
  SitterDto _mapBookmarkedSitterToDto(Map<String, dynamic> json) {
    final userIdData = json['userId'] as Map<String, dynamic>? ?? {};

    // Photo URL can be in userId object or directly on sitter profile
    final photoUrl =
        userIdData['photoUrl'] as String? ?? json['photoUrl'] as String? ?? '';

    return SitterDto(
      id: json['_id'] ?? '',
      userId: userIdData['_id'] ?? '',
      firstName: userIdData['firstName'] ?? '',
      lastName: userIdData['lastName'] ?? '',
      photoUrl: photoUrl,
      bio: json['bio'] ?? '',
      hourlyRate: (json['hourlyRate'] as num?)?.toDouble() ?? 0.0,
      skills: List<String>.from(json['skills'] ?? []),
      ageRanges: List<String>.from(json['ageRanges'] ?? []),
      address: json['address'],
      distance: (json['distance'] as num?)?.toDouble(),
      reliabilityScore: (json['reliabilityScore'] as num?)?.toDouble() ?? 100.0,
      reviewCount: (json['totalJobs'] as num?)?.toInt() ?? 0,
      isSaved: true, // Always true since this is from saved list
    );
  }
}
