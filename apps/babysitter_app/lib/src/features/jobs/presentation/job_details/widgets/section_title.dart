import 'package:flutter/material.dart';
import '../../../../../theme/app_tokens.dart';

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          bottom: 12.0), // Space between title and content
      child: Text(
        title,
        style: AppTokens.jobDetailsSectionTitleStyle,
      ),
    );
  }
}
