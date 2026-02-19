import 'package:core/core.dart';
import 'package:flutter/material.dart';
import '../../../profile_details/data/sitter_me_dto.dart';

class AvailabilitySection extends StatefulWidget {
  final List<SitterAvailabilityDto>? availability;
  final VoidCallback? onEditTap;

  const AvailabilitySection({
    super.key,
    this.availability,
    this.onEditTap,
  });

  @override
  State<AvailabilitySection> createState() => _AvailabilitySectionState();
}

class _AvailabilitySectionState extends State<AvailabilitySection> {
  late DateTime _currentMonth;
  late Set<DateTime> _availableDates;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime.now();
    _parseAvailability();
  }

  @override
  void didUpdateWidget(AvailabilitySection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.availability != oldWidget.availability) {
      _parseAvailability();
    }
  }

  void _parseAvailability() {
    _availableDates = {};
    if (widget.availability != null) {
      for (final avail in widget.availability!) {
        if (!avail.noBookings) {
          try {
            final date = DateTime.parse(avail.date);
            _availableDates.add(DateTime(date.year, date.month, date.day));
          } catch (_) {}
        }
      }
    }
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Availability',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.buttonDark,
                ),
              ),
              if (widget.onEditTap != null)
                GestureDetector(
                  onTap: widget.onEditTap,
                  child: const Icon(
                    Icons.edit_outlined,
                    size: 20,
                    color: Color(0xFF667085),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          // Month selector
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, color: Color(0xFF667085)),
                onPressed: _previousMonth,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 16),
              Text(
                _getMonthName(_currentMonth.month),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.buttonDark,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.keyboard_arrow_down, size: 16, color: Color(0xFF667085)),
              const SizedBox(width: 16),
              Text(
                _currentMonth.year.toString(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.buttonDark,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.keyboard_arrow_down, size: 16, color: Color(0xFF667085)),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(Icons.chevron_right, color: Color(0xFF667085)),
                onPressed: _nextMonth,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Weekday headers
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _WeekdayLabel('S'),
              _WeekdayLabel('M'),
              _WeekdayLabel('T'),
              _WeekdayLabel('W'),
              _WeekdayLabel('T'),
              _WeekdayLabel('F'),
              _WeekdayLabel('S'),
            ],
          ),
          const SizedBox(height: 8),
          // Calendar grid
          _buildCalendarGrid(),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final lastDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
    final firstWeekday = firstDayOfMonth.weekday % 7; // Sunday = 0
    final daysInMonth = lastDayOfMonth.day;

    final List<Widget> rows = [];
    List<Widget> currentRow = [];

    // Add empty cells for days before the first of the month
    for (int i = 0; i < firstWeekday; i++) {
      final prevMonthDay = firstDayOfMonth.subtract(Duration(days: firstWeekday - i));
      currentRow.add(_CalendarDay(
        day: prevMonthDay.day,
        isCurrentMonth: false,
        isAvailable: false,
      ));
    }

    // Add days of the current month
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_currentMonth.year, _currentMonth.month, day);
      final isAvailable = _availableDates.contains(date);

      currentRow.add(_CalendarDay(
        day: day,
        isCurrentMonth: true,
        isAvailable: isAvailable,
        isToday: _isToday(date),
      ));

      if (currentRow.length == 7) {
        rows.add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: currentRow,
        ));
        currentRow = [];
      }
    }

    // Add empty cells for days after the last of the month
    if (currentRow.isNotEmpty) {
      int nextMonthDay = 1;
      while (currentRow.length < 7) {
        currentRow.add(_CalendarDay(
          day: nextMonthDay++,
          isCurrentMonth: false,
          isAvailable: false,
        ));
      }
      rows.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: currentRow,
      ));
    }

    return Column(children: rows.map((row) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: row,
    )).toList());
  }

  bool _isToday(DateTime date) {
    final today = DateTime.now();
    return date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}

class _WeekdayLabel extends StatelessWidget {
  final String label;

  const _WeekdayLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF667085),
          ),
        ),
      ),
    );
  }
}

class _CalendarDay extends StatelessWidget {
  final int day;
  final bool isCurrentMonth;
  final bool isAvailable;
  final bool isToday;

  const _CalendarDay({
    required this.day,
    required this.isCurrentMonth,
    required this.isAvailable,
    this.isToday = false,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor = Colors.transparent;
    Color textColor = const Color(0xFF667085);

    if (!isCurrentMonth) {
      textColor = const Color(0xFFD0D5DD);
    } else if (isAvailable) {
      bgColor = const Color(0xFF62A8FF);
      textColor = Colors.white;
    } else if (isToday) {
      bgColor = const Color(0xFFE8F4FF);
      textColor = const Color(0xFF62A8FF);
    }

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          day.toString(),
          style: TextStyle(
            fontSize: 14,
            fontWeight: isAvailable || isToday ? FontWeight.w600 : FontWeight.w400,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
