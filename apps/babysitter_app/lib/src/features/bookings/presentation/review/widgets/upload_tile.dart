import 'package:flutter/material.dart';
import '../../../../../theme/app_tokens.dart';

class UploadTile extends StatelessWidget {
  final VoidCallback onTap;

  const UploadTile({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppTokens.uploadTileSize,
        height: AppTokens.uploadTileSize,
        decoration: BoxDecoration(
          color: AppTokens.uploadTileBg,
          borderRadius: BorderRadius.circular(AppTokens.uploadTileRadius),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.file_upload_outlined,
                color: AppTokens.uploadTileIconColor, size: 20),
            const SizedBox(height: 4),
            Text(
              'Upload Photo\n/ screenshot',
              style: AppTokens.uploadTileTextStyle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
