import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../theme/app_tokens.dart';
import 'dart:math' as math;

/// A circular avatar with a progress ring around it and a badge showing percentage.
class CircularProgressAvatar extends StatelessWidget {
  final String? imageUrl;
  final double progress; // 0.0 to 1.0
  final double size;

  const CircularProgressAvatar({
    super.key,
    this.imageUrl,
    required this.progress,
    this.size = 64.0,
  });

  @override
  Widget build(BuildContext context) {
    final ringSize = size + 12; // Extra space for the ring

    return SizedBox(
      width: ringSize.w,
      height: ringSize.h + 20.h, // Extra space for badge
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Progress Ring
          SizedBox(
            width: ringSize.w,
            height: ringSize.h,
            child: CustomPaint(
              painter: _ProgressRingPainter(
                progress: progress,
                trackColor: AppTokens.progressRingTrack,
                progressColor: AppTokens.progressRingValue,
                strokeWidth: AppTokens.progressRingStroke,
              ),
              child: Center(
                child: CircleAvatar(
                  radius: (size / 2).r,
                  backgroundColor: AppTokens.accountCardBg,
                  backgroundImage: imageUrl != null && imageUrl!.isNotEmpty
                      ? NetworkImage(imageUrl!)
                      : const AssetImage('assets/images/user1.png')
                          as ImageProvider,
                ),
              ),
            ),
          ),
          // Badge
          Positioned(
            bottom: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: AppTokens.progressBadgeBg,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(
                  fontFamily: AppTokens.fontFamily,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTokens.progressBadgeText,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressRingPainter extends CustomPainter {
  final double progress;
  final Color trackColor;
  final Color progressColor;
  final double strokeWidth;

  _ProgressRingPainter({
    required this.progress,
    required this.trackColor,
    required this.progressColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Track
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, // Start from top
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ProgressRingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
