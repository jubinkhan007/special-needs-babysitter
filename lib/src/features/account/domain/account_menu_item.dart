import 'package:flutter/material.dart';

/// Model representing a menu item in the Account screen.
class AccountMenuItem {
  final IconData icon;
  final String title;
  final String? route;
  final VoidCallback? onTap;

  const AccountMenuItem({
    required this.icon,
    required this.title,
    this.route,
    this.onTap,
  });
}
