import 'package:flutter/material.dart';
import '../../../../../theme/app_tokens.dart';

class BottomActionBar extends StatelessWidget {
  final VoidCallback onReportTap;
  final VoidCallback onSkipTap;
  final VoidCallback onSubmitTap;

  const BottomActionBar({
    super.key,
    required this.onReportTap,
    required this.onSkipTap,
    required this.onSubmitTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // Sticky bar bg
      padding: const EdgeInsets.symmetric(
        horizontal: AppTokens.screenHorizontalPadding,
        vertical: AppTokens.bottomBarPadding,
      ),
      child: SafeArea(
        // Ensure bottom safe area (home indicator)
        top: false,
        child: SizedBox(
          height: AppTokens.buttonHeight,
          child: Row(
            children: [
              // Report (Outlined)
              Expanded(
                flex: 1, // small
                child: _OutlinedBtn(label: 'Report', onTap: onReportTap),
              ),
              const SizedBox(width: 10),

              // Skip (Outlined)
              Expanded(
                flex: 1, // small
                child: _OutlinedBtn(label: 'Skip', onTap: onSkipTap),
              ),
              const SizedBox(width: 10),

              // Submit (Primary)
              Expanded(
                flex:
                    2, // Larger submit button? Or equal? Figma looks like 1:1:1.5 or 1:1:2
                child: ElevatedButton(
                  onPressed: onSubmitTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTokens.primaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppTokens.buttonRadius),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: Text('Submit', style: AppTokens.buttonText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OutlinedBtn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _OutlinedBtn({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppTokens.outlinedButtonBorder),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTokens.buttonRadius),
        ),
        padding: EdgeInsets.zero,
      ),
      child: Text(label, style: AppTokens.outlinedButtonTextStyle),
    );
  }
}
