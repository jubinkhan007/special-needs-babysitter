import 'package:dio/dio.dart';

import '../models/sitter_review.dart';

class SitterReviewsRemoteDataSource {
  final Dio _dio;

  SitterReviewsRemoteDataSource(this._dio);

  Future<List<SitterReview>> getMyReviews() async {
    try {
      print('DEBUG: Reviews Request: GET /reviews/my-reviews');
      final response = await _dio.get('/reviews/my-reviews');
      print('DEBUG: Reviews Response Status: ${response.statusCode}');

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
        print('DEBUG: Reviews Error: ${e.message}');
        print('DEBUG: Reviews Error Response: ${e.response?.data}');
      }
      rethrow;
    }
  }
}
