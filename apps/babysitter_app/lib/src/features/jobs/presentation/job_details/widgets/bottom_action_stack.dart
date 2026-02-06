import 'package:flutter/material.dart';
import '../../../../../theme/app_tokens.dart';

class BottomActionStack extends StatelessWidget {
  final String primaryLabel;
  final String secondaryLabel;
  final String outlinedLabel;
  final VoidCallback onPrimary;
  final VoidCallback onSecondary;
  final VoidCallback onOutlined;
  final String? paymentLabel;
  final VoidCallback? onPayment;
  final bool showPaymentButton;

  const BottomActionStack({
    super.key,
    required this.primaryLabel,
    required this.secondaryLabel,
    required this.outlinedLabel,
    required this.onPrimary,
    required this.onSecondary,
    required this.onOutlined,
    this.paymentLabel,
    this.onPayment,
    this.showPaymentButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // Sticky bar bg
      padding: EdgeInsets.fromLTRB(
        AppTokens.jobDetailsHorizontalPadding,
        16.0,
        AppTokens.jobDetailsHorizontalPadding,
        MediaQuery.of(context).padding.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Payment Button (shown when payment is required)
          if (showPaymentButton && paymentLabel != null) ...[
            _buildButton(
              context,
              label: paymentLabel!,
              bgColor: const Color(0xFFFFA726), // Orange for payment action
              textColor: Colors.white,
              onTap: onPayment ?? () {},
            ),
            const SizedBox(height: AppTokens.jobDetailsButtonGap),
          ],
          
          // Primary
          _buildButton(
            context,
            label: primaryLabel,
            bgColor: AppTokens.jobDetailsPrimaryBtnBg,
            textColor: Colors.white,
            onTap: onPrimary,
          ),
          const SizedBox(height: AppTokens.jobDetailsButtonGap),

          // Secondary
          _buildButton(
            context,
            label: secondaryLabel,
            bgColor: AppTokens.jobDetailsSecondaryBtnBg,
            textColor: Colors.white,
            onTap: onSecondary,
          ),
          const SizedBox(height: AppTokens.jobDetailsButtonGap),

          // Outlined
          _buildOutlinedButton(
            context,
            label: outlinedLabel,
            onTap: onOutlined,
          ),
        ],
      ),
    );
  }

  Widget _buildButton(
    BuildContext context, {
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
          foregroundColor: textColor, // ripple
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

  Widget _buildOutlinedButton(
    BuildContext context, {
    required String label,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: AppTokens.jobDetailsButtonHeight,
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppTokens.jobDetailsOutlinedTextColor,
          side:
              const BorderSide(color: AppTokens.jobDetailsOutlinedBorderColor),
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(AppTokens.jobDetailsButtonRadius),
          ),
          textStyle: AppTokens.jobDetailsOutlinedTextStyle,
        ),
        onPressed: onTap,
        child: Text(label),
      ),
    );
  }
}
