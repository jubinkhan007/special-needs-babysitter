// onboarding_screen.dart
//
// Fully responsive onboarding carousel matching the screenshot:
// - Fullscreen image carousel (PageView)
// - Title + subtitle overlay on pages 2..4
// - Dots indicator (active pill)
// - Bottom rounded white card with buttons (Get Started / Log In / Looking for Jobs as a Sitter)
// - Page 1 shows role selection inside the bottom card (Family / Babysitter)
//
// Uses flutter_screenutil for responsive sizing across all devices.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        statusBarIconBrightness: Brightness.dark,
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
    final role = _selectedRole ?? 'parent';
    final from = GoRouterState.of(context).uri.queryParameters['from'];
    
    final params = {'role': role};
    if (from != null) {
      params['from'] = from;
    }

    context.go(Uri(path: Routes.signUp, queryParameters: params).toString());
  }

  void _goToSignIn() {
    final role = _selectedRole ?? 'parent';
    final from = GoRouterState.of(context).uri.queryParameters['from'];
    
    final params = {'role': role};
    if (from != null) {
      params['from'] = from;
    }

    context.go(Uri(path: Routes.signIn, queryParameters: params).toString());
  }

  void _onBottomLinkTapped() {
    final currentRole = _selectedRole ?? 'parent';
    final targetRole = currentRole == 'sitter' ? 'parent' : 'sitter';
    
    final from = GoRouterState.of(context).uri.queryParameters['from'];
    final params = {'role': targetRole};
    if (from != null) {
      params['from'] = from;
    }

    context.go(Uri(path: Routes.signUp, queryParameters: params).toString());
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

          // Page indicators (dots)
          if (_currentPage > 0)
            Positioned(
              bottom: 260.h,
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

          // Bottom control bar
          if (_currentPage > 0)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _BottomControlBar(
                onGetStarted: _goToSignUp,
                onLogin: _goToSignIn,
                onBottomLinkTapped: _onBottomLinkTapped,
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

/// Welcome Page (Page 1) with role selection
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
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Responsive calculations based on screen size
    final imageHeight = screenHeight * 0.58;
    final cardHeight = screenHeight * 0.45;
    
    return Stack(
      children: [
        // Top Image Area
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: imageHeight,
          child: Image.asset(
            slide.imagePath,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
        ),

        // Bottom Content Area (White Card)
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: cardHeight,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32.r),
                topRight: Radius.circular(32.r),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: IntrinsicHeight(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Title
                              Text(
                                slide.title,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF1A3A4A),
                                  height: 1.2,
                                ),
                              ),
                              SizedBox(height: 12.h),
                              
                              // Description
                              Text(
                                slide.description,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: const Color(0xFF6B7280),
                                  height: 1.5,
                                ),
                              ),
                              
                              const Spacer(),
                              
                              // Role selection label
                              Text(
                                'Select Your Role',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF9CA3AF),
                                ),
                              ),
                              SizedBox(height: 16.h),
                              
                              // Role buttons row
                              Row(
                                children: [
                                  Expanded(
                                    child: _RoleButton(
                                      label: 'Family',
                                      isSelected: selectedRole != 'sitter',
                                      onTap: onFamilySelected,
                                    ),
                                  ),
                                  SizedBox(width: 16.w),
                                  Expanded(
                                    child: _RoleButton(
                                      label: 'Babysitter',
                                      isSelected: selectedRole == 'sitter',
                                      onTap: onBabysitterSelected,
                                    ),
                                  ),
                                ],
                              ),
                              
                              SizedBox(height: 16.h),
                              
                              // Bottom indicator line
                              Container(
                                width: 40.w,
                                height: 4.h,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(2.r),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Feature Pages (Pages 2-5)
class _FeaturePage extends StatelessWidget {
  final OnboardingSlide slide;

  const _FeaturePage({required this.slide});

  @override
  Widget build(BuildContext context) {
    final bottomSheetHeight = 260.h; // Approximate height of bottom area
    
    return Stack(
      fit: StackFit.expand,
      children: [
        // Full background image
        Image.asset(
          slide.imagePath,
          fit: BoxFit.cover,
        ),
        
        // Gradient Overlay
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  const Color(0xFF0D1B2A).withValues(alpha: 0.0),
                  const Color(0xFF0D1B2A).withValues(alpha: 0.8),
                  const Color(0xFF0D1B2A),
                ],
                stops: const [0.0, 0.4, 0.65, 0.9],
              ),
            ),
          ),
        ),
        
        // Content on Image - positioned above bottom area
        SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.only(
              left: 24.w,
              right: 24.w,
              bottom: bottomSheetHeight + 20.h,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  slide.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  slide.description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white70,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Bottom control bar for pages 2-5
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
    // SafeArea handles bottom padding automatically
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32.r),
          topRight: Radius.circular(32.r),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Get Started button
            SizedBox(
              width: double.infinity,
              height: 56.h,
              child: ElevatedButton(
                onPressed: onGetStarted,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF88C6E0),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'Get Started',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    height: 1.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            
            // Log In button
            SizedBox(
              width: double.infinity,
              height: 56.h,
              child: OutlinedButton(
                onPressed: onLogin,
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF88C6E0),
                  side: const BorderSide(color: Color(0xFFE5E7EB)),
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'Log In',
                  style: TextStyle(
                    fontSize: 16.sp,
                    height: 1.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            
            // Bottom link
            GestureDetector(
              onTap: onBottomLinkTapped,
              child: Text(
                bottomLinkText,
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 12.sp,
                  color: const Color(0xFF374151),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 8.h),
            
            // Bottom indicator line
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Role selection button
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
        height: 48.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF88C6E0)
              : const Color(0xFFD1E8F2),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF1A3A4A),
          ),
        ),
      ),
    );
  }
}

/// Page indicator dots
class _PageIndicator extends StatelessWidget {
  final bool isActive;

  const _PageIndicator({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      width: isActive ? 24.w : 8.w,
      height: 8.h,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF88C6E0) : Colors.white24,
        borderRadius: BorderRadius.circular(4.r),
      ),
    );
  }
}
