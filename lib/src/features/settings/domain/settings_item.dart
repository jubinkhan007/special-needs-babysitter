import 'package:flutter/material.dart';

/// Enum to distinguish between navigation and toggle items.
enum SettingsItemType { navigation, toggle }

/// Model representing a settings menu item.
class SettingsItem {
  final String id;
  final String title;
  final IconData icon;
  final SettingsItemType type;
  final String? route;

  const SettingsItem({
    required this.id,
    required this.title,
    required this.icon,
    this.type = SettingsItemType.navigation,
    this.route,
  });
}
