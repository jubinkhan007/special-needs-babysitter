import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../theme/app_tokens.dart';

/// Reusable settings item tile with optional trailing widget (e.g., Switch).
class SettingsItemTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  const SettingsItemTile({
    super.key,
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: AppTokens.settingsTileHeight.h,
        padding: EdgeInsets.symmetric(
            horizontal: AppTokens.settingsTileInternalHPad.w),
        decoration: BoxDecoration(
          color: AppTokens.settingsTileBg,
          borderRadius: BorderRadius.circular(AppTokens.settingsTileRadius.r),
          border: Border.all(
            color: AppTokens.settingsTileBorder,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: AppTokens.settingsIconSize.sp,
              color: AppTokens.settingsIconColor,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                title,
                style: AppTokens.settingsTitleStyle,
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}

/// Custom styled switch that matches the Figma design.
class SettingsSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;

  const SettingsSwitch({
    super.key,
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: AppTokens.settingsSwitchScale,
      child: Switch.adaptive(
        value: value,
        onChanged: onChanged,
        activeColor: AppTokens.settingsSwitchActiveThumb,
        activeTrackColor: AppTokens.settingsSwitchActiveTrack,
        inactiveThumbColor: AppTokens.settingsSwitchInactiveThumb,
        inactiveTrackColor: AppTokens.settingsSwitchInactiveTrack,
      ),
    );
  }
}
