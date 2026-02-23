import 'package:flutter/material.dart';
import 'form_field_card.dart';

class BookingTimeField extends StatelessWidget {
  final String hintText;
  final String? value;
  final VoidCallback onTap;

  const BookingTimeField({
    super.key,
    required this.hintText,
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
              value ?? hintText,
              style: TextStyle(
                fontSize: 16,
                fontWeight: value != null ? FontWeight.w500 : FontWeight.w400,
                color: value != null
                    ? const Color(0xFF101828)
                    : const Color(0xFF667085),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.access_time,
            color: Color(0xFF667085), // Grey icon
            size: 20,
          ),
        ],
      ),
    );
  }
}
