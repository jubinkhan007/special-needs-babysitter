import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:domain/domain.dart';
import 'package:auth/auth.dart';
import 'package:flutter/widgets.dart';
import '../state/profile_details_state.dart';
import '../providers/profile_details_providers.dart';
import '../../../presentation/controllers/account_controller.dart';

class ProfileDetailsController extends AsyncNotifier<ProfileDetailsState> {
  @override
  FutureOr<ProfileDetailsState> build() {
    return _loadDetails();
  }

  Future<ProfileDetailsState> _loadDetails() async {
    final getProfileDetails = ref.read(getProfileDetailsUseCaseProvider);
    final authState = ref.watch(authNotifierProvider);
    final user = authState.value?.user;

    if (user == null) {
      if (authState.isLoading) {
        return const ProfileDetailsState(isLoading: true);
      }
      return const ProfileDetailsState(errorMessage: 'User not authenticated');
    }

    try {
      final details = await getProfileDetails(user.id);
      return ProfileDetailsState(details: details, isLoading: false);
    } catch (e) {
      return ProfileDetailsState(errorMessage: e.toString(), isLoading: false);
    }
  }

  Future<void> reload() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _loadDetails());
  }

  Future<bool> updateYourDetails(Map<String, dynamic> data,
      {int step = 1}) async {
    final user = ref.read(authNotifierProvider).value?.user;
    if (user == null) return false;

    state = const AsyncValue.loading();
    try {
      await ref
          .read(profileDetailsRepositoryProvider)
          .updateProfileDetails(user.id, data, step: step);

      await ref.read(authNotifierProvider.notifier).refreshProfile();
      ref.invalidate(accountControllerProvider);

      // Reload and update state properly
      final newState = await _loadDetails();
      state = AsyncValue.data(newState);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> addChild(Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(profileDetailsRepositoryProvider).addChild(data);

      final newState = await _loadDetails();
      state = AsyncValue.data(newState);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> updateChild(String childId, Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      await ref
          .read(profileDetailsRepositoryProvider)
          .updateChild(childId, data);

      final newState = await _loadDetails();
      state = AsyncValue.data(newState);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  void onEditYourDetails(
      UserProfileDetails currentDetails, BuildContext context) {
    // Logic handled in view, but method kept for consistency if needed.
    // Ideally we call showDialog from UI, and UI calls controller.updateYourDetails
  }

  Future<String> uploadPhoto(File file) async {
    return await ref
        .read(profileDetailsRepositoryProvider)
        .uploadProfilePhoto(file);
  }
}
