import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../common/theme/auth_theme.dart';
import '../../../../../../common/widgets/primary_action_button.dart';
import '../../../../auth/presentation/widgets/step_indicator.dart';
import '../../widgets/add_child_dialog.dart';

/// Step 3: Add Kids - List of children with add button
class Step3Kids extends ConsumerStatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final Map<String, dynamic> profileData;

  const Step3Kids({
    super.key,
    required this.onNext,
    required this.onBack,
    required this.profileData,
  });

  @override
  ConsumerState<Step3Kids> createState() => _Step3KidsState();
}

class _Step3KidsState extends ConsumerState<Step3Kids> {
  List<Map<String, dynamic>> _kids = [];

  @override
  void initState() {
    super.initState();
    _kids = List<Map<String, dynamic>>.from(
        widget.profileData['kids'] as List? ?? []);
  }

  void _addChild() {
    showDialog(
      context: context,
      builder: (context) => AddChildDialog(
        onSave: (child) {
          setState(() => _kids.add(child));
        },
      ),
    );
  }

  void _editChild(int index) {
    showDialog(
      context: context,
      builder: (context) => AddChildDialog(
        existingChild: _kids[index],
        onSave: (child) {
          setState(() => _kids[index] = child);
        },
      ),
    );
  }

  void _deleteChild(int index) {
    setState(() => _kids.removeAt(index));
  }

  void _saveAndNext() {
    if (_kids.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one child'),
          backgroundColor: AuthTheme.errorRed,
        ),
      );
      return;
    }
    widget.profileData['kids'] = _kids;
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
                      currentStep: 2,
                      totalSteps: 6,
                      onBack: widget.onBack,
                      onHelp: () {},
                    ),
                    const SizedBox(height: 24),

                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: AuthTheme.primaryBlue.withAlpha(30),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.child_friendly,
                        size: 36,
                        color: AuthTheme.primaryBlue,
                      ),
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      'Add Kids',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A1A),
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Text(
                      'Add your children and their special care needs',
                      style: TextStyle(
                        fontSize: 14,
                        color: AuthTheme.textDark.withAlpha(153),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Kids list
                    ..._kids.asMap().entries.map((entry) {
                      final index = entry.key;
                      final kid = entry.value;
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
                                color: AuthTheme.primaryBlue.withAlpha(30),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.child_care,
                                color: AuthTheme.primaryBlue,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    kid['name'] as String,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF1A1A1A),
                                    ),
                                  ),
                                  Text(
                                    '${kid['age']} years old',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: AuthTheme.textDark.withAlpha(153),
                                    ),
                                  ),
                                  if ((kid['specialNeeds'] as List?)
                                          ?.isNotEmpty ??
                                      false)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Wrap(
                                        spacing: 4,
                                        children: (kid['specialNeeds'] as List)
                                            .map((need) {
                                          return Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: AuthTheme.primaryBlue
                                                  .withAlpha(25),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              need as String,
                                              style: const TextStyle(
                                                fontSize: 11,
                                                color: AuthTheme.primaryBlue,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit_outlined, size: 20),
                              onPressed: () => _editChild(index),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  size: 20, color: AuthTheme.errorRed),
                              onPressed: () => _deleteChild(index),
                            ),
                          ],
                        ),
                      );
                    }),

                    // Add child button
                    GestureDetector(
                      onTap: _addChild,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AuthTheme.primaryBlue,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_circle_outline,
                              color: AuthTheme.primaryBlue,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Add a Child',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AuthTheme.primaryBlue,
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
