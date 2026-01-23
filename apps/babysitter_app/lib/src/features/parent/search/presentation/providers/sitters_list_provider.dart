import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../sitters/data/sitters_data_di.dart';
import '../../models/sitter_list_item_model.dart';
import '../filter/models/search_filter_ui_model.dart';

/// FamilyFutureProvider that fetches sitters based on filter state
/// Auto-disposes when filters change and refetches automatically
final sittersListProvider = FutureProvider.autoDispose
    .family<List<SitterListItemModel>, SearchFilterUiModel>((ref, filters) async {
  print('DEBUG: sittersListProvider refreshing with filters: $filters');
  final repository = ref.watch(sittersRepositoryProvider);

  return repository.fetchSitters(
    latitude: filters.latitude,
    longitude: filters.longitude,
    maxDistance: filters.radius.toInt(),
    date: filters.date,
    startTime: filters.startTime,
    endTime: filters.endTime,
    skills: filters.selectedExpertise.isNotEmpty ? filters.selectedExpertise : null,
    maxRate: filters.hourlyRate,
  );
});
