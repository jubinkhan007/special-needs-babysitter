import 'package:flutter/material.dart';
import 'package:core/core.dart';

/// Sitter jobs screen
class SitterJobsScreen extends StatelessWidget {
  const SitterJobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Jobs'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.work,
              size: 80,
              color: AppColors.secondary.withOpacity(0.3),
            ),
            AppSpacing.verticalMd,
            Text(
              'Find Jobs',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            AppSpacing.verticalXs,
            Text(
              'Browse available jobs',
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
