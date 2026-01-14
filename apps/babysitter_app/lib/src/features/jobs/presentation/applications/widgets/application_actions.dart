import 'package:flutter/material.dart';
import '../../../../../theme/app_tokens.dart';

class ApplicationActions extends StatelessWidget {
  final VoidCallback onAccept;
  final VoidCallback onViewApplication;
  final VoidCallback onReject;

  const ApplicationActions({
    super.key,
    required this.onAccept,
    required this.onViewApplication,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Accept
        _buildButton(
          label: 'Accept',
          bgColor: AppTokens.jobDetailsPrimaryBtnBg, // Reusing light blue
          textColor: Colors.white,
          onTap: onAccept,
        ),
        const SizedBox(
            height: AppTokens.jobDetailsButtonGap), // Reusing 12.0 gap

        // View Application
        _buildButton(
          label: 'View Application',
          bgColor: AppTokens.jobDetailsSecondaryBtnBg, // Reusing dark navy
          textColor: Colors.white,
          onTap: onViewApplication,
        ),
        const SizedBox(height: AppTokens.jobDetailsButtonGap),

        // Reject
        SizedBox(
          height: AppTokens.jobDetailsButtonHeight,
          width: double.infinity,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTokens.jobDetailsOutlinedTextColor,
              side: const BorderSide(
                  color: AppTokens
                      .jobDetailsPrimaryBtnBg), // Blue border per screenshot
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(AppTokens.jobDetailsButtonRadius),
              ),
              textStyle: AppTokens.jobDetailsOutlinedTextStyle,
            ),
            onPressed: onReject,
            child: const Text('Reject'),
          ),
        ),
      ],
    );
  }

  Widget _buildButton({
    required String label,
    required Color bgColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: AppTokens.jobDetailsButtonHeight,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: textColor,
          elevation: 0,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(AppTokens.jobDetailsButtonRadius),
          ),
          textStyle: AppTokens.jobDetailsButtonTextStyle,
        ),
        onPressed: onTap,
        child: Text(label),
      ),
    );
  }
}
