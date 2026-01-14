import 'package:flutter/material.dart';
import '../../../../theme/app_tokens.dart';
import '../models/job_ui_model.dart';

class JobRichChildDetails extends StatelessWidget {
  final List<ChildPart> parts;

  const JobRichChildDetails({
    super.key,
    required this.parts,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: AppTokens.jobInfoValueStyle, // Base style
        children: parts.map((part) {
          if (part.type == ChildPartType.age) {
            return TextSpan(
              text: part.text,
              style: AppTokens.jobInfoValueStyle.copyWith(
                color: AppTokens.jobInfoValueAccentColor,
              ),
            );
          }
          return TextSpan(text: part.text);
        }).toList(),
      ),
    );
  }
}
