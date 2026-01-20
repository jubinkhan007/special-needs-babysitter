import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../theme/app_tokens.dart';

/// Reusable card wrapper for application preview sections.
class ApplicationPreviewCard extends StatelessWidget {
  final Widget child;

  const ApplicationPreviewCard({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppTokens.cardBorder,
          width: 1,
        ),
      ),
      padding: EdgeInsets.all(16.w),
      child: child,
    );
  }
}
