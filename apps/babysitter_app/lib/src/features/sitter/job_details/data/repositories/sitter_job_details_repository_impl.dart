import '../../domain/entities/sitter_job_details.dart';
import '../../domain/repositories/sitter_job_details_repository.dart';
import '../sources/sitter_job_details_remote_source.dart';
import '../mappers/job_details_mapper.dart';

/// Repository implementation for sitter job details using remote API.
class SitterJobDetailsRepositoryImpl implements SitterJobDetailsRepository {
  final SitterJobDetailsRemoteSource _remoteSource;

  SitterJobDetailsRepositoryImpl(this._remoteSource);

  @override
  Future<SitterJobDetails> getJobDetails(String jobId) async {
    print(
        'DEBUG: SitterJobDetailsRepositoryImpl.getJobDetails called with jobId=$jobId');

    try {
      final response = await _remoteSource.getJobDetails(jobId);
      print('DEBUG: Remote source returned response, mapping to entity...');

      final entity = JobDetailsMapper.fromDto(response);
      print(
          'DEBUG: Mapped entity: title=${entity.title}, childrenCount=${entity.childrenCount}');

      return entity;
    } catch (e, stack) {
      print('DEBUG: Repository error: $e');
      print('DEBUG: Stack: $stack');
      rethrow;
    }
  }
}
