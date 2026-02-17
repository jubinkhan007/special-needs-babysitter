import 'package:flutter/material.dart';
import '../../../../theme/app_tokens.dart';

class PipPreviewTile extends StatelessWidget {
  final String previewUrl;
  final VoidCallback onSwitchCamera;

  const PipPreviewTile({
    super.key,
    required this.previewUrl,
    required this.onSwitchCamera,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppTokens.pipWidth,
      height: AppTokens.pipHeight,
      decoration: BoxDecoration(
        color: AppTokens.pipBg,
        borderRadius: BorderRadius.circular(AppTokens.pipRadius),
        boxShadow: const [
          BoxShadow(
            color: AppTokens.pipShadowColor,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Local Camera Preview
          Positioned.fill(
            child: Image.network(
              previewUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: Colors.grey),
            ),
          ),

          // Switch Camera Button (Top Right)
          // "top-right small circular icon button (rotate/switch camera icon) inside the tile"
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: onSwitchCamera,
              child: Container(
                padding: EdgeInsets.all(AppTokens.pipInnerIconPadding),
                decoration: const BoxDecoration(
                  color: AppTokens.pipIconBg, // Translucent white
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.cameraswitch_rounded, // Or cached_rounded / loop
                  color: AppTokens.pipIconColor, // Dark grey
                  size: AppTokens.pipInnerIconSize,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
