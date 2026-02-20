import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:dio/dio.dart';
import 'package:domain/domain.dart';
import 'package:data/data.dart';
import 'package:core/core.dart';
import '../../../../constants/app_constants.dart';

/// Dio provider configured for registration API
final registrationDioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: Constants.connectionTimeout,
      receiveTimeout: Constants.receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );
});

/// Registration data source provider
final registrationDataSourceProvider =
    Provider<RegistrationRemoteDataSource>((ref) {
  final dio = ref.watch(registrationDioProvider);
  return RegistrationRemoteDataSource(dio);
});

/// Registration repository provider
final registrationRepositoryProvider = Provider<RegistrationRepository>((ref) {
  final dataSource = ref.watch(registrationDataSourceProvider);
  return RegistrationRepositoryImpl(dataSource);
});

/// Get security questions use case provider
final getSecurityQuestionsUseCaseProvider =
    Provider<GetSecurityQuestionsUseCase>((ref) {
  final repo = ref.watch(registrationRepositoryProvider);
  return GetSecurityQuestionsUseCase(repo);
});

/// Register and send OTP use case provider (sequential flow)
final registerAndSendOtpUseCaseProvider =
    Provider<RegisterAndSendOtpUseCase>((ref) {
  final repo = ref.watch(registrationRepositoryProvider);
  return RegisterAndSendOtpUseCase(repo);
});

/// Check uniqueness use case provider
final checkUniquenessUseCaseProvider =
    Provider<CheckUniquenessUseCase>((ref) {
  final repo = ref.watch(registrationRepositoryProvider);
  return CheckUniquenessUseCase(repo);
});
