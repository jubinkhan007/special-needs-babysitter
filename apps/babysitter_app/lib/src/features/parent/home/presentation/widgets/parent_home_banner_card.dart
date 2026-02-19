import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart'; // Assuming core handles AppColors/AppTypography
import '../../../../../routing/routes.dart';
import '../theme/home_design_tokens.dart';

class ParentHomeBannerCard extends StatelessWidget {
  const ParentHomeBannerCard({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Lock text scaling to 1.0 to prevent layout breakage on large system fonts.
    // This is a specific requirement for graphical banners.
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        // 2. Use AspectRatio to maintain the Figma shape on all screens.
        // Aspect ratio seems to be roughly 335 / 170 ~ 1.97 based on typical banner sizes.
        // The previous code had a minHeight of 210, but Figma usually is tighter.
        // Let's us HomeDesignTokens or a standard ratio.
        // If width is screen_width - 48, height should correspond.
        // Let's stick to a safe ratio of ~16/9 or slightly taller like 2/1.
        child: AspectRatio(
          aspectRatio:
              335 / 195, // Adjusted to prevent overflow on small screens
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: HomeDesignTokens.bannerShadow,
              // Background color or gradient if image doesn't load/fill
              color: const Color(0xFF6F98BA),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;

                  return Stack(
                    children: [
                      // A. Background Image (Full Coverage or Gradient)
                      // The previous code used 'assets/images/promo_banner_bg.png' as cover.
                      // If that image includes the person, we must use it carefully.
                      // Instructions say "Right side = image Positioned... Left side = heading".
                      // Assumption: The asset 'promo_banner_bg.png' is the FULL background.
                      // If so, we just use it as background.
                      // BUT, the prompt says "Right side image... Left side heading".
                      // If the previous asset 'promo_banner_bg.png' was just an image, we should position it.
                      // Looking at previous code: decoration image was 'assets/images/promo_banner_bg.png' fit: cover.
                      // This implies the asset itself might be the whole banner background including the person.
                      // However, to follow "Right side image" instruction strictly,
                      // we should position it to ensure the face is visible on the right.

                      Positioned.fill(
                        child: Image.asset(
                          'assets/images/promo_banner_bg.png',
                          fit: BoxFit.cover,
                          alignment: Alignment
                              .centerRight, // Focus on the right side (person)
                        ),
                      ),

                      // B. Content overlay (Gradient to ensure text readability if needed?)
                      // If the background image has text space on left, we are good.
                      // Adding a subtle gradient on the left just in case content overlaps image on small screens.
                      Positioned(
                        left: 0,
                        top: 0,
                        bottom: 0,
                        width: width * 0.65, // Fade out before right side
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withValues(
                                    alpha: 0.2), // Slight darkening for text
                                Colors.transparent,
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                          ),
                        ),
                      ),

                      // C. Left Content (Text + Button)
                      // Combined in a single Positioned to properly manage vertical space and prevent overlap.
                      Positioned(
                        left: 20,
                        top: 12, // Reduced padding
                        bottom: 12, // Reduced padding to prevent overflow
                        width: width *
                            0.55, // Roughly 55% width for text (since image is 45%)
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment
                              .spaceBetween, // Distribute space
                          children: [
                            // Text Area - Wrapped in Expanded to prevent overflow pushing button out
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'Verified Sitters.\nPeace of Mind.',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18,
                                      height: 1.15, // Slightly tighter
                                      fontFamily: AppTypography.fontFamily,
                                      shadows: [
                                        Shadow(
                                          offset: Offset(0, 1),
                                          blurRadius: 2,
                                          color: Colors.black26,
                                        ),
                                      ],
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4), // Reduced spacing
                                  Flexible(
                                    child: Text(
                                      'All babysitters are background-checked and approved.',
                                      style: TextStyle(
                                        color: Colors.white.withValues(alpha: 0.95),
                                        fontSize: 12,
                                        height: 1.25,
                                        fontFamily: AppTypography.fontFamily,
                                        shadows: const [
                                          Shadow(
                                            offset: Offset(0, 1),
                                            blurRadius: 2,
                                            color: Colors.black26,
                                          ),
                                        ],
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Button - Fixed height, always visible at bottom
                            ElevatedButton(
                              onPressed: () => context.push(Routes.postJob),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.buttonDark,
                                foregroundColor: AppColors.textOnButton,
                                elevation: 0,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                minimumSize: const Size(0, 36),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
