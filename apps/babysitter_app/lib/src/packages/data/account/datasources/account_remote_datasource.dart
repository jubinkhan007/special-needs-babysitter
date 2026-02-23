import 'package:dio/dio.dart';

/// Remote data source for account related operations
class AccountRemoteDataSource {
  final Dio _dio;

  AccountRemoteDataSource(this._dio);

  /// Fetch account stats (mocked for now as no endpoint exists)
  Future<Map<String, dynamic>> getAccountStats(String userId) async {
    // Keep _dio for future use when endpoint is ready
    // ignore: unused_local_variable
    final dio = _dio;
    // START MOCK - Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));
    return {
      'bookingHistoryCount': 4,
      'savedSittersCount': 4,
    };
    // END MOCK
  }
}
