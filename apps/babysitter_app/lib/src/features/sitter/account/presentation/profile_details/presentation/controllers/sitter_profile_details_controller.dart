import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:auth/auth.dart';
import 'package:core/core.dart';
import '../../../../../../sitter_profile_setup/presentation/providers/sitter_profile_setup_providers.dart';
import '../../data/sitter_me_dto.dart';
import '../../data/sitter_me_remote_datasource.dart';

part 'sitter_profile_details_controller.g.dart';

/// Provider for SitterMeRemoteDataSource
final sitterMeRemoteDataSourceProvider =
    Provider<SitterMeRemoteDataSource>((ref) {
  return SitterMeRemoteDataSource(ref.watch(authDioProvider));
});

@riverpod
class SitterProfileDetailsController extends _$SitterProfileDetailsController {
  @override
  Future<SitterMeProfileDto> build() async {
    return _loadProfile();
  }

  Future<SitterMeProfileDto> _loadProfile() async {
    try {
      final dataSource = ref.read(sitterMeRemoteDataSourceProvider);
      final response = await dataSource.getSitterMe();
      return response.data.profile;
    } catch (e) {
      throw AppErrorHandler.parse(e);
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _loadProfile());
  }

  Future<bool> updateProfessionalInfo(Map<String, dynamic> payload) async {
    try {
      final repository = ref.read(sitterProfileRepositoryProvider);
      await repository.updateProfile(step: 2, data: payload);
      await refresh();
      return true;
    } catch (e) {
      return false;
    }
  }
}
