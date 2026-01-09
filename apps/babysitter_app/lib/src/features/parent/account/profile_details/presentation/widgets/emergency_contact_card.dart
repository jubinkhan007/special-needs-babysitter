import 'package:flutter/material.dart';
import 'package:domain/domain.dart';
import 'common_profile_widgets.dart';

class EmergencyContactCard extends StatelessWidget {
  final EmergencyContact? contact;
  final VoidCallback onEdit;

  const EmergencyContactCard({
    super.key,
    this.contact,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return ProfileCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: 'Emergency Contact', onEdit: onEdit),
          const SizedBox(height: 12),
          if (contact != null) ...[
            LabelValueRow(label: 'Full Name', value: contact!.fullName),
            LabelValueRow(
              label: 'Relationship to Child',
              value: contact!.relationshipToChild,
            ),
            LabelValueRow(
              label: 'Primary Phone Number',
              value: contact!.phoneNumber,
            ),
            LabelValueRow(label: 'Email Address', value: contact!.email),
            LabelValueRow(label: 'Address', value: contact!.address),
            LabelValueRow(
              label: 'Special Instruction',
              value: contact!.specialInstructions,
              isMultiLine: true,
            ),
          ] else
            const Text(
              'No emergency contact provided.',
              style: TextStyle(color: Color(0xFF6B7280)),
            ),
        ],
      ),
    );
  }
}
