import 'package:flutter/material.dart';
import '../../../../../../common/theme/auth_theme.dart';
import '../../../../../../common/widgets/primary_action_button.dart';
import '../../../auth/presentation/widgets/auth_input_field.dart';

class AddChildDialog extends StatefulWidget {
  final Map<String, dynamic>? existingChild;
  final Function(Map<String, dynamic>) onSave;

  const AddChildDialog({
    super.key,
    this.existingChild,
    required this.onSave,
  });

  @override
  State<AddChildDialog> createState() => _AddChildDialogState();
}

class _AddChildDialogState extends State<AddChildDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _ageController;
  late final TextEditingController _diagnosisController;
  late final TextEditingController _personalityController;
  late final TextEditingController _medsController;
  late final TextEditingController _routineController;
  late final TextEditingController _allergyTypeController;
  late final TextEditingController _triggersTypeController;
  late final TextEditingController _calmingController;

  bool _hasAllergies = false;
  bool _hasTriggers = false;

  @override
  void initState() {
    super.initState();
    final c = widget.existingChild ?? {};
    _firstNameController = TextEditingController(text: c['firstName']);
    _lastNameController = TextEditingController(text: c['lastName']);
    _ageController = TextEditingController(text: c['age']?.toString());
    _diagnosisController = TextEditingController(text: c['diagnosis']);
    _personalityController = TextEditingController(text: c['personality']);
    _medsController = TextEditingController(text: c['meds']);
    _routineController = TextEditingController(text: c['routine']);
    _allergyTypeController = TextEditingController(text: c['allergyType']);
    _triggersTypeController = TextEditingController(text: c['triggerType']);
    _calmingController = TextEditingController(text: c['calming']);

    _hasAllergies = c['hasAllergies'] ?? false;
    _hasTriggers = c['hasTriggers'] ?? false;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    _diagnosisController.dispose();
    _personalityController.dispose();
    _medsController.dispose();
    _routineController.dispose();
    _allergyTypeController.dispose();
    _triggersTypeController.dispose();
    _calmingController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      widget.onSave({
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'age': _ageController.text,
        'diagnosis': _diagnosisController.text,
        'personality': _personalityController.text,
        'meds': _medsController.text,
        'routine': _routineController.text,
        'hasAllergies': _hasAllergies,
        'allergyType': _hasAllergies ? _allergyTypeController.text : null,
        'hasTriggers': _hasTriggers,
        'triggerType': _hasTriggers ? _triggersTypeController.text : null,
        'calming': _calmingController.text,
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
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Text(
                  'Add a Child',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, color: Color(0xFF1A1A1A)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Form Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildField(_firstNameController, 'First Name*'),
                    const SizedBox(height: 12),
                    _buildField(_lastNameController, 'Last Name*'),
                    const SizedBox(height: 12),
                    _buildField(_ageController, 'Age*', isNum: true),
                    const SizedBox(height: 12),
                    _buildField(
                        _diagnosisController, 'Special Needs Diagnosis*'),
                    const SizedBox(height: 8),
                    Text(
                      '*Include any diagnoses or areas where your child may need extra support. Leave blank if unsure or still exploring.',
                      style: TextStyle(
                          fontSize: 12,
                          color: const Color(0xFF1A1A1A).withAlpha(153)),
                    ),
                    const SizedBox(height: 12),

                    // Personality - Taller
                    _buildField(_personalityController,
                        'Child\'s Personality Description',
                        maxLines: 5),
                    const SizedBox(height: 12),

                    _buildField(_medsController, 'Medication & Dietary Needs*'),
                    const SizedBox(height: 12),
                    _buildField(_routineController, 'Routine*'),
                    const SizedBox(height: 16),

                    // Allergies Checkbox
                    _buildCheckbox('Allergies', _hasAllergies,
                        (v) => setState(() => _hasAllergies = v!)),
                    if (_hasAllergies) ...[
                      const SizedBox(height: 8),
                      _buildField(_allergyTypeController, 'Type of Allergy'),
                    ],
                    const SizedBox(height: 16),

                    // Triggers Checkbox
                    _buildCheckbox('Type of Triggers', _hasTriggers,
                        (v) => setState(() => _hasTriggers = v!)),
                    if (_hasTriggers) ...[
                      const SizedBox(height: 8),
                      _buildField(_triggersTypeController, 'Type of Triggers'),
                    ],
                    const SizedBox(height: 12),

                    _buildField(_calmingController, 'Calming Method'),
                  ],
                ),
              ),
            ),
          ),

          // Footer Buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF667085),
                    ),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: 120,
                  child: PrimaryActionButton(
                    label: 'Save',
                    onPressed: _onSave,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String hint,
      {bool isNum = false, int maxLines = 1}) {
    // Only show separate label if it's not the hint inside
    // Figma shows Labels outside? No, screenshot shows Hint inside.
    // Actually Figma screenshot shows: "First Name*" inside the box.
    // So we keep it as hint text.

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white, // Ensure white container background
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0D101828), // Very subtle shadow
                offset: Offset(0, 1),
                blurRadius: 2,
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: isNum ? TextInputType.number : TextInputType.text,
            maxLines: maxLines,
            style: const TextStyle(
                color: Color(0xFF1A1A1A), fontSize: 16), // Dark Text
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                  color: Color(0xFF667085), fontSize: 16), // Grey Hint
              filled: true, // Force filled
              fillColor: Colors.white, // Force white
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
                borderSide: const BorderSide(color: AuthTheme.primaryBlue),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AuthTheme.errorRed),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              isDense: true,
            ),
            validator: (v) {
              if (hint.endsWith('*') && (v == null || v.isEmpty)) {
                return 'Required';
              }
              return null;
            },
            onTapOutside: (event) =>
                FocusManager.instance.primaryFocus?.unfocus(),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckbox(String label, bool value, Function(bool?) onChanged) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Hug content
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: Checkbox(
              value: value,
              activeColor: AuthTheme.primaryBlue,
              side: const BorderSide(color: Color(0xFFD0D5DD), width: 1.5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)), // Slightly rounded
              onChanged: onChanged,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14, // Slightly smaller match design
              fontWeight: FontWeight.w500,
              color: Color(0xFF344054), // Dark grey
            ),
          ),
        ],
      ),
    );
  }
}
