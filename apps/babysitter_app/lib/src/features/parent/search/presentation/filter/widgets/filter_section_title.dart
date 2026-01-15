import 'package:flutter/material.dart';
import '../../../../../../theme/app_tokens.dart';

class FilterSectionTitle extends StatelessWidget {
  final String title;

  const FilterSectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0), // Gap to field
      child: Text(
        title,
        style: AppTokens.sheetSectionTitleStyle,
      ),
    );
  }
}
