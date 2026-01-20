import 'dart:io';

import 'package:domain/domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Controller uses Repository Interface from Domain only.
// Providers are defined in `providers/parent_profile_providers.dart`
// to keep dependency injection separate and clean.

class ParentProfileController extends StateNotifier<AsyncValue<void>> {
  final ParentProfileRepository _repository;

  ParentProfileController(this._repository)
      : super(const AsyncValue.data(null));

  Future<bool> updateProfile({
    required int step,
    required Map<String, dynamic> data,
    File? profilePhoto,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _repository.updateProfile(
        step: step,
        data: data,
        profilePhoto: profilePhoto,
      );
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> addUpdateChild(Map<String, dynamic> childData) async {
    state = const AsyncValue.loading();
    try {
      await _repository.addUpdateChild(childData);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> markProfileComplete() async {
    state = const AsyncValue.loading();
    try {
      await _repository.markProfileComplete();
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}
