import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/core.dart';
import '../../../../../../common/widgets/primary_action_button.dart';
import '../../../../auth/presentation/widgets/step_indicator.dart';

/// Step 6: Review Info - Summary of all entered data
class Step6Review extends ConsumerWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final Map<String, dynamic> profileData;

  const Step6Review({
    super.key,
    required this.onNext,
    required this.onBack,
    required this.profileData,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasSpouse = profileData['hasSpouse'] as bool? ?? false;
    final spouse = profileData['spouse'] as Map<String, dynamic>? ?? {};
    final kids = profileData['kids'] as List? ?? [];
    final services = profileData['services'] as List? ?? [];
    final contacts = profileData['emergencyContacts'] as List? ?? [];

    return Scaffold(
      backgroundColor: AppColors.background,
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
                      currentStep: 5,
                      totalSteps: 6,
                      onBack: onBack,
                      onHelp: () {},
                    ),
                    const SizedBox(height: 24),

                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withAlpha(30),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.fact_check_outlined,
                        size: 36,
                        color: AppColors.secondary,
                      ),
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      'Review Info',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A1A),
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Text(
                      'Please review your information before submitting',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textPrimary.withAlpha(153),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Spouse Section
                    _ReviewSection(
                      title: 'Spouse/Partner',
                      icon: Icons.people_outline,
                      child: hasSpouse
                          ? Text(
                              '${spouse['firstName']} ${spouse['lastName']}',
                              style: const TextStyle(fontSize: 14),
                            )
                          : Text(
                              'None added',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textPrimary.withAlpha(128),
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                    ),
                    const SizedBox(height: 16),

                    // Kids Section
                    _ReviewSection(
                      title: 'Children',
                      icon: Icons.child_friendly,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: kids.isEmpty
                            ? [
                                Text(
                                  'None added',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textPrimary.withAlpha(128),
                                    fontStyle: FontStyle.italic,
                                  ),
                                )
                              ]
                            : kids.map((kid) {
                                final kidMap = kid as Map<String, dynamic>;
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    children: [
                                      Text(
                                        '${kidMap['name']}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        ' (${kidMap['age']} years)',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color:
                                              AppColors.textPrimary.withAlpha(153),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Services Section
                    _ReviewSection(
                      title: 'Care Services',
                      icon: Icons.health_and_safety_outlined,
                      child: services.isEmpty
                          ? Text(
                              'None selected',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textPrimary.withAlpha(128),
                                fontStyle: FontStyle.italic,
                              ),
                            )
                          : Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: services.map((s) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.secondary.withAlpha(25),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    _formatServiceName(s as String),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.secondary,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                    ),
                    const SizedBox(height: 16),

                    // Emergency Contacts Section
                    _ReviewSection(
                      title: 'Emergency Contacts',
                      icon: Icons.emergency_outlined,
                      iconColor: AppColors.coralAccent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: contacts.isEmpty
                            ? [
                                Text(
                                  'None added',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textPrimary.withAlpha(128),
                                    fontStyle: FontStyle.italic,
                                  ),
                                )
                              ]
                            : contacts.map((contact) {
                                final c = contact as Map<String, dynamic>;
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${c['name']} (${c['relation']})',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        c['phone'] as String,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: AppColors.secondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
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
                label: 'Submit Profile',
                onPressed: onNext,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatServiceName(String id) {
    return id
        .split('_')
        .map((w) => w[0].toUpperCase() + w.substring(1))
        .join(' ');
  }
}

class _ReviewSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color? iconColor;
  final Widget child;

  const _ReviewSection({
    required this.title,
    required this.icon,
    this.iconColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: iconColor ?? AppColors.secondary),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
