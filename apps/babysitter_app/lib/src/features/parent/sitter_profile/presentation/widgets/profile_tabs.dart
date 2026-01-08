import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:babysitter_app/src/features/parent/home/presentation/theme/home_design_tokens.dart';

class ProfileTabs extends StatelessWidget {
  const ProfileTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFF2F4F7))), // Divider
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: isSelected
          ? const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
            )
          : null,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
        ),
      ),
    );
  }
}
