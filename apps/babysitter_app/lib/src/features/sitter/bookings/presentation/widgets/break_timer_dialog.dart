import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BreakTimerDialog extends StatefulWidget {
  final DateTime pausedAt;
  final VoidCallback onResume;
  final VoidCallback onEndBreak;
  final VoidCallback onClose;

  const BreakTimerDialog({
    super.key,
    required this.pausedAt,
    required this.onResume,
    required this.onEndBreak,
    required this.onClose,
  });

  @override
  State<BreakTimerDialog> createState() => _BreakTimerDialogState();
}

class _BreakTimerDialogState extends State<BreakTimerDialog> {
  late Timer _timer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final elapsed = _now.isAfter(widget.pausedAt)
        ? _now.difference(widget.pausedAt)
        : Duration.zero;
    final hours = _twoDigits(elapsed.inHours);
    final minutes = _twoDigits(elapsed.inMinutes % 60);
    final seconds = _twoDigits(elapsed.inSeconds % 60);

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
                      'Break Timer',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1D2939),
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.onClose,
                    child: const Icon(
                      Icons.close_rounded,
                      size: 20,
                      color: Color(0xFF1D2939),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F9FF),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: const Color(0xFFE0F2FE)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _TimeUnit(value: hours, label: 'Hour'),
                        _TimeSeparator(),
                        _TimeUnit(value: minutes, label: 'Minute'),
                        _TimeSeparator(),
                        _TimeUnit(value: seconds, label: 'Seconds'),
                      ],
                    ),
                  ),
                  Positioned(
                    top: -10.h,
                    right: 12.w,
                    child: _BreakBadge(),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoIcon(),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'The family will be notified that you are on a break.',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: const Color(0xFF667085),
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18.h),
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  onPressed: widget.onResume,
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
                    'Resume Shift',
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
                  onPressed: widget.onEndBreak,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF8EC9F5)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: Text(
                    'End Break',
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

  String _twoDigits(int value) => value.toString().padLeft(2, '0');
}

class _TimeUnit extends StatelessWidget {
  final String value;
  final String label;

  const _TimeUnit({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _TimeBox(value: value),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: const Color(0xFF667085),
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }
}

class _TimeBox extends StatelessWidget {
  final String value;

  const _TimeBox({required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56.w,
      height: 56.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF8EC9F5)),
      ),
      child: Center(
        child: Text(
          value,
          style: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF8EC9F5),
            fontFamily: 'Inter',
          ),
        ),
      ),
    );
  }
}

class _TimeSeparator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Column(
        children: [
          Text(
            ':',
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1D2939),
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}

class _BreakBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3C7),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.w,
            height: 6.w,
            decoration: const BoxDecoration(
              color: Color(0xFFF59E0B),
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 4.w),
          Text(
            'On Break',
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF92400E),
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20.w,
      height: 20.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFD0D5DD)),
      ),
      child: const Center(
        child: Icon(
          Icons.info_outline,
          size: 12,
          color: Color(0xFF667085),
        ),
      ),
    );
  }
}
