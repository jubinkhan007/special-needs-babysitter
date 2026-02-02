import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'form_field_card.dart';

class BookingTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final String? Function(String?)? validator;

  const BookingTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.keyboardType,
    this.inputFormatters,
    this.maxLength,
    this.validator,
  });

  List<TextInputFormatter>? _getInputFormatters(TextInputType? keyboardType) {
    final List<TextInputFormatter> formatters = [];
    
    // Add max length formatter if specified
    if (maxLength != null) {
      formatters.add(LengthLimitingTextInputFormatter(maxLength));
    }
    
    // Add numeric formatter for phone/number fields
    if (keyboardType == TextInputType.number ||
        keyboardType == TextInputType.phone) {
      formatters.add(FilteringTextInputFormatter.digitsOnly);
    }
    
    // Add custom formatters
    if (inputFormatters != null) {
      formatters.addAll(inputFormatters!);
    }
    
    return formatters.isEmpty ? null : formatters;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormFieldCard(
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            inputFormatters: _getInputFormatters(keyboardType),
            decoration: InputDecoration(
              filled: false,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              hintText: hintText,
              hintStyle: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w400,
              ),
              contentPadding: EdgeInsets.zero,
              isDense: true,
              counterText: '', // Hide default counter
            ),
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w400,
              color: const Color(0xFF101828), // Dark text for visibility
            ),
          ),
        ),
        // Show character count when maxLength is set
        if (maxLength != null)
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller ?? TextEditingController(),
            builder: (context, value, child) {
              final currentLength = controller?.text.length ?? 0;
              return Padding(
                padding: const EdgeInsets.only(top: 4, left: 4),
                child: Text(
                  '$currentLength/$maxLength',
                  style: TextStyle(
                    fontSize: 12,
                    color: currentLength >= maxLength!
                        ? const Color(0xFFD92D20) // Red when at limit
                        : const Color(0xFF667085), // Gray normally
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
