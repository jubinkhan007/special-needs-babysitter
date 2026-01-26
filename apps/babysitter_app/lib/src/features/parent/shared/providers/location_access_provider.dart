import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../search/utils/location_helper.dart';

final locationAccessStatusProvider =
    FutureProvider.autoDispose<LocationAccessStatus>((ref) async {
  return LocationHelper.getStatus();
});
