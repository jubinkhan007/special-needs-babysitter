import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ReviewRemoteDataSource {
  final Dio _dio;

  ReviewRemoteDataSource(this._dio);

  Future<void> postReview({
    required String revieweeId,
    required String jobId,
    required int rating,
    required String reviewText,
    String? imageUrl,
  }) async {
    try {
      final payload = <String, dynamic>{
        'revieweeId': revieweeId,
        'jobId': jobId,
        'rating': rating,
        'reviewText': reviewText,
      };
      if (imageUrl != null && imageUrl.isNotEmpty) {
        payload['imageUrl'] = imageUrl;
      }
      debugPrint('DEBUG: Posting review with payload: $payload');
      debugPrint('DEBUG: jobId being sent = $jobId');
      debugPrint('DEBUG: revieweeId being sent = $revieweeId');
      await _dio.post('/reviews', data: payload);
    } on DioException catch (e) {
      debugPrint('DEBUG: Review POST error: ${e.message}');
      debugPrint('DEBUG: Review POST response: ${e.response?.data}');
      debugPrint('DEBUG: The jobId "$jobId" was not found by the server');
      rethrow;
    }
  }
}
