import 'package:flutter/material.dart';
import 'package:core/core.dart';

/// Sitter messages screen
class SitterMessagesScreen extends StatelessWidget {
  const SitterMessagesScreen({super.key});

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
              color: AppColors.secondary.withOpacity(0.3),
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
              'Chat with families',
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
