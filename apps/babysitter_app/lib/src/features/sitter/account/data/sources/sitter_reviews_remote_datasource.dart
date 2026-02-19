import 'package:dio/dio.dart';

import '../models/sitter_review.dart';
import 'package:flutter/foundation.dart';

class SitterReviewsRemoteDataSource {
  final Dio _dio;

  SitterReviewsRemoteDataSource(this._dio);

  Future<List<SitterReview>> getMyReviews() async {
    try {
      debugPrint('DEBUG: Reviews Request: GET /reviews/my-reviews');
      final response = await _dio.get(
        '/reviews/my-reviews',
        options: Options(
          receiveTimeout: const Duration(seconds: 60),
        ),
      );
      debugPrint('DEBUG: Reviews Response Status: ${response.statusCode}');

      final data = response.data;
      dynamic list = data;
      if (data is Map<String, dynamic>) {
        list = data['data'] ?? data['reviews'] ?? data['items'];
      }

      if (list is! List) {
        return [];
      }

      return list
          .whereType<Map<String, dynamic>>()
          .map(SitterReview.fromJson)
          .toList();
    } catch (e) {
      if (e is DioException) {
        debugPrint('DEBUG: Reviews Error: ${e.message}');
        debugPrint('DEBUG: Reviews Error Response: ${e.response?.data}');
        if (e.type == DioExceptionType.receiveTimeout) {
          throw Exception(
            'The reviews request is taking longer than expected. Please try again.',
          );
        }
      }
      rethrow;
    }
  }
}
