import 'package:flutter/material.dart';
import '../../../../theme/app_tokens.dart';

class JobInfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Widget? customValueWidget; // For rich text like child details

  const JobInfoItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.customValueWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
              top: 2.0), // Optical alignment with label text
          child: Icon(
            icon,
            size: AppTokens.jobInfoIconSize,
            color: AppTokens.jobInfoIconColor,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTokens.jobInfoLabelStyle,
              ),
              const SizedBox(height: AppTokens.jobInfoLabelValueGap),
              customValueWidget ??
                  Text(
                    value,
                    style: AppTokens.jobInfoValueStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
            ],
          ),
        ),
      ],
    );
  }
}
