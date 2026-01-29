import 'package:auth/auth.dart';
import 'package:dio/dio.dart';

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
      print('DEBUG: Posting review with payload: $payload');
      print('DEBUG: jobId being sent = $jobId');
      print('DEBUG: revieweeId being sent = $revieweeId');
      await _dio.post('/reviews', data: payload);
    } on DioException catch (e) {
      print('DEBUG: Review POST error: ${e.message}');
      print('DEBUG: Review POST response: ${e.response?.data}');
      print('DEBUG: The jobId "$jobId" was not found by the server');
      rethrow;
    }
  }
}
