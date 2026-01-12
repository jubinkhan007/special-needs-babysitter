import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../common/widgets/primary_action_button.dart';
import '../../providers/sitter_profile_setup_providers.dart';
import '../../widgets/onboarding_header.dart';
import '../../widgets/step_progress_dots.dart';
import '../../widgets/profile_complete_dialog.dart';
import '../../sitter_profile_constants.dart';

class Step9ReviewProfile extends ConsumerStatefulWidget {
  final VoidCallback onFinish;
  final VoidCallback onBack;
  final Function(int step) onEditStep;

  const Step9ReviewProfile({
    super.key,
    required this.onFinish,
    required this.onBack,
    required this.onEditStep,
  });

  @override
  ConsumerState<Step9ReviewProfile> createState() => _Step9ReviewProfileState();
}

class _Step9ReviewProfileState extends ConsumerState<Step9ReviewProfile> {
  bool _isSubmitting = false;

  static const _textDark = Color(0xFF1A1A1A);
  static const _primaryBlue = Color(0xFF88CBE6);
  static const _darkChip = Color(0xFF1D2939); // Dark slate/black
  static const _greyText = Color(0xFF667085);
  static const _dividerColor = Color(0xFFEAECF0);

  Future<void> _handleSubmit() async {
    if (_isSubmitting) return;
    setState(() => _isSubmitting = true);

    try {
      final controller =
          ref.read(sitterProfileSetupControllerProvider.notifier);
      final repository = ref.read(sitterProfileRepositoryProvider);
      final success = await controller.submitSitterProfile(repository);

      if (!mounted) return;

      if (success) {
        await showProfileCompleteDialog(context);
        // Dialog handles navigation internally
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Failed to submit profile. Please try again.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sitterProfileSetupControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF3FAFD),
      appBar: OnboardingHeader(
        currentStep: 9,
        totalSteps: kSitterProfileTotalSteps,
        onBack: widget.onBack,
      ),
      body: Stack(
        children: [
          // Scrollable Content
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 160), // Space for button
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const StepProgressDots(
                    currentStep: 9, totalSteps: kSitterProfileTotalSteps),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      // Header: Review Your Profile + Avatar
                      const Text(
                        'Review Your Profile',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: _textDark,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Avatar
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.grey[200],
                            backgroundImage: state.profilePhotoPath != null
                                ? AssetImage(
                                    state.profilePhotoPath!) // Mock/Local
                                : const AssetImage(
                                    'assets/images/placeholder_avatar.png'),
                            // Ideally FileImage if local, but state stores string.
                            // Assuming path is local file system or asset for this exercise.
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () => widget.onEditStep(1),
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: _dividerColor),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    )
                                  ],
                                ),
                                child: const Icon(Icons.edit,
                                    size: 14, color: _greyText),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Section: Skills & Certifications
                      _buildSectionHeader('Skills & Certifications',
                          () => widget.onEditStep(6)),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ...state.certifications
                              .map((cert) => _buildDarkChip(cert)),
                          // Fallback if empty
                          if (state.certifications.isEmpty)
                            const Text('No certifications selected',
                                style: TextStyle(
                                    color: _greyText,
                                    fontStyle: FontStyle.italic)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                              fontSize: 14,
                              color: _greyText,
                              height: 1.5,
                              fontFamily: 'Inter'),
                          children: [
                            const TextSpan(
                                text: 'Experience: ',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: _textDark)),
                            TextSpan(
                                text:
                                    'I have ${(state.yearsExperience ?? "some").toLowerCase()} of experience. ${state.bio.length > 50 ? state.bio.substring(0, 50) + "..." : state.bio}'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Divider(color: _dividerColor, height: 1),
                      const SizedBox(height: 24),

                      // Section: Age Range Experience
                      const Text(
                        'Age Range Experience',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: _textDark,
                            fontFamily: 'Inter'),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: state.ageGroups.isNotEmpty
                            ? state.ageGroups
                                .map((age) => _buildLightTargetChip(age))
                                .toList()
                            : [
                                const Text('None selected',
                                    style: TextStyle(color: _greyText))
                              ],
                      ),
                      const SizedBox(height: 24),
                      const Divider(color: _dividerColor, height: 1),
                      const SizedBox(height: 24),

