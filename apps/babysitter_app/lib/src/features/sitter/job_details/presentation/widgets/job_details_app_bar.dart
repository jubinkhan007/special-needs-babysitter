import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../theme/app_tokens.dart';

/// Custom app bar for sitter job details screen.
class JobDetailsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onBack;
  final VoidCallback? onSupport;

  const JobDetailsAppBar({
    super.key,
    this.onBack,
    this.onSupport,
  });

  @override
  Size get preferredSize => Size.fromHeight(56.h);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height + MediaQuery.of(context).padding.top,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      decoration: const BoxDecoration(
        color: AppTokens.bg,
      ),
      child: Row(
        children: [
          // Back button
          IconButton(
            onPressed: onBack ?? () => context.pop(),
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 20.w,
              color: AppTokens.iconGrey,
            ),
          ),
          // Title
          Expanded(
            child: Center(
              child: Text(
                'Job Details',
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w500,
                  color: AppTokens.appBarTitleGrey,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ),
          // Support icon
          IconButton(
            onPressed: onSupport,
            icon: Icon(
              Icons.headset_mic_outlined,
              size: 22.w,
              color: AppTokens.iconGrey,
            ),
          ),
        ],
      ),
    );
  }
}
