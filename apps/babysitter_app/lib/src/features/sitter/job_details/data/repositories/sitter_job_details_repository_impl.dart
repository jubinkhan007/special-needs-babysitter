import '../../domain/entities/sitter_job_details.dart';
import '../../domain/repositories/sitter_job_details_repository.dart';
import '../sources/sitter_job_details_remote_source.dart';
import '../mappers/job_details_mapper.dart';
import 'package:flutter/foundation.dart';

/// Repository implementation for sitter job details using remote API.
class SitterJobDetailsRepositoryImpl implements SitterJobDetailsRepository {
  final SitterJobDetailsRemoteSource _remoteSource;

  SitterJobDetailsRepositoryImpl(this._remoteSource);

  @override
  Future<SitterJobDetails> getJobDetails(String jobId) async {
    debugPrint(
        'DEBUG: SitterJobDetailsRepositoryImpl.getJobDetails called with jobId=$jobId');

    try {
      final response = await _remoteSource.getJobDetails(jobId);
      debugPrint('DEBUG: Remote source returned response, mapping to entity...');

      final entity = JobDetailsMapper.fromDto(response);
      debugPrint(
          'DEBUG: Mapped entity: title=${entity.title}, childrenCount=${entity.childrenCount}');

      return entity;
    } catch (e, stack) {
      debugPrint('DEBUG: Repository error: $e');
      debugPrint('DEBUG: Stack: $stack');
      rethrow;
    }
  }
}
