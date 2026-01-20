import '../../domain/repositories/application_repository.dart';
import '../sources/application_remote_datasource.dart';

/// Repository implementation for job applications.
class ApplicationRepositoryImpl implements ApplicationRepository {
  final ApplicationRemoteDataSource _remoteDataSource;

  ApplicationRepositoryImpl(this._remoteDataSource);

  @override
  Future<void> submitApplication({
    required String jobId,
    required String coverLetter,
  }) async {
    print('DEBUG: ApplicationRepositoryImpl.submitApplication called');
    await _remoteDataSource.submitApplication(
      jobId: jobId,
      coverLetter: coverLetter,
    );
    print('DEBUG: Application submitted successfully');
  }
}
