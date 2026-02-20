import 'package:flutter_riverpod/legacy.dart';
import '../filter/controller/search_filter_controller.dart';

final searchFilterProvider =
    ChangeNotifierProvider<SearchFilterController>((ref) {
  return SearchFilterController();
});
