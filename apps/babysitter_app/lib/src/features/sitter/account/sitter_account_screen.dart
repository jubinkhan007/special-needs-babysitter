import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:auth/auth.dart';
import 'package:core/core.dart';
import 'package:ui_kit/ui_kit.dart';

import '../../../routing/routes.dart';

/// Sitter account screen
class SitterAccountScreen extends ConsumerWidget {
  const SitterAccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    final user = userAsync.valueOrNull;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
      ),
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            children: [
              // User info
              CircleAvatar(
                radius: 48,
                backgroundColor: AppColors.secondary.withOpacity(0.1),
                child: Text(
                  user?.initials ?? '?',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppColors.secondary,
                      ),
                ),
              ),
              AppSpacing.verticalMd,
              Text(
                user?.fullName ?? 'User',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              AppSpacing.verticalXs,
              Text(
                user?.email ?? '',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              AppSpacing.verticalXs,
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Text(
                  'Babysitter Account',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.secondary,
                      ),
                ),
              ),
              if (user?.isSitterApproved == false) ...[
                AppSpacing.verticalSm,
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: Text(
                    'Pending Approval',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.warning,
                        ),
                  ),
                ),
              ],
              AppSpacing.verticalXxl,

              // Settings placeholder
              ListTile(
                leading: const Icon(Icons.settings_outlined),
                title: const Text('Settings'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Settings coming soon')),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.help_outline),
                title: const Text('Help & Support'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Help coming soon')),
                  );
                },
              ),
              const Divider(),

              const Spacer(),

              // Sign out button
              SecondaryButton(
                label: 'Sign Out',
                icon: Icons.logout,
                onPressed: () async {
                  await ref.read(authNotifierProvider.notifier).signOut();
                  if (context.mounted) {
                    context.go(Routes.signIn);
                  }
                },
              ),
              AppSpacing.verticalMd,
            ],
          ),
        ),
      ),
    );
  }
}
