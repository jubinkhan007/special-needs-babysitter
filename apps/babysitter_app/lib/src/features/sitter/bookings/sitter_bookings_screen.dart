import 'package:flutter/material.dart';
import 'package:core/core.dart';

/// Sitter bookings screen
class SitterBookingsScreen extends StatelessWidget {
  const SitterBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookings'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today,
              size: 80,
              color: AppColors.secondary.withOpacity(0.3),
            ),
            AppSpacing.verticalMd,
            Text(
              'Bookings',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            AppSpacing.verticalXs,
            Text(
              'Your scheduled sessions',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textTertiary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
