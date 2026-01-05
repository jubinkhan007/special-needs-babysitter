import 'package:flutter/material.dart';
import 'package:core/core.dart';

/// Parent bookings screen
class ParentBookingsScreen extends StatelessWidget {
  const ParentBookingsScreen({super.key});

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
              color: AppColors.primary.withOpacity(0.3),
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
              'Manage your bookings',
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
