import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:babysitter_app/src/packages/auth/auth.dart';
import 'package:babysitter_app/src/features/settings/manage_notifications/models/notification_preferences.dart';
import 'package:babysitter_app/src/features/settings/manage_notifications/services/notification_preferences_api_service.dart';

final notificationPrefsApiServiceProvider =
    Provider<NotificationPreferencesApiService>((ref) {
      final dio = ref.watch(authDioProvider);
      return NotificationPreferencesApiService(dio);
    });

final notificationPreferencesProvider = AsyncNotifierProvider<
  NotificationPreferencesNotifier,
  NotificationPreferences
>(NotificationPreferencesNotifier.new);

class NotificationPreferencesNotifier
    extends AsyncNotifier<NotificationPreferences> {
  @override
  Future<NotificationPreferences> build() async {
    final service = ref.watch(notificationPrefsApiServiceProvider);
    return service.getPreferences();
  }

  Future<void> toggle(String field, bool value) async {
    final previous = state.value;
    if (previous == null) return;

    // Optimistic update
    final updated = _applyField(previous, field, value);
    state = AsyncData(updated);

    try {
      final service = ref.read(notificationPrefsApiServiceProvider);
      await service.updatePreferences({field: value});
    } catch (e) {
      // Revert on failure
      debugPrint('Failed to update notification preference: $e');
      state = AsyncData(previous);
    }
  }

  NotificationPreferences _applyField(
    NotificationPreferences prefs,
    String field,
    bool value,
  ) {
    switch (field) {
      case 'pushNotifications':
        return prefs.copyWith(pushNotifications: value);
      case 'jobUpdates':
        return prefs.copyWith(jobUpdates: value);
      case 'messages':
        return prefs.copyWith(messages: value);
      case 'reminders':
        return prefs.copyWith(reminders: value);
      case 'appUpdatesAndEvents':
        return prefs.copyWith(appUpdatesAndEvents: value);
      default:
        return prefs;
    }
  }
}
