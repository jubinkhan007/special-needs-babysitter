import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../theme/app_tokens.dart';

/// Search bar widget for the Saved Sitters screen.
class SavedSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const SavedSearchBar({
    super.key,
    this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppTokens.searchFieldHeight.h,
      decoration: BoxDecoration(
        color: AppTokens.searchFieldBg,
        borderRadius: BorderRadius.circular(AppTokens.searchFieldRadius.r),
        border: Border.all(
          color: AppTokens.searchFieldBorder,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          SizedBox(width: 16.w),
          Icon(
            Icons.search,
            size: 22.sp,
            color: AppTokens.searchIconColor,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: AppTokens.searchFieldTextStyle,
              decoration: InputDecoration(
                hintText: 'Search By Sitter Name or Location',
                hintStyle: AppTokens.searchFieldHintStyle,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: true,
                fillColor: Colors.transparent,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
            ),
          ),
          SizedBox(width: 16.w),
        ],
      ),
    );
  }
}
