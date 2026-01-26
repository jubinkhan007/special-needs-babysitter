import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../sitters/data/sitters_data_di.dart';
import '../../models/sitter_list_item_model.dart';
import '../filter/models/search_filter_ui_model.dart';
import 'search_filter_provider.dart';

/// FamilyFutureProvider that fetches sitters based on filter state
/// Auto-disposes when filters change and refetches automatically
final sittersListProvider = FutureProvider.autoDispose
    .family<List<SitterListItemModel>, SearchFilterUiModel>((ref, filters) async {
  print('DEBUG: sittersListProvider refreshing with filters: $filters');
  final repository = ref.watch(sittersRepositoryProvider);
  const defaultFilters = SearchFilterUiModel();
  final skills = <String>{
    ...filters.selectedExpertise,
    ...filters.selectedLanguages,
  };
  if (filters.specialNeedsExpertise != null &&
      filters.specialNeedsExpertise!.trim().isNotEmpty) {
    skills.add(filters.specialNeedsExpertise!.trim());
  }
  if (filters.otherLanguage != null && filters.otherLanguage!.trim().isNotEmpty) {
    skills.add(filters.otherLanguage!.trim());
  }

  final maxDistance =
      filters.radius != defaultFilters.radius ? filters.radius.toInt() : null;
  final maxRate =
      filters.hourlyRate != defaultFilters.hourlyRate ? filters.hourlyRate : null;

  final query = filters.searchQuery?.trim();
  final hasLetters =
      query != null && RegExp(r'[A-Za-z]').hasMatch(query);
  final hasDigits = query != null && RegExp(r'\d').hasMatch(query);
  final isLocationLike = query != null &&
      (query.contains(',') || (!hasLetters && hasDigits));

  Future<List<SitterListItemModel>> fetchWith({
    String? name,
    String? location,
  }) {
    return repository.fetchSitters(
      latitude: filters.latitude,
      longitude: filters.longitude,
      maxDistance: maxDistance,
      date: filters.date,
      startTime: filters.startTime,
      endTime: filters.endTime,
      name: name,
      location: location,
      skills: skills.isNotEmpty ? skills.toList() : null,
      maxRate: maxRate,
    );
  }

  if (query == null || query.isEmpty) {
    return fetchWith();
  }

  if (isLocationLike) {
    return fetchWith(location: query);
  }

  final nameResults = await fetchWith(name: query);
  final locationResults = await fetchWith(location: query);
  final merged = <String, SitterListItemModel>{};
  for (final sitter in [...nameResults, ...locationResults]) {
    merged[sitter.id] = sitter;
  }
  return merged.values.toList();
});
