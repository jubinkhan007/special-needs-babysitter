import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  late final TextEditingController _triggersController; // Description
  late final TextEditingController _calmingController;
  late final TextEditingController _pickupLocController;
  late final TextEditingController _dropoffLocController;
  late final TextEditingController _transportInstrController;
  late final TextEditingController _otherEquipmentController;

  // New State variables for Checkboxes
  List<String> _selectedTransportModes = [];
  List<String> _selectedEquipment = [];
  bool _hasAllergies = false;
  bool _hasTriggers = false;
  bool _needsDropoff = false;
  bool _otherEquipmentSelected = false;
  String? _validationError; // Inline validation error message

  static const _transportOptions = [
    'No transportation (care at home only)',
    'Walking only (short distance)',
    'Family vehicle with car seat provided',
    "Sitter's vehicle allowed (with parent consent)",
    'Ride-share allowed (with parent consent)',
    'Public transport allowed (with parent consent)',
  ];

  static const _equipmentOptions = [
    'Car seat required',
    'Booster seat required',
    'Wheelchair accessible',
  ];

  @override
  void initState() {
    super.initState();
    final c = widget.existingChild ?? {};
    _firstNameController = TextEditingController(text: c['firstName']);
    _lastNameController = TextEditingController(text: c['lastName']);
    _ageController = TextEditingController(text: c['age']?.toString());
    _diagnosisController =
        TextEditingController(text: c['specialNeedsDiagnosis']);
    _personalityController =
        TextEditingController(text: c['personalityDescription']);
    _medsController = TextEditingController(text: c['medicationDietaryNeeds']);
    _routineController = TextEditingController(text: c['routine']);
    _allergyTypeController = TextEditingController(
        text: (c['allergyTypes'] as List<dynamic>?)?.join(', '));
    _triggersTypeController = TextEditingController(
        text: (c['triggerTypes'] as List<dynamic>?)?.join(', '));
    _triggersController = TextEditingController(text: c['triggers']);
    _calmingController = TextEditingController(text: c['calmingMethods']);

    _pickupLocController = TextEditingController(text: c['pickupLocation']);
    _dropoffLocController = TextEditingController(text: c['dropoffLocation']);
    _transportInstrController =
        TextEditingController(text: c['transportSpecialInstructions']);

    _selectedTransportModes =
        (c['transportationModes'] as List<dynamic>?)?.cast<String>() ?? [];

    final equip =
        (c['equipmentSafety'] as List<dynamic>?)?.cast<String>() ?? [];
    _selectedEquipment = equip
        .where((e) => _equipmentOptions.contains(e) || e == 'Other')
        .toList();

    // Check if there's an 'Other: ...' or just check list
    // Filter out known options to find "Other" items
    final otherItems =
        equip.where((e) => !_equipmentOptions.contains(e)).toList();
    if (otherItems.isNotEmpty) {
      _otherEquipmentController =
          TextEditingController(text: otherItems.join(', '));
      _otherEquipmentSelected = true;
    } else {
      _otherEquipmentController = TextEditingController();
    }

    _hasAllergies = c['hasAllergies'] ?? false;
    _hasTriggers = c['hasTriggers'] ?? false;
    _needsDropoff = c['needsDropoff'] ?? false;
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
    _triggersController.dispose();
    _calmingController.dispose();
    _pickupLocController.dispose();
    _dropoffLocController.dispose();
    _transportInstrController.dispose();
    _otherEquipmentController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      // Validate pickup/dropoff fields if needsDropoff is checked
      if (_needsDropoff) {
        if (_pickupLocController.text.trim().isEmpty ||
            _dropoffLocController.text.trim().isEmpty) {
          setState(() {
            _validationError =
                'Please fill in Pickup and Drop-off locations, or uncheck the drop-off option.';
          });
          return;
        }
      }

      // Clear any previous error
      setState(() {
        _validationError = null;
      });

      // Debug logging for pickup/dropoff fields
      print('DEBUG AddChildDialog: needsDropoff=$_needsDropoff');
      print(
          'DEBUG AddChildDialog: pickupLocController.text=${_pickupLocController.text}');
      print(
          'DEBUG AddChildDialog: dropoffLocController.text=${_dropoffLocController.text}');
      print(
          'DEBUG AddChildDialog: transportInstrController.text=${_transportInstrController.text}');

      final pickupValue = _needsDropoff ? _pickupLocController.text : '';
      final dropoffValue = _needsDropoff ? _dropoffLocController.text : '';
      final instrValue = _needsDropoff ? _transportInstrController.text : '';

      print('DEBUG AddChildDialog: Sending pickupLocation=$pickupValue');
      print('DEBUG AddChildDialog: Sending dropoffLocation=$dropoffValue');

      widget.onSave({
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'age': int.tryParse(_ageController.text) ?? 0,
        'specialNeedsDiagnosis': _diagnosisController.text,
        'personalityDescription': _personalityController.text,
        'medicationDietaryNeeds': _medsController.text,
        'routine': _routineController.text,
        'hasAllergies': _hasAllergies,
        'allergyTypes': _hasAllergies && _allergyTypeController.text.isNotEmpty
            ? _allergyTypeController.text
                .split(',')
                .map((e) => e.trim())
                .toList()
            : [],
        'hasTriggers': _hasTriggers,
        'triggerTypes': _hasTriggers && _triggersTypeController.text.isNotEmpty
            ? _triggersTypeController.text
                .split(',')
                .map((e) => e.trim())
                .toList()
            : [],
        'triggers': _hasTriggers ? _triggersController.text : '',
        'calmingMethods': _calmingController.text,
        'transportationModes': _selectedTransportModes,
        'equipmentSafety': [
          ..._selectedEquipment,
          if (_otherEquipmentSelected &&
              _otherEquipmentController.text.isNotEmpty)
            ..._otherEquipmentController.text
                .split(',')
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty),
        ].cast<String>(),
        'needsDropoff': _needsDropoff,
        'pickupLocation': pickupValue,
        'dropoffLocation': dropoffValue,
        'transportSpecialInstructions': instrValue,
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
                Text(
                  widget.existingChild != null ? 'Update Child' : 'Add a Child',
                  style: const TextStyle(
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
                    _buildField(
                      _firstNameController,
                      'First Name*',
                      maxLength: 50,
                      minLength: 2,
                    ),
                    const SizedBox(height: 12),
                    _buildField(
                      _lastNameController,
                      'Last Name*',
                      maxLength: 50,
                      minLength: 2,
                    ),
                    const SizedBox(height: 12),
                    _buildField(
                      _ageController,
                      'Age*',
                      isNum: true,
                      maxLength: 2,
                    ),
                    const SizedBox(height: 12),
                    _buildField(
                      _diagnosisController,
                      'Special Needs Diagnosis*',
                      maxLength: 200,
                      minLength: 2,
                    ),
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
                        maxLines: 5,
                        maxLength: 500),
                    const SizedBox(height: 12),

                    _buildField(
                      _medsController,
                      'Medication & Dietary Needs*',
                      maxLength: 200,
                      minLength: 2,
                    ),
                    const SizedBox(height: 12),
                    _buildField(
                      _routineController,
                      'Routine*',
                      maxLength: 200,
                      minLength: 2,
                    ),
                    const SizedBox(height: 16),

                    // Allergies Checkbox
                    _buildSquareCheckbox('Allergies', _hasAllergies,
                        (v) => setState(() => _hasAllergies = v!)),
                    if (_hasAllergies) ...[
                      const SizedBox(height: 8),
                      _buildField(
                        _allergyTypeController,
                        'Type of Allergy',
                        maxLength: 100,
                      ),
                    ],
                    const SizedBox(height: 16),

                    // Triggers Checkbox
                    _buildSquareCheckbox('Type of Triggers', _hasTriggers,
                        (v) => setState(() => _hasTriggers = v!)),
                    if (_hasTriggers) ...[
                      const SizedBox(height: 8),
                      _buildField(
                        _triggersTypeController,
                        'Type of Triggers',
                        maxLength: 100,
                      ),
                    ],
                    const SizedBox(height: 12),

                    _buildField(_calmingController, 'Calming Method',
                        maxLines: 2,
                        maxLength: 200),

                    const SizedBox(height: 24),

                    // --- Transportation Section ---
                    const Text(
                      'Transportation Preferences (Optional)',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Used to help sitters understand your child\'s transportation routine, special sitter needs does not provide or assume responsibility for transportation.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF475467),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      'Transportation Mode',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF344054)),
                    ),
                    const SizedBox(height: 8),
                    ..._transportOptions.map((mode) => _buildSquareCheckbox(
                          mode,
                          _selectedTransportModes.contains(mode),
                          (val) {
                            setState(() {
                              if (val == true) {
                                _selectedTransportModes.add(mode);
                              } else {
                                _selectedTransportModes.remove(mode);
                              }
                            });
                          },
                        )),
                    const SizedBox(height: 12),

                    _buildSquareCheckbox(
                      'Does your child need to be dropped off at therapy, school, or an activity?',
                      _needsDropoff,
                      (v) => setState(() => _needsDropoff = v!),
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      'Equipment & Safety',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF344054)),
                    ),
                    const SizedBox(height: 8),
                    ..._equipmentOptions.map((eq) => _buildSquareCheckbox(
                          eq,
                          _selectedEquipment.contains(eq),
                          (val) {
                            setState(() {
                              if (val == true) {
                                _selectedEquipment.add(eq);
                              } else {
                                _selectedEquipment.remove(eq);
                              }
                            });
                          },
                        )),
                    // Other's Checkbox
                    _buildSquareCheckbox(
                      "Other\'s",
                      _otherEquipmentSelected,
                      (v) => setState(() => _otherEquipmentSelected = v!),
                    ),
                    if (_otherEquipmentSelected) ...[
                      const SizedBox(height: 8),
                      _buildField(
                        _otherEquipmentController,
                        'Other Equipment',
                        maxLength: 120,
                      ),
                    ],

                    const SizedBox(height: 16),

                    if (_needsDropoff) ...[
                      const SizedBox(height: 16),
                      const Text(
                        'Pickup / Drop-off Details',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF344054)),
                      ),
                      const SizedBox(height: 8),
                      _buildField(_pickupLocController,
                          'Pickup Location (e.g., School gate)',
                          maxLength: 120),
                      const SizedBox(height: 8),
                      _buildField(_dropoffLocController,
                          'Drop-off Location (e.g. 123 Main ST)',
                          maxLength: 120),
                      const SizedBox(height: 8),
                      _buildField(_transportInstrController,
                          'Special Instructions (e.g. Avoid highways)',
                          maxLines: 3,
                          maxLength: 240),
                    ],
                  ],
                ),
              ),
            ),
          ),

          // Inline Error Message
          if (_validationError != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: const Color(0xFFFEE4E2),
              child: Row(
                children: [
                  const Icon(Icons.error_outline,
                      color: Color(0xFFD92D20), size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _validationError!,
                      style: const TextStyle(
                        color: Color(0xFFD92D20),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
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

  Widget _buildField(
    TextEditingController controller,
    String hint, {
    bool isNum = false,
    int maxLines = 1,
    int? maxLength,
    int? minLength,
  }) {
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
            inputFormatters: [
              if (isNum) FilteringTextInputFormatter.digitsOnly,
              if (maxLength != null)
                LengthLimitingTextInputFormatter(maxLength),
            ],
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
              counterText: '',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                if (hint.endsWith('*'))
                  return 'Required'; // Simple required check
                return null;
              }
              if (minLength != null && value.trim().length < minLength) {
                return 'Must be at least $minLength characters';
              }
              if (maxLength != null && value.trim().length > maxLength) {
                return 'Must be $maxLength characters or less';
              }
              if (isNum) {
                final n = int.tryParse(value);
                if (n == null) return 'Must be a number';
                if (hint.contains('Age')) {
                  if (n < 0 || n > 18) return 'Age must be between 0 and 18';
                }
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

  Widget _buildSquareCheckbox(
      String label, bool value, Function(bool?) onChanged) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14, // Slightly smaller match design
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF344054), // Dark grey
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
