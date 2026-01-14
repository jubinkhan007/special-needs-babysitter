import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../theme/app_tokens.dart';

/// Balance card showing in-app balance with top-up action.
class BalanceCard extends StatelessWidget {
  final String balanceText;
  final VoidCallback? onTopUp;

  const BalanceCard({
    super.key,
    required this.balanceText,
    this.onTopUp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppTokens.balanceCardPadding,
      decoration: BoxDecoration(
        color: AppTokens.balanceCardBg,
        borderRadius: BorderRadius.circular(AppTokens.balanceCardRadius.r),
        boxShadow: AppTokens.balanceCardShadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Balance info
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'In-App Balance',
                style: AppTokens.balanceLabelStyle,
              ),
              SizedBox(height: 4.h),
              Text(
                balanceText,
                style: AppTokens.balanceAmountStyle,
              ),
            ],
          ),
          // Right: Top Up action
          GestureDetector(
            onTap: onTopUp,
            behavior: HitTestBehavior.opaque,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Top Up',
                  style: AppTokens.topUpTextStyle,
                ),
                SizedBox(width: 8.w),
                Icon(
                  Icons.credit_card_outlined,
                  size: AppTokens.topUpIconSize.sp,
                  color: AppTokens.topUpIconColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
