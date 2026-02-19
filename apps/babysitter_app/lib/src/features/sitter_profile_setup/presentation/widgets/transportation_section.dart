import 'package:core/core.dart';
import 'package:flutter/material.dart';

class TransportationSection extends StatelessWidget {
  final bool hasReliableTransportation;
  final String? details;
  final ValueChanged<bool> onToggle;
  final ValueChanged<String> onDetailsChanged;

  const TransportationSection({
    super.key,
    required this.hasReliableTransportation,
    required this.details,
    required this.onToggle,
    required this.onDetailsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Transportation',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () => onToggle(!hasReliableTransportation),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      color: hasReliableTransportation
                          ? AppColors.primary
                          : const Color(0xFF98A2B3),
                      width: 2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: hasReliableTransportation
                    ? const Icon(Icons.check,
                        size: 18, color: AppColors.primary)
                    : null,
              ),
              const SizedBox(width: 12),
              const Text(
                'I have reliable transportation',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF667085),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 120, // Specific height per design screenshot look
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: TextFormField(
            initialValue: details,
            onChanged: onDetailsChanged,
            maxLines: 5,
            style: const TextStyle(color: Color(0xFF1A1A1A)),
            decoration: const InputDecoration(
              filled: true,
              fillColor: Colors.transparent,
              hintText:
                  'Describe any limitations or preferences (e.g.,\npublic transport, willing to drive up to 10 miles).',
              hintStyle: TextStyle(
                  color: Color(0xFF98A2B3), fontSize: 14, height: 1.5),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }
}
