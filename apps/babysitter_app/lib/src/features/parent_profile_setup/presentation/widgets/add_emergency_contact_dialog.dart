import 'package:flutter/material.dart';

import '../../../../../../common/theme/auth_theme.dart';
import '../../../../../../common/widgets/primary_action_button.dart';
import '../../../auth/presentation/widgets/auth_input_field.dart';

/// Dialog for adding an emergency contact
class AddEmergencyContactDialog extends StatefulWidget {
  final Map<String, dynamic>? existingContact;
  final Function(Map<String, dynamic>) onSave;

  const AddEmergencyContactDialog({
    super.key,
    this.existingContact,
    required this.onSave,
  });

  @override
  State<AddEmergencyContactDialog> createState() =>
      _AddEmergencyContactDialogState();
}

class _AddEmergencyContactDialogState extends State<AddEmergencyContactDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _relationController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
        text: widget.existingContact?['name'] as String? ?? '');
    _relationController = TextEditingController(
        text: widget.existingContact?['relation'] as String? ?? '');
    _phoneController = TextEditingController(
        text: widget.existingContact?['phone'] as String? ?? '');
    _emailController = TextEditingController(
        text: widget.existingContact?['email'] as String? ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _relationController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    widget.onSave({
      'name': _nameController.text.trim(),
      'relation': _relationController.text.trim(),
      'phone': _phoneController.text.trim(),
      'email': _emailController.text.trim(),
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AuthTheme.coralAccent.withAlpha(30),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.emergency_outlined,
                      color: AuthTheme.coralAccent,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Emergency Contact',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              AuthInputField(
                controller: _nameController,
                hint: 'Full Name*',
                textInputAction: TextInputAction.next,
                validator: (v) => v?.isEmpty == true ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              AuthInputField(
                controller: _relationController,
                hint: 'Relationship (e.g., Grandmother)*',
                textInputAction: TextInputAction.next,
                validator: (v) => v?.isEmpty == true ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              AuthInputField(
                controller: _phoneController,
                hint: 'Phone Number*',
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                validator: (v) => v?.isEmpty == true ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              AuthInputField(
                controller: _emailController,
                hint: 'Email (optional)',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 24),
              PrimaryActionButton(
                label:
                    widget.existingContact != null ? 'Update' : 'Add Contact',
                onPressed: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
