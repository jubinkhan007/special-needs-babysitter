import 'dart:math';
import 'package:flutter/material.dart';
// Assuming UI Kit usage for colors

class ProfileProgressAvatar extends StatelessWidget {
  final String? avatarUrl;
  final String initials;
  final double progress; // 0.0 to 1.0

  const ProfileProgressAvatar({
    super.key,
    this.avatarUrl,
    required this.initials,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 76, // 64 avatar + 6 padding each side for ring space
      height: 76,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Progress Ring
          CustomPaint(
            size: const Size(76, 76),
            painter: _RingPainter(
              progress: progress,
              color: const Color(0xFF62A8FF), // Light blue accent
              backgroundColor: const Color(0xFFE0E0E0), // Light gray track
            ),
          ),
          // Avatar
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(3.0), // Gap between ring and avatar
              child: CircleAvatar(
                backgroundColor: const Color(0xFFF2F4F7), // Light background
                backgroundImage:
                    avatarUrl != null ? NetworkImage(avatarUrl!) : null,
                child: avatarUrl == null
                    ? Text(
                        initials,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1D2939),
                        ),
                      )
                    : null,
              ),
            ),
          ),
          // Badge
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF62A8FF),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                child: Text(
                  '${(progress * 100).toInt()}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;

  _RingPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 4) / 2; // Stroke width 4

    final trackPaint = Paint()
      ..color = backgroundColor.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    // Draw track
    canvas.drawCircle(center, radius, trackPaint);

    // Draw progress arc - start from top (-90 degrees)
    // Actually the design shows it starts around 7 o'clock and goes clockwise to 5 o'clock?
    // Or simpler: typical circle progress starts top.
    // Screenshot: Blue starts top-leftish, goes around.

    // Let's assume standard start (-pi/2)
    final sweepAngle = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2, // Start at top
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}
