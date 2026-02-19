import 'package:core/core.dart';
import 'package:flutter/material.dart';
import '../../../../theme/app_tokens.dart';

class JobsPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const JobsPrimaryButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppTokens.jobButtonHeight,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTokens.jobPrimaryBtnBg,
          foregroundColor: AppColors.textOnButton,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTokens.jobButtonRadius),
          ),
          textStyle: AppTokens.jobButtonTextStyle,
        ),
        onPressed: onTap,
        child: Text(text),
      ),
    );
  }
}

class JobsSecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const JobsSecondaryButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppTokens.jobButtonHeight,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTokens.jobSecondaryBtnBg,
          foregroundColor: AppColors.textOnButton,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTokens.jobButtonRadius),
          ),
          textStyle: AppTokens.jobButtonTextStyle,
        ),
        onPressed: onTap,
        child: Text(text),
      ),
    );
  }
}
