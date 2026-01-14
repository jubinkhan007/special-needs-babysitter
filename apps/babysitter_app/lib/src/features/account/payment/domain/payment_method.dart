import 'package:flutter/material.dart';

/// Model representing a payment method.
class PaymentMethod {
  final String id;
  final String title;
  final IconData? icon;
  final String? assetPath;
  final bool isText; // For text-based icons like "VISA"

  const PaymentMethod({
    required this.id,
    required this.title,
    this.icon,
    this.assetPath,
    this.isText = false,
  });
}
