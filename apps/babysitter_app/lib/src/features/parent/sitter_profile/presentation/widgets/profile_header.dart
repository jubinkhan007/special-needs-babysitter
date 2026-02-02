import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:babysitter_app/src/common_widgets/debounced_button.dart';

class SitterProfileHeaderExact extends StatelessWidget {
  const SitterProfileHeaderExact({
    super.key,
    required this.name,
    required this.distanceText,
    required this.ratingText,
    required this.avatarAsset,
    required this.onMessage,
    this.onBack,
    this.onBookmark,
    this.onShare,
    this.onTapRating,
    this.isBookmarked = false,
  });

  final String name;
  final String distanceText;
  final String ratingText;
  final String avatarAsset;
  final VoidCallback onMessage;

  final VoidCallback? onBack;
  final VoidCallback? onBookmark;
  final VoidCallback? onShare;
  final VoidCallback? onTapRating;
  final bool isBookmarked;

  // Colors from your current implementation (tweak if your Figma uses slightly different tints)
  static const _blueBg = Color(0xFFEAF6FF);
  static const _iconGrey = Color(0xFF6B7280);
  static const _textPrimary = Color(0xFF111827);
  static const _textSecondary = Color(0xFF6B7280);
  static const _accentBlue = Color(0xFF6EC1F5);
  static const _starYellow = Color(0xFFF9C941);
  static const _messageBg = Color(0xFF1F2A37);

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;

    // --------------------------
    // 🔧 Pixel-tuning knobs
    // (Adjust these while comparing to the Figma screenshot)
    // --------------------------
    const side = 20.0;

    // Blue header block
    const blueHeight = 140.0; // NOT including status bar
    const blueBottomRadius = 26.0;

    // White "wave" that rises into the blue on the LEFT
    const whiteWaveLift = 34.0; // how much white rises above blue bottom
    const whiteWaveTopLeftRadius = 28.0; // radius of the white wave corner

    // Avatar
    const avatarSize = 86.0;
    const avatarBorder = 4.0;
    const avatarLeft = side;
    // Place avatar so it overlaps the blue->white seam
    // seamY = top + blueHeight - whiteWaveLift
    const avatarYOffsetFromSeam =
        -36.0; // negative = pushes avatar upward into blue

    // Nav row
    const navHeight = 44.0;

    // Content spacing
    const contentTopPadding = 44.0; // space from seam to name block (tune)
    const messageHeight = 34.0;
    const messageRadius = 20.0;
    // --------------------------

    final seamY = top + blueHeight - whiteWaveLift;

