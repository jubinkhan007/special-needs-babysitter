import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../notifications_service.dart';
import '../notifications_service_impl.dart';
import '../noop_notifications_service.dart';

/// Provider that indicates if Firebase is ready (set by app)
final firebaseReadyProvider = StateProvider<bool>((ref) => false);

/// Provider for NotificationsService
/// Uses Firebase implementation when ready, otherwise no-op
final notificationsServiceProvider = Provider<NotificationsService>((ref) {
  final firebaseReady = ref.watch(firebaseReadyProvider);

  if (firebaseReady) {
    return NotificationsServiceImpl();
  }
  return NoopNotificationsService();
});
