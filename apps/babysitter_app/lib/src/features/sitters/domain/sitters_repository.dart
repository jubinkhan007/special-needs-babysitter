import '../../parent/home/presentation/models/home_mock_models.dart';
import '../../parent/search/models/sitter_list_item_model.dart';

abstract class SittersRepository {
  Future<List<SitterListItemModel>> fetchSitters();
  Future<SitterModel> getSitterDetails(String id);
}
