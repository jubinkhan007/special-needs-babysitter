import 'package:dio/dio.dart';
import 'package:domain/domain.dart';
import 'package:core/core.dart';

import '../datasources/registration_remote_datasource.dart';
import '../../mappers/auth_mappers.dart';

/// Implementation of RegistrationRepository
class RegistrationRepositoryImpl implements RegistrationRepository {
  final RegistrationRemoteDataSource _dataSource;

  RegistrationRepositoryImpl(this._dataSource);

  @override
  Future<RegisteredUser> register(RegistrationPayload payload) async {
    try {
      return await _dataSource.register(payload);
    } on DioException catch (e) {
      throw _mapDioException(e);
    } catch (e) {
      // Catch parsing errors or other unexpected exceptions
      throw ServerFailure(message: 'Registration failed: $e');
    }
  }

  @override
  Future<void> sendOtp(OtpSendPayload payload) async {
    try {
      await _dataSource.sendOtp(payload);
    } on DioException catch (e) {
      throw _mapDioException(e);
    } catch (e) {
      throw ServerFailure(message: 'OTP failed: $e');
    }
  }

  @override
  Future<AuthSession> verifyOtp(OtpVerifyPayload payload) async {
    try {
      final dto = await _dataSource.verifyOtp(payload);
      return AuthMappers.authSessionFromDto(dto);
    } on DioException catch (e) {
      throw _mapDioException(e);
    } catch (e) {
      throw ServerFailure(message: 'OTP verification failed: $e');
    }
  }

  @override
  Future<List<String>> getSecurityQuestions() async {
    try {
      return await _dataSource.getSecurityQuestions();
    } on DioException catch (e) {
      throw _mapDioException(e);
    } catch (e) {
      throw ServerFailure(message: 'Failed to load questions: $e');
    }
  }

  @override
  Future<UniquenessCheckResult> checkUniqueness(
      UniquenessCheckPayload payload) async {
    try {
      return await _dataSource.checkUniqueness(payload);
    } on DioException catch (e) {
      throw _mapDioException(e);
    } catch (e) {
      throw ServerFailure(message: 'Failed to check availability: $e');
    }
  }

  Failure _mapDioException(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return const NetworkFailure(message: 'Request timed out');
    }

    if (e.type == DioExceptionType.connectionError) {
      return const NetworkFailure(message: 'No internet connection');
    }

    final response = e.response;
    if (response != null) {
      final statusCode = response.statusCode;
      final data = response.data;
      String? serverMessage;

      if (data is Map<String, dynamic>) {
        // API uses 'error' key for error messages
        serverMessage = data['error'] as String? ?? data['message'] as String?;

        // Also check for validation errors array
        if (serverMessage == null && data['errors'] is List) {
          final errors = data['errors'] as List;
          if (errors.isNotEmpty) {
            serverMessage = errors.first.toString();
          }
        }
      }

      if (statusCode == 400) {
        return ValidationFailure(
          message: serverMessage ?? 'Please check your inputs',
        );
      }

      if (statusCode == 409) {
        return ServerFailure(
          message: serverMessage ?? 'Email or phone already exists',
          statusCode: 409,
        );
      }

      return ServerFailure(
        message: serverMessage ?? 'Something went wrong. Please try again',
        statusCode: statusCode,
      );
    }

    return const UnexpectedFailure(
      message: 'Something went wrong. Please try again',
    );
  }
}
