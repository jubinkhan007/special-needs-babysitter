import 'package:flutter/material.dart';
import 'package:core/core.dart';
import '../../../search/models/sitter_list_item_model.dart';
import '../theme/home_design_tokens.dart';

class SavedSitterCard extends StatelessWidget {
  final SitterListItemModel sitter;
  final VoidCallback? onBookmarkTap;
  final VoidCallback? onTap;

  const SavedSitterCard({
    super.key,
    required this.sitter,
    this.onBookmarkTap,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: HomeDesignTokens.savedSitterWidth, // 140
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(HomeDesignTokens.smallCardRadius), // 12
          boxShadow: HomeDesignTokens.defaultCardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image + Bookmark overlay
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  child: sitter.imageAssetPath.startsWith('http')
                      ? Image.network(
                          sitter.imageAssetPath,
                          height:
                              HomeDesignTokens.savedSitterImageHeight, // 120
                          width: double.infinity,
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                          errorBuilder: (_, _, _) => Container(
                            height: HomeDesignTokens.savedSitterImageHeight,
                            color: AppColors.neutral10,
                          ),
                        )
                      : Image.asset(
                          sitter.imageAssetPath,
                          height: HomeDesignTokens.savedSitterImageHeight,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                          errorBuilder: (_, _, _) => Container(
                            height: HomeDesignTokens.savedSitterImageHeight,
                            color: AppColors.neutral10,
                          ),
                        ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: onBookmarkTap,
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      width: 28,
                      height: 28,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.bookmark, // Solid/Filled bookmark
                          size: 16,
                          color: AppColors.textPrice),
                    ),
                  ),
                ),
              ],
            ),

            // Info Strip
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row 1: Name + Verified + Star + Rating
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            sitter.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: AppColors.textPrimary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (sitter.isVerified) ...[
                          const SizedBox(width: 4),
                          const Icon(Icons.verified,
                              size: 14, color: AppColors.verifiedBlue),
                        ],
                        const SizedBox(width: 4),
                        const Icon(Icons.star,
                            size: 12, color: AppColors.starYellow),
                        const SizedBox(width: 2),
                        Text(
                          sitter.rating.toStringAsFixed(1),
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 11),
                        ),
                        if (sitter.reviewCount > 0) ...[
                          const SizedBox(width: 2),
                          Text(
                            '(${sitter.reviewCount})',
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 10,
                                color: AppColors.textSecondary),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Row 2: Location Pin + Text
                    Row(
                      children: [
                        const Icon(Icons.location_on, // Filled pin
                            size: 12,
                            color: AppColors.neutral40),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            sitter.distanceText, // Using actual distance
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.neutral40,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
