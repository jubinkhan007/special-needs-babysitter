import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:auth/auth.dart';
import 'package:core/core.dart';
import 'package:domain/domain.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
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

  Future<bool> updateProfilePhoto(File photoFile) async {
    try {
      final repository = ref.read(sitterProfileRepositoryProvider);
      final resultData = await repository.updateProfile(
        step: 1,
        data: {},
        profilePhoto: photoFile,
      );

      // Sync to user profile (best effort - don't fail if this doesn't work)
      final photoUrl = resultData['photoUrl'] as String?;
      if (photoUrl != null && photoUrl.isNotEmpty) {
        try {
          final profileRepository = ref.read(profileRepositoryProvider);
          await profileRepository.updateProfile(
            UpdateProfileParams(avatarUrl: photoUrl),
          );
        } catch (syncError) {
          // User profile sync failed, but sitter photo was saved successfully
          print('DEBUG: User profile avatar sync failed (non-critical): $syncError');
        }
      }

      await refresh();
      return true;
    } catch (e) {
      print('DEBUG: updateProfilePhoto failed: $e');
      return false;
    }
  }

  Future<bool> updateSkillsAndCertifications({
    required SitterMeProfileDto profile,
    required List<String> skills,
    required List<String> certifications,
    required List<String> ageRanges,
    required String? yearsOfExperience,
  }) async {
    try {
      final repository = ref.read(sitterProfileRepositoryProvider);

      await repository.updateProfile(
        step: 4,
        data: {
          'skills': skills,
          'certifications': certifications,
        },
      );

      final step2Data = <String, dynamic>{
        'ageRanges': ageRanges,
        if (yearsOfExperience != null) 'yearsOfExperience': yearsOfExperience,
        if (profile.bio != null && profile.bio!.isNotEmpty)
          'bio': profile.bio,
        if (profile.dateOfBirth != null && profile.dateOfBirth!.isNotEmpty)
          'dateOfBirth': _formatDateOfBirth(profile.dateOfBirth),
        if (profile.hasTransportation != null)
          'hasTransportation': profile.hasTransportation,
        if (profile.transportationDetails != null &&
            profile.transportationDetails!.isNotEmpty)
          'transportationDetails': profile.transportationDetails,
        if (profile.willingToTravel != null)
          'willingToTravel': profile.willingToTravel,
        if (profile.overnightAvailable != null)
          'overnight': profile.overnightAvailable,
        if (profile.languages != null) 'languages': profile.languages,
      };

      await repository.updateProfile(
        step: 2,
        data: step2Data,
      );

      await refresh();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateAvailability(
      List<Map<String, dynamic>> availability) async {
    try {
      final repository = ref.read(sitterProfileRepositoryProvider);
      await repository.updateProfile(
        step: 7,
        data: {'availability': availability},
      );
      await refresh();
      return true;
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 500) {
        try {
          await refresh();
        } catch (_) {}
        return true;
      }
      return false;
    }
  }

  Future<bool> updateHourlyRate({
    required double hourlyRate,
    required bool openToNegotiating,
  }) async {
    try {
      final repository = ref.read(sitterProfileRepositoryProvider);
      await repository.updateProfile(
        step: 8,
        data: {
          'hourlyRate': hourlyRate.toInt(),
          'openToNegotiating': openToNegotiating,
        },
      );
      await refresh();
      return true;
    } catch (e) {
      return false;
    }
  }

  String? _formatDateOfBirth(String? value) {
    if (value == null || value.isEmpty) return null;
    final parsed = DateTime.tryParse(value);
    if (parsed == null) {
      return value;
    }
    return DateFormat('MM/dd/yyyy').format(parsed);
  }
}
