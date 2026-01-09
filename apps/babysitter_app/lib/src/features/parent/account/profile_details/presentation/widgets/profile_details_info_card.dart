import 'package:flutter/material.dart';
import 'package:domain/domain.dart';
import '../profile_details_ui_constants.dart';
import 'common_profile_widgets.dart';

class ProfileDetailsInfoCard extends StatelessWidget {
  final UserProfileDetails details;
  final VoidCallback onEdit;
  final VoidCallback onEditAvatar;

  const ProfileDetailsInfoCard({
    super.key,
    required this.details,
    required this.onEdit,
    required this.onEditAvatar,
  });

  @override
  Widget build(BuildContext context) {
    final user = details.user;

    return ProfileCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: user.avatarUrl != null
                      ? NetworkImage(user.avatarUrl!)
                      : null,
                  backgroundColor: Colors.grey[200],
                  child: user.avatarUrl == null
                      ? Text(
                          user.initials,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        )
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: onEditAvatar,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            )
                          ]),
                      child: const Icon(
                        Icons.edit,
                        size: 14,
                        color: ProfileDetailsUI.secondaryText,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          SectionHeader(title: 'Your Details', onEdit: onEdit),
          const SizedBox(height: 12),

          LabelValueRow(label: 'Name', value: user.fullName),
          LabelValueRow(label: 'Phone', value: user.phoneNumber ?? ''),
          LabelValueRow(label: 'Email', value: user.email),
          LabelValueRow(
              label: 'No. of Family Members',
              value: details.numberOfFamilyMembers.toString()),
          LabelValueRow(
            label: 'Family Bio',
            value: details.familyBio,
            isMultiLine: true,
          ),
          LabelValueRow(
              label: 'No. of Pets', value: details.numberOfPets.toString()),
          LabelValueRow(
              label: 'Languages', value: _formatLanguages(details.languages)),
        ],
      ),
    );
  }

  String _formatLanguages(List<String> languages) {
    if (languages.isEmpty) return 'None';
    if (languages.length == 1) return languages.first;
    final last = languages.last;
    final rest = languages.sublist(0, languages.length - 1).join(', ');
    return '$rest and $last';
  }
}
