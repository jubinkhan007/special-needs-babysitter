import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:domain/domain.dart';
import 'package:core/core.dart';

/// Formatter that only allows digits and at most one decimal point
class DecimalInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Allow empty
    if (newValue.text.isEmpty) {
      return newValue;
    }
    
    // Only allow digits and at most one decimal point
    final buffer = StringBuffer();
    bool hasDecimal = false;
    
    for (int i = 0; i < newValue.text.length; i++) {
      final char = newValue.text[i];
      if (char == '.') {
        if (!hasDecimal) {
          buffer.write(char);
          hasDecimal = true;
        }
        // Skip additional decimal points
      } else if (RegExp(r'[0-9]').hasMatch(char)) {
        buffer.write(char);
      }
      // Skip all other characters (letters, symbols, etc.)
    }
    
    final newText = buffer.toString();
    
    // Adjust cursor position if needed
    int newOffset = newValue.selection.end;
    if (newOffset > newText.length) {
      newOffset = newText.length;
    }
    
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newOffset),
    );
  }
}

final TextInputFormatter _decimalInputFormatter = DecimalInputFormatter();

class EditInsurancePlanDialog extends StatefulWidget {
  final InsurancePlan? initialPlan;
  final Function(Map<String, dynamic>) onSave;

  const EditInsurancePlanDialog({
    super.key,
    this.initialPlan,
    required this.onSave,
  });

  @override
  State<EditInsurancePlanDialog> createState() =>
      _EditInsurancePlanDialogState();
}

