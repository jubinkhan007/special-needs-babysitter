import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:domain/domain.dart';
import 'package:babysitter_app/common/theme/auth_theme.dart';

class EditEmergencyContactDialog extends StatefulWidget {
  final EmergencyContact? initialContact;
  final Function(Map<String, dynamic>) onSave;

  const EditEmergencyContactDialog({
    super.key,
    this.initialContact,
    required this.onSave,
  });

  @override
  State<EditEmergencyContactDialog> createState() =>
      _EditEmergencyContactDialogState();
}

class _EditEmergencyContactDialogState
    extends State<EditEmergencyContactDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameController;
  late TextEditingController _relationshipController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late TextEditingController _instructionsController;

  bool _wantToAddContact = true;

  @override
  void initState() {
    super.initState();
    final c = widget.initialContact;
    _fullNameController = TextEditingController(text: c?.fullName ?? '');
    _relationshipController =
        TextEditingController(text: c?.relationshipToChild ?? '');
    _phoneController = TextEditingController(text: c?.phoneNumber ?? '');
    _emailController = TextEditingController(text: c?.email ?? '');
    _addressController = TextEditingController(text: c?.address ?? '');
    _instructionsController =
        TextEditingController(text: c?.specialInstructions ?? '');

    // If no initial contact, default to checked as user tapped 'add/edit'
    _wantToAddContact = true;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _relationshipController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onSave({
        'fullName': _fullNameController.text,
        'relationshipToChild': _relationshipController.text,
        'primaryPhone': _phoneController.text,
        'email': _emailController.text,
        'address': _addressController.text,
        'specialInstructions': _instructionsController.text,
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
                const SizedBox(
                    width: 24), // Spacer for centering if needed, or icon
                // Just matching design "Emergency Contact" title in body,
                // but dialog usually needs header or close button.
                // Design shows full screen stack? No, user requested Dialog.
                // We'll add a header for closure.
                const Expanded(
                  child: Text(
                    'Emergency Contact',
                    textAlign: TextAlign.center,
                    style: TextStyle(
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Checkbox "Want to add Emergency Contact?"
                    Row(
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                            value: _wantToAddContact,
                            activeColor: AuthTheme.primaryBlue,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                            onChanged: (v) =>
                                setState(() => _wantToAddContact = v!),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Want to add Emergency Contact?',
                          style:
                              TextStyle(fontSize: 14, color: Color(0xFF344054)),
                        )
                      ],
                    ),
                    const SizedBox(height: 16),

                    if (_wantToAddContact) ...[
                      _buildField(_fullNameController, 'Full Name*'),
                      const SizedBox(height: 12),
                      _buildField(
                          _relationshipController, 'Relationship to Child*'),
                      const SizedBox(height: 12),
                      _buildField(_phoneController, 'Primary Phone Number*',
                          isNum: true),
                      const SizedBox(height: 12),
                      _buildField(_emailController, 'Email Address'),
                      const SizedBox(height: 12),
                      _buildField(_addressController, 'Address'),
                      const SizedBox(height: 12),
                      _buildField(
                          _instructionsController, 'Special Instructions*',
                          maxLines: 1),
                    ],
                  ],
                ),
              ),
            ),
          ),

          // Save Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AuthTheme.primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String hint,
      {bool isNum = false, int maxLines = 1}) {
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
                ? TextInputType.phone
                : (hint.toLowerCase().contains('email')
                    ? TextInputType.emailAddress
                    : TextInputType.text),
            inputFormatters:
                isNum ? [FilteringTextInputFormatter.digitsOnly] : [],
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
                borderSide: const BorderSide(color: AuthTheme.primaryBlue),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              isDense: true,
            ),
            validator: (value) {
              if (hint.contains('Email') && value != null && value.isNotEmpty) {
                // Basic email regex
                final emailRegex = RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                if (!emailRegex.hasMatch(value)) {
                  return 'Please enter a valid email address';
                }
              }

              if (hint.endsWith('*') && (value == null || value.isEmpty)) {
                // Remove asterisk for message
                return '${hint.replaceAll('*', '')} is required';
              }

              if (isNum &&
                  value != null &&
                  value.isNotEmpty &&
                  value.length < 10) {
                return 'Please enter a valid phone number (at least 10 digits)';
              }

              return null;
            },
          ),
        ),
      ],
    );
  }
}