    return SizedBox(
      // Total height should include blue + the first content line block under it
      height: top + blueHeight + 95,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 1) Blue background with rounded bottom corners
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: top + blueHeight,
            child: Container(
              decoration: const BoxDecoration(
                color: _blueBg,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(blueBottomRadius),
                  bottomRight: Radius.circular(blueBottomRadius),
                ),
              ),
            ),
          ),

          // 2) White area behind content + "wave" on left
          Positioned(
            left: 0,
            right: 0,
            top: seamY,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  // This creates the exact “curved up” left edge from Figma
                  topLeft: Radius.circular(whiteWaveTopLeftRadius),
                ),
              ),
            ),
          ),

          // 3) iOS-like nav row (center title, icons at edges)
          Positioned(
            left: 0,
            right: 0,
            top: top,
            height: navHeight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: _TopIcon(
                      icon: Icons.arrow_back_ios_new_rounded,
                      color: _iconGrey,
                      onTap: onBack ?? () => context.pop(),
                      size: 22,
                    ),
                  ),
                  Text(
                    '$name Profile',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: _iconGrey,
                      height: 1.0,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _TopIcon(
                          icon: isBookmarked
                              ? Icons.bookmark_rounded
                              : Icons.bookmark_border_rounded,
                          color: _iconGrey,
                          onTap: onBookmark ?? () {},
                          size: 26,
                        ),
                        const SizedBox(width: 22),
                        _TopIcon(
                          icon: Icons.share_outlined,
                          color: _iconGrey,
                          onTap: onShare ?? () {},
                          size: 26,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 4) Avatar overlapping seam + rosette verified badge
          Positioned(
            left: avatarLeft,
            top: seamY + avatarYOffsetFromSeam,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: avatarSize,
                  height: avatarSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: Colors.white, width: avatarBorder),
                  ),
                  child: ClipOval(
                    child: avatarAsset.isEmpty
                        ? Container(
                            color: Colors.grey[200],
                            child: const Icon(Icons.person_rounded,
                                color: Colors.grey, size: 48),
                          )
                        : avatarAsset.startsWith('http')
                            ? Image.network(
                                avatarAsset,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.person_rounded,
                                      color: Colors.grey, size: 48),
                                ),
                              )
                            : (avatarAsset.trim().isNotEmpty
                                ? Image.asset(
                                    avatarAsset,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        Container(
                                      color: Colors.grey[200],
                                      child: const Icon(Icons.person_rounded,
                                          color: Colors.grey, size: 48),
                                    ),
                                  )
                                : Container(
                                    color: Colors.grey[200],
                                    child: const Icon(Icons.person_rounded,
                                        color: Colors.grey, size: 48),
                                  )),
                  ),
                ),
                // Verified badge (rosette)
                const Positioned(
                  right: -2,
                  bottom: -2,
                  child: VerifiedRosetteBadge(
                    size: 34,
                    color: Color(0xFF6EC1F5),
                    iconSize: 18,
                  ),
                ),
              ],
            ),
          ),

          // 5) Name + location + rating + message aligned like Figma
          Positioned(
            left: side,
            right: side,
            top: seamY + contentTopPadding + 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: _textPrimary,
                    height: 1.05,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 8),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Left side: Location (Flexible)
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.location_on_rounded,
                              size: 16, color: _accentBlue),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              distanceText,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: _textSecondary,
                                height: 1.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Right side: Rating + Message
                    // Rating (star + number)
                    GestureDetector(
                      onTap: onTapRating,
                      child: Row(
                        children: [
                          const Icon(Icons.star_rounded,
                              color: _starYellow, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            ratingText,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: _textPrimary,
                              height: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Message button (dark pill) with debouncing
                    SizedBox(
                      height: messageHeight,
                      child: DebouncedElevatedButton(
                        label: 'Message',
                        onPressed: onMessage,
                        debounceDuration: const Duration(milliseconds: 600),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _messageBg,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(messageRadius),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TopIcon extends StatelessWidget {
  const _TopIcon({
    required this.icon,
    required this.color,
    required this.onTap,
    required this.size,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 24,
      child: SizedBox(
        width: 44,
        height: 44,
        child: Center(child: Icon(icon, size: size, color: color)),
      ),
    );
  }
}

/// Rosette badge to match Figma (instead of a plain circle).
/// If you later export the exact badge asset from Figma, replace this widget with Image/SVG.
class VerifiedRosetteBadge extends StatelessWidget {
  const VerifiedRosetteBadge({
    super.key,
    required this.size,
    required this.color,
    required this.iconSize,
  });

  final double size;
  final Color color;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _RosettePainter(color: color),
      child: SizedBox(
        width: size,
        height: size,
        child: Center(
          child: Icon(Icons.check_rounded, color: Colors.white, size: iconSize),
        ),
      ),
    );
  }
}

class _RosettePainter extends CustomPainter {
  _RosettePainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final center = Offset(size.width / 2, size.height / 2);

    // Scalloped edge (petals)
    const petals = 10;
    final rOuter = size.width / 2;
    final rInner = rOuter * 0.82;

    final path = Path();
    for (int i = 0; i < petals * 2; i++) {
      final isOuter = i.isEven;
      final r = isOuter ? rOuter : rInner;
      final t = (math.pi * 2 * i) / (petals * 2);
      final p =
          Offset(center.dx + r * math.cos(t), center.dy + r * math.sin(t));
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }
    path.close();

    canvas.drawPath(path, paint);

    // Inner circle to smooth the rosette shape
    final innerPaint = Paint()..color = color;
    canvas.drawCircle(center, rInner * 0.95, innerPaint);
  }

  @override
  bool shouldRepaint(covariant _RosettePainter oldDelegate) =>
      oldDelegate.color != color;
}
