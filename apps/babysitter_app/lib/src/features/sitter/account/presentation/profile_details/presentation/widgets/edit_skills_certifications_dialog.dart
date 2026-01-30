import 'package:flutter/material.dart';
import 'package:babysitter_app/src/common_widgets/app_toast.dart';
import 'package:babysitter_app/common/widgets/primary_action_button.dart';
import '../../../../../../sitter_profile_setup/presentation/widgets/multi_select_accordion.dart';
import '../../../../../../sitter_profile_setup/presentation/widgets/selectable_chip_group.dart';
import '../../../../../../sitter_profile_setup/presentation/widgets/labeled_dropdown_field.dart';

class SkillsCertificationsPayload {
  final List<String> skills;
  final List<String> certifications;
  final List<String> ageRanges;
  final String? yearsOfExperience;

  const SkillsCertificationsPayload({
    required this.skills,
    required this.certifications,
    required this.ageRanges,
    required this.yearsOfExperience,
  });
}

class EditSkillsCertificationsDialog extends StatefulWidget {
  final List<String> initialSkills;
  final List<String> initialCertifications;
  final List<String> initialAgeRanges;
  final String? initialYearsOfExperience;
  final Future<bool> Function(SkillsCertificationsPayload payload) onSave;

  const EditSkillsCertificationsDialog({
    super.key,
    required this.initialSkills,
    required this.initialCertifications,
    required this.initialAgeRanges,
    required this.initialYearsOfExperience,
    required this.onSave,
  });

  @override
  State<EditSkillsCertificationsDialog> createState() =>
      _EditSkillsCertificationsDialogState();
}

class _EditSkillsCertificationsDialogState
    extends State<EditSkillsCertificationsDialog> {
  static const _textDark = Color(0xFF1A1A1A);
  static const _primaryBlue = Color(0xFF88CBE6);
  static const _greyText = Color(0xFF667085);

  final List<String> _availableCertifications = const [
    'CPR Certification',
    'First Aid Certification',
    'Childcare or Babysitting Certification',
    'Special Needs Care Training',
    'Background Check Clearance',
    'Health & Safety Training',
    'Early Childhood Education Courses',
    'Behavioral Management Training',
    'Medication Administration Certification',
    'None At This Time',
  ];

  final List<String> _availableSkills = const [
    'Patience & empathy',
    'Non-verbal communication skills',
    'Behavior management',
    'Crisis de-escalation',
    'Routine & structure planning',
    'Sensory awareness',
    'Toileting & hygiene support',
    'Social-emotional coaching',
    'Flexible thinking & adaptability',
    'Medication Administration',
    'Mobility & Transfer Support',
    'Communication Support',
    'Homework/Tutoring Support',
  ];

  late List<String> _skills;
  late List<String> _certifications;
  late List<String> _ageRanges;
  String? _yearsOfExperience;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _skills = List<String>.from(widget.initialSkills);
    _certifications = List<String>.from(widget.initialCertifications);
    _ageRanges = _normalizeAgeRanges(widget.initialAgeRanges);
    _yearsOfExperience = widget.initialYearsOfExperience;
  }

  List<String> _normalizeAgeRanges(List<String> values) {
    const options = ['Infants', 'Toddlers', 'Children', 'Teens'];
    final normalized = <String>{};
    for (final value in values) {
      final cleaned = value.trim().toLowerCase();
      final match = options.firstWhere(
        (option) => option.toLowerCase() == cleaned,
        orElse: () => value,
      );
      normalized.add(match);
    }
    return normalized.toList();
  }

  Future<void> _handleSave() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

    final payload = SkillsCertificationsPayload(
      skills: _skills,
      certifications: _certifications,
      ageRanges: _ageRanges,
      yearsOfExperience: _yearsOfExperience,
    );

    final success = await widget.onSave(payload);
    if (!mounted) return;

    if (success) {
      Navigator.of(context).pop();
    } else {
      AppToast.show(
        context,
        const SnackBar(content: Text('Failed to update profile')),
      );
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Edit Skills & Certifications',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1D2939),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: _greyText),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MultiSelectAccordion(
                    title: 'Select Certifications',
                    options: _availableCertifications,
                    selectedValues: _certifications,
                    onChanged: (values) =>
                        setState(() => _certifications = values),
                    onOtherTap: () {
                      AppToast.show(
                        context,
                        const SnackBar(
                            content: Text('Add other certification coming soon')),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  MultiSelectAccordion(
                    title: 'Select Skills',
                    options: _availableSkills,
                    selectedValues: _skills,
                    onChanged: (values) => setState(() => _skills = values),
                    onOtherTap: () {
                      AppToast.show(
                        context,
                        const SnackBar(
                            content: Text('Add other skill coming soon')),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  SelectableChipGroup(
                    title: 'Age Range(s) Experience',
                    options: const ['Infants', 'Toddlers', 'Children', 'Teens'],
                    selectedValues: _ageRanges,
                    onSelected: (val) {
                      setState(() {
                        if (_ageRanges.contains(val)) {
                          _ageRanges.remove(val);
                        } else {
                          _ageRanges.add(val);
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  LabeledDropdownField(
                    label: 'Years of Experience',
                    hint: 'Select Year',
                    value: _yearsOfExperience,
                    items: const [
                      '< 1 year',
                      '1-3 years',
                      '3-5 years',
                      '5+ years'
                    ],
                    onChanged: (val) =>
                        setState(() => _yearsOfExperience = val),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Update your years of experience to match your profile.',
                    style: TextStyle(fontSize: 12, color: _greyText),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          Padding(
            padding: const EdgeInsets.all(16),
            child: PrimaryActionButton(
              label: _isSaving ? 'Saving...' : 'Save Changes',
              onPressed: _isSaving ? null : _handleSave,
              backgroundColor: _primaryBlue,
            ),
          ),
        ],
      ),
    );
  }
}