class _EditInsurancePlanDialogState extends State<EditInsurancePlanDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _planNameController;
  late TextEditingController _typeController;
  late TextEditingController _coverageController;
  late TextEditingController _monthlyPremController;
  late TextEditingController _yearlyPremController;
  late TextEditingController _descriptionController;

  bool _isActive = true;

  // Character limits
  static const int _maxPlanNameLength = 50;
  static const int _maxTypeLength = 50;
  static const int _maxCoverageLength = 12; // For numeric values like 999999999.99
  static const int _maxPremiumLength = 12;
  static const int _maxDescriptionLength = 500;

  @override
  void initState() {
    super.initState();
    final p = widget.initialPlan;
    _planNameController = TextEditingController(text: p?.planName ?? '');
    _typeController = TextEditingController(text: p?.insuranceType ?? '');
    _coverageController =
        TextEditingController(text: p?.coverageAmount.toString() ?? '');
    _monthlyPremController =
        TextEditingController(text: p?.monthlyPremium.toString() ?? '');
    _yearlyPremController =
        TextEditingController(text: p?.yearlyPremium.toString() ?? '');
    _descriptionController = TextEditingController(text: p?.description ?? '');
    _isActive = p?.isActive ?? true;
  }

  @override
  void dispose() {
    _planNameController.dispose();
    _typeController.dispose();
    _coverageController.dispose();
    _monthlyPremController.dispose();
    _yearlyPremController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onSave({
        'planName': _planNameController.text,
        'insuranceType': _typeController.text,
        'coverageAmount': double.tryParse(_coverageController.text) ?? 0,
        'monthlyPremium': double.tryParse(_monthlyPremController.text) ?? 0,
        'yearlyPremium': double.tryParse(_yearlyPremController.text) ?? 0,
        'description': _descriptionController.text,
        'isActive': _isActive,
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFFF3FAFD),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const SizedBox(width: 24),
                Expanded(
                  child: Text(
                    widget.initialPlan == null
                        ? 'Add an Insurance Plan'
                        : 'Edit Insurance Plan',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF101828),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Color(0xFF101828)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildField(
                      _planNameController, 
                      'Insurance Plan Name*',
                      maxLength: _maxPlanNameLength,
                      minLength: 2,
                    ),
                    const SizedBox(height: 12),
                    _buildField(
                      _typeController, 
                      'Insurance Type',
                      maxLength: _maxTypeLength,
                    ),
                    const SizedBox(height: 12),
                    _buildField(
                      _coverageController, 
                      'Coverage Amount*',
                      isNum: true,
                      maxLength: _maxCoverageLength,
                      minValue: 1,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                            child: _buildField(
                              _monthlyPremController, 
                              'Monthly Premium*',
                              isNum: true,
                              maxLength: _maxPremiumLength,
                              minValue: 0,
                            )),
                        const SizedBox(width: 12),
                        Expanded(
                            child: _buildField(
                              _yearlyPremController, 
                              'Yearly Premium*',
                              isNum: true,
                              maxLength: _maxPremiumLength,
                              minValue: 0,
                            )),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildField(
                      _descriptionController, 
                      'Description / Benefits',
                      maxLines: 4,
                      maxLength: _maxDescriptionLength,
                    ),

                    const SizedBox(height: 24),
                    // Status Toggle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          'Status',
                          style:
                              TextStyle(fontSize: 16, color: Color(0xFF344054)),
                        ),
                        const Spacer(),
                        const Text(
                          'Inactive',
                          style:
                              TextStyle(fontSize: 14, color: Color(0xFF667085)),
                        ),
                        const SizedBox(width: 8),
                        Switch(
                          value: _isActive,
                          onChanged: (v) => setState(() => _isActive = v),
                          activeThumbColor: Colors.white,
                          activeTrackColor:
                              const Color(0xFF75CFF0), // Match Save button blue
                          inactiveThumbColor: Colors.white,
                          inactiveTrackColor: const Color(0xFFD0D5DD),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Active',
                          style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF344054),
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),

          // Action Buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: Color(0xFFD0D5DD)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      backgroundColor: Colors.white,
                    ),
                    child: const Text('Cancel',
                        style: TextStyle(
                            color: Color(0xFF344054),
                            fontSize: 16,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(
                          0xFF75CFF0), // Light blue from design screenshot
                      foregroundColor: AppColors.textOnButton,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: const Text('Save',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(
    TextEditingController controller, 
    String hint, {
    bool isNum = false, 
    int maxLines = 1,
    int? maxLength,
    int? minLength,
    double? minValue,
  }) {
    // Build input formatters list
    final List<TextInputFormatter> formatters = [];
    if (isNum) {
      formatters.add(_decimalInputFormatter);
    }
    if (maxLength != null) {
      formatters.add(LengthLimitingTextInputFormatter(maxLength));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0D101828),
                offset: Offset(0, 1),
                blurRadius: 2,
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: isNum
                ? const TextInputType.numberWithOptions(decimal: true)
                : TextInputType.text,
            inputFormatters: formatters.isEmpty ? null : formatters,
            maxLines: maxLines,
            style: const TextStyle(color: Color(0xFF101828), fontSize: 16),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle:
                  const TextStyle(color: Color(0xFF667085), fontSize: 16),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFD0D5DD)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFD0D5DD)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.secondary),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              isDense: true,
              counterText: '', // Hide default counter
            ),
            validator: (value) {
              // Required field validation
              if (hint.endsWith('*') && (value == null || value.isEmpty)) {
                return '${hint.replaceAll('*', '')} is required';
              }
              // Min length validation
              if (minLength != null && value != null && value.isNotEmpty) {
                if (value.trim().length < minLength) {
                  return 'Must be at least $minLength characters';
                }
              }
              // Numeric validation
              if (isNum && value != null && value.isNotEmpty) {
                final numValue = double.tryParse(value);
                if (numValue == null) {
                  return 'Please enter a valid number';
                }
                if (minValue != null && numValue < minValue) {
                  return 'Must be at least $minValue';
                }
              }
              return null;
            },
          ),
        ),
        // Character counter for text fields
        if (maxLength != null && !isNum)
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, child) {
              final currentLength = controller.text.length;
              return Padding(
                padding: const EdgeInsets.only(top: 4, left: 4),
                child: Text(
                  '$currentLength/$maxLength',
                  style: TextStyle(
                    fontSize: 12,
                    color: currentLength >= maxLength
                        ? const Color(0xFFD92D20) // Red at limit
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
