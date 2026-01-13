import 'package:flutter/material.dart';
import "package:babysitter_app/src/features/parent/search/presentation/theme/app_ui_tokens.dart";

class ProfileTabs extends StatelessWidget {
  const ProfileTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppUiTokens.borderColor)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Even spacing
        children: [
          _buildTab("Overview", isSelected: true),
          _buildTab("Skills", isSelected: false),
          _buildTab("Schedule", isSelected: false),
          _buildTab("Reviews", isSelected: false),
        ],
      ),
    );
  }

  Widget _buildTab(String label, {required bool isSelected}) {
    // Figma: Text width + spacing. "Evenly spaced across width" -> Expanded?
    // Screenshot 4: looks like equal width tabs.
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14), // Approx 14-16
        decoration: isSelected
            ? const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppUiTokens.primaryBlue, // Light Blue
                    width: 2,
                  ),
                ),
              )
            : null,
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected
                  ? AppUiTokens.textPrimary
                  : AppUiTokens.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
