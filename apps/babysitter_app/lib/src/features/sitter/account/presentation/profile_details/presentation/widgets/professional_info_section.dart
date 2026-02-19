import 'package:core/core.dart';
import 'package:flutter/material.dart';

class ProfessionalInfoSection extends StatelessWidget {
  final String? bio;
  final List<String>? skills;
  final List<String>? languages;
  final bool? hasTransportation;
  final String? transportationDetails;
  final bool? willingToTravel;
  final VoidCallback? onEditTap;

  const ProfessionalInfoSection({
    super.key,
    this.bio,
    this.skills,
    this.languages,
    this.hasTransportation,
    this.transportationDetails,
    this.willingToTravel,
    this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Professional Information',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.buttonDark,
                ),
              ),
              if (onEditTap != null)
                IconButton(
                  icon: const Icon(Icons.edit, size: 20, color: Color(0xFF667085)),
                  onPressed: onEditTap,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
          const SizedBox(height: 16),
          // Bio
          if (bio != null && bio!.isNotEmpty) ...[
            _InfoItem(
              label: 'Bio',
              child: Text(
                bio!,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF667085),
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          // Skills
          if (skills != null && skills!.isNotEmpty) ...[
            _InfoItem(
              label: 'Skills',
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: skills!.map((skill) => _SkillChip(label: skill)).toList(),
              ),
            ),
            const SizedBox(height: 16),
          ],
          // Languages
          if (languages != null && languages!.isNotEmpty) ...[
            _InfoItem(
              label: 'Languages',
              child: Text(
                languages!.join(', '),
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF667085),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          // Reliable Transportation
          _InfoItem(
            label: 'Reliable Transportation',
            child: Text(
              hasTransportation == true ? 'Yes' : 'No',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF667085),
              ),
            ),
          ),
          // Transportation details
          if (hasTransportation == true && transportationDetails != null && transportationDetails!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              transportationDetails!,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF667085),
                height: 1.5,
              ),
            ),
          ],
          // Willing to travel
          if (willingToTravel != null) ...[
            const SizedBox(height: 16),
            _InfoItem(
              label: 'Willing to Travel',
              child: Text(
                willingToTravel == true ? 'Yes' : 'No',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF667085),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final Widget child;

  const _InfoItem({
    required this.label,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label:',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.buttonDark,
          ),
        ),
        const SizedBox(height: 4),
        child,
      ],
    );
  }
}

class _SkillChip extends StatelessWidget {
  final String label;

  const _SkillChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Color(0xFF667085),
        ),
      ),
    );
  }
}
