import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:babysitter_app/src/theme/app_tokens.dart';
import 'app_radio_row.dart';

/// Privacy choice enum
enum PrivacyChoice { yes, no }

/// Reusable privacy radio section widget.
/// Displays a title and Yes/No radio options.
class PrivacyRadioSection extends StatelessWidget {
  final String title;
  final PrivacyChoice selected;
  final ValueChanged<PrivacyChoice> onChanged;

  const PrivacyRadioSection({
    super.key,
    required this.title,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: AppTokens.fontFamily,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppTokens.textPrimary,
          ),
        ),
        SizedBox(height: 8.h),
        AppRadioRow(
          label: 'Yes',
          selected: selected == PrivacyChoice.yes,
          onTap: () => onChanged(PrivacyChoice.yes),
        ),
        AppRadioRow(
          label: 'No',
          selected: selected == PrivacyChoice.no,
          onTap: () => onChanged(PrivacyChoice.no),
        ),
      ],
    );
  }
}
