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
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../routing/routes.dart';

/// Onboarding slide data
class OnboardingSlide {
  final String imagePath;
  final String title;
  final String description;

  const OnboardingSlide({
    required this.imagePath,
    required this.title,
    required this.description,
  });
}

/// Onboarding screen with carousel
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  String? _selectedRole; // 'family' or 'babysitter'

  // Parent/Family onboarding slides
  static const List<OnboardingSlide> _parentSlides = [
    OnboardingSlide(
      imagePath: 'assets/onboarding_1.jpg',
      title: 'Welcome to Special\nNeeds Sitters',
      description:
          "We're here to support children with unique\nneeds — and the families who love them.",
    ),
    OnboardingSlide(
      imagePath: 'assets/onboarding_2.jpg',
      title: 'Specialized Care',
      description:
          'All caregivers are trained and experienced in\nworking with special needs children.',
    ),
    OnboardingSlide(
      imagePath: 'assets/onboarding_3.jpg',
      title: 'Verified & Trusted',
      description:
          'Rigorous background checks and caregiver\nreviews ensure your peace of mind.',
    ),
    OnboardingSlide(
      imagePath: 'assets/onboarding_4.jpg',
      title: 'No Subscriptions.\nJust Sitters.',
      description:
          'Book sitters when you need them — with no\ncommitments or monthly fees.',
    ),
  ];

  // Sitter/Babysitter onboarding slides
  static const List<OnboardingSlide> _sitterSlides = [
    OnboardingSlide(
      imagePath: 'assets/onboarding_1.jpg',
      title: 'Welcome to Special\nNeeds Sitters',
      description:
          "We're here to support children with unique\nneeds — and the families who love them.",
    ),
    OnboardingSlide(
      imagePath: 'assets/onboarding_2.jpg',
      title: 'Match with Families\nNeeding Your Skills.',
      description:
          'Families are looking for sitters like you — let\nyour skills open the right doors.',
    ),
    OnboardingSlide(
      imagePath: 'assets/onboarding_3.jpg',
      title: 'Empowering Families\nwith All Abilities',
      description:
          'Your skills make a difference — help families\nthrive with confidence.',
    ),
    OnboardingSlide(
      imagePath: 'assets/onboarding_4.jpg',
      title: "We've Got Your Back,\nSitter or Parent.",
      description: 'Here to care, here to connect — always\nwith you.',
    ),
    OnboardingSlide(
      imagePath: 'assets/onboarding_4.jpg',
      title: 'Specialized Care',
      description:
          'Quickly Connect with Families Who Need\nSpecialized Support',
    ),
  ];

  // Get slides based on selected role
  List<OnboardingSlide> get _slides {
    if (_selectedRole == 'sitter') {
      return _sitterSlides;
    }
    return _parentSlides;
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness
            .dark, // Dark icons for white background/light image parts?
// Actually, for full bleed images (Status bar over image), we usually want light icons if image is dark.
// Screen 1: Image top.
// Screen 2-5: Image full bleed.
// Let's stick to simple defaults for now.
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _goToSignUp() {
    final role = _selectedRole ?? 'parent'; // Default to parent if null
    print(
        'DEBUG OnboardingScreen: Navigating to SignUp with role=$role from selectedRole=$_selectedRole');
    context.go(
        Uri(path: Routes.signUp, queryParameters: {'role': role}).toString());
  }

  void _goToSignIn() {
    final role = _selectedRole ?? 'parent';
    context.go(
        Uri(path: Routes.signIn, queryParameters: {'role': role}).toString());
  }

  void _onBottomLinkTapped() {
    // If currently sitter, switch to parent. If parent, switch to sitter.
    final currentRole = _selectedRole ?? 'parent';
    final targetRole = currentRole == 'sitter' ? 'parent' : 'sitter';
    context.go(Uri(path: Routes.signUp, queryParameters: {'role': targetRole})
        .toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: _slides.length,
            itemBuilder: (context, index) {
              if (index == 0) {
                return _WelcomePage(
                  slide: _slides[index],
                  selectedRole: _selectedRole,
                  onFamilySelected: () {
                    setState(() => _selectedRole = 'parent');
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  onBabysitterSelected: () {
                    setState(() => _selectedRole = 'sitter');
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                );
              } else {
                return _FeaturePage(slide: _slides[index]);
              }
            },
          ),

          // Bottom Sheet / Controls Overlay
          if (_currentPage > 0)
            Positioned(
              bottom: 260,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _slides.length,
                  (index) => _PageIndicator(isActive: _currentPage == index),
                ),
              ),
            ),

          if (_currentPage > 0)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _BottomControlBar(
                onGetStarted: _goToSignUp,
                onLogin: _goToSignIn,
                onBottomLinkTapped: _onBottomLinkTapped, // Pass new callback
                bottomLinkText: _selectedRole == 'sitter'
                    ? "I'm looking for a sitter"
                    : 'Looking for Jobs as a Sitter',
              ),
            ),
        ],
      ),
    );
  }
}

