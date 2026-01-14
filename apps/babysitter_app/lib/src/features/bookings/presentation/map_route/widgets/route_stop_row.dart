import 'package:flutter/material.dart';
import '../../../../../theme/app_tokens.dart';
import '../../models/route_stop_ui_model.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart'; // Assuming standard sizing, but using tokens mostly

class RouteStopRow extends StatelessWidget {
  final RouteStopUiModel stop;

  const RouteStopRow({
    super.key,
    required this.stop,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Timeline Indicator Column
          SizedBox(
            width: 24, // Fixed width for alignment
            child: Column(
              children: [
                // The Dot
                Container(
                  width: AppTokens.routeDotSize,
                  height: AppTokens.routeDotSize,
                  decoration: BoxDecoration(
                    color: stop.isActive
                        ? AppTokens.routeDotActiveFill
                        : AppTokens.routeDotInactiveFill,
                    shape: BoxShape.circle,
                    border: stop.isActive
                        ? null
                        : Border.all(
                            color: AppTokens.routeDotBorderColor, width: 2),
                  ),
                ),
                // The Line (if not last)
                if (!stop.isLast)
                  Expanded(
                    child: Center(
                      child: CustomPaint(
                        size: const Size(2, double.infinity),
                        painter: _DottedLinePainter(),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(width: 12), // Gap between dot and text

          // 2. Address Text
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                  bottom:
                      AppTokens.routeRowGapVertical), // Spacing to next item
              child: Text(
                stop.addressLine,
                style: AppTokens.routeAddressTextStyle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),

          const SizedBox(width: 8),

          // 3. Time Text
          Text(
            stop.timeLabel,
            style: AppTokens.routeTimeTextStyle,
          ),
        ],
      ),
    );
  }
}

class _DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = AppTokens.routeConnectorColor
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    const double dashHeight = 4;
    const double dashSpace = 4;
    double startY = 4; // Start a bit below the dot

    while (startY < size.height) {
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
