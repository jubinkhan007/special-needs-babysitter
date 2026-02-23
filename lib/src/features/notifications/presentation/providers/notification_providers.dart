import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:babysitter_app/src/packages/auth/auth.dart';

import 'package:babysitter_app/src/features/notifications/models/notification_item.dart';
import 'package:babysitter_app/src/features/notifications/services/notifications_api_service.dart';

/// Provides the authenticated API service.
final notificationsApiServiceProvider =
    Provider<NotificationsApiService>((ref) {
  final dio = ref.watch(authDioProvider);
  return NotificationsApiService(dio);
});

/// Unread count for badge display on bell icons.
final unreadNotificationCountProvider =
    FutureProvider<int>((ref) async {
  final service = ref.watch(notificationsApiServiceProvider);
  return service.getUnreadCount();
});

/// Main notification list provider with refresh support.
final notificationsListProvider =
    AsyncNotifierProvider<NotificationsListNotifier, List<NotificationItem>>(
  NotificationsListNotifier.new,
);

class NotificationsListNotifier
    extends AsyncNotifier<List<NotificationItem>> {
  @override
  Future<List<NotificationItem>> build() async {
    final service = ref.watch(notificationsApiServiceProvider);
    return service.getNotifications();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() {
      final service = ref.read(notificationsApiServiceProvider);
      return service.getNotifications();
    });
  }

  Future<void> markAsRead(String id) async {
    final service = ref.read(notificationsApiServiceProvider);
    await service.markAsRead(id);
    // Update local state to reflect the read status
    final currentList = state.value;
    if (currentList != null) {
      state = AsyncValue.data(
        currentList.map((item) {
          if (item.id == id) {
            return NotificationItem(
              id: item.id,
              type: item.type,
              status: item.status,
              title: item.title,
              body: item.body,
              category: item.category,
              actionUserName: item.actionUserName,
              actionUserAvatar: item.actionUserAvatar,
              data: item.data,
              readAt: DateTime.now(),
              createdAt: item.createdAt,
            );
          }
          return item;
        }).toList(),
      );
    }
    // Refresh unread count badge
    ref.invalidate(unreadNotificationCountProvider);
  }

  Future<void> markAllAsRead() async {
    final service = ref.read(notificationsApiServiceProvider);
    await service.markAllAsRead();
    // Update all items locally
    final currentList = state.value;
    if (currentList != null) {
      final now = DateTime.now();
      state = AsyncValue.data(
        currentList.map((item) {
          if (item.isUnread) {
            return NotificationItem(
              id: item.id,
              type: item.type,
              status: item.status,
              title: item.title,
              body: item.body,
              category: item.category,
              actionUserName: item.actionUserName,
              actionUserAvatar: item.actionUserAvatar,
              data: item.data,
              readAt: now,
              createdAt: item.createdAt,
            );
          }
          return item;
        }).toList(),
      );
    }
    ref.invalidate(unreadNotificationCountProvider);
  }
}
