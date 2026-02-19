import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../../../common/widgets/primary_action_button.dart';
import '../../providers/sitter_profile_setup_providers.dart';
import '../../widgets/onboarding_header.dart';
import '../../widgets/step_progress_dots.dart';
import '../../sitter_profile_constants.dart';

class Step7Availability extends ConsumerStatefulWidget {
  final VoidCallback onFinish;
  final VoidCallback onBack;

  const Step7Availability({
    super.key,
    required this.onFinish,
    required this.onBack,
  });

  @override
  ConsumerState<Step7Availability> createState() => _Step7AvailabilityState();
}

class _Step7AvailabilityState extends ConsumerState<Step7Availability> {
  static const _textDark = Color(0xFF1A1A1A);
  static const _primaryBlue = AppColors.primary;
  static const _greyText = Color(0xFF667085);

  final DateFormat _dateFormat = DateFormat('MM/dd/yyyy');

  Future<void> _pickDate({bool isStart = true, bool isRange = false}) async {
    final now = DateTime.now();
    final result = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: _primaryBlue),
          ),
          child: child!,
        );
      },
    );

    if (result != null) {
      final notifier = ref.read(sitterProfileSetupControllerProvider.notifier);
      if (isRange) {
        if (isStart) {
          notifier.updateDateRange(start: result);
        } else {
          notifier.updateDateRange(end: result);
        }
      } else {
        notifier.updateSingleDate(result);
      }
    }
  }

  Future<void> _pickTime({required bool isStart}) async {
    final result = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: _primaryBlue),
          ),
          child: child!,
        );
      },
    );

    if (result != null) {
      final notifier = ref.read(sitterProfileSetupControllerProvider.notifier);
      if (isStart) {
        notifier.updateTime(start: result);
      } else {
        notifier.updateTime(end: result);
      }
    }
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return '';
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('h:mm a').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sitterProfileSetupControllerProvider);
    final isSingle = state.availabilityMode == AvailabilityMode.singleDay;

    return Scaffold(
      backgroundColor: AppColors.surfaceTint,
      appBar: OnboardingHeader(
        currentStep: 7,
        totalSteps: kSitterProfileTotalSteps,
        onBack: widget.onBack,
      ),
      body: Column(
        children: [
          const StepProgressDots(
              currentStep: 7, totalSteps: kSitterProfileTotalSteps),
          Expanded(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon Tile
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceTint,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.calendar_month_outlined,
                        size: 32, color: _primaryBlue),
                  ),
                  const SizedBox(height: 24),

                  // Title & Description
                  const Text(
                    'Availability Settings',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: _textDark,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Update your available days and times by highlighting blocks of dates. Your Availability is Mandatory.',
                    style: TextStyle(
                      fontSize: 14,
                      color: _greyText,
                      fontFamily: 'Inter',
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Segmented Toggle
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => ref
                                .read(sitterProfileSetupControllerProvider
                                    .notifier)
                                .setAvailabilityMode(
                                    AvailabilityMode.singleDay),
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: isSingle
                                    ? AppColors.surfaceTint
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Single Day',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: isSingle
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                  color: isSingle ? _textDark : _greyText,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => ref
                                .read(sitterProfileSetupControllerProvider
                                    .notifier)
                                .setAvailabilityMode(
                                    AvailabilityMode.multipleDays),
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: !isSingle
                                    ? AppColors.surfaceTint
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Multiple Days',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: !isSingle
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                  color: !isSingle ? _textDark : _greyText,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Date Inputs
                  if (isSingle) ...[
                    // Single Date
                    _DateField(
                      label: 'Date',
                      text: state.singleDate != null
                          ? _dateFormat.format(state.singleDate!)
                          : 'Select Date',
                      onTap: () => _pickDate(isRange: false),
                    ),
                  ] else ...[
                    // Date Range
                    Row(
                      children: [
                        const Text('Date',
                            style: TextStyle(
                                color: _greyText, fontWeight: FontWeight.w500)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _DateField(
                            text: state.dateRangeStart != null
                                ? _dateFormat.format(state.dateRangeStart!)
                                : 'Start',
                            onTap: () =>
                                _pickDate(isRange: true, isStart: true),
                            hideLabel: true,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text('to', style: TextStyle(color: _greyText)),
                        ),
                        Expanded(
                          child: _DateField(
                            text: state.dateRangeEnd != null
                                ? _dateFormat.format(state.dateRangeEnd!)
                                : 'End',
                            onTap: () =>
                                _pickDate(isRange: true, isStart: false),
                            hideLabel: true,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 24),

                  // No Bookings Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'No Bookings for the Day',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: _textDark,
                          fontFamily: 'Inter',
                        ),
                      ),
                      Switch(
                        value: state.noBookings,
                        onChanged: (val) {
                          ref
                              .read(
                                  sitterProfileSetupControllerProvider.notifier)
                              .toggleNoBookings(val);
                        },
                        // Active State (ON)
                        activeThumbColor: Colors.white, // Thumb
                        activeTrackColor: _primaryBlue, // Track
                        // Inactive State (OFF)
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor:
                            const Color(0xFFEAECF0), // Light Grey
                        trackOutlineColor:
                            WidgetStateProperty.all(Colors.transparent),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Time Inputs
                  Opacity(
                    opacity: state.noBookings ? 0.5 : 1.0,
                    child: IgnorePointer(
                      ignoring: state.noBookings,
                      child: Row(
                        children: [
                          const Row(
                            children: [
                              Text('Time',
                                  style: TextStyle(
                                      color: _textDark,
                                      fontWeight: FontWeight.w500)),
                              SizedBox(width: 4),
                              Icon(Icons.info_outline,
                                  size: 16, color: _greyText),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _TimeField(
                              text: state.startTime != null
                                  ? _formatTime(state.startTime)
                                  : 'Start Time*',
                              onTap: () => _pickTime(isStart: true),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child:
                                Text('to', style: TextStyle(color: _greyText)),
                          ),
                          Expanded(
                            child: _TimeField(
                              text: state.endTime != null
                                  ? _formatTime(state.endTime)
                                  : 'End Time*',
                              onTap: () => _pickTime(isStart: false),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 100), // Bottom View Padding
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // Reset Logic
                    final notifier =
                        ref.read(sitterProfileSetupControllerProvider.notifier);
                    notifier.toggleNoBookings(false);
                    // Add more resets if needed
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                    side: const BorderSide(color: _primaryBlue),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.white,
                  ),
                  child: const Text('Reset',
                      style: TextStyle(
                        color: _greyText,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      )),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: PrimaryActionButton(
                  label: 'Save',
                  onPressed: widget.onFinish,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  final String label;
  final String text;
  final VoidCallback onTap;
  final bool hideLabel;

  const _DateField({
    this.label = '',
    required this.text,
    required this.onTap,
    this.hideLabel = false,
  });

  @override
  Widget build(BuildContext context) {
    if (hideLabel) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.transparent), // Flat feel
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const Icon(Icons.calendar_month_outlined,
                  size: 18, color: Color(0xFF98A2B3)),
            ],
          ),
        ),
      );
    }

    // Single Day Full Width with Label inside logic is not what design has.
    // Design has Date 14-08-2025 [Calendar]
    // The design shows the layout:
    // With Single Day: 14-08-2025 [Calendar] (Full width)
    // With Multiple Days: Label "Date" -> Start [Cal] to End [Cal]

    // So for Single Day, we just need the box.
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: const TextStyle(
                fontFamily: 'Inter',
                color: Color(0xFF1A1A1A),
                fontSize: 16,
              ),
            ),
            const Icon(Icons.calendar_month_outlined, color: Color(0xFF98A2B3)),
          ],
        ),
      ),
    );
  }
}

class _TimeField extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _TimeField({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.transparent),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                text,
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: text.contains('*')
                      ? const Color(0xFF98A2B3)
                      : const Color(0xFF1A1A1A),
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.access_time, size: 18, color: Color(0xFF98A2B3)),
          ],
        ),
      ),
    );
  }
}
