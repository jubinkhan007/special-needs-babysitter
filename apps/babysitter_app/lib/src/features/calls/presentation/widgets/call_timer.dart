import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Widget displaying elapsed call time in MM:SS format
class CallTimer extends StatelessWidget {
  final int elapsedSeconds;
  final TextStyle? style;

  const CallTimer({
    super.key,
    required this.elapsedSeconds,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final minutes = elapsedSeconds ~/ 60;
    final seconds = elapsedSeconds % 60;
    final timeString = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return Text(
      timeString,
      style: style ??
          TextStyle(
            fontSize: 16.sp,
            color: Colors.white70,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
    );
  }
}
