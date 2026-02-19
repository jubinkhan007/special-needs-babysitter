import 'package:core/core.dart';
import 'package:flutter/material.dart';
import '../../../../../theme/app_tokens.dart';

class BottomDecisionBar extends StatelessWidget {
  final String primaryLabel;
  final String secondaryLabel;
  final VoidCallback onPrimary;
  final VoidCallback onSecondary;

  const BottomDecisionBar({
    super.key,
    required this.primaryLabel,
    required this.secondaryLabel,
    required this.onPrimary,
    required this.onSecondary,
  });

  @override
  Widget build(BuildContext context) {
    // Ensuring it sits above Home Indicator
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTokens.bookingApplicationBottomBarPadding,
          vertical: AppTokens.bottomBarGap,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
              top: BorderSide(color: AppTokens.dashColor)), // Subtle top border
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Primary (Accept)
            SizedBox(
              width: double.infinity,
              height: AppTokens.jobDetailsButtonHeight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTokens.jobDetailsPrimaryBtnBg,
                  foregroundColor: AppColors.textOnButton,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppTokens.jobDetailsButtonRadius),
                  ),
                  textStyle: AppTokens.jobDetailsButtonTextStyle,
                ),
                onPressed: onPrimary,
                child: Text(primaryLabel),
              ),
            ),
            const SizedBox(height: AppTokens.bottomBarGap),

            // Secondary (Reject)
            SizedBox(
              width: double.infinity,
              height: AppTokens.jobDetailsButtonHeight,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTokens.jobDetailsOutlinedTextColor,
                  side: const BorderSide(
                      color: AppTokens.jobDetailsPrimaryBtnBg), // Blue border
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppTokens.jobDetailsButtonRadius),
                  ),
                  textStyle: AppTokens.jobDetailsButtonTextStyle,
                ),
                onPressed: onSecondary,
                child: Text(secondaryLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
