import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../common/theme/auth_theme.dart';
import '../../../../../../common/widgets/primary_action_button.dart';
import '../../../../auth/presentation/widgets/step_indicator.dart';

/// Step 4: Care/Special Services - Checkbox list
class Step4Services extends ConsumerStatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final Map<String, dynamic> profileData;

  const Step4Services({
    super.key,
    required this.onNext,
    required this.onBack,
    required this.profileData,
  });

  @override
  ConsumerState<Step4Services> createState() => _Step4ServicesState();
}

class _Step4ServicesState extends ConsumerState<Step4Services> {
  late Set<String> _selectedServices;

  static const _serviceOptions = [
    {
      'id': 'bathing',
      'title': 'Bathing/Hygiene Assistance',
      'icon': Icons.bathtub_outlined
    },
    {
      'id': 'feeding',
      'title': 'Feeding Assistance',
      'icon': Icons.restaurant_outlined
    },
    {
      'id': 'medication',
      'title': 'Medication Administration',
      'icon': Icons.medication_outlined
    },
    {
      'id': 'mobility',
      'title': 'Mobility Support',
      'icon': Icons.accessible_outlined
    },
    {
      'id': 'therapy',
      'title': 'Therapy Exercise Support',
      'icon': Icons.fitness_center_outlined
    },
    {
      'id': 'behavioral',
      'title': 'Behavioral Support',
      'icon': Icons.psychology_outlined
    },
    {
      'id': 'medical_equipment',
      'title': 'Medical Equipment Care',
      'icon': Icons.medical_services_outlined
    },
    {
      'id': 'communication',
      'title': 'Communication Support',
      'icon': Icons.record_voice_over_outlined
    },
    {
      'id': 'sensory',
      'title': 'Sensory Activities',
      'icon': Icons.touch_app_outlined
    },
    {
      'id': 'overnight',
      'title': 'Overnight Care',
      'icon': Icons.nightlight_outlined
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedServices =
        Set<String>.from(widget.profileData['services'] as List? ?? []);
  }

  void _toggleService(String id) {
    setState(() {
      if (_selectedServices.contains(id)) {
        _selectedServices.remove(id);
      } else {
        _selectedServices.add(id);
      }
    });
  }

  void _saveAndNext() {
    widget.profileData['services'] = _selectedServices.toList();
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
                      currentStep: 3,
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
                        Icons.health_and_safety_outlined,
                        size: 36,
                        color: AuthTheme.primaryBlue,
                      ),
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      'Care/Special Services',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A1A),
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Text(
                      'Select the services your family may need',
                      style: TextStyle(
                        fontSize: 14,
                        color: AuthTheme.textDark.withAlpha(153),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Service checkboxes
                    ..._serviceOptions.map((service) {
                      final isSelected =
                          _selectedServices.contains(service['id']);
                      return GestureDetector(
                        onTap: () => _toggleService(service['id'] as String),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AuthTheme.primaryBlue.withAlpha(25)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? AuthTheme.primaryBlue
                                  : const Color(0xFFE5E7EB),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AuthTheme.primaryBlue.withAlpha(51)
                                      : const Color(0xFFF5F5F5),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  service['icon'] as IconData,
                                  color: isSelected
                                      ? AuthTheme.primaryBlue
                                      : const Color(0xFF6B7280),
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  service['title'] as String,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                    color: isSelected
                                        ? AuthTheme.primaryBlue
                                        : const Color(0xFF1A1A1A),
                                  ),
                                ),
                              ),
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isSelected
                                      ? AuthTheme.primaryBlue
                                      : Colors.white,
                                  border: Border.all(
                                    color: isSelected
                                        ? AuthTheme.primaryBlue
                                        : const Color(0xFFD0D5DD),
                                    width: 2,
                                  ),
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
                    }),
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
