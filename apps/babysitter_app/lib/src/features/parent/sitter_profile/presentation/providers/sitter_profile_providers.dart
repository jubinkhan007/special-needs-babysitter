import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:babysitter_app/src/features/parent/home/presentation/models/home_mock_models.dart';
import '../../../../sitters/data/sitters_data_di.dart';

/// Provider for loading a sitter profile by ID.
/// Returns AsyncValue<SitterModel> for loading/error/success states.
final sitterProfileProvider =
    FutureProvider.family<SitterModel, String>((ref, sitterId) async {
  final repository = ref.watch(sittersRepositoryProvider);
  return repository.getSitterDetails(sitterId);
});

/// Provider for toggling favorite/bookmark state.
final sitterBookmarkProvider =
    StateProvider.family<bool, String>((ref, sitterId) {
  return false; // Default not bookmarked
});
