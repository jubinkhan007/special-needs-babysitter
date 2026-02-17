import 'package:flutter/material.dart';
import '../../../../../theme/app_tokens.dart';

class SectionDivider extends StatelessWidget {
  const SectionDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(
        vertical: AppTokens.jobDetailsSectionDividerPaddingY,
      ),
      child: Divider(
        color: AppTokens.jobDetailsDividerColor,
        thickness: AppTokens.jobDetailsDividerThickness,
        height: AppTokens.jobDetailsDividerThickness,
      ),
    );
  }
}
