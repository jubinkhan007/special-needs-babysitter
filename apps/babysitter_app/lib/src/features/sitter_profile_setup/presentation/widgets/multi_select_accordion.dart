import 'package:core/core.dart';
import 'package:flutter/material.dart';

class MultiSelectAccordion extends StatefulWidget {
  final String title;
  final List<String> options;
  final List<String> selectedValues;
  final ValueChanged<List<String>> onChanged;
  final VoidCallback? onOtherTap;

  const MultiSelectAccordion({
    super.key,
    required this.title,
    required this.options,
    required this.selectedValues,
    required this.onChanged,
    this.onOtherTap,
  });

  @override
  State<MultiSelectAccordion> createState() => _MultiSelectAccordionState();
}

class _MultiSelectAccordionState extends State<MultiSelectAccordion> {
  bool _isExpanded = false;

  void _toggleOption(String option) {
    final newValues = List<String>.from(widget.selectedValues);
    if (newValues.contains(option)) {
      newValues.remove(option);
    } else {
      newValues.add(option);
    }
    widget.onChanged(newValues);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: BorderRadius.vertical(
              top: const Radius.circular(12),
              bottom: Radius.circular(_isExpanded ? 0 : 12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(
                          0xFF667085), // Grey text per placeholder look
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: const Color(0xFF98A2B3),
                  ),
                ],
              ),
            ),
          ),
          // Expanded List
          if (_isExpanded) ...[
            const Divider(height: 1, thickness: 1, color: Color(0xFFF2F4F7)),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: widget.options.length,
              separatorBuilder: (context, index) => const Divider(
                  height: 1, thickness: 1, color: Color(0xFFF2F4F7)),
              itemBuilder: (context, index) {
                final option = widget.options[index];
                final isSelected = widget.selectedValues.contains(option);
                return InkWell(
                  onTap: () => _toggleOption(option),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            option,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF344054),
                              fontFamily: 'Inter',
                              fontWeight:
                                  FontWeight.w500, // Slightly bolder for items
                            ),
                          ),
                        ),
                        // Custom Checkbox
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : const Color(0xFFD0D5DD),
                              width: isSelected ? 0 : 1,
                            ),
                            color: isSelected
                                ? AppColors.primary
                                : Colors.white,
                          ),
                          child: isSelected
                              ? const Icon(Icons.check,
                                  size: 16, color: Colors.white)
                              : null,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            // Other Option
            const Divider(height: 1, thickness: 1, color: Color(0xFFF2F4F7)),
            InkWell(
              onTap: widget.onOtherTap,
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(12)),
              child: const Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Other',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF344054),
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Icon(Icons.add, color: Color(0xFF344054)),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
