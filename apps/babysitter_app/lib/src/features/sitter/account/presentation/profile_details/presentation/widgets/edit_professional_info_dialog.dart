import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:babysitter_app/common/widgets/primary_action_button.dart';
import 'package:babysitter_app/src/common_widgets/app_toast.dart';
import '../../../../../../sitter_profile_setup/presentation/widgets/bio_text_area_card.dart';
import '../../../../../../sitter_profile_setup/presentation/widgets/dob_dropdown_row.dart';
import '../../../../../../sitter_profile_setup/presentation/widgets/labeled_dropdown_field.dart';
import '../../../../../../sitter_profile_setup/presentation/widgets/selectable_chip_group.dart';
import '../../../../../../sitter_profile_setup/presentation/widgets/transportation_section.dart';
import '../../../../../../sitter_profile_setup/presentation/widgets/willing_to_travel_section.dart';
import '../../data/sitter_me_dto.dart';

class EditProfessionalInfoDialog extends StatefulWidget {
  final SitterMeProfileDto profile;
  final Future<bool> Function(Map<String, dynamic> payload) onSave;

  const EditProfessionalInfoDialog({
    super.key,
    required this.profile,
    required this.onSave,
  });

  @override
  State<EditProfessionalInfoDialog> createState() =>
      _EditProfessionalInfoDialogState();
}

class _EditProfessionalInfoDialogState
    extends State<EditProfessionalInfoDialog> {
  late String _bio;
  late DateTime? _dob;
  late List<String> _ageGroups;
  late List<String> _languages;
  late String? _yearsExperience;
  late bool _hasTransportation;
  late String? _transportationDetails;
  late bool _willingToTravel;
  late bool _overnightAvailable;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _bio = widget.profile.bio ?? '';
    _dob = _parseDob(widget.profile.dateOfBirth);
    _ageGroups = _normalizeAgeRanges(widget.profile.ageRanges ?? []);
    _languages = List<String>.from(widget.profile.languages ?? []);
    _yearsExperience = widget.profile.yearsOfExperience;
    _hasTransportation = widget.profile.hasTransportation ?? false;
    _transportationDetails = widget.profile.transportationDetails;
    _willingToTravel = widget.profile.willingToTravel ?? false;
    _overnightAvailable = widget.profile.overnightAvailable ?? false;
  }

  DateTime? _parseDob(String? value) {
    if (value == null || value.isEmpty) return null;
    final parsed = DateTime.tryParse(value);
    if (parsed != null) return parsed;
    try {
      return DateFormat('MM/dd/yyyy').parse(value);
    } catch (_) {
      return null;
    }
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

  Future<void> _onSave() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

    final payload = {
      'bio': _bio,
      'dateOfBirth':
          _dob != null ? DateFormat('MM/dd/yyyy').format(_dob!) : null,
      'yearsOfExperience': _yearsExperience,
      'hasTransportation': _hasTransportation,
      'transportationDetails': _transportationDetails ?? '',
      'willingToTravel': _willingToTravel,
      'overnight': _overnightAvailable,
      'ageRanges': _ageGroups,
      'languages': _languages,
    };
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
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Edit Professional Info',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1D2939),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Color(0xFF667085)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),

          // Scrollable Content
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BioTextAreaCard(
                    text: _bio,
                    onChanged: (val) => setState(() => _bio = val),
                  ),
                  const SizedBox(height: 24),
                  DobDropdownRow(
                    dob: _dob,
                    onDateSelected: (val) => setState(() => _dob = val),
                  ),
                  const SizedBox(height: 24),
                  SelectableChipGroup(
                    title: 'Age Range(s) Experience',
                    options: const [
                      'Infants',
                      'Toddlers',
                      'Children',
                      'Teens'
                    ],
                    selectedValues: _ageGroups,
                    onSelected: (val) {
                      setState(() {
                        if (_ageGroups.contains(val)) {
                          _ageGroups.remove(val);
                        } else {
                          _ageGroups.add(val);
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  LabeledDropdownField(
                    label: 'Languages Spoken',
                    hint: 'Select Language',
                    value: null,
                    items: const ['English', 'Spanish', 'French', 'ASL'],
                    onChanged: (val) {
                      if (val != null && !_languages.contains(val)) {
                        setState(() => _languages.add(val));
                      }
                    },
                  ),
                  if (_languages.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Wrap(
                        spacing: 8,
                        children: _languages
                            .map((lang) => Chip(
                                  label: Text(lang),
                                  onDeleted: () =>
                                      setState(() => _languages.remove(lang)),
                                  backgroundColor: Colors.white,
                                ))
                            .toList(),
                      ),
                    ),
                  const SizedBox(height: 24),
                  LabeledDropdownField(
                    label: 'Years of Experience',
                    hint: 'Select Year',
                    value: _yearsExperience,
                    items: const [
                      '< 1 year',
                      '1-3 years',
                      '3-5 years',
                      '5+ years'
                    ],
                    onChanged: (val) => setState(() => _yearsExperience = val),
                  ),
                  const SizedBox(height: 24),
                  TransportationSection(
                    hasReliableTransportation: _hasTransportation,
                    details: _transportationDetails,
                    onToggle: (val) => setState(() => _hasTransportation = val),
                    onDetailsChanged: (val) =>
                        setState(() => _transportationDetails = val),
                  ),
                  const SizedBox(height: 24),
                  WillingToTravelSection(
                    willingToTravel: _willingToTravel,
                    overnightStay: _overnightAvailable,
                    onWillingChanged: (val) =>
                        setState(() => _willingToTravel = val),
                    onOvernightChanged: (val) =>
                        setState(() => _overnightAvailable = val),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Action Button
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          Padding(
            padding: const EdgeInsets.all(16),
            child: PrimaryActionButton(
              label: _isSaving ? 'Saving...' : 'Save Changes',
              onPressed: _isSaving ? null : _onSave,
              backgroundColor: const Color(0xFF00A3E0),
            ),
          ),
        ],
      ),
    );
  }
}
