import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/sitters_data_di.dart';
import '../../domain/sitters_repository.dart';
import '../../../parent/search/models/sitter_list_item_model.dart';
import 'package:flutter/foundation.dart';

/// Controller for the saved sitters list and bookmark operations.
class SavedSittersController extends AsyncNotifier<List<SitterListItemModel>> {
  SittersRepository get _repository => ref.watch(sittersRepositoryProvider);

  @override
  Future<List<SitterListItemModel>> build() async {
    return _fetchSavedSitters();
  }

  Future<List<SitterListItemModel>> _fetchSavedSitters() async {
    return _repository.getSavedSitters();
  }

  /// Toggles bookmark status for a sitter.
  /// If the sitter is currently in the list (saved), it removes them.
  /// If not (e.g. called from search screen), it adds them.
  ///
  /// Note: This logic assumes we want to toggle. The API requires ID.
  /// We need to know current state.
  ///
  /// For the `SavedSittersScreen`, removing an item is the primary action.
  /// For other screens, we might need a separate method or check existence.
  Future<void> toggleBookmark(String sitterId,
      {bool? isCurrentlySaved, SitterListItemModel? sitterItem}) async {
    final currentList = state.value ?? [];
    final isSaved =
        isCurrentlySaved ?? currentList.any((s) => s.userId == sitterId);

    try {
      if (isSaved) {
        // Optimistic remove
        final newList = currentList.where((s) => s.userId != sitterId).toList();
        state = AsyncValue.data(newList);
        await _repository.removeBookmarkedSitter(sitterId);
      } else {
        // Optimistic add if item provided
        if (sitterItem != null) {
          final newList = [...currentList, sitterItem];
          state = AsyncValue.data(newList);
        }
        await _repository.bookmarkSitter(sitterId);
        // Refresh to ensure sync, but optimistic update handles UI
        if (sitterItem == null) {
          ref.invalidateSelf();
        } else {
          // Silent refresh or just trust optimistic?
          // Better to refresh eventually to ensure consistency
          ref.invalidateSelf();
        }
      }
    } catch (e, st) {
      // Revert state on error?
      // For now just error state
      state = AsyncValue.error(e, st);
    }
  }

  /// Explicitly add a bookmark (used from other screens)
  Future<void> bookmarkSitter(String sitterId) async {
    try {
      await _repository.bookmarkSitter(sitterId);
      ref.invalidateSelf(); // Refresh list to include new one
    } catch (e) {
      // Handle error (maybe show toast in UI)
      rethrow;
    }
  }

  /// Explicitly remove a bookmark.
  /// Returns true if successful, false if failed (for UI feedback).
  Future<bool> removeBookmark(String sitterUserId) async {
    final currentList = state.value ?? [];

    debugPrint('DEBUG removeBookmark: sitterUserId=$sitterUserId');
    debugPrint('DEBUG removeBookmark: currentList has ${currentList.length} items');
    for (final s in currentList) {
      debugPrint('DEBUG removeBookmark: item id=${s.id}, userId=${s.userId}, name=${s.name}');
    }

    // Optimistic update FIRST for responsive UI
    final newList =
        currentList.where((s) => s.userId != sitterUserId).toList();
    debugPrint('DEBUG removeBookmark: newList has ${newList.length} items after filter');
    state = AsyncValue.data(newList);

    try {
      await _repository.removeBookmarkedSitter(sitterUserId);
      debugPrint('DEBUG removeBookmark: API call successful');
      return true;
    } catch (e) {
      // Revert on error - sitter reappears in the list
      debugPrint('DEBUG removeBookmark: API call failed with error: $e');
      state = AsyncValue.data(currentList);
      return false;
    }
  }

  bool isSitterBookmarked(String sitterId) {
    return state.value?.any((s) => s.userId == sitterId) ?? false;
  }
}

final savedSittersControllerProvider =
    AsyncNotifierProvider<SavedSittersController, List<SitterListItemModel>>(
  SavedSittersController.new,
);
