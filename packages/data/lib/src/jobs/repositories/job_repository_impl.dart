import 'package:domain/domain.dart';
import '../datasources/job_remote_datasource.dart';
import '../datasources/job_local_datasource.dart';
import '../dtos/job_dto.dart';
import 'package:flutter/foundation.dart';

class JobRepositoryImpl implements JobRepository {
  final JobRemoteDataSource _remoteDataSource;
  final JobLocalDataSource _localDataSource;

  JobRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<String> createJob(Job job) async {
    final jobDto = JobDto.fromDomain(job);
    return _remoteDataSource.createJob(jobDto);
  }

  @override
  Future<List<Job>> getJobs() async {
    final jobDtos = await _remoteDataSource.getJobs();
    debugPrint('DEBUG: JobRepositoryImpl received ${jobDtos.length} jobs');
    return jobDtos.map((dto) {
      try {
        return dto.toDomain();
      } catch (e, stack) {
        debugPrint('ERROR: Failed to convert JobDto to Domain: ${dto.id}');
        debugPrint('Error details: $e');
        debugPrint('Stack trace: $stack');
        debugPrint('Problematic DTO: $dto');
        rethrow;
      }
    }).toList();
  }

  @override
  Future<List<Job>> getPublicJobs(
      {int limit = 20, int offset = 0, String? status = 'posted',}) async {
    final jobDtos = await _remoteDataSource.getJobs(
        status: status, limit: limit, offset: offset,);
    return jobDtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<Job> getJobById(String id) async {
    final jobDto = await _remoteDataSource.getJobById(id);
    return jobDto.toDomain();
  }

  @override
  Future<void> updateJob(Job job) async {
    final jobDto = JobDto.fromDomain(job);
    return _remoteDataSource.updateJob(jobDto);
  }

  @override
  Future<void> deleteJob(String id) async {
    return _remoteDataSource.deleteJob(id);
  }

  @override
  Future<void> saveLocalDraft(Job job) async {
    final jobDto = JobDto.fromDomain(job);
    await _localDataSource.saveDraft(jobDto);
  }

  @override
  Future<Job?> getLocalDraft() async {
    final jobDto = await _localDataSource.getDraft();
    return jobDto?.toDomain();
  }

  @override
  Future<void> clearLocalDraft() async {
    await _localDataSource.clearDraft();
  }

  @override
  Future<void> inviteSitter(String jobId, String sitterId) async {
    return _remoteDataSource.inviteSitter(jobId, sitterId);
  }
}
