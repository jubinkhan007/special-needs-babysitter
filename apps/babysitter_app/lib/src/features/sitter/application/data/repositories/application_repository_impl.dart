import '../../data/models/application_model.dart';
import '../../data/sources/application_remote_datasource.dart';
import '../../domain/repositories/application_repository.dart';

class ApplicationRepositoryImpl implements ApplicationRepository {
  final ApplicationRemoteDataSource _remoteDataSource;

  ApplicationRepositoryImpl(this._remoteDataSource);

  @override
  Future<void> submitApplication({
    required String jobId,
    required String coverLetter,
  }) {
    return _remoteDataSource.submitApplication(
      jobId: jobId,
      coverLetter: coverLetter,
    );
  }

  @override
  Future<List<ApplicationModel>> getApplications({
    String? status,
    String? type,
    int limit = 20,
    int offset = 0,
  }) {
    return _remoteDataSource.getApplications(
      status: status,
      type: type,
      limit: limit,
      offset: offset,
    );
  }

  @override
  Future<ApplicationModel> getApplicationById(String applicationId) {
    return _remoteDataSource.getApplicationById(applicationId);
  }
}
