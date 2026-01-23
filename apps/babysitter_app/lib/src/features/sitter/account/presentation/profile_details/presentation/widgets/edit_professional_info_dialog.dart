import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:babysitter_app/common/widgets/primary_action_button.dart';
import '../../../../../../sitter_profile_setup/presentation/widgets/bio_text_area_card.dart';
import '../../../../../../sitter_profile_setup/presentation/widgets/dob_dropdown_row.dart';
import '../../../../../../sitter_profile_setup/presentation/widgets/labeled_dropdown_field.dart';
import '../../../../../../sitter_profile_setup/presentation/widgets/selectable_chip_group.dart';
import '../../../../../../sitter_profile_setup/presentation/widgets/transportation_section.dart';
import '../../../../../../sitter_profile_setup/presentation/widgets/willing_to_travel_section.dart';
import '../../data/sitter_me_dto.dart';

class EditProfessionalInfoDialog extends StatefulWidget {
  final SitterMeProfileDto profile;
  final Function(Map<String, dynamic> payload) onSave;

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

  @override
  void initState() {
    super.initState();
    _bio = widget.profile.bio ?? '';
    _dob = widget.profile.dateOfBirth != null
        ? DateTime.tryParse(widget.profile.dateOfBirth!)
        : null;
    _ageGroups = List<String>.from(widget.profile.ageRanges ?? []);
    _languages = List<String>.from(widget.profile.languages ?? []);
    _yearsExperience = widget.profile.yearsOfExperience;
    _hasTransportation = widget.profile.hasTransportation ?? false;
    _transportationDetails = widget.profile.transportationDetails;
    _willingToTravel = widget.profile.willingToTravel ?? false;
    _overnightAvailable = widget.profile.overnightAvailable ?? false;
  }

  void _onSave() {
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
    widget.onSave(payload);
    Navigator.of(context).pop();
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
              label: 'Save Changes',
              onPressed: _onSave,
              backgroundColor: const Color(0xFF00A3E0),
            ),
          ),
        ],
      ),
    );
  }
}
