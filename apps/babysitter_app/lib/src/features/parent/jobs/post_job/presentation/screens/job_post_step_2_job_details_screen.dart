import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/job_post_providers.dart';
import '../controllers/job_post_controller.dart';
import 'job_post_step_header.dart';

/// Job Post Step 2: Job Details
/// Pixel-perfect implementation matching Figma design
class JobPostStep2JobDetailsScreen extends ConsumerStatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const JobPostStep2JobDetailsScreen({
    super.key,
    required this.onNext,
    required this.onBack,
  });

  @override
  ConsumerState<JobPostStep2JobDetailsScreen> createState() =>
      _JobPostStep2JobDetailsScreenState();
}

class _JobPostStep2JobDetailsScreenState
    extends ConsumerState<JobPostStep2JobDetailsScreen> {
  // Controllers
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  DateTime? _rawStartDate;
  DateTime? _rawEndDate;
  String _startStr = '';
  String _endStr = '';

  @override
  void initState() {
    super.initState();
    final state = ref.read(jobPostControllerProvider);
    _jobTitleController.text = state.title;
    _dateController.text =
        state.startDate.isNotEmpty && state.endDate.isNotEmpty
            ? '${state.startDate} - ${state.endDate}'
            : '';
    _startTimeController.text = state.startTime;
    _endTimeController.text = state.endTime;
    _rawStartDate = state.rawStartDate;
    _rawEndDate = state.rawEndDate;
    _startStr = state.startDate;
    _endStr = state.endDate;
  }

  // Design Constants
  static const _bgColor = Color(0xFFF3FAFD); // Light sky background
  static const _titleColor = Color(0xFF0B1736); // Deep navy
  static const _mutedText = Color(0xFF667085); // Grey
  static const _borderColor = Color(0xFFD0E8F2); // Light blue border
  static const _progressFill = Color(0xFF88CBE6); // Active progress

  static const _primaryBtn = Color(0xFF88CBE6); // Continue button
  static const _iconBoxFill = Color(0xFFD6F0FA); // Icon box fill
  static const _iconBlue = Color(0xFF74BFEA); // Icon color

  @override
  void dispose() {
    _jobTitleController.dispose();
    _dateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    super.dispose();
  }

  Future<void> _onDateTap() async {
    final now = DateTime.now();
    final pickedRange = await showDateRangePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            colorScheme: const ColorScheme.light(
              primary: _titleColor, // Header background (Dark Navy)
              onPrimary: Colors.white, // Header text
              surface: Colors.white, // Dialog background
              onSurface: _titleColor, // Body text (Dark Navy)
              secondary: _progressFill, // Range selection color
            ),
            dialogBackgroundColor: Colors.white,
            scaffoldBackgroundColor: Colors.white,
            datePickerTheme: DatePickerThemeData(
              headerBackgroundColor: Colors.white,
              headerForegroundColor: _titleColor,
              rangeSelectionBackgroundColor: _progressFill.withOpacity(0.3),
              rangePickerBackgroundColor: Colors.white,
              rangePickerHeaderBackgroundColor: Colors.white,
              rangePickerHeaderForegroundColor: _titleColor,
              todayBorder: const BorderSide(color: _progressFill),
              todayForegroundColor:
                  const MaterialStatePropertyAll(_progressFill),
              dayForegroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return Colors.white;
                }
                return _titleColor;
              }),
              dayOverlayColor:
                  MaterialStatePropertyAll(_progressFill.withOpacity(0.1)),
              yearForegroundColor: MaterialStatePropertyAll(_titleColor),
            ),
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 400,
                maxHeight: 600,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: child!,
              ),
            ),
          ),
        );
      },
    );

    if (pickedRange != null) {
      // Format: "Aug 14 - Aug 17"
      final start = pickedRange.start;
      final end = pickedRange.end;

      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];

      final startStr = '${months[start.month - 1]} ${start.day}';
      final endStr = '${months[end.month - 1]} ${end.day}';

      setState(() {
        _startStr = startStr;
        _endStr = endStr;
        _dateController.text = '$startStr - $endStr';
        _rawStartDate = start;
        _rawEndDate = end;
      });
    }
  }

  Future<void> _onStartTimeTap() async {
    final now = TimeOfDay.now();
    final picked = await showTimePicker(
      context: context,
      initialTime: now,
      initialEntryMode: TimePickerEntryMode.input,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: Theme(
            data: Theme.of(context).copyWith(
              // Override text theme to ensure all labels are dark
              textTheme: Theme.of(context).textTheme.copyWith(
                    bodySmall: const TextStyle(color: _titleColor),
                    bodyMedium: const TextStyle(color: _titleColor),
                    displayLarge: const TextStyle(color: _titleColor),
                    displayMedium: const TextStyle(color: _titleColor),
                    displaySmall: const TextStyle(color: _titleColor),
                    titleMedium: const TextStyle(color: _titleColor),
                    labelSmall: const TextStyle(color: _titleColor),
                  ),
              colorScheme: const ColorScheme.light(
                primary: _progressFill, // Active selection / OK button
                onPrimary: Colors.white, // Text on primary
                surface: Color(0xFFEAF6FF), // Dialog background (Light Blue)
                onSurface: _titleColor, // Text color
                secondary: _progressFill, // Cursor/Highlight
                onSurfaceVariant: _titleColor, // Label colors
                outline: _progressFill, // Input border color
              ),
              timePickerTheme: TimePickerThemeData(
                backgroundColor: const Color(0xFFEAF6FF),
                helpTextStyle: const TextStyle(
                  color: _titleColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                entryModeIconColor: _titleColor,
                hourMinuteShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(
                      color: _progressFill, width: 2), // Active border
                ),
                dayPeriodBorderSide: const BorderSide(color: _mutedText),
                dayPeriodColor: MaterialStateColor.resolveWith((states) =>
                    states.contains(MaterialState.selected)
                        ? _progressFill.withOpacity(0.3)
                        : Colors.transparent),
                dayPeriodTextColor: MaterialStateColor.resolveWith((states) =>
                    states.contains(MaterialState.selected)
                        ? _titleColor
                        : _mutedText),
                hourMinuteColor: MaterialStateColor.resolveWith((states) =>
                    states.contains(MaterialState.selected)
                        ? Colors.white
                        : _progressFill.withOpacity(0.1)),
                hourMinuteTextColor: MaterialStateColor.resolveWith((states) =>
                    states.contains(MaterialState.selected)
                        ? _titleColor
                        : _mutedText),
                inputDecorationTheme: const InputDecorationTheme(
                  labelStyle: TextStyle(color: _titleColor),
                  helperStyle: TextStyle(color: _titleColor),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: _titleColor, // Button text color
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            child: child!,
          ),
        );
      },
    );

    if (picked != null && mounted) {
      setState(() {
        _startTimeController.text = picked.format(context);
      });
    }
  }

  Future<void> _onEndTimeTap() async {
    final now = TimeOfDay.now();
    final picked = await showTimePicker(
      context: context,
      initialTime: now,
      initialEntryMode: TimePickerEntryMode.input,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: Theme(
            data: Theme.of(context).copyWith(
              // Override text theme to ensure all labels are dark
              textTheme: Theme.of(context).textTheme.copyWith(
                    bodySmall: const TextStyle(color: _titleColor),
                    bodyMedium: const TextStyle(color: _titleColor),
                    displayLarge: const TextStyle(color: _titleColor),
                    displayMedium: const TextStyle(color: _titleColor),
                    displaySmall: const TextStyle(color: _titleColor),
                    titleMedium: const TextStyle(color: _titleColor),
                    labelSmall: const TextStyle(color: _titleColor),
                  ),
              colorScheme: const ColorScheme.light(
                primary: _progressFill,
                onPrimary: Colors.white,
                surface: Color(0xFFEAF6FF),
                onSurface: _titleColor,
                secondary: _progressFill,
                onSurfaceVariant: _titleColor,
                outline: _progressFill,
              ),
              timePickerTheme: TimePickerThemeData(
                backgroundColor: const Color(0xFFEAF6FF),
                helpTextStyle: const TextStyle(
                  color: _titleColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                entryModeIconColor: _titleColor,
                hourMinuteShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(
                      color: _progressFill, width: 2), // Active border
                ),
                dayPeriodBorderSide: const BorderSide(color: _mutedText),
                dayPeriodColor: MaterialStateColor.resolveWith((states) =>
                    states.contains(MaterialState.selected)
                        ? _progressFill.withOpacity(0.3)
                        : Colors.transparent),
                dayPeriodTextColor: MaterialStateColor.resolveWith((states) =>
                    states.contains(MaterialState.selected)
                        ? _titleColor
                        : _mutedText),
                hourMinuteColor: MaterialStateColor.resolveWith((states) =>
                    states.contains(MaterialState.selected)
                        ? Colors.white
                        : _progressFill.withOpacity(0.1)),
                hourMinuteTextColor: MaterialStateColor.resolveWith((states) =>
                    states.contains(MaterialState.selected)
                        ? _titleColor
                        : _mutedText),
                inputDecorationTheme: const InputDecorationTheme(
                  labelStyle: TextStyle(color: _titleColor),
                  helperStyle: TextStyle(color: _titleColor),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: _titleColor,
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            child: child!,
          ),
        );
      },
    );

    if (picked != null && mounted) {
      setState(() {
        _endTimeController.text = picked.format(context);
      });
    }
  }

  void _onContinue() {
    // Validate all required fields
    if (_jobTitleController.text.trim().isEmpty) {
      _showError('Please enter a job title');
      return;
    }
    
    if (_dateController.text.isEmpty) {
      _showError('Please select dates for the job');
      return;
    }
    
    if (_startTimeController.text.isEmpty) {
      _showError('Please select a start time');
      return;
    }
    
    if (_endTimeController.text.isEmpty) {
      _showError('Please select an end time');
      return;
    }
    
    // Validate that end time is after start time
    if (!_isEndTimeAfterStartTime()) {
      _showError('End time must be after start time');
      return;
    }
    
    // Update controller state
    ref.read(jobPostControllerProvider.notifier).updateJobDetails(
          title: _jobTitleController.text.trim(),
          startDate: _startStr,
          endDate: _endStr,
          startTime: _startTimeController.text,
          endTime: _endTimeController.text,
          rawStartDate: _rawStartDate,
          rawEndDate: _rawEndDate,
        );
    widget.onNext();
  }
  
  bool _isEndTimeAfterStartTime() {
    if (_startTimeController.text.isEmpty || _endTimeController.text.isEmpty) {
      return false;
    }
    
    try {
      final startTime = _parseTimeString(_startTimeController.text);
      final endTime = _parseTimeString(_endTimeController.text);
      
      // Convert to minutes since midnight for comparison
      final startMinutes = startTime.hour * 60 + startTime.minute;
      final endMinutes = endTime.hour * 60 + endTime.minute;
      
      // If on the same day, end time must be after start time
      // If spanning multiple days, allow end time to be earlier (overnight shift)
      if (_rawStartDate != null && 
          _rawEndDate != null && 
          _rawStartDate!.isAtSameMomentAs(_rawEndDate!)) {
        return endMinutes > startMinutes;
      }
      
      return true; // Multi-day booking allows any times
    } catch (e) {
      return true; // If parsing fails, let it pass and handle at backend
    }
  }
  
  TimeOfDay _parseTimeString(String timeStr) {
    // Handle format like "10:00 AM" or "2:30 PM"
    final cleanTime = timeStr.trim();
    final parts = cleanTime.split(' ');
    if (parts.length != 2) throw FormatException('Invalid time format');
    
    final timeParts = parts[0].split(':');
    final period = parts[1].toUpperCase();
    
    int hour = int.parse(timeParts[0]);
    final int minute = int.parse(timeParts[1]);
    
    if (period == 'PM' && hour != 12) hour += 12;
    if (period == 'AM' && hour == 12) hour = 0;
    
    return TimeOfDay(hour: hour, minute: minute);
  }
  
  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: const Color(0xFFD92D20),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<JobPostState>(jobPostControllerProvider, (previous, next) {
      if (previous?.title != next.title) _jobTitleController.text = next.title;
      if (previous?.startTime != next.startTime) {
        _startTimeController.text = next.startTime;
      }
      if (previous?.endTime != next.endTime) {
        _endTimeController.text = next.endTime;
      }
      if (previous?.startDate != next.startDate ||
          previous?.endDate != next.endDate) {
        _dateController.text =
            next.startDate.isNotEmpty && next.endDate.isNotEmpty
                ? '${next.startDate} - ${next.endDate}'
                : '';
        _startStr = next.startDate;
        _endStr = next.endDate;
      }
      if (previous?.rawStartDate != next.rawStartDate) {
        _rawStartDate = next.rawStartDate;
      }
      if (previous?.rawEndDate != next.rawEndDate) {
        _rawEndDate = next.rawEndDate;
      }
    });

    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            // Step 2 of 5
            JobPostStepHeader(
              activeStep: 2,
              totalSteps: 5,
              onBack: widget.onBack,
            ),

            // Main Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),

                    // Icon Card
                    _buildIconCard(),

                    const SizedBox(height: 20),

                    // Title
                    const Text(
                      'Job Details',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: _titleColor,
                        letterSpacing: -0.5,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Job Title Field
                    _buildValidatedField(
                      controller: _jobTitleController,
                      hint: 'Job Title*',
                      maxLength: 100,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Job title is required';
                        }
                        if (value.trim().length < 3) {
                          return 'Must be at least 3 characters';
                        }
                        if (value.length > 100) {
                          return 'Must be 100 characters or less';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // Date Field
                    _buildField(
                      controller: _dateController,
                      hint: 'Date*',
                      readOnly: true,
                      onTap: _onDateTap,
                      suffixIcon: Icons.calendar_month_outlined,
                    ),

                    const SizedBox(height: 20),

                    // Time Fields Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildField(
                            controller: _startTimeController,
                            hint: 'Start Time*',
                            readOnly: true,
                            onTap: _onStartTimeTap,
                            suffixIcon: Icons.access_time,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildField(
                            controller: _endTimeController,
                            hint: 'End Time*',
                            readOnly: true,
                            onTap: _onEndTimeTap,
                            suffixIcon: Icons.access_time,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Bar
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildIconCard() {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: _iconBoxFill,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: Icon(
          Icons.description_outlined,
          size: 36,
          color: _iconBlue,
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    bool readOnly = false,
    VoidCallback? onTap,
    IconData? suffixIcon,
  }) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _borderColor, width: 1.5),
      ),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        cursorColor: _progressFill,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: _titleColor,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: _mutedText,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          suffixIcon: suffixIcon != null
              ? Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Icon(
                    suffixIcon,
                    size: 24,
                    color: _mutedText,
                  ),
                )
              : null,
          suffixIconConstraints: const BoxConstraints(
            minWidth: 24,
            minHeight: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildValidatedField({
    required TextEditingController controller,
    required String hint,
    bool readOnly = false,
    VoidCallback? onTap,
    IconData? suffixIcon,
    int? maxLength,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildField(
          controller: controller,
          hint: hint,
          readOnly: readOnly,
          onTap: onTap,
          suffixIcon: suffixIcon,
        ),
        if (validator != null)
          Builder(
            builder: (context) {
              final error = validator(controller.text);
              if (error != null && controller.text.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(left: 16, top: 6),
                  child: Text(
                    error,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFFD92D20),
                    ),
                  ),
                );
              }
              if (maxLength != null) {
                return Padding(
                  padding: const EdgeInsets.only(left: 16, top: 6),
                  child: Text(
                    '${controller.text.length}/$maxLength characters',
                    style: TextStyle(
                      fontSize: 12,
                      color: controller.text.length > maxLength
                          ? const Color(0xFFD92D20)
                          : _mutedText,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous Button
          TextButton(
            onPressed: widget.onBack,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            ),
            child: const Text(
              'Previous',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: _titleColor,
              ),
            ),
          ),

          // Continue Button
          GestureDetector(
            onTap: _onContinue,
            child: Container(
              width: 160,
              height: 52,
              decoration: BoxDecoration(
                color: _primaryBtn,
                borderRadius: BorderRadius.circular(26),
              ),
              child: const Center(
                child: Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
