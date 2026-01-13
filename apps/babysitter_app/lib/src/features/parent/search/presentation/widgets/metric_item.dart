import 'package:flutter/material.dart';
import 'package:babysitter_app/src/features/parent/search/presentation/theme/app_ui_tokens.dart';

class MetricItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const MetricItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: AppUiTokens.iconSizeSmall,
                color: AppUiTokens.textSecondary,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  style: AppUiTokens.metricLabel,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppUiTokens.metricValue,
          ),
        ],
      ),
    );
  }
}
