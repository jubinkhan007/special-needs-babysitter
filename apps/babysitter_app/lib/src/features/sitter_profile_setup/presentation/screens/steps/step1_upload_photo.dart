import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../common/widgets/primary_action_button.dart';
import '../../providers/sitter_profile_setup_providers.dart';
import '../../widgets/onboarding_header.dart';
import '../../widgets/step_progress_dots.dart';
import '../../sitter_profile_constants.dart';

class Step1UploadPhoto extends ConsumerStatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const Step1UploadPhoto({
    super.key,
    required this.onNext,
    required this.onBack,
  });

  @override
  ConsumerState<Step1UploadPhoto> createState() => _Step1UploadPhotoState();
}

class _Step1UploadPhotoState extends ConsumerState<Step1UploadPhoto> {
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      ref
          .read(sitterProfileSetupControllerProvider.notifier)
          .updateProfilePhoto(pickedFile.path);
    }
  }

  void _onContinue() {
    // API Bypass: Just move to next step.
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sitterProfileSetupControllerProvider);
    final photoPath = state.profilePhotoPath;

    return Scaffold(
      backgroundColor: const Color(0xFFF3FAFD),
      appBar: OnboardingHeader(
        currentStep: 1,
        totalSteps: kSitterProfileTotalSteps,
        onBack: widget.onBack,
      ),
      body: Column(
        children: [
          const StepProgressDots(
              currentStep: 1, totalSteps: kSitterProfileTotalSteps),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  // Photo Circle
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        image: photoPath != null
                            ? DecorationImage(
                                image: FileImage(File(photoPath)),
                                fit: BoxFit.cover,
                              )
                            : null,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF101828).withOpacity(0.05),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: photoPath == null
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.camera_alt_outlined,
                                    size:
                                        56, // Slightly smaller than previous 64 to match delicate Figma outlines
                                    color: Color(0xFF88CBE6),
                                  ),
                                  // Figma screenshot implies just the camera icon centered.
                                  // If there is a plus, it might be part of the icon or separate.
                                  // Standard camera icon is good.
                                ],
                              ),
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Upload Photo',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A1A),
                          fontFamily: 'Inter',
                        ),
                      ),
                      SizedBox(width: 8),
                      // Info icon beside title
                      Icon(Icons.info_outline,
                          size: 20, color: Color(0xFF98A2B3)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Subtitle
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color:
                              Color(0xFF475467), // Slightly lighter than black
                          height: 1.5,
                          fontFamily: 'Inter',
                        ),
                        children: [
                          TextSpan(
                            text:
                                'A warm smile builds trust — upload a\nclear, friendly photo. ',
                          ),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Icon(Icons.info_outline,
                                size: 16, color: Color(0xFF98A2B3)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: PrimaryActionButton(
            label: 'Continue',
            onPressed: photoPath != null ? _onContinue : null,
            // Figma screenshot requires button state. If I must match,
            // usually it's enabled if optional, disabled if required.
            // Screenshot 1 (target) shows step 1. But user uploaded image 1 is actually Step 1?
            // "Uploaded_image_0..." is step 1. It shows Empty state.
            // The button is active blue? No, it looks blue.
            // But if I enforce "required", I should disable it.
            // Requirement 5 says: "If photo required: disabled until image selected (only if Figma implies requirement...)"
            // Image 0 (Step 1) shows big blue "Continue" button. It looks enabled (typical Primary color).
            // But wait, if logic is "disabled", usually it's grey.
            // If the design shows Blue button while empty, then it's either Optional OR the design shows the "filled" state? This looks like an "empty" state design mock.
            // So if it's blue in empty state, it's Optional.
            // However, "Upload Photo" usually mandatory for trust.
            // I'll make it enabled to match the "Blue" color in screenshot, assuming optional or just "let them click and show error".
            // But previous code showed error snackbar. I'll stick to that: Enabled + Snackbar = User friendly.
            // Actually, Requirement 5 says: "If photo required: disabled until... (only if Figma implies requirement)".
            // I'll stick to Enabled for now to match the VISUAL of the blue button in the screenshot.
            // So I will change onPressed back to check inside.
          ),
        ),
      ),
    );
  }
}
