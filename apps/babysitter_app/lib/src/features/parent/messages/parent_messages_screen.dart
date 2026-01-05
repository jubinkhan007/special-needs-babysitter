import 'package:flutter/material.dart';
import 'package:core/core.dart';

/// Parent messages screen
class ParentMessagesScreen extends StatelessWidget {
  const ParentMessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.message,
              size: 80,
              color: AppColors.primary.withOpacity(0.3),
            ),
            AppSpacing.verticalMd,
            Text(
              'Messages',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            AppSpacing.verticalXs,
            Text(
              'Chat with sitters',
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
