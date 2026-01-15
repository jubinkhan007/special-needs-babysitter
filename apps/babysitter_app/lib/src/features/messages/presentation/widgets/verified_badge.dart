import 'package:flutter/material.dart';
import '../../../../theme/app_tokens.dart';

/// Blue verified checkmark badge.
class VerifiedBadge extends StatelessWidget {
  const VerifiedBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.verified,
      size: AppTokens.verifiedIconSize,
      color: AppTokens.verifiedBadgeBlue,
    );
  }
}
