import 'package:flutter/material.dart';

/// Simple controller for Settings screen state.
/// In a real app, this would be a GetX/Riverpod/BLoC controller.
class SettingsController extends ChangeNotifier {
  bool _isLocationEnabled = true;

  bool get isLocationEnabled => _isLocationEnabled;

  void toggleLocation(bool value) {
    _isLocationEnabled = value;
    notifyListeners();
    // Hook for actual permission logic would go here
  }
}
