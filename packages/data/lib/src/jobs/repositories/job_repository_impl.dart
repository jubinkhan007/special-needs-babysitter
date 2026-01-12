import 'package:domain/domain.dart';
import '../datasources/job_remote_datasource.dart';
import '../datasources/job_local_datasource.dart';
import '../dtos/job_dto.dart';

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
}
