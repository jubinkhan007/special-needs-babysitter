import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:babysitter_app/src/theme/app_tokens.dart';

class AppConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String primaryActionLabel;
  final String secondaryActionLabel;
  final VoidCallback onPrimary;
  final VoidCallback onSecondary;
  final VoidCallback? onClose; // Optional close callback
  final bool
      primaryIsDestructive; // To style primary differently if needed, though specific req is cancel=blue

  const AppConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    required this.primaryActionLabel,
    required this.secondaryActionLabel,
    required this.onPrimary,
    required this.onSecondary,
    this.onClose,
    this.primaryIsDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    // Lock text scaling as per requirement
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Dialog(
        backgroundColor: Colors.transparent, // Handle bg in container
        elevation: 0,
        insetPadding:
            EdgeInsets.symmetric(horizontal: 24.w), // Margins from screen edge
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppTokens.dialogBg,
            borderRadius: BorderRadius.circular(AppTokens.dialogRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Content Padding
              Padding(
                padding: EdgeInsets.all(AppTokens.dialogPadding),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        height: 8
                            .h), // Space for close icon visual balance? Or just standard padding. Close icon is top right.

                    // Title
                    Padding(
                      padding: EdgeInsets.only(
                          right: 24.w), // Avoid overlap with close icon
                      child: Text(
                        title,
                        style: AppTokens.dialogTitleStyle,
                      ),
                    ),

                    SizedBox(height: 16.h),

                    // Body
                    Text(
                      message,
                      style: AppTokens.dialogBodyStyle,
                    ),

                    SizedBox(height: 32.h),

                    // Actions Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Secondary Action (Left - Text Button)
                        Flexible(
                          child: TextButton(
                            onPressed: onSecondary,
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              splashFactory: NoSplash.splashFactory,
                            ),
                            child: Text(
                              secondaryActionLabel,
                              style: AppTokens.dialogDestructiveActionStyle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),

                        SizedBox(width: AppTokens.dialogActionGap),

                        // Primary Action (Right - Filled Pill)
                        // Using ConstrainedBox to ensure it doesn't grow infinitely and has a reasonable minimum.
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: 100.w,
                          ),
                          child: ElevatedButton(
                            onPressed: onPrimary,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTokens.dialogPrimaryBtnBg,
                              foregroundColor: AppTokens.dialogPrimaryBtnText,
                              elevation: 0,
                              minimumSize:
                                  Size(100.w, AppTokens.dialogPrimaryBtnHeight),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 24.w),
                            ),
                            child: Text(
                              primaryActionLabel,
                              style: AppTokens.dialogPrimaryBtnStyle,
                              maxLines: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Close Icon (Top Right)
              Positioned(
                top: 16.h,
                right: 16.w,
                child: GestureDetector(
                  onTap: onClose ?? () => Navigator.of(context).pop(),
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: EdgeInsets.all(8.w), // Touch area
                    child: Icon(
                      Icons.close_rounded,
                      size: AppTokens.dialogCloseIconSize,
                      color: AppTokens.dialogCloseIconColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
