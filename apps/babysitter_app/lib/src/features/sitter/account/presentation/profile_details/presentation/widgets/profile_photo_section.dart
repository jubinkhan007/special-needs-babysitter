import 'package:flutter/material.dart';

class ProfilePhotoSection extends StatelessWidget {
  final String? photoUrl;
  final VoidCallback? onEditTap;

  const ProfilePhotoSection({
    super.key,
    this.photoUrl,
    this.onEditTap,
  });

  /// Adds a cache-busting timestamp to the URL to force reload
  String _getImageUrlWithCacheBuster(String url) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final separator = url.contains('?') ? '&' : '?';
    return '$url${separator}_cb=$timestamp';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF62A8FF),
                width: 3,
              ),
            ),
            child: ClipOval(
              child: photoUrl != null && photoUrl!.isNotEmpty
                  ? Image.network(
                      _getImageUrlWithCacheBuster(photoUrl!),
                      key: ValueKey(photoUrl), // Force rebuild when URL changes
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildPlaceholder(),
                    )
                  : _buildPlaceholder(),
            ),
          ),
          if (onEditTap != null)
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: onEditTap,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFF62A8FF),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.edit,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: const Color(0xFFF2F4F7),
      child: const Icon(
        Icons.person,
        size: 48,
        color: Color(0xFF667085),
      ),
    );
  }
}
