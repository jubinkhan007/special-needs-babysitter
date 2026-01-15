import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:babysitter_app/src/theme/app_tokens.dart';

/// Reusable toggle tile for settings screens.
/// Displays a title on the left and a Cupertino-style switch on the right.
class AppToggleTile extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const AppToggleTile({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppTokens.settingsTileHeight.h,
      padding: EdgeInsets.symmetric(
        horizontal: AppTokens.settingsTileInternalHPad.w,
      ),
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
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontFamily: AppTokens.fontFamily,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppTokens.textPrimary,
              ),
            ),
          ),
          Transform.scale(
            scale: AppTokens.settingsSwitchScale,
            child: CupertinoSwitch(
              value: value,
              onChanged: onChanged,
              activeTrackColor: AppTokens.settingsSwitchActiveTrack,
              thumbColor: AppTokens.settingsSwitchActiveThumb,
            ),
          ),
        ],
      ),
    );
  }
}
