import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../theme/app_tokens.dart';
import '../../domain/rejection_reason.dart';

/// Result returned from the rejection bottom sheet.
class RejectReasonResult {
  final RejectionReason reason;
  final String? otherText;

  const RejectReasonResult({required this.reason, this.otherText});
}

/// Shows the reject reason modal bottom sheet.
/// Returns [RejectReasonResult] if submitted, null if dismissed.
Future<RejectReasonResult?> showRejectReasonBottomSheet(BuildContext context) {
  return showModalBottomSheet<RejectReasonResult>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.4),
    useSafeArea: false,
    builder: (ctx) => const _RejectReasonSheetContent(),
  );
}

class _RejectReasonSheetContent extends StatefulWidget {
  const _RejectReasonSheetContent();

  @override
  State<_RejectReasonSheetContent> createState() =>
      _RejectReasonSheetContentState();
}

class _RejectReasonSheetContentState extends State<_RejectReasonSheetContent> {
  RejectionReason? _selectedReason;
  final TextEditingController _otherController = TextEditingController();

  @override
  void dispose() {
    _otherController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_selectedReason == null && _otherController.text.trim().isEmpty) {
      return; // Nothing selected or typed
    }

    if (_otherController.text.trim().isNotEmpty) {
      // If user typed in "other", use that
      Navigator.of(context).pop(RejectReasonResult(
        reason: RejectionReason.other,
        otherText: _otherController.text.trim(),
      ));
    } else if (_selectedReason != null) {
      Navigator.of(context).pop(RejectReasonResult(
        reason: _selectedReason!,
        otherText: null,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Theme(
      // Force a light theme to override any dark theme colors
      data: ThemeData.light().copyWith(
        inputDecorationTheme: const InputDecorationTheme(
          fillColor: Colors.white,
          filled: true,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomInset),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppTokens.rejectSheetTopRadius.r),
            ),
            child: Container(
              color: const Color(0xFFFFFFFF), // Explicit white
              child: MediaQuery.withClampedTextScaling(
                minScaleFactor: 1.0,
                maxScaleFactor: 1.0,
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppTokens.rejectSheetHorizontalPadding.w,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16.h),

                        // Close Button
                        Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            behavior: HitTestBehavior.opaque,
                            child: SizedBox(
                              width: 48.w,
                              height: 48.h,
                              child: Center(
                                child: Icon(
                                  Icons.close,
                                  size: AppTokens.rejectSheetCloseIconSize.sp,
                                  color: AppTokens.rejectSheetCloseIconColor,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Title
                        Text(
                          'Select Reason for Rejection',
                          style: AppTokens.rejectSheetTitleStyle,
                        ),
                        SizedBox(height: 20.h),

                        // Radio Options
                        ...RejectionReason.values
                            .where((r) => r != RejectionReason.other)
                            .map((reason) => _buildRadioTile(reason)),

                        SizedBox(height: 16.h),

                        // "Add Other" Text Field
                        Container(
                          height: AppTokens.rejectOtherFieldHeight.h,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFFFF), // Explicit white
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color:
                                  const Color(0xFFD1D5DB), // Light grey border
                              width: 1.0,
                            ),
                          ),
                          child: TextField(
                            controller: _otherController,
                            onTap: () {
                              setState(() {
                                _selectedReason = null;
                              });
                            },
                            onChanged: (_) {
                              setState(() {
                                _selectedReason = null;
                              });
                            },
                            style: AppTokens.rejectOtherTextStyle,
                            decoration: InputDecoration(
                              hintText: 'Add Other',
                              hintStyle: AppTokens.rejectOtherHintStyle,
                              contentPadding: AppTokens.rejectOtherFieldPadding,
                              filled: true,
                              fillColor:
                                  const Color(0xFFFFFFFF), // Explicit white
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              suffixIcon: Icon(
                                Icons.add,
                                color: AppTokens.rejectOtherPlusIconColor,
                                size: AppTokens.rejectOtherPlusIconSize.sp,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 16.h),

                        // Submit Button (Custom Container for full control)
                        GestureDetector(
                          onTap: _onSubmit,
                          child: Container(
                            width: double.infinity,
                            height: AppTokens.rejectSubmitHeight.h,
                            decoration: BoxDecoration(
                              color: const Color(0xFF89CFF0), // Baby blue
                              borderRadius: BorderRadius.circular(
                                  AppTokens.rejectSubmitRadius.r),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Submit',
                              style: AppTokens.rejectSubmitTextStyle,
                            ),
                          ),
                        ),

                        SizedBox(height: 32.h), // Extra padding at bottom
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRadioTile(RejectionReason reason) {
    final isSelected = _selectedReason == reason;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedReason = reason;
          _otherController.clear();
          FocusScope.of(context).unfocus();
        });
      },
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: AppTokens.rejectRadioRowHeight.h,
        child: Row(
          children: [
            Container(
              width: 22.w,
              height: 22.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppTokens.rejectRadioSelectedColor
                      : AppTokens.rejectRadioOuterColor,
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 11.w,
                        height: 11.h,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTokens.rejectRadioSelectedColor,
                        ),
                      ),
                    )
                  : null,
            ),
            SizedBox(width: AppTokens.rejectRadioGap.w),
            Text(
              reason.displayLabel,
              style: AppTokens.rejectRadioTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}
