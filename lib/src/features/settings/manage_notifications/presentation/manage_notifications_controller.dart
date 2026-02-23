import 'package:flutter/material.dart';

/// Controller for Manage Notifications screen
class ManageNotificationsController extends ChangeNotifier {
  bool _pushNotifications = true;
  bool _jobUpdates = true;
  bool _messages = true;
  bool _reminders = true;
  bool _appUpdatesEvents = true;

  bool get pushNotifications => _pushNotifications;
  bool get jobUpdates => _jobUpdates;
  bool get messages => _messages;
  bool get reminders => _reminders;
  bool get appUpdatesEvents => _appUpdatesEvents;

  void togglePushNotifications(bool value) {
    _pushNotifications = value;
    notifyListeners();
  }

  void toggleJobUpdates(bool value) {
    _jobUpdates = value;
    notifyListeners();
  }

  void toggleMessages(bool value) {
    _messages = value;
    notifyListeners();
  }

  void toggleReminders(bool value) {
    _reminders = value;
    notifyListeners();
  }

  void toggleAppUpdates(bool value) {
    _appUpdatesEvents = value;
    notifyListeners();
  }
}
