import 'package:dio/dio.dart';

import 'package:babysitter_app/src/features/notifications/models/notification_item.dart';

class NotificationsApiService {
  final Dio _dio;

  NotificationsApiService(this._dio);

  Future<List<NotificationItem>> getNotifications({
    int limit = 20,
    int offset = 0,
  }) async {
    final response = await _dio.get(
      '/notification-inbox',
      queryParameters: {'limit': limit, 'offset': offset},
    );
    final data = _unwrapMap(response.data);
    final items = data['notifications'] ?? data['items'] ?? data['data'];
    if (items is List) {
      return items
          .whereType<Map<String, dynamic>>()
          .map(NotificationItem.fromJson)
          .toList();
    }
    // If the top-level response is already a list
    if (response.data is List) {
      return (response.data as List)
          .whereType<Map<String, dynamic>>()
          .map(NotificationItem.fromJson)
          .toList();
    }
    return [];
  }

  Future<int> getUnreadCount() async {
    final response = await _dio.get('/notification-inbox/unread-count');
    final data = _unwrapMap(response.data);
    final count = data['count'] ?? data['unreadCount'] ?? 0;
    return count is int ? count : int.tryParse(count.toString()) ?? 0;
  }

  Future<void> markAsRead(String id) async {
    await _dio.post('/notification-inbox/$id/read');
  }

  Future<void> markAllAsRead() async {
    await _dio.post('/notification-inbox/mark-all-read');
  }

  Map<String, dynamic> _unwrapMap(dynamic data) {
    if (data is Map<String, dynamic>) {
      final nested = data['data'];
      if (nested is Map<String, dynamic>) {
        return nested;
      }
      return data;
    }
    return {};
  }
}
