import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../theme/app_tokens.dart';
import 'filter_pill_button.dart';

/// Header row showing "Showing X Sitters" and Filter By pill.
class SavedListHeaderRow extends StatelessWidget {
  final int sitterCount;
  final VoidCallback? onFilterTap;

  const SavedListHeaderRow({
    super.key,
    required this.sitterCount,
    this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTokens.savedSittersBodyBg,
      padding: EdgeInsets.symmetric(
        horizontal: AppTokens.savedSittersHPad.w,
        vertical: 12.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Showing $sitterCount Sitters',
            style: AppTokens.listHeaderTextStyle,
          ),
          FilterPillButton(onTap: onFilterTap),
        ],
      ),
    );
  }
}
