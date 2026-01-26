import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PauseClockDialog extends StatefulWidget {
  final VoidCallback onPause;
  final VoidCallback onCancel;

  const PauseClockDialog({
    super.key,
    required this.onPause,
    required this.onCancel,
  });

  @override
  State<PauseClockDialog> createState() => _PauseClockDialogState();
}

class _PauseClockDialogState extends State<PauseClockDialog> {
  String? _selectedReason;
  final TextEditingController _otherController = TextEditingController();

  @override
  void dispose() {
    _otherController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: SizedBox(
        width: 320.w,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Pause Clock',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1D2939),
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                  _InfoIcon(),
                  SizedBox(width: 12.w),
                  GestureDetector(
                    onTap: widget.onCancel,
                    child: const Icon(
                      Icons.close_rounded,
                      size: 20,
                      color: Color(0xFF1D2939),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Text(
                'Select a Reason',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1D2939),
                  fontFamily: 'Inter',
                ),
              ),
              SizedBox(height: 12.h),
              _ReasonRow(
                label: 'Lunch Break',
                value: 'lunch',
                groupValue: _selectedReason,
                onChanged: (value) => setState(() {
                  _selectedReason = value;
                }),
              ),
              SizedBox(height: 8.h),
              _ReasonRow(
                label: 'Emergency',
                value: 'emergency',
                groupValue: _selectedReason,
                onChanged: (value) => setState(() {
                  _selectedReason = value;
                }),
              ),
              SizedBox(height: 8.h),
              Text(
                'Other:',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF667085),
                  fontFamily: 'Inter',
                ),
              ),
              SizedBox(height: 8.h),
              TextField(
                controller: _otherController,
                maxLines: 4,
                minLines: 4,
                decoration: InputDecoration(
                  hintText: 'Write your reason here...',
                  hintStyle: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF98A2B3),
                    fontFamily: 'Inter',
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: const BorderSide(color: Color(0xFFB9D9F7)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: const BorderSide(color: Color(0xFF8EC9F5)),
                  ),
                  contentPadding: EdgeInsets.all(12.w),
                ),
              ),
              SizedBox(height: 16.h),
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  onPressed: widget.onPause,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8EC9F5),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      height: 1.0,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              SizedBox(
                width: double.infinity,
                height: 44.h,
                child: OutlinedButton(
                  onPressed: widget.onCancel,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF8EC9F5)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF667085),
                      fontFamily: 'Inter',
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

class _InfoIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22.w,
      height: 22.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFD0D5DD)),
      ),
      child: const Center(
        child: Icon(
          Icons.info_outline,
          size: 14,
          color: Color(0xFF667085),
        ),
      ),
    );
  }
}

class _ReasonRow extends StatelessWidget {
  final String label;
  final String value;
  final String? groupValue;
  final ValueChanged<String> onChanged;

  const _ReasonRow({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF667085),
              fontFamily: 'Inter',
            ),
          ),
        ),
        SizedBox(
          width: 20.w,
          height: 20.w,
          child: Checkbox(
            value: groupValue == value,
            onChanged: (_) => onChanged(value),
            side: const BorderSide(color: Color(0xFF98A2B3)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.r),
            ),
            activeColor: const Color(0xFF8EC9F5),
          ),
        ),
      ],
    );
  }
}
