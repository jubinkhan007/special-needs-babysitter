import 'package:flutter/material.dart';
import '../profile_details_ui_constants.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onEdit;

  const SectionHeader({
    super.key,
    required this.title,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: ProfileDetailsUI.sectionTitle),
        InkWell(
          onTap: onEdit,
          borderRadius: BorderRadius.circular(12),
          child: const Padding(
            padding: EdgeInsets.all(4.0),
            child: Icon(
              Icons.edit_outlined,
              size: 20,
              color: ProfileDetailsUI.secondaryText,
            ),
          ),
        ),
      ],
    );
  }
}

class LabelValueRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isMultiLine;

  const LabelValueRow({
    super.key,
    required this.label,
    required this.value,
    this.isMultiLine = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: RichText(
        text: TextSpan(
          style: ProfileDetailsUI.fieldValue,
          children: [
            TextSpan(
              text: '$label: ',
              style: ProfileDetailsUI.fieldLabel,
            ),
            TextSpan(
              text: value,
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileCardContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const ProfileCardContainer({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ProfileDetailsUI.cardBackground,
        borderRadius: BorderRadius.circular(ProfileDetailsUI.cardRadius),
        boxShadow: ProfileDetailsUI.cardShadow,
      ),
      child: child,
    );
  }
}
