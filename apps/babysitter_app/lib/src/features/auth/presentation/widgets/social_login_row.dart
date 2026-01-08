import 'package:flutter/material.dart';

import '../../../../../../common/theme/auth_theme.dart';

/// Pixel-perfect social login row matching Figma
class SocialLoginRow extends StatelessWidget {
  final VoidCallback? onFacebookTap;
  final VoidCallback? onGoogleTap;
  final VoidCallback? onAppleTap;

  const SocialLoginRow({
    super.key,
    this.onFacebookTap,
    this.onGoogleTap,
    this.onAppleTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Divider with text - blue-tinted lines on both sides
        Row(
          children: [
            Expanded(
              child: Container(
                height: 1,
                color: const Color(0xFFB8D4E3), // Blue-tinted divider
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Or SignUp with',
                style: TextStyle(
                  fontSize: 13,
                  color: AuthTheme.textDark.withOpacity(0.45),
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 1,
                color: const Color(0xFFB8D4E3), // Blue-tinted divider
              ),
            ),
          ],
        ),
        const SizedBox(height: 20), // More breathing room

        // Social buttons - transparent with blue-tinted border
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _SocialButton(
              iconPath: 'assets/icons/facebook_icon.png',
              onTap: onFacebookTap,
            ),
            const SizedBox(width: 16),
            _SocialButton(
              iconPath: 'assets/icons/google_icon.png',
              onTap: onGoogleTap,
            ),
            const SizedBox(width: 16),
            _SocialButton(
              iconPath: 'assets/icons/apple_icon.png',
              onTap: onAppleTap,
            ),
          ],
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String iconPath;
  final VoidCallback? onTap;

  const _SocialButton({
    required this.iconPath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.transparent, // Transparent, blends with background
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFFB8D4E3), // Blue-tinted border
            width: 1,
          ),
        ),
        child: Center(
          child: Image.asset(
            iconPath,
            width: 22, // Smaller icons
            height: 22,
            errorBuilder: (_, error, __) {
              debugPrint('❌ Asset failed: $iconPath -> $error');
              return const Icon(Icons.error_outline,
                  size: 18, color: Colors.grey);
            },
          ),
        ),
      ),
    );
  }
}
