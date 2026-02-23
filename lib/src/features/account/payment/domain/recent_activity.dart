import 'package:flutter/material.dart';

/// Model representing a recent activity item.
class RecentActivity {
  final String id;
  final String title;
  final String dateText;
  final String amountText;
  final IconData leadingIcon;

  const RecentActivity({
    required this.id,
    required this.title,
    required this.dateText,
    required this.amountText,
    required this.leadingIcon,
  });
}
