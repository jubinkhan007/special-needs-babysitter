import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:babysitter_app/src/common_widgets/app_toast.dart';
import 'package:babysitter_app/common/widgets/primary_action_button.dart';
import '../../data/sitter_me_dto.dart';

class EditAvailabilityDialog extends StatefulWidget {
  final List<SitterAvailabilityDto>? initialAvailability;
  final Future<bool> Function(List<Map<String, dynamic>> availability) onSave;

  const EditAvailabilityDialog({
    super.key,
    required this.initialAvailability,
    required this.onSave,
  });

  @override
  State<EditAvailabilityDialog> createState() => _EditAvailabilityDialogState();
}

class _EditAvailabilityDialogState extends State<EditAvailabilityDialog> {
  static const _textDark = Color(0xFF1A1A1A);
  static const _greyText = Color(0xFF667085);
  static const _primaryBlue = Color(0xFF88CBE6);

  final DateFormat _dateFormat = DateFormat('MM/dd/yyyy');
  final DateFormat _timeFormat = DateFormat('h:mm a');
  final DateFormat _apiDateFormat = DateFormat('yyyy-MM-dd');
  final DateFormat _apiTimeFormat = DateFormat('HH:mm');

  bool _isRange = false;
  DateTime? _singleDate;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  bool _noBookings = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _hydrateFromAvailability(widget.initialAvailability);
  }

  void _hydrateFromAvailability(List<SitterAvailabilityDto>? availability) {
    if (availability == null || availability.isEmpty) {
      _singleDate = DateTime.now();
      _startTime = const TimeOfDay(hour: 9, minute: 0);
      _endTime = const TimeOfDay(hour: 17, minute: 0);
      _noBookings = false;
      return;
    }

    final dates = availability
        .map((a) => _parseDate(a.date))
        .whereType<DateTime>()
        .toList()
      ..sort();

    if (dates.isEmpty) {
      _singleDate = DateTime.now();
    } else if (dates.length == 1) {
      _singleDate = dates.first;
      _isRange = false;
    } else {
      _isRange = true;
      _rangeStart = dates.first;
      _rangeEnd = dates.last;
    }

    final first = availability.first;
    _startTime = _parseTime(first.startTime) ?? const TimeOfDay(hour: 9, minute: 0);
    _endTime = _parseTime(first.endTime) ?? const TimeOfDay(hour: 17, minute: 0);
    _noBookings = first.noBookings;
  }

  DateTime? _parseDate(String? value) {
    if (value == null || value.isEmpty) return null;
    try {
      return DateTime.parse(value);
    } catch (_) {
      try {
        return _dateFormat.parse(value);
      } catch (_) {
        return null;
      }
    }
  }

  TimeOfDay? _parseTime(String? value) {
    if (value == null || value.isEmpty) return null;
    try {
      final dt = _timeFormat.parse(value);
      return TimeOfDay.fromDateTime(dt);
    } catch (_) {
      try {
        final dt = _apiTimeFormat.parse(value);
        return TimeOfDay.fromDateTime(dt);
      } catch (_) {
        return null;
      }
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Select date';
    return _dateFormat.format(date);
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return 'Select time';
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return _timeFormat.format(dt);
  }

  String _formatDateForApi(DateTime date) {
    return _apiDateFormat.format(date);
  }

  String _formatTimeForApi(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return _apiTimeFormat.format(dt);
  }

  Future<void> _pickDate({required bool isStart}) async {
    final now = DateTime.now();
    final initial = isStart
        ? (_rangeStart ?? _singleDate ?? now)
        : (_rangeEnd ?? _singleDate ?? now);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: now.subtract(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(primary: _primaryBlue),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      setState(() {
        if (_isRange) {
          if (isStart) {
            _rangeStart = picked;
            if (_rangeEnd != null && _rangeEnd!.isBefore(picked)) {
              _rangeEnd = picked;
            }
          } else {
            _rangeEnd = picked;
            if (_rangeStart != null && _rangeStart!.isAfter(picked)) {
              _rangeStart = picked;
            }
          }
        } else {
          _singleDate = picked;
        }
      });
    }
  }

  Future<void> _pickTime({required bool isStart}) async {
    final initial = isStart ? (_startTime ?? const TimeOfDay(hour: 9, minute: 0)) : (_endTime ?? const TimeOfDay(hour: 17, minute: 0));
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(primary: _primaryBlue),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  Future<void> _handleSave() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

    final startDate = _isRange ? _rangeStart : _singleDate;
    final endDate = _isRange ? _rangeEnd : _singleDate;

    if (startDate == null || endDate == null) {
      AppToast.show(
        context,
        const SnackBar(content: Text('Please select a date')),
      );
      setState(() => _isSaving = false);
      return;
    }

    if (_startTime == null || _endTime == null) {
      AppToast.show(
        context,
        const SnackBar(content: Text('Please select start and end times')),
      );
      setState(() => _isSaving = false);
      return;
    }

    final availability = <Map<String, dynamic>>[];
    var current = DateTime(startDate.year, startDate.month, startDate.day);
    final last = DateTime(endDate.year, endDate.month, endDate.day);

    while (!current.isAfter(last)) {
      availability.add({
        'date': _formatDateForApi(current),
        'startTime': _formatTimeForApi(_startTime!),
        'endTime': _formatTimeForApi(_endTime!),
        'noBookings': _noBookings,
      });
      current = current.add(const Duration(days: 1));
    }

    final success = await widget.onSave(availability);
    if (!mounted) return;

    if (success) {
      Navigator.of(context).pop();
    } else {
      AppToast.show(
        context,
        const SnackBar(content: Text('Failed to update availability')),
      );
      setState(() => _isSaving = false);
    }
  }

  Widget _buildField(String label, String value, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFD0D5DD)),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value,
              style: const TextStyle(fontSize: 14, color: _textDark),
            ),
            const Icon(Icons.calendar_today, size: 16, color: _greyText),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeField(String label, String value, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFD0D5DD)),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value,
              style: const TextStyle(fontSize: 14, color: _textDark),
            ),
            const Icon(Icons.access_time, size: 16, color: _greyText),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Edit Availability',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1D2939),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: _greyText),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F4F7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _isRange = false),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: _isRange ? Colors.transparent : Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Single Day',
                                style: TextStyle(
                                  fontWeight: _isRange ? FontWeight.w500 : FontWeight.w600,
                                  color: _isRange ? _greyText : _textDark,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _isRange = true),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: _isRange ? Colors.white : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Date Range',
                                style: TextStyle(
                                  fontWeight: _isRange ? FontWeight.w600 : FontWeight.w500,
                                  color: _isRange ? _textDark : _greyText,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_isRange) ...[
                    const Text('Start Date',
                        style: TextStyle(fontSize: 12, color: _greyText)),
                    const SizedBox(height: 6),
                    _buildField('Start Date', _formatDate(_rangeStart),
                        () => _pickDate(isStart: true)),
                    const SizedBox(height: 12),
                    const Text('End Date',
                        style: TextStyle(fontSize: 12, color: _greyText)),
                    const SizedBox(height: 6),
                    _buildField('End Date', _formatDate(_rangeEnd),
                        () => _pickDate(isStart: false)),
                  ] else ...[
                    const Text('Date',
                        style: TextStyle(fontSize: 12, color: _greyText)),
                    const SizedBox(height: 6),
                    _buildField('Date', _formatDate(_singleDate),
                        () => _pickDate(isStart: true)),
                  ],
                  const SizedBox(height: 16),
                  const Text('Start Time',
                      style: TextStyle(fontSize: 12, color: _greyText)),
                  const SizedBox(height: 6),
                  _buildTimeField('Start Time', _formatTime(_startTime),
                      () => _pickTime(isStart: true)),
                  const SizedBox(height: 12),
                  const Text('End Time',
                      style: TextStyle(fontSize: 12, color: _greyText)),
                  const SizedBox(height: 6),
                  _buildTimeField('End Time', _formatTime(_endTime),
                      () => _pickTime(isStart: false)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Checkbox(
                        value: _noBookings,
                        onChanged: (val) =>
                            setState(() => _noBookings = val ?? false),
                        activeColor: _primaryBlue,
                      ),
                      const Expanded(
                        child: Text(
                          'No bookings for this period',
                          style: TextStyle(fontSize: 14, color: _greyText),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          Padding(
            padding: const EdgeInsets.all(16),
            child: PrimaryActionButton(
              label: _isSaving ? 'Saving...' : 'Save Changes',
              onPressed: _isSaving ? null : _handleSave,
              backgroundColor: _primaryBlue,
            ),
          ),
        ],
      ),
    );
  }
}
