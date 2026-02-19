import 'package:core/core.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../../../common/widgets/primary_action_button.dart';
import '../../providers/sitter_profile_setup_providers.dart';
import '../../widgets/onboarding_header.dart';
import '../../widgets/step_progress_dots.dart';
import '../../widgets/profile_complete_dialog.dart';
import '../../sitter_profile_constants.dart';
import 'package:babysitter_app/src/common_widgets/app_toast.dart';

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
  static const _primaryBlue = AppColors.primary;
  static const _darkChip = AppColors.buttonDark; // Dark slate/black
  static const _greyText = Color(0xFF667085);
  static const _dividerColor = Color(0xFFEAECF0);

  Future<void> _handleSubmit() async {
    if (_isSubmitting) return;
    setState(() => _isSubmitting = true);

    try {
      final controller =
          ref.read(sitterProfileSetupControllerProvider.notifier);
      final repository = ref.read(sitterProfileRepositoryProvider);
      debugPrint('DEBUG UI: Step 9 Submit Button Tapped');
      final success = await controller.submitSitterProfile(repository);

      if (!mounted) return;

      if (success) {
        await showProfileCompleteDialog(context);
        // Dialog handles navigation internally
      } else {
        AppToast.show(context, 
          const SnackBar(
              content: Text('Failed to submit profile. Please try again.')),
        );
      }
    } catch (e) {
      if (mounted) {
        AppToast.show(context, 
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  /// Returns the appropriate ImageProvider for the profile photo.
  /// Uses FileImage for local file paths, AssetImage for assets.
  /// Returns null for missing paths - CircleAvatar will show child icon.
  ImageProvider? _getProfileImage(String? path) {
    if (path == null || path.isEmpty) {
      return null; // Let CircleAvatar use child icon
    }
    // Check if it's a local file path (starts with / or contains cache/data)
    if (path.startsWith('/') ||
        path.contains('cache') ||
        path.contains('data')) {
      final file = File(path);
      if (file.existsSync()) {
        return FileImage(file);
      }
      return null; // File doesn't exist
    }
    // Fallback to AssetImage if it looks like an asset path
    if (path.startsWith('assets/')) {
      return AssetImage(path);
    }
    // Default: return null
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sitterProfileSetupControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.surfaceTint,
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
                            backgroundImage:
                                _getProfileImage(state.profilePhotoPath),
                            child: state.profilePhotoPath == null ||
                                    state.profilePhotoPath!.isEmpty
                                ? const Icon(Icons.person,
                                    size: 40, color: Colors.grey)
                                : null,
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
                                      color: Colors.black.withValues(alpha: 0.1),
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
                                    'I have ${(state.yearsExperience ?? "some").toLowerCase()} of experience. ${state.bio.length > 50 ? "${state.bio.substring(0, 50)}..." : state.bio}'),
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
                      _buildCalendarLikeFigma(state,
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
                      const SizedBox(height: 32),
                      const Divider(color: _dividerColor, height: 1),
                      const SizedBox(height: 16),
                      const Text(
                        'Once submitted, your profile will be reviewed. You can still update your profile later from the Account section.',
                        style: TextStyle(
                          fontSize: 13,
                          color: _greyText,
                          height: 1.5,
                          fontFamily: 'Inter',
                        ),
                        textAlign: TextAlign.center,
                      ),
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
              color: AppColors.surfaceTint
                  .withValues(alpha: 0.9), // Slight transparency matching bg
              padding: const EdgeInsets.all(24.0),
              child: SafeArea(
                top: false,
                child: _isSubmitting
                    ? const SizedBox(
                        height: 56,
                        child: Center(
                          child: CircularProgressIndicator(
                              color: AppColors.primary),
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

  // Dynamic Calendar Implementation
  Widget _buildCalendarLikeFigma(SitterProfileState state,
      {required VoidCallback onEdit}) {
    // Determine which month to show
    DateTime targetDate = DateTime.now();
    if (state.singleDate != null) {
      targetDate = state.singleDate!;
    } else if (state.dateRangeStart != null) {
      targetDate = state.dateRangeStart!;
    }

    final monthName = DateFormat('MMMM').format(targetDate);
    final yearStr = DateFormat('yyyy').format(targetDate);

    // Calculate calendar days
    final daysInMonth = DateTime(targetDate.year, targetDate.month + 1, 0).day;
    final firstDayOfMonth = DateTime(targetDate.year, targetDate.month, 1);
    // Sunday = 7 in DateTime.weekday, but usually calendars show Sun as index 0.
    // Let's assume standard layout S M T W T F S
    // standard DateTime: Mon=1 ... Sun=7.
    // We want Sun=0, Mon=1...Sat=6.
    // So if weekday is 7 (Sun), index is 0. Else weekday.
    final firstWeekdayIndex =
        firstDayOfMonth.weekday == 7 ? 0 : firstDayOfMonth.weekday;

    // We need a list of strings for the grid cells, and bools for styling.
    // Total cells = padding + days. Round up to full weeks (rows).
    final totalCells = ((firstWeekdayIndex + daysInMonth) / 7).ceil() * 7;

    // Build days list
    // Use empty string for padding days
    List<String> dayLabels = [];
    List<DateTime?> cellDates = [];

    for (int i = 0; i < totalCells; i++) {
      if (i < firstWeekdayIndex || i >= firstWeekdayIndex + daysInMonth) {
        dayLabels.add('');
        cellDates.add(null);
      } else {
        final dayNum = i - firstWeekdayIndex + 1;
        dayLabels.add(dayNum.toString());
        cellDates.add(DateTime(targetDate.year, targetDate.month, dayNum));
      }
    }

    return Column(
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                icon: const Icon(Icons.chevron_left, color: _greyText),
                onPressed: () {
                  // In a real generic component, this would change month.
                  // Here we just static to the selected date's month for "best effort".
                }),
            Row(
              children: [
                Text(monthName,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _textDark)),
                const Icon(Icons.arrow_drop_down, color: _greyText),
              ],
            ),
            IconButton(
                icon: const Icon(Icons.chevron_right, color: _greyText),
                onPressed: () {}),
            const Spacer(),
            Row(
              children: [
                Text(yearStr,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _textDark)),
                const Icon(Icons.arrow_drop_down, color: _greyText),
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
        // Grid Rows
        ...List.generate((totalCells / 7).round(), (rowIndex) {
          final startIndex = rowIndex * 7;
          final rowDays = dayLabels.sublist(startIndex, startIndex + 7);
          final rowDates = cellDates.sublist(startIndex, startIndex + 7);

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (colIndex) {
                final text = rowDays[colIndex];
                final date = rowDates[colIndex];

                if (text.isEmpty || date == null) {
                  return const SizedBox(width: 32, height: 32);
                }

                // Determine highlighting
                bool isGreen = false;
                // bool isRed = false; // Add this if we had "unavailable" logic to show

                if (state.availabilityMode == AvailabilityMode.singleDay) {
                  if (state.singleDate != null &&
                      isSameDay(date, state.singleDate!)) {
                    isGreen = true;
                  }
                } else {
                  // Range
                  if (state.dateRangeStart != null &&
                      state.dateRangeEnd != null) {
                    // Check if date is within start and end (inclusive)
                    // Using isAtSameMomentAs to include start/end boundaries accurately
                    final start = DateTime(state.dateRangeStart!.year,
                        state.dateRangeStart!.month, state.dateRangeStart!.day);
                    final end = DateTime(state.dateRangeEnd!.year,
                        state.dateRangeEnd!.month, state.dateRangeEnd!.day);
                    // Normalize current cell date to midnight
                    final current = DateTime(date.year, date.month, date.day);

                    if ((current.isAfter(start) ||
                            current.isAtSameMomentAs(start)) &&
                        (current.isBefore(end) ||
                            current.isAtSameMomentAs(end))) {
                      isGreen = true;
                    }
                  }
                }

                BoxDecoration? decoration;
                if (isGreen) {
                  decoration = BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.green, width: 1.5),
                    color: Colors.green.withValues(alpha: 0.1),
                  );
                }

                return Container(
                  width: 32,
                  height: 32,
                  decoration: decoration,
                  alignment: Alignment.center,
                  child: Text(
                    text,
                    style: const TextStyle(
                      color: _textDark,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }),
            ),
          );
        }),
      ],
    );
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
