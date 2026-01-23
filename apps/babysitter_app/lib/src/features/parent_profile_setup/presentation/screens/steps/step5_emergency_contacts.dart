import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../common/theme/auth_theme.dart';
import '../../../../../../common/widgets/primary_action_button.dart';
import '../../../../auth/presentation/widgets/step_indicator.dart';
import '../../widgets/add_emergency_contact_dialog.dart';
import 'package:babysitter_app/src/common_widgets/app_toast.dart';

/// Step 5: Emergency Contacts - List with add button
class Step5EmergencyContacts extends ConsumerStatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final Map<String, dynamic> profileData;

  const Step5EmergencyContacts({
    super.key,
    required this.onNext,
    required this.onBack,
    required this.profileData,
  });

  @override
  ConsumerState<Step5EmergencyContacts> createState() =>
      _Step5EmergencyContactsState();
}

class _Step5EmergencyContactsState
    extends ConsumerState<Step5EmergencyContacts> {
  List<Map<String, dynamic>> _contacts = [];

  @override
  void initState() {
    super.initState();
    _contacts = List<Map<String, dynamic>>.from(
        widget.profileData['emergencyContacts'] as List? ?? []);
  }

  void _addContact() {
    showDialog(
      context: context,
      builder: (context) => AddEmergencyContactDialog(
        onSave: (contact) {
          setState(() => _contacts.add(contact));
        },
      ),
    );
  }

  void _editContact(int index) {
    showDialog(
      context: context,
      builder: (context) => AddEmergencyContactDialog(
        existingContact: _contacts[index],
        onSave: (contact) {
          setState(() => _contacts[index] = contact);
        },
      ),
    );
  }

  void _deleteContact(int index) {
    setState(() => _contacts.removeAt(index));
  }

  void _saveAndNext() {
    if (_contacts.isEmpty) {
      AppToast.show(context, 
        const SnackBar(
          content: Text('Please add at least one emergency contact'),
          backgroundColor: AuthTheme.errorRed,
        ),
      );
      return;
    }
    widget.profileData['emergencyContacts'] = _contacts;
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuthTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    StepIndicator(
                      currentStep: 4,
                      totalSteps: 6,
                      onBack: widget.onBack,
                      onHelp: () {},
                    ),
                    const SizedBox(height: 24),

                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: AuthTheme.coralAccent.withAlpha(30),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.emergency_outlined,
                        size: 36,
                        color: AuthTheme.coralAccent,
                      ),
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      'Emergency Contact',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A1A),
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Text(
                      'Add contacts who can be reached in case of emergency',
                      style: TextStyle(
                        fontSize: 14,
                        color: AuthTheme.textDark.withAlpha(153),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Contacts list
                    ..._contacts.asMap().entries.map((entry) {
                      final index = entry.key;
                      final contact = entry.value;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: AuthTheme.coralAccent.withAlpha(30),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.person_outline,
                                color: AuthTheme.coralAccent,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    contact['name'] as String,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF1A1A1A),
                                    ),
                                  ),
                                  Text(
                                    contact['relation'] as String,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: AuthTheme.textDark.withAlpha(153),
                                    ),
                                  ),
                                  Text(
                                    contact['phone'] as String,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AuthTheme.primaryBlue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit_outlined, size: 20),
                              onPressed: () => _editContact(index),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  size: 20, color: AuthTheme.errorRed),
                              onPressed: () => _deleteContact(index),
                            ),
                          ],
                        ),
                      );
                    }),

                    // Add contact button
                    GestureDetector(
                      onTap: _addContact,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AuthTheme.coralAccent,
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_circle_outline,
                              color: AuthTheme.coralAccent,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Add Emergency Contact',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AuthTheme.coralAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: PrimaryActionButton(
                label: 'Next',
                onPressed: _saveAndNext,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
