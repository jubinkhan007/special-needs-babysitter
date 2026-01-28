import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/sitters_data_di.dart';
import '../../domain/sitters_repository.dart';
import '../../../parent/search/models/sitter_list_item_model.dart';

/// Controller for the saved sitters list and bookmark operations.
class SavedSittersController extends AsyncNotifier<List<SitterListItemModel>> {
  late final SittersRepository _repository;

  @override
  Future<List<SitterListItemModel>> build() async {
    _repository = ref.watch(sittersRepositoryProvider);
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
  Future<void> toggleBookmark(String sitterId, {bool? isCurrentlySaved}) async {
    final currentList = state.valueOrNull ?? [];
    final isSaved = isCurrentlySaved ?? currentList.any((s) => s.userId == sitterId);

    try {
      if (isSaved) {
        await _repository.removeBookmarkedSitter(sitterId);
        // Optimistically remove from list
        state = AsyncValue.data(
          currentList.where((s) => s.userId != sitterId).toList(),
        );
      } else {
        await _repository.bookmarkSitter(sitterId);
        // To optimistically add, we'd need the full sitter object.
        // Since we don't always have it here, we reload the list.
        ref.invalidateSelf();
      }
    } catch (e, st) {
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

  /// Explicitly remove a bookmark
  Future<void> removeBookmark(String sitterId) async {
    try {
      await _repository.removeBookmarkedSitter(sitterId);
      // Optimistic update
      final currentList = state.valueOrNull ?? [];
      state = AsyncValue.data(
        currentList.where((s) => s.userId != sitterId).toList(),
      );
    } catch (e) {
      rethrow;
    }
  }
  
  bool isSitterBookmarked(String sitterId) {
    return state.valueOrNull?.any((s) => s.userId == sitterId) ?? false;
  }
}

final savedSittersControllerProvider =
    AsyncNotifierProvider<SavedSittersController, List<SitterListItemModel>>(
  SavedSittersController.new,
);
