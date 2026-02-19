import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../models/sitter_dto.dart'; // Adjust path if needed
import '../models/sitter_profile_dto.dart';
import '../models/review_dto.dart';

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

  Future<void> removeBookmarkedSitter(String sitterUserId) async {
    try {
      debugPrint(
          'DEBUG removeBookmarkedSitter: Calling DELETE /parents/bookmarked-sitters/$sitterUserId');
      final response = await _dio.delete(
        '/parents/bookmarked-sitters/$sitterUserId',
      );
      debugPrint(
          'DEBUG removeBookmarkedSitter: Response status=${response.statusCode}');
      debugPrint('DEBUG removeBookmarkedSitter: Response data=${response.data}');
      if (response.data['success'] != true) {
        throw Exception('Failed to remove bookmark');
      }
    } catch (e) {
      debugPrint('DEBUG removeBookmarkedSitter: Error=$e');
      rethrow;
    }
  }

  Future<List<SitterDto>> getSavedSitters() async {
    try {
      debugPrint('DEBUG getSavedSitters: Calling GET /parents/bookmarked-sitters');
      final response = await _dio.get('/parents/bookmarked-sitters');
      debugPrint('DEBUG getSavedSitters: Response data = ${response.data}');
      if (response.data['success'] == true) {
        final List<dynamic> list = response.data['data']['sitters'] ?? [];
        debugPrint('DEBUG getSavedSitters: Found ${list.length} sitters');
        return list.map((e) => _mapBookmarkedSitterToDto(e)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('DEBUG getSavedSitters: Error = $e');
      rethrow;
    }
  }

  /// Maps the bookmarked sitter API response to SitterDto.
  /// The API returns sitter data with nested userId object containing user details.
  SitterDto _mapBookmarkedSitterToDto(Map<String, dynamic> json) {
    debugPrint('DEBUG _mapBookmarkedSitterToDto: Raw JSON = $json');
    final userIdData = json['userId'] as Map<String, dynamic>? ?? {};
    debugPrint('DEBUG _mapBookmarkedSitterToDto: userIdData = $userIdData');
    debugPrint(
        'DEBUG _mapBookmarkedSitterToDto: profile _id (json[_id]) = ${json['_id']}');
    debugPrint(
        'DEBUG _mapBookmarkedSitterToDto: user _id (userIdData[_id]) = ${userIdData['_id']}');

    // Photo URL can be in userId object or directly on sitter profile
    final photoUrl =
        userIdData['photoUrl'] as String? ?? json['photoUrl'] as String? ?? '';
    final avgRating = _toDouble(json['avgRating']) ??
        _toDouble(json['rating']) ??
        _toDouble(userIdData['avgRating']) ??
        _toDouble(userIdData['rating']) ??
        0.0;
    final reviewCount = _toInt(json['reviewCount']) ??
        _toInt(json['totalReviews']) ??
        _toInt(userIdData['reviewCount']) ??
        0;

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
      avgRating: avgRating,
      reliabilityScore: (json['reliabilityScore'] as num?)?.toDouble() ?? 100.0,
      reviewCount: reviewCount,
      isSaved: true, // Always true since this is from saved list
    );
  }

  /// Fetch reviews for a specific sitter by user ID
  Future<List<ReviewDto>> fetchReviews(String sitterUserId) async {
    try {
      debugPrint('DEBUG: Fetching reviews for sitterUserId: $sitterUserId');
      final response = await _dio.get(
        '/reviews',
        queryParameters: {'userId': sitterUserId},
      );

      debugPrint('DEBUG: Response status: ${response.statusCode}');
      debugPrint('DEBUG: Response data type: ${response.data.runtimeType}');

      // The API returns a direct array, not wrapped in {success, data}
      if (response.data is List) {
        final data = response.data as List<dynamic>;
        debugPrint('DEBUG: Response is a List with ${data.length} items');

        final reviews = <ReviewDto>[];
        for (var i = 0; i < data.length; i++) {
          try {
            debugPrint('DEBUG: Parsing review $i');
            final review = ReviewDto.fromJson(data[i] as Map<String, dynamic>);
            reviews.add(review);
          } catch (e, stack) {
            debugPrint('DEBUG: Error parsing review $i: $e');
            debugPrint('DEBUG: Stack: $stack');
            rethrow;
          }
        }
        return reviews;
      }

      // Fallback: try wrapped format
      if (response.data is Map<String, dynamic>) {
        final data = response.data['data'];
        if (data is List) {
          debugPrint('DEBUG: Response is wrapped Map with ${data.length} reviews');
          return data
              .map((json) => ReviewDto.fromJson(json as Map<String, dynamic>))
              .toList();
        }
      }

      debugPrint('DEBUG: Unknown response format');
      return [];
    } catch (e, stack) {
      debugPrint('DEBUG: Error in fetchReviews: $e');
      debugPrint('DEBUG: Stack trace: $stack');
      rethrow;
    }
  }

  /// Fetch generic user profile (for parents/sitters) by ID
  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    try {
      final response = await _dio.get('/users/$userId');
      if (response.data['success'] == true) {
        return response.data['data'] as Map<String, dynamic>;
      }
      throw Exception('Failed to fetch user profile');
    } catch (e) {
      debugPrint('DEBUG: Error fetching user profile $userId: $e');
      rethrow;
    }
  }

  double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}
