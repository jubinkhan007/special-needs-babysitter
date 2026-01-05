import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auth/auth.dart';
import 'package:core/core.dart';

/// Sitter home screen
class SitterHomeScreen extends ConsumerWidget {
  const SitterHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    final user = userAsync.valueOrNull;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome, ${user?.firstName ?? 'Sitter'}!',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              AppSpacing.verticalMd,
              Text(
                'Find families who need your help.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              AppSpacing.verticalXl,
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person,
                        size: 80,
                        color: AppColors.secondary.withOpacity(0.3),
                      ),
                      AppSpacing.verticalMd,
                      Text(
                        'Sitter Dashboard',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
