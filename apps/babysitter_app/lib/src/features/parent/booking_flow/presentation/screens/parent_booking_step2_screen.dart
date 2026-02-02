import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/booking_flow_provider.dart';
import '../../data/models/booking_flow_state.dart';
import '../widgets/booking_step_header.dart';
import '../widgets/booking_primary_bottom_button.dart';
import 'parent_booking_step3_screen.dart';

class ParentBookingStep2Screen extends ConsumerStatefulWidget {
  const ParentBookingStep2Screen({super.key});

  @override
  ConsumerState<ParentBookingStep2Screen> createState() =>
      _ParentBookingStep2ScreenState();
}

class _ParentBookingStep2ScreenState
    extends ConsumerState<ParentBookingStep2Screen> {
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;

  // Design Constants (matching job post flow)
  static const _bgColor = Color(0xFFF0F9FF);
  static const _titleColor = Color(0xFF101828);
  static const _mutedText = Color(0xFF667085);
  static const _borderColor = Color(0xFFB2DDFF);
  static const _progressFill = Color(0xFF88CBE6);
  static const _errorColor = Color(0xFFD92D20);

  @override
  void initState() {
    super.initState();
    // Load existing state from provider
    final state = ref.read(bookingFlowProvider);
    _jobTitleController.text = state.jobTitle ?? '';
    _dateController.text = state.dateRange ?? '';
    _startTimeController.text = state.startTime ?? '';
    _endTimeController.text = state.endTime ?? '';
    _startDate = state.startDate;
    _endDate = state.endDate;
  }

  @override
  void dispose() {
    _jobTitleController.dispose();
    _dateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    super.dispose();
  }
  
  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: _errorColor,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
  
  bool _isEndTimeAfterStartTime() {
    if (_startTimeController.text.isEmpty || _endTimeController.text.isEmpty) {
      return false;
    }
    
    try {
      final startTime = _parseTimeString(_startTimeController.text);
      final endTime = _parseTimeString(_endTimeController.text);
      
      final startMinutes = startTime.hour * 60 + startTime.minute;
      final endMinutes = endTime.hour * 60 + endTime.minute;
      
      // Same day booking validation
      if (_startDate != null && 
          _endDate != null && 
          _startDate!.isAtSameMomentAs(_endDate!)) {
        return endMinutes > startMinutes;
      }
      
      return true; // Multi-day booking allows any times
    } catch (e) {
      return true;
    }
  }
  
  TimeOfDay _parseTimeString(String timeStr) {
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
              primary: _titleColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: _titleColor,
              secondary: _progressFill,
            ),
            dialogBackgroundColor: Colors.white,
            datePickerTheme: DatePickerThemeData(
              headerBackgroundColor: Colors.white,
              headerForegroundColor: _titleColor,
              rangeSelectionBackgroundColor: _progressFill.withOpacity(0.3),
              rangePickerBackgroundColor: Colors.white,
              todayBorder: const BorderSide(color: _progressFill),
            ),
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
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
      final startStr =
          '${months[pickedRange.start.month - 1]} ${pickedRange.start.day}';
      final endStr =
          '${months[pickedRange.end.month - 1]} ${pickedRange.end.day}';
      setState(() {
        _dateController.text = '$startStr - $endStr';
        _startDate = pickedRange.start;
        _endDate = pickedRange.end;
      });
    }
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  Future<void> _onStartTimeTap() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.input,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: Theme(
            data: Theme.of(context).copyWith(
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
                  side: const BorderSide(color: _progressFill, width: 2),
                ),
                dayPeriodBorderSide: const BorderSide(color: _mutedText),
                dayPeriodColor: WidgetStateColor.resolveWith((states) =>
                    states.contains(WidgetState.selected)
                        ? _progressFill.withOpacity(0.3)
                        : Colors.transparent),
                dayPeriodTextColor: WidgetStateColor.resolveWith((states) =>
                    states.contains(WidgetState.selected)
                        ? _titleColor
                        : _mutedText),
                hourMinuteColor: WidgetStateColor.resolveWith((states) =>
                    states.contains(WidgetState.selected)
                        ? Colors.white
                        : _progressFill.withOpacity(0.1)),
                hourMinuteTextColor: WidgetStateColor.resolveWith((states) =>
                    states.contains(WidgetState.selected)
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
      setState(() => _startTimeController.text = _formatTimeOfDay(picked));
    }
  }

  Future<void> _onEndTimeTap() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.input,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: Theme(
            data: Theme.of(context).copyWith(
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
                  side: const BorderSide(color: _progressFill, width: 2),
                ),
                dayPeriodBorderSide: const BorderSide(color: _mutedText),
                dayPeriodColor: WidgetStateColor.resolveWith((states) =>
                    states.contains(WidgetState.selected)
                        ? _progressFill.withOpacity(0.3)
                        : Colors.transparent),
                dayPeriodTextColor: WidgetStateColor.resolveWith((states) =>
                    states.contains(WidgetState.selected)
                        ? _titleColor
                        : _mutedText),
                hourMinuteColor: WidgetStateColor.resolveWith((states) =>
                    states.contains(WidgetState.selected)
                        ? Colors.white
                        : _progressFill.withOpacity(0.1)),
                hourMinuteTextColor: WidgetStateColor.resolveWith((states) =>
                    states.contains(WidgetState.selected)
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
      setState(() => _endTimeController.text = _formatTimeOfDay(picked));
    }
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    bool readOnly = false,
    VoidCallback? onTap,
    IconData? suffixIcon,
  }) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor, width: 1.5),
      ),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        cursorColor: _progressFill,
        style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.w500, color: _titleColor),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w400, color: _mutedText),
          filled: false,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: InputBorder.none,
          suffixIcon: suffixIcon != null
              ? Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Icon(suffixIcon, size: 22, color: _mutedText),
                )
              : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Listen for state changes to sync when navigating back
    ref.listen<BookingFlowState>(bookingFlowProvider, (previous, next) {
      if (previous?.jobTitle != next.jobTitle) {
        _jobTitleController.text = next.jobTitle ?? '';
      }
      if (previous?.startTime != next.startTime) {
        _startTimeController.text = next.startTime ?? '';
      }
      if (previous?.endTime != next.endTime) {
        _endTimeController.text = next.endTime ?? '';
      }
      if (previous?.dateRange != next.dateRange) {
        _dateController.text = next.dateRange ?? '';
      }
      if (previous?.startDate != next.startDate) {
        _startDate = next.startDate;
      }
      if (previous?.endDate != next.endDate) {
        _endDate = next.endDate;
      }
    });
    
    return Scaffold(
      backgroundColor: _bgColor,
      body: Column(
        children: [
          BookingStepHeader(
            currentStep: 2,
            totalSteps: 4,
            onBack: () => Navigator.of(context).pop(),
            onHelp: () {},
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  const Text(
                    'Job Details',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: _titleColor,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildField(
                      controller: _jobTitleController, hint: 'Job Title*'),
                  const SizedBox(height: 16),
                  _buildField(
                    controller: _dateController,
                    hint: 'Date*',
                    readOnly: true,
                    onTap: _onDateTap,
                    suffixIcon: Icons.calendar_month_outlined,
                  ),
                  const SizedBox(height: 16),
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
                  SizedBox(
                      height: 24 + MediaQuery.of(context).padding.bottom + 60),
                ],
              ),
            ),
          ),
          Container(
            color: _bgColor,
            padding: EdgeInsets.fromLTRB(
                24, 0, 24, MediaQuery.of(context).padding.bottom + 16),
            child: BookingPrimaryBottomButton(
              text: 'Next',
              onPressed: () {
                // Validate all required fields
                if (_jobTitleController.text.trim().isEmpty) {
                  _showError('Please enter a job title');
                  return;
                }
                
                if (_jobTitleController.text.trim().length < 3) {
                  _showError('Job title must be at least 3 characters');
                  return;
                }
                
                if (_dateController.text.isEmpty) {
                  _showError('Please select dates for the booking');
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
                
                // Validate time order for same-day bookings
                if (!_isEndTimeAfterStartTime()) {
                  _showError('End time must be after start time');
                  return;
                }
                
                // Save to provider
                ref.read(bookingFlowProvider.notifier).updateStep2(
                      jobTitle: _jobTitleController.text.trim(),
                      dateRange: _dateController.text,
                      startDate: _startDate,
                      endDate: _endDate,
                      startTime: _startTimeController.text,
                      endTime: _endTimeController.text,
                    );

                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const ParentBookingStep3Screen()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
