import 'package:flutter_riverpod/legacy.dart';
import 'package:babysitter_app/src/features/parent/search/presentation/filter/controller/search_filter_controller.dart';

final searchFilterProvider =
    ChangeNotifierProvider<SearchFilterController>((ref) {
  return SearchFilterController();
});
