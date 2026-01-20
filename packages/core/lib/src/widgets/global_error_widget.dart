import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_spacing.dart';

class GlobalErrorWidget extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;
  final String retryText;

  const GlobalErrorWidget({
    super.key,
    required this.title,
    required this.message,
    this.onRetry,
    this.retryText = 'Try Again',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.screenPadding,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: AppColors.error,
            ),
            AppSpacing.verticalMd,
            Text(
              title,
              style: AppTypography.textTheme.headlineSmall?.copyWith(
                color: const Color(0xFF1D2939), // Force dark color
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.verticalSm,
            Text(
              message,
              style: AppTypography.textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF475467), // Force dark gray
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              AppSpacing.verticalXl,
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(retryText),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