                      // Section: Availability Settings
                      const Text(
                        'Availability Settings',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: _textDark,
                            fontFamily: 'Inter'),
                      ),
                      const SizedBox(height: 16),
                      _buildCalendarLikeFigma(
                          onEdit: () =>
                              widget.onEditStep(7)), // 7 is Availability
                      const SizedBox(height: 24),
                      const Divider(color: _dividerColor, height: 1),
                      const SizedBox(height: 24),

                      // Section: Your Hourly Rate
                      _buildSectionHeader(
                          'Your Hourly Rate', () => widget.onEditStep(8)),
                      const SizedBox(height: 8),
                      Text(
                        '\$${state.hourlyRate.toStringAsFixed(0)} / hr',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: _textDark,
                            fontFamily: 'Inter'),
                      ),
                      const SizedBox(height: 24),
                      const Divider(color: _dividerColor, height: 1),
                      const SizedBox(height: 24),

                      // Section: Professional Information
                      _buildSectionHeader(
                          'Professional Information',
                          () => widget.onEditStep(
                              4)), // Edit goes to skills/bio general area? or Step 2? Step 2 has Bio.
                      const SizedBox(height: 12),
                      _buildLabelValue(
                          'Bio: ',
                          state.bio.isNotEmpty
                              ? state.bio
                              : 'No bio provided.'),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Skills: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: _textDark,
                                  fontSize: 14,
                                  fontFamily: 'Inter')),
                          Expanded(
                            child: Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: state.skills.isNotEmpty
                                  ? state.skills
                                      .map((s) => _buildSmallLightChip(s))
                                      .toList()
                                  : [
                                      const Text('None',
                                          style: TextStyle(
                                              color: _greyText, fontSize: 14))
                                    ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildLabelValue(
                          'Languages: ',
                          state.languages.isNotEmpty
                              ? state.languages.join(', ')
                              : 'English'),
                      const SizedBox(height: 12),
                      _buildLabelValue('Reliable Transportation: ',
                          state.hasReliableTransportation ? 'Yes' : 'No'),
                      if (state.transportationDetails != null &&
                          state.transportationDetails!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                                fontSize: 14,
                                color: _greyText,
                                height: 1.5,
                                fontFamily: 'Inter'),
                            children: [
                              const TextSpan(
                                  text: 'Reliable Transportation: ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: _textDark)),
                              TextSpan(text: state.transportationDetails),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Pinned Bottom Button
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: const Color(0xFFF3FAFD)
                  .withOpacity(0.9), // Slight transparency matching bg
              padding: const EdgeInsets.all(24.0),
              child: SafeArea(
                top: false,
                child: _isSubmitting
                    ? const SizedBox(
                        height: 56,
                        child: Center(
                          child: CircularProgressIndicator(
                              color: Color(0xFF88CBE6)),
                        ),
                      )
                    : PrimaryActionButton(
                        label: 'Submit',
                        onPressed: _handleSubmit,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onEdit) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: _textDark,
              fontFamily: 'Inter'),
        ),
        GestureDetector(
          onTap: onEdit,
          child: const Icon(Icons.edit, size: 20, color: _greyText),
        ),
      ],
    );
  }

  Widget _buildDarkChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _darkChip,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon placeholder - ideally mapped, but using generic for pixel match
          const Icon(Icons.verified_user_outlined,
              size: 14, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                fontFamily: 'Inter'),
          ),
        ],
      ),
    );
  }

  Widget _buildLightTargetChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _primaryBlue,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter'),
      ),
    );
  }

  Widget _buildSmallLightChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _primaryBlue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w500,
            fontFamily: 'Inter'),
      ),
    );
  }

  Widget _buildLabelValue(String label, String value) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
            fontSize: 14, color: _greyText, height: 1.5, fontFamily: 'Inter'),
        children: [
          TextSpan(
              text: label,
              style: const TextStyle(
                  fontWeight: FontWeight.w700, color: _textDark)),
          TextSpan(text: value),
        ],
      ),
    );
  }

  // Purely visual implementation of the calendar to match Figma
  Widget _buildCalendarLikeFigma({required VoidCallback onEdit}) {
    // Figma shows Aug 2025.
    // We will build the exact grid shown in the image roughly.
    // S M T W T F S
    // 26 27 28 29 30 31 1 ...
    // ...
    // 16 17 18 19 20 ... Green circles on 17, 18, 19, 20
    // 23 24 25 26 27 ... Red circles on 24, 25, 26, 27
    return Column(
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                icon: const Icon(Icons.chevron_left, color: _greyText),
                onPressed: () {}),
            Row(
              children: const [
                Text('Aug',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _textDark)),
                Icon(Icons.arrow_drop_down, color: _greyText),
              ],
            ),
            IconButton(
                icon: const Icon(Icons.chevron_right, color: _greyText),
                onPressed: () {}),
            const Spacer(),
            Row(
              children: const [
                Text('2025',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _textDark)),
                Icon(Icons.arrow_drop_down, color: _greyText),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Days Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
              .map((d) => Text(d,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, color: _textDark)))
              .toList(),
        ),
        const SizedBox(height: 12),
        // Grid - We'll manually build 5 rows to match the look
        _buildCalRow(['26', '27', '28', '29', '30', '31', '1'],
            [true, true, true, true, true, true, false]),
        _buildCalRow(['2', '3', '4', '5', '6', '7', '8'],
            [false, false, false, false, false, false, false]),
        _buildCalRow(['9', '10', '11', '12', '13', '14', '15'],
            [false, false, false, false, false, false, false]),
        _buildCalRow(['16', '17', '18', '19', '20', '21', '22'],
            [false, false, false, false, false, false, false],
            greenIndices: [1, 2, 3, 4]),
        _buildCalRow(['23', '24', '25', '26', '27', '28', '29'],
            [false, false, false, false, false, false, false],
            redIndices: [1, 2, 3, 4]),
        _buildCalRow(['30', '1', '2', '3', '4', '5', '6'],
            [false, true, true, true, true, true, true]),
      ],
    );
  }

  Widget _buildCalRow(List<String> days, List<bool> isGrey,
      {List<int> greenIndices = const [], List<int> redIndices = const []}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(7, (index) {
          final isGreen = greenIndices.contains(index);
          final isRed = redIndices.contains(index);
          final text = days[index];
          final grey = isGrey[index];

          BoxDecoration? decoration;
          if (isGreen) {
            decoration = BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.green, width: 1.5),
              color: Colors.green.withOpacity(0.1),
            );
          } else if (isRed) {
            decoration = BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.red, width: 1.5),
              color: Colors.red.withOpacity(0.1),
            );
          }

          return Container(
            width: 32,
            height: 32,
            decoration: decoration,
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(
                color: grey ? Colors.grey[300] : _textDark,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }),
      ),
    );
  }
}
