import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:babysitter_app/src/common_widgets/app_toast.dart';

class DeclineReasonDialog extends StatefulWidget {
  final Function(String reason, String? otherReason) onSubmit;

  const DeclineReasonDialog({
    super.key,
    required this.onSubmit,
  });

  @override
  State<DeclineReasonDialog> createState() => _DeclineReasonDialogState();
}

class _DeclineReasonDialogState extends State<DeclineReasonDialog> {
  String? selectedReason;
  final TextEditingController _otherController = TextEditingController();
  bool showOtherField = false;

  final List<String> reasons = [
    'Schedule Conflict',
    'Insufficient Pay',
    'Prefer More Details',
    'Not a Good Fit',
  ];

  @override
  void dispose() {
    _otherController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    String reason = selectedReason ?? '';
    String? otherReason;

    if (showOtherField) {
      if (_otherController.text.isEmpty) {
        AppToast.show(context, 
          const SnackBar(
            content: Text('Please enter a reason'),
            backgroundColor: Color(0xFFEF4444),
          ),
        );
        return;
      }
      otherReason = _otherController.text.trim();
      reason = 'Other'; // Set reason to 'Other' when custom text is provided
    } else if (reason.isEmpty) {
      AppToast.show(context, 
        const SnackBar(
          content: Text('Please select a reason'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
      return;
    }

    widget.onSubmit(reason, otherReason);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      backgroundColor: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with close button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Reason for Decline',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF101828),
                    fontFamily: 'Inter',
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close,
                      size: 24.w, color: const Color(0xFF667085)),
                  onPressed: () => Navigator.of(context).pop(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),

            SizedBox(height: 20.h),

            // Radio options
            ...reasons.map((reason) => _buildRadioOption(reason)),

            SizedBox(height: 12.h),

            // Add Other field
            if (!showOtherField)
              InkWell(
                onTap: () {
                  setState(() {
                    showOtherField = true;
                    selectedReason = null;
                  });
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFD0D5DD)),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Add Other',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF667085),
                          fontFamily: 'Inter',
                        ),
                      ),
                      Icon(Icons.add,
                          size: 20.w, color: const Color(0xFF667085)),
                    ],
                  ),
                ),
              ),

            // Other text field
            if (showOtherField) ...[
              TextField(
                controller: _otherController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Enter your reason',
                  hintStyle: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF98A2B3),
                    fontFamily: 'Inter',
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: const BorderSide(color: Color(0xFFD0D5DD)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: const BorderSide(color: Color(0xFFD0D5DD)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: const BorderSide(color: Color(0xFF87C4F2)),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                ),
                maxLines: 3,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF101828),
                  fontFamily: 'Inter',
                ),
              ),
              SizedBox(height: 8.h),
              TextButton(
                onPressed: () {
                  setState(() {
                    showOtherField = false;
                    _otherController.clear();
                  });
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF667085),
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ],

            SizedBox(height: 20.h),

            // Submit button
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton(
                onPressed: _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF87C4F2),
                  foregroundColor: AppColors.textOnButton,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  'Submit',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioOption(String reason) {
    final isSelected = selectedReason == reason;

    return InkWell(
      onTap: () {
        setState(() {
          selectedReason = reason;
          showOtherField = false;
          _otherController.clear();
        });
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          children: [
            Container(
              width: 20.w,
              height: 20.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF87C4F2)
                      : const Color(0xFFD0D5DD),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10.w,
                        height: 10.h,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF87C4F2),
                        ),
                      ),
                    )
                  : null,
            ),
            SizedBox(width: 12.w),
            Text(
              reason,
              style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFF344054),
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
