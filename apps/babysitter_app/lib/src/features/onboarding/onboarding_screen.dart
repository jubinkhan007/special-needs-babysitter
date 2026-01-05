// onboarding_screen.dart
//
// Pixel-perfect style onboarding carousel (single screen) matching the screenshot:
// - Fullscreen image carousel (PageView)
// - Title + subtitle overlay on pages 2..4
// - Dots indicator (active pill)
// - Bottom rounded white card with buttons (Get Started / Log In / Looking for Jobs as a Sitter)
// - Page 1 shows role selection inside the bottom card (Family / Babysitter)
//
// Drop this file into:
// apps/babysitter_app/lib/src/features/onboarding/onboarding_screen.dart
//
// NOTE:
// - Uses your core theme tokens (AppColors/AppSpacing/AppRadii). If names differ, adjust imports.
// - Replace image assets with your own (assets/onboarding_1.jpg ...).
// - Hook callbacks to your routing/auth logic.

import 'package:flutter/material.dart';
import 'package:core/core.dart'; // AppColors, AppSpacing, AppRadii (adjust if different)

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({
    super.key,
    required this.onFamilySelected,
    required this.onBabysitterSelected,
    required this.onGetStarted,
    required this.onLogIn,
    required this.onLookingForJobs,
  });

  final VoidCallback onFamilySelected;
  final VoidCallback onBabysitterSelected;
  final VoidCallback onGetStarted;
  final VoidCallback onLogIn;
  final VoidCallback onLookingForJobs;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _index = 0;

  static const _pages = <_OnboardPage>[
    _OnboardPage(
      imageAsset: 'assets/onboarding_1.jpg',
      headline: 'Welcome to Special\nNeeds Sitters',
      subhead:
          "We’re here to support children with unique\nneeds — and the families who love them.",
      mode: _OnboardMode.roleSelect,
    ),
    _OnboardPage(
      imageAsset: 'assets/onboarding_2.jpg',
      headline: 'Specialized Care',
      subhead:
          'All caregivers are trained and experienced in\nworking with special needs children.',
      mode: _OnboardMode.cta,
    ),
    _OnboardPage(
      imageAsset: 'assets/onboarding_3.jpg',
      headline: 'Verified & Trusted',
      subhead:
          'Rigorous background checks and caregiver\nreviews ensure your peace of mind.',
      mode: _OnboardMode.cta,
    ),
    _OnboardPage(
      imageAsset: 'assets/onboarding_4.jpg',
      headline: 'No Subscriptions.\nJust Sitters.',
      subhead:
          'Book sitters when you need them — with no\ncommitments or monthly fees.',
      mode: _OnboardMode.cta,
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isRoleSelect => _pages[_index].mode == _OnboardMode.roleSelect;

  @override
  Widget build(BuildContext context) {
    // Match “screenshot from figma” feel: no app bar, full-bleed imagery.
    return Scaffold(
      body: Stack(
        children: [
          // Carousel images
          PageView.builder(
            controller: _controller,
            itemCount: _pages.length,
            onPageChanged: (i) => setState(() => _index = i),
            itemBuilder: (context, i) {
              final p = _pages[i];
              return _ImagePage(
                imageAsset: p.imageAsset,
                showDarkOverlay: p.mode == _OnboardMode.cta,
              );
            },
          ),

          // Text overlay (pages 2..4)
          if (!_isRoleSelect)
            Positioned(
              left: 0,
              right: 0,
              bottom: 250, // tuned to sit above bottom card like screenshot
              child: SafeArea(
                minimum: const EdgeInsets.symmetric(horizontal: 24),
                child: _OverlayCopy(
                  title: _pages[_index].headline,
                  subtitle: _pages[_index].subhead,
                ),
              ),
            ),

          // Dots indicator (just above bottom card like screenshot)
          Positioned(
            left: 0,
            right: 0,
            bottom: _isRoleSelect ? 330 : 310,
            child: Center(
              child: _DotsIndicator(
                count: _pages.length,
                index: _index,
              ),
            ),
          ),

          // Bottom rounded card
          Align(
            alignment: Alignment.bottomCenter,
            child: _BottomCard(
              mode: _pages[_index].mode,
              welcomeTitle: _pages[0].headline,
              welcomeSubtitle: _pages[0].subhead,
              onFamilySelected: widget.onFamilySelected,
              onBabysitterSelected: widget.onBabysitterSelected,
              onGetStarted: widget.onGetStarted,
              onLogIn: widget.onLogIn,
              onLookingForJobs: widget.onLookingForJobs,
            ),
          ),
        ],
      ),
    );
  }
}

class _ImagePage extends StatelessWidget {
  const _ImagePage({
    required this.imageAsset,
    required this.showDarkOverlay,
  });

  final String imageAsset;
  final bool showDarkOverlay;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            imageAsset,
            fit: BoxFit.cover,
          ),
        ),

        // Bottom gradient to match Figma screenshot readability
        if (showDarkOverlay)
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.55),
                  ],
                  stops: const [0.45, 1.0],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _OverlayCopy extends StatelessWidget {
  const _OverlayCopy({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w800,
            height: 1.12,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withOpacity(0.92),
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
            height: 1.35,
          ),
        ),
      ],
    );
  }
}

