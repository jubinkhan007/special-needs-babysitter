import 'package:flutter/material.dart';
import 'package:core/core.dart';

class DobDropdownRow extends StatelessWidget {
  final DateTime? dob;
  final ValueChanged<DateTime> onDateSelected;

  const DobDropdownRow({
    super.key,
    required this.dob,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final date = dob ?? DateTime.now();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Date of birth',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildPickerBox(
              context,
              label: dob == null ? 'Month' : _monthName(date.month),
              isActive: dob != null,
            ),
            const SizedBox(width: 12),
            _buildPickerBox(
              context,
              label: dob == null ? 'Date' : '${date.day}',
              isActive: dob != null,
            ),
            const SizedBox(width: 12),
            _buildPickerBox(
              context,
              label: dob == null ? 'Year' : '${date.year}',
              isActive: dob != null,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPickerBox(BuildContext context,
      {required String label, required bool isActive}) {
    return Expanded(
      child: GestureDetector(
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: dob ?? DateTime(1995),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: AppColors.secondary, // Header background color
                    onPrimary: Colors.white, // Header text color
                    onSurface: Color(0xFF1A1A1A), // Body text color
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                      foregroundColor:
                          AppColors.secondary, // Button text color
                    ),
                  ),
                ),
                child: child!,
              );
            },
          );
          if (picked != null) onDateSelected(picked);
        },
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.transparent),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    color: isActive
                        ? const Color(0xFF1A1A1A)
                        : const Color(0xFF667085),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(Icons.keyboard_arrow_down,
                  size: 20, color: Color(0xFF98A2B3)),
            ],
          ),
        ),
      ),
    );
  }

  String _monthName(int month) {
    const months = [
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
    return months[month - 1];
  }
}
