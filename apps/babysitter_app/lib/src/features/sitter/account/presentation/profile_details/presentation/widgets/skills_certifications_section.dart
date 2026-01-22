import 'package:flutter/material.dart';
import '../../../profile_details/data/sitter_me_dto.dart';

class SkillsCertificationsSection extends StatelessWidget {
  final List<SitterCertificationDto>? certifications;
  final String? yearsOfExperience;
  final List<String>? ageRanges;
  final VoidCallback? onEditTap;

  const SkillsCertificationsSection({
    super.key,
    this.certifications,
    this.yearsOfExperience,
    this.ageRanges,
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
            color: Colors.black.withOpacity(0.05),
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
                'Skills & Certifications',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1D2939),
                ),
              ),
              if (onEditTap != null)
                GestureDetector(
                  onTap: onEditTap,
                  child: const Icon(
                    Icons.edit_outlined,
                    size: 20,
                    color: Color(0xFF667085),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          // Certifications chips
          if (certifications != null && certifications!.isNotEmpty) ...[
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: certifications!.map((cert) {
                return _CertificationChip(
                  label: cert.type,
                  isPending: cert.status == 'pending',
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
          ],
          // Experience
          if (yearsOfExperience != null && yearsOfExperience!.isNotEmpty) ...[
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF667085),
                  height: 1.5,
                ),
                children: [
                  const TextSpan(
                    text: 'Experience: ',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(
                    text: 'I have $yearsOfExperience of experience babysitting children of various ages, including infants and children with special needs. I\'m trained in CPR and first aid.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          // Age Range Experience
          if (ageRanges != null && ageRanges!.isNotEmpty) ...[
            const Text(
              'Age Range Experience',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1D2939),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ageRanges!.map((range) {
                return _AgeRangeChip(label: _formatAgeRange(range));
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  String _formatAgeRange(String range) {
    switch (range.toLowerCase()) {
      case 'infants':
        return 'Infants';
      case 'toddlers':
        return 'Toddlers';
      case 'children':
        return 'Children';
      case 'teens':
        return 'Teens';
      default:
        return range;
    }
  }
}

class _CertificationChip extends StatelessWidget {
  final String label;
  final bool isPending;

  const _CertificationChip({
    required this.label,
    this.isPending = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F4FF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF62A8FF).withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.verified_outlined,
            size: 14,
            color: Color(0xFF62A8FF),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF62A8FF),
            ),
          ),
          if (isPending) ...[
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'Pending',
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFD97706),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _AgeRangeChip extends StatelessWidget {
  final String label;

  const _AgeRangeChip({required this.label});

  Color get _chipColor {
    switch (label.toLowerCase()) {
      case 'infants':
        return const Color(0xFF62A8FF);
      case 'toddlers':
        return const Color(0xFF10B981);
      case 'children':
        return const Color(0xFF8B5CF6);
      case 'teens':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF62A8FF);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _chipColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }
}
