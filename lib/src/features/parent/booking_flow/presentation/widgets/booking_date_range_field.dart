import 'package:flutter/material.dart';
import 'form_field_card.dart';

class BookingDateRangeField extends StatelessWidget {
  final String? value;
  final VoidCallback onTap;

  const BookingDateRangeField({
    super.key,
    this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FormFieldCard(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Text(
              value ?? 'Select Date Range', // Fallback
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight
                    .w500, // Medium as per screenshot "14-08..." looks solid
                color: value != null
                    ? const Color(0xFF101828)
                    : const Color(0xFF667085),
              ),
            ),
          ),
          const Icon(
            Icons.calendar_today_outlined,
            color: Color(0xFF667085), // Grey icon
            size: 20,
          ),
        ],
      ),
    );
  }
}
