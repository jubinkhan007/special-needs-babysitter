import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:core/core.dart';

/// Reusable search field widget.
/// Can be used in two modes:
/// 1. Tap-only mode (enabled = false): Shows placeholder, triggers onTap
/// 2. Interactive mode (enabled = true): Full text input with callbacks
class AppSearchField extends StatelessWidget {
  final String hintText;
  final VoidCallback? onTap;
  final bool enabled;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;
  final bool autofocus;

  const AppSearchField({
    super.key,
    required this.hintText,
    this.onTap,
    this.enabled = false,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!enabled) {
      // Tap-only mode
      return GestureDetector(
        onTap: onTap,
        child: Container(
          height: 44.h,
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                Icons.search,
                size: 18.w,
                color: AppColors.textSecondary,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  hintText,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.textMuted,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Interactive mode
    return Container(
      height: 44.h,
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        autofocus: autofocus,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        textInputAction: TextInputAction.search,
        style: TextStyle(
          fontSize: 13.sp,
          color: AppColors.textPrimary,
          fontFamily: 'Inter',
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 13.sp,
            color: AppColors.textMuted,
            fontFamily: 'Inter',
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 14.w, right: 10.w),
            child: Icon(
              Icons.search,
              size: 18.w,
              color: AppColors.textSecondary,
            ),
          ),
          prefixIconConstraints: BoxConstraints(
            minWidth: 42.w,
            minHeight: 18.w,
          ),
          suffixIcon: controller != null && controller!.text.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    controller?.clear();
                    onChanged?.call('');
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: 14.w),
                    child: Icon(
                      Icons.close,
                      size: 18.w,
                      color: AppColors.textSecondary,
                    ),
                  ),
                )
              : null,
          suffixIconConstraints: BoxConstraints(
            minWidth: 32.w,
            minHeight: 18.w,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 12.h),
        ),
      ),
    );
  }
}