class _WelcomePage extends StatelessWidget {
  final OnboardingSlide slide;
  final String? selectedRole;
  final VoidCallback onFamilySelected;
  final VoidCallback onBabysitterSelected;

  const _WelcomePage({
    required this.slide,
    required this.selectedRole,
    required this.onFamilySelected,
    required this.onBabysitterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
// Top Image Area
// Use Positioned to fill roughly top 65% of screen
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: MediaQuery.of(context).size.height * 0.65,
          child: Image.asset(
            slide.imagePath,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
        ),

// Bottom Content Area (White Card effect)
// ALign to bottom, occupying roughly 40% height.
// This naturally extends UP over the 65% image bottom boundary due to overlap logic if we just set height.
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.40,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    slide.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A3A4A), // Dark Text
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    slide.description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280), // Gray Text
                      height: 1.5,
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'Select Your Role',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _RoleButton(
                          label: 'Family',
                          isSelected: selectedRole != 'sitter',
                          onTap: onFamilySelected,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _RoleButton(
                          label: 'Babysitter',
                          isSelected: selectedRole == 'sitter',
                          onTap: onBabysitterSelected,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
// Small indicator line at very bottom?
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Pages 2-5: Feature Showcase
class _FeaturePage extends StatelessWidget {
  final OnboardingSlide slide;

  const _FeaturePage({required this.slide});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
// Full background image
        Image.asset(
          slide.imagePath,
          fit: BoxFit.cover,
        ),
// Gradient Overlay (Bottom Up)
// Design shows text sitting on the image, then a WHITE bottom sheet starts.
// Wait, the design for 2-5 shows:
// Image Top (~60%), White Card Bottom (~40%). It looks idential structurally to Screen 1!
// EXCEPT:
// - Screen 2,3,4: Title is on the IMAGE (White text), Description is on the IMAGE (White text).
// - Bottom White Card contains: "Get Started", "Log In", "Lookingfor jobs..."
// - Dots are on the IMAGE/Dark part?
// Let's re-examine image.
// Screen 2 (Specialized Care):
// White text "Specialized Care" + Description is overlaid on the dark bottom part of the IMAGE.
// THEN there is a White Card at the bottom with buttons.
// Indicators (dots) are between the text and the white card.
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  const Color(0xFF0D1B2A).withOpacity(0.0),
                  const Color(0xFF0D1B2A)
                      .withOpacity(0.8), // Darken bottom of image for text
                  const Color(
                      0xFF0D1B2A), // Solid dark at very bottom before white card?
                ],
                stops: const [0.0, 0.4, 0.7, 1.0],
              ),
            ),
          ),
        ),
// Content on Image
        Positioned(
          left: 24,
          right: 24,
          bottom: 290, // Push up above the white bottom sheet height
          child: Column(
            children: [
              Text(
                slide.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                slide.description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
// Dots placeholder handled by bottom bar or separate?
// The design shows dots ON the dark background, above the white card.
            ],
          ),
        ),
      ],
    );
  }
}

class _BottomControlBar extends StatelessWidget {
  final VoidCallback onGetStarted;
  final VoidCallback onLogin;
  final VoidCallback onBottomLinkTapped;
  final String bottomLinkText;

  const _BottomControlBar({
    required this.onGetStarted,
    required this.onLogin,
    required this.onBottomLinkTapped,
    required this.bottomLinkText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: onGetStarted,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF88C6E0),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(8), // Slightly squarer than 12?
                ),
              ),
              child: const Text(
                'Get Started',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton(
              onPressed: onLogin,
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF88C6E0), // Blue text
                side: const BorderSide(
                    color: Color(0xFFE5E7EB)), // Light gray border
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Log In'),
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: onBottomLinkTapped,
            child: Text(
              bottomLinkText,
              style: const TextStyle(
                decoration: TextDecoration.underline,
                fontSize: 12,
                color: Color(0xFF374151), // Dark gray
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoleButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF88C6E0)
              : const Color(0xFF88C6E0), // Design shows both blue?
// Wait, design Screen 1:
// Left button "Family" is Blue background, White text.
// Right button "Babysitter" is Blue background?
// Actually, in the first screenshot, "Family" is highlighted blue, "Babysitter" is same blue?
// Or maybe one is selected and other is unselected.
// Usually unselected is gray or outlined.
// Let's assume standard toggle behavior.
// But looking at the screenshot, "Family" is Solid Blue. "Babysitter" is Solid Blue.
// Both look identical. Maybe it's just two choices.
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

// Helper for Dots
class _PageIndicator extends StatelessWidget {
  final bool isActive;

  const _PageIndicator({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color:
            isActive ? const Color(0xFF88C6E0) : Colors.white24, // Cyan vs dim
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
