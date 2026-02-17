import 'package:flutter/material.dart';
import '../../../../../../theme/app_tokens.dart';

class FilterBottomPrimaryBar extends StatelessWidget {
  final VoidCallback? onTap;
  final String label;

  const FilterBottomPrimaryBar({
    super.key,
    required this.onTap,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: AppTokens.sheetHorizontalPadding,
        right: AppTokens.sheetHorizontalPadding,
        top: 16, // Top padding inside bar
        bottom: MediaQuery.of(context).padding.bottom + 16, // Safe area
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTokens.sliderTrackActive, // Primary Blue
          minimumSize: const Size(double.infinity, AppTokens.sheetFieldHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTokens.sheetFieldRadius),
          ),
          elevation: 0,
        ),
        child: Text(
          label, // "Show 6 Results"
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            height: 1.0, // Prevents text clipping
          ),
        ),
      ),
    );
  }
}
