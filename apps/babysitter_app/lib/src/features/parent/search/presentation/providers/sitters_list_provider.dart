import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../sitters/data/sitters_data_di.dart';
import '../../models/sitter_list_item_model.dart';

final sittersListProvider =
    FutureProvider.autoDispose<List<SitterListItemModel>>((ref) async {
  print('DEBUG: sittersListProvider refreshing');
  final repository = ref.watch(sittersRepositoryProvider);
  return repository.fetchSitters();
});
