import 'package:flutter/material.dart';
import 'package:domain/domain.dart';
import '../profile_details_ui_constants.dart';
import 'common_profile_widgets.dart';

class InsurancePlanCard extends StatelessWidget {
  final InsurancePlan? plan;
  final VoidCallback onEdit;

  const InsurancePlanCard({
    super.key,
    this.plan,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return ProfileCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: 'Insurance Plan', onEdit: onEdit),
          const SizedBox(height: 12),
          if (plan != null)
            Text(
              plan!.description,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: ProfileDetailsUI.primaryText,
              ),
            )
          else
            const Text(
              'No insurance plan added.',
              style: TextStyle(color: Color(0xFF6B7280)),
            ),
        ],
      ),
    );
  }
}
