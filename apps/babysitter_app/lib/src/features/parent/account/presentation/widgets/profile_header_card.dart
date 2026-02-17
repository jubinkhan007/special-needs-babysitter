import 'package:flutter/material.dart';
import '../account_ui_constants.dart';
import 'profile_progress_avatar.dart';

class ProfileHeaderCard extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String? avatarUrl;
  final double completionPercent;
  final VoidCallback onTapDetails;

  const ProfileHeaderCard({
    super.key,
    required this.userName,
    required this.userEmail,
    this.avatarUrl,
    required this.completionPercent,
    required this.onTapDetails,
  });

  @override
  Widget build(BuildContext context) {
    // Determine initials
    final initials = userName.isNotEmpty ? userName[0].toUpperCase() : '?';

    return Container(
      decoration: AccountUI.cardDecoration,
      padding: const EdgeInsets.all(AccountUI.cardPadding),
      child: Row(
        children: [
          ProfileProgressAvatar(
            avatarUrl: avatarUrl,
            initials: initials,
            progress: completionPercent,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: AccountUI.titleStyle.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 4),
                Text(
                  userEmail,
                  style: AccountUI.subtitleStyle,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: onTapDetails,
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'View Profile Details',
                        style: TextStyle(
                          color: AccountUI.accentBlue,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.chevron_right,
                        size: 16,
                        color: AccountUI.accentBlue,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
