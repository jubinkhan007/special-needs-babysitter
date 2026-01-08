import 'package:flutter/material.dart';
import 'package:core/core.dart';
import '../theme/home_design_tokens.dart';

class PromoBannerCard extends StatelessWidget {
  const PromoBannerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      height: HomeDesignTokens.promoBannerHeight,
      decoration: BoxDecoration(
        gradient: AppColors.promoGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: HomeDesignTokens.bannerShadow,
      ),
      child: Stack(
        alignment: Alignment.centerLeft, // Align content to left
        children: [
          // Right Image - Positioned to the right side
          Positioned(
            right: -15,
            bottom: 0,
            top: 10, // Move up slightly
            child: Image.asset(
              'assets/images/banner/banner_mom_baby.png',
              fit: BoxFit
                  .contain, // Contain to preserve aspect ratio without crop
              alignment: Alignment.bottomRight,
              width: 180,
              errorBuilder: (_, __, ___) => const SizedBox(),
            ),
          ),
          // Content - Restricted width to avoid overlap
          Padding(
            padding: const EdgeInsets.fromLTRB(
                20, 20, 160, 20), // Large right padding to clear image
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Verified Sitters.\nPeace of Mind.',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    height: 1.2,
                    fontFamily: AppTypography.fontFamily,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'All babysitters are background-checked and approved.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                    height: 1.4,
                    fontFamily: AppTypography.fontFamily,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16), // Space before button
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonDark,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    minimumSize: const Size(0, 40), // Slightly taller
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      fontFamily: AppTypography.fontFamily,
                    ),
                  ),
                  child: const Text('Post a Job'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
