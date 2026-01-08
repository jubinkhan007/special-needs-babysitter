import 'package:dio/dio.dart';
import 'package:domain/domain.dart';

/// Remote data source for registration API calls
class RegistrationRemoteDataSource {
  final Dio _dio;

  RegistrationRemoteDataSource(this._dio);

  /// POST /auth/register
  /// API returns: {"success": true, "userId": "...", "message": "..."}
  Future<RegisteredUser> register(RegistrationPayload payload) async {
    final response = await _dio.post(
      '/auth/register',
      data: payload.toJson(),
    );

    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw FormatException('Invalid response format: $data');
    }

    // API returns minimal data on success - we construct user from payload + userId
    final userId = data['userId'];
    if (userId is! String) {
      // Fallback: Check if 'id' or 'uid' exists, or print data to debug
      print('Registration successful but userId missing/invalid. Data: $data');
      if (data['id'] is String) {
        return _createUser(payload, data['id'] as String);
      }
      throw FormatException('Missing userId in response: $data');
    }

    return _createUser(payload, userId);
  }

  RegisteredUser _createUser(RegistrationPayload payload, String userId) {
    return RegisteredUser(
      id: userId,
      email: payload.email,
      firstName: payload.firstName,
      lastName: payload.lastName,
      middleInitial: payload.middleInitial,
      phone: payload.phone,
      role: payload.role,
      phoneVerified: false,
      emailVerified: false,
      createdAt: DateTime.now(),
    );
  }

  /// POST /auth/otp/send
  Future<void> sendOtp(OtpSendPayload payload) async {
    await _dio.post(
      '/auth/otp/send',
      data: payload.toJson(),
    );
  }

  /// GET /auth/security-questions
  Future<List<String>> getSecurityQuestions() async {
    final response = await _dio.get('/auth/security-questions');
    final data = response.data as Map<String, dynamic>;
    final questions = data['questions'] as List<dynamic>;
    return questions.cast<String>();
  }
}
