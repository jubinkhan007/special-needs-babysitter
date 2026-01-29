import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:babysitter_app/src/features/parent/search/presentation/theme/app_ui_tokens.dart';

class CalendarAvailabilitySection extends StatefulWidget {
  final List<dynamic>? availability;

  const CalendarAvailabilitySection({super.key, this.availability});

  @override
  State<CalendarAvailabilitySection> createState() =>
      _CalendarAvailabilitySectionState();
}

class _CalendarAvailabilitySectionState
    extends State<CalendarAvailabilitySection> {
  late DateTime _focusedDate;
  final Set<String> _availableDates = {};

  @override
  void initState() {
    super.initState();
    _focusedDate = DateTime.now();
    _parseAvailability();
  }

  void _parseAvailability() {
    _availableDates.clear();
    if (widget.availability == null) return;
    for (var item in widget.availability!) {
      if (item is Map<String, dynamic>) {
        final dateStr = item['date'] as String?;
        if (dateStr != null) {
          final parsed = DateTime.tryParse(dateStr);
          if (parsed != null) {
            _availableDates.add(_formatDateKey(parsed));
          }
        }
      } else if (item is String) {
        final parsed = DateTime.tryParse(item);
        if (parsed != null) {
          _availableDates.add(_formatDateKey(parsed));
        }
      }
    }
  }

  String _formatDateKey(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  void _nextMonth() {
    setState(() {
      _focusedDate = DateTime(_focusedDate.year, _focusedDate.month + 1);
    });
  }

  void _prevMonth() {
    setState(() {
      _focusedDate = DateTime(_focusedDate.year, _focusedDate.month - 1);
    });
  }

  void _nextYear() {
    setState(() {
      _focusedDate = DateTime(_focusedDate.year + 1, _focusedDate.month);
    });
  }

  void _prevYear() {
    setState(() {
      _focusedDate = DateTime(_focusedDate.year - 1, _focusedDate.month);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Availability",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppUiTokens.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 16),
          _buildHeader(),
          const SizedBox(height: 16),
          _buildDaysOfWeek(),
          const SizedBox(height: 8),
          _buildCalendarGrid(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final monthName = DateFormat('MMMM').format(_focusedDate);
    final yearName = DateFormat('yyyy').format(_focusedDate);

    return Row(
      children: [
        Expanded(
          child: _buildSelectorRow(
            label: monthName,
            onPrev: _prevMonth,
            onNext: _nextMonth,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildSelectorRow(
            label: yearName,
            onPrev: _prevYear,
            onNext: _nextYear,
          ),
        ),
      ],
    );
  }

  Widget _buildSelectorRow({
    required String label,
    required VoidCallback onPrev,
    required VoidCallback onNext,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left,
              color: AppUiTokens.textSecondary),
          onPressed: onPrev,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
          iconSize: 18,
        ),
        const SizedBox(width: 2),
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppUiTokens.textPrimary,
              ),
            ),
          ),
        ),
        const SizedBox(width: 2),
        const Icon(Icons.arrow_drop_down,
            size: 16, color: AppUiTokens.textSecondary),
        const SizedBox(width: 2),
        IconButton(
          icon: const Icon(Icons.chevron_right,
              color: AppUiTokens.textSecondary),
          onPressed: onNext,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
          iconSize: 18,
        ),
      ],
    );
  }

  Widget _buildDaysOfWeek() {
    const days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: days
          .map((d) => SizedBox(
                width: 32,
                child: Center(
                  child: Text(
                    d,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppUiTokens.textPrimary,
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildCalendarGrid() {
    final daysInMonth =
        DateUtils.getDaysInMonth(_focusedDate.year, _focusedDate.month);
    final firstDayOfMonth = DateTime(_focusedDate.year, _focusedDate.month, 1);
    // 1 = Monday, 7 = Sunday.
    // If we want Sunday start:
    // 7 -> 0, 1 -> 1 ...
    // weekday returns 1..7 (Mon..Sun).
    // offset = (firstDay.weekday % 7). If Sun(7) -> 0. Mon(1) -> 1.
    final offset = firstDayOfMonth.weekday % 7;

    final totalCells = daysInMonth + offset;
    final rowCount = (totalCells / 7).ceil();

    return Column(
      children: List.generate(rowCount, (rowIndex) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (colIndex) {
              final cellIndex = rowIndex * 7 + colIndex;
              final dayNumber = cellIndex - offset + 1;

              if (dayNumber < 1 || dayNumber > daysInMonth) {
                return const SizedBox(width: 32, height: 32);
              }

              final date =
                  DateTime(_focusedDate.year, _focusedDate.month, dayNumber);
              final dateKey = _formatDateKey(date);
              final isAvailable = _availableDates.contains(dateKey);

              return Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isAvailable 
                      ? const Color(0xFFE8F5E9) // Light green background for available dates
                      : Colors.transparent,
                  border: isAvailable
                      ? Border.all(
                          color: const Color(0xFF4ADE80),
                          width: 1.5) // Light Green Ring
                      : null,
                ),
                child: Center(
                  child: Text(
                    dayNumber.toString(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight:
                          isAvailable ? FontWeight.w600 : FontWeight.w400,
                      color: isAvailable
                          ? AppUiTokens.textPrimary
                          : AppUiTokens.textSecondary,
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }
}
