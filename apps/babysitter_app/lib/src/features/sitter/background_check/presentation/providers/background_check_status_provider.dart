import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/background_check_status_model.dart';
import '../controllers/background_check_controller.dart'; // accessing remoteDataSourceProvider from here or move it to DI

/// Provider for the background check status
final backgroundCheckStatusProvider =
    FutureProvider.autoDispose<BackgroundCheckStatus>((ref) async {
  final dataSource = ref.watch(backgroundCheckRemoteDataSourceProvider);

  try {
    // For now, if the API isn't ready or returns errors as per user feedback,
    // we might want to mock it. But ideally we call the API.
    // Uncomment the real call once API is stable.

    final data = await dataSource.getBackgroundCheckStatus();
    return BackgroundCheckStatus.fromJson(data);

    // MOCK DATA for development (Uncomment to test UI states without backend)
    /*
    await Future.delayed(const Duration(seconds: 1));
    return const BackgroundCheckStatus(status: BackgroundCheckStatusType.notStarted);
    */
  } catch (e) {
    // Default to not started on error
    return const BackgroundCheckStatus(
        status: BackgroundCheckStatusType.notStarted);
  }
});
