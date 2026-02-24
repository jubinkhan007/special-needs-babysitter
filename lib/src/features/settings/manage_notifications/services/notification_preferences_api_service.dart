import 'package:dio/dio.dart';

import 'package:babysitter_app/src/features/settings/manage_notifications/models/notification_preferences.dart';

class NotificationPreferencesApiService {
  final Dio _dio;

  NotificationPreferencesApiService(this._dio);

  Future<NotificationPreferences> getPreferences() async {
    final response = await _dio.get('/notifications/preferences');
    final data = _unwrapMap(response.data);
    return NotificationPreferences.fromJson(data);
  }

  Future<NotificationPreferences> updatePreferences(
    Map<String, bool> updates,
  ) async {
    final response = await _dio.patch(
      '/notifications/preferences',
      data: updates,
    );
    final data = _unwrapMap(response.data);
    return NotificationPreferences.fromJson(data);
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
