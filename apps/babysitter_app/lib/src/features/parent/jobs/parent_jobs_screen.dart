import 'package:flutter/material.dart';
import 'package:core/core.dart';

/// Parent jobs screen
class ParentJobsScreen extends StatelessWidget {
  const ParentJobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post a Job'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.work,
              size: 80,
              color: AppColors.primary.withOpacity(0.3),
            ),
            AppSpacing.verticalMd,
            Text(
              'Post a Job',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            AppSpacing.verticalXs,
            Text(
              'Create job listings for sitters',
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
