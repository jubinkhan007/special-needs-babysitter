import 'package:flutter/material.dart';
import '../theme/app_ui_tokens.dart';

class FilterRow extends StatelessWidget {
  final int count;

  const FilterRow({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // "white section below app bar"
      padding: const EdgeInsets.symmetric(
        horizontal: AppUiTokens.horizontalPadding,
        vertical: 12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Showing $count Sitters',
            style: AppUiTokens.filterText,
          ),
          // Filter Pill
          Container(
            height: AppUiTokens.filterPillHeight,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppUiTokens.radiusCircle),
              border: Border.all(color: AppUiTokens.borderColor),
            ),
            child: Row(
              children: const [
                Text(
                  'Filter By:',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppUiTokens.textSecondary,
                  ),
                ),
                SizedBox(width: 4),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 16,
                  color: AppUiTokens.textSecondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