class _BottomCard extends StatelessWidget {
  const _BottomCard({
    required this.mode,
    required this.welcomeTitle,
    required this.welcomeSubtitle,
    required this.onFamilySelected,
    required this.onBabysitterSelected,
    required this.onGetStarted,
    required this.onLogIn,
    required this.onLookingForJobs,
  });

  final _OnboardMode mode;
  final String welcomeTitle;
  final String welcomeSubtitle;

  final VoidCallback onFamilySelected;
  final VoidCallback onBabysitterSelected;
  final VoidCallback onGetStarted;
  final VoidCallback onLogIn;
  final VoidCallback onLookingForJobs;

  @override
  Widget build(BuildContext context) {
    final isRole = mode == _OnboardMode.roleSelect;

    return SafeArea(
      top: false,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(22),
            topRight: Radius.circular(22),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: isRole
            ? _RoleSelectContent(
                title: welcomeTitle,
                subtitle: welcomeSubtitle,
                onFamilySelected: onFamilySelected,
                onBabysitterSelected: onBabysitterSelected,
              )
            : _CtaContent(
                onGetStarted: onGetStarted,
                onLogIn: onLogIn,
                onLookingForJobs: onLookingForJobs,
              ),
      ),
    );
  }
}

class _RoleSelectContent extends StatelessWidget {
  const _RoleSelectContent({
    required this.title,
    required this.subtitle,
    required this.onFamilySelected,
    required this.onBabysitterSelected,
  });

  final String title;
  final String subtitle;

  final VoidCallback onFamilySelected;
  final VoidCallback onBabysitterSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12.8,
            color: AppColors.textMuted,
            height: 1.35,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'Select Your Role',
          style: TextStyle(
            fontSize: 12.5,
            color: AppColors.textMuted,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _RoleButton(
                label: 'Family',
                onTap: onFamilySelected,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _RoleButton(
                label: 'Babysitter',
                onTap: onBabysitterSelected,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _RoleButton extends StatelessWidget {
  const _RoleButton({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Matches the small, soft-blue rounded rectangles in the screenshot
    return SizedBox(
      height: 46,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.primarySoft,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w700,
          ),
        ),
        child: Text(label),
      ),
    );
  }
}

class _CtaContent extends StatelessWidget {
  const _CtaContent({
    required this.onGetStarted,
    required this.onLogIn,
    required this.onLookingForJobs,
  });

  final VoidCallback onGetStarted;
  final VoidCallback onLogIn;
  final VoidCallback onLookingForJobs;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _PrimaryWideButton(
          label: 'Get Started',
          onTap: onGetStarted,
        ),
        const SizedBox(height: 12),
        _OutlineWideButton(
          label: 'Log In',
          onTap: onLogIn,
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: onLookingForJobs,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text(
              'Looking for Jobs as a Sitter',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 12.2,
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PrimaryWideButton extends StatelessWidget {
  const _PrimaryWideButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primarySoft,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        child: Text(label),
      ),
    );
  }
}

class _OutlineWideButton extends StatelessWidget {
  const _OutlineWideButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        child: Text(label),
      ),
    );
  }
}

class _DotsIndicator extends StatelessWidget {
  const _DotsIndicator({
    required this.count,
    required this.index,
  });

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (i) {
        final isActive = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          height: 6,
          width: isActive ? 18 : 6,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(99),
          ),
        );
      }),
    );
  }
}

enum _OnboardMode { roleSelect, cta }

class _OnboardPage {
  const _OnboardPage({
    required this.imageAsset,
    required this.headline,
    required this.subhead,
    required this.mode,
  });

  final String imageAsset;
  final String headline;
  final String subhead;
  final _OnboardMode mode;
}
