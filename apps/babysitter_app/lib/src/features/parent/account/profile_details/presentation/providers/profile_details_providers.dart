import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:auth/auth.dart';

import '../controllers/profile_details_controller.dart';
import '../state/profile_details_state.dart';

// Authenticated Dio Provider
// Authenticated Dio Provider - Removed in favor of authDioProvider
// final profileDetailsDioProvider = Provider<Dio>((ref) { ... });

// Data Source
final profileDetailsRemoteDataSourceProvider =
    Provider<ProfileDetailsRemoteDataSource>((ref) {
  return ProfileDetailsRemoteDataSource(ref.watch(authDioProvider));
});

// Repository
final profileDetailsRepositoryProvider =
    Provider<ProfileDetailsRepository>((ref) {
  final remoteDataSource = ref.watch(profileDetailsRemoteDataSourceProvider);
  final profileRepository = ref.watch(profileRepositoryProvider);

  // Create AccountRemoteDataSource just for the repo (or reuse if we want)
  // Re-using the logic from AccountRepoImpl requirement
  final accountRemoteDataSource =
      AccountRemoteDataSource(ref.watch(authDioProvider));
  final accountRepository =
      AccountRepositoryImpl(accountRemoteDataSource, profileRepository);

  return ProfileDetailsRepositoryImpl(remoteDataSource, accountRepository);
});

// Use Case
final getProfileDetailsUseCaseProvider =
    Provider<GetProfileDetailsUseCase>((ref) {
  return GetProfileDetailsUseCase(ref.read(profileDetailsRepositoryProvider));
});

// Controller
final profileDetailsControllerProvider =
    AsyncNotifierProvider<ProfileDetailsController, ProfileDetailsState>(
        () => ProfileDetailsController());
