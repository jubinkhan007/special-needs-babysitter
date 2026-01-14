import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../theme/app_tokens.dart';
import 'widgets/balance_card.dart';
import 'widgets/payment_method_row.dart';
import 'widgets/recent_activity_row.dart';

/// The Payment screen displaying balance, payment methods, and recent activities.
class PaymentScreen extends StatelessWidget {
  final VoidCallback? onTopUp;

  const PaymentScreen({
    super.key,
    this.onTopUp,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTokens.paymentBg,
      appBar: AppBar(
        backgroundColor: AppTokens.paymentHeaderBg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppTokens.appBarTitleColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Payment',
          style: TextStyle(
            fontFamily: AppTokens.fontFamily,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppTokens.appBarTitleColor,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_outlined,
              color: AppTokens.appBarTitleColor,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: MediaQuery.withClampedTextScaling(
        minScaleFactor: 1.0,
        maxScaleFactor: 1.0,
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding:
                  EdgeInsets.symmetric(horizontal: AppTokens.paymentHPad.w),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  SizedBox(height: 16.h),

                  // Balance Card
                  BalanceCard(
                    balanceText: '\$ 700.00',
                    onTopUp: onTopUp,
                  ),

                  SizedBox(height: AppTokens.paymentSectionGapTop.h),

                  // Payment Method section title
                  Text(
                    'Payment Method',
                    style: AppTokens.paymentSectionTitleStyle,
                  ),

                  SizedBox(height: AppTokens.paymentSectionGapBottom.h),

                  // Payment methods
                  PaymentMethodRow(
                    leading: Icon(
                      Icons.paypal_outlined,
                      size: 20.sp,
                      color: const Color(0xFF003087),
                    ),
                    title: 'Stripe',
                    onTap: () {},
                  ),
                  SizedBox(height: AppTokens.methodRowGap.h),

                  PaymentMethodRow(
                    leading: Text(
                      'VISA',
                      style: TextStyle(
                        fontFamily: AppTokens.fontFamily,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1F71),
                      ),
                    ),
                    title: 'Credit Card Or Debit Card',
                    onTap: () {},
                  ),
                  SizedBox(height: AppTokens.methodRowGap.h),

                  PaymentMethodRow(
                    leading: Icon(
                      Icons.apple,
                      size: 20.sp,
                      color: const Color(0xFF000000),
                    ),
                    title: 'Apple Pay',
                    onTap: () {},
                  ),
                  SizedBox(height: AppTokens.methodRowGap.h),

                  PaymentMethodRow(
                    leading: Text(
                      'G',
                      style: TextStyle(
                        fontFamily: AppTokens.fontFamily,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF4285F4),
                      ),
                    ),
                    title: 'Google Pay',
                    onTap: () {},
                  ),
                  SizedBox(height: AppTokens.methodRowGap.h),

                  PaymentMethodRow(
                    leading: Icon(
                      Icons.account_balance_outlined,
                      size: 20.sp,
                      color: const Color(0xFF6B7280),
                    ),
                    title: 'Bank Account',
                    onTap: () {},
                  ),

                  SizedBox(height: AppTokens.paymentSectionGapTop.h),

                  // Recent Activities section title
                  Text(
                    'Recent Activities',
                    style: AppTokens.paymentSectionTitleStyle,
                  ),

                  SizedBox(height: AppTokens.paymentSectionGapBottom.h),

                  // Recent activities
                  RecentActivityRow(
                    leadingIcon: Icons.receipt_long_outlined,
                    title: 'Krystina',
                    dateText: '20 May, 2025',
                    amountText: '\$ 320',
                    onTap: () {},
                  ),

                  SizedBox(height: 32.h), // Bottom padding
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
