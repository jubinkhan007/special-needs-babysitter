import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';

import '../../../../common_widgets/app_toast.dart';
import '../../../../routing/routes.dart';
import '../../../sitter/wallet/presentation/providers/stripe_connect_providers.dart';
import '../../../sitter/wallet/data/models/stripe_connect_status.dart';
import '../../domain/entities/wallet_balance.dart';
import '../controllers/wallet_controller.dart';
import '../providers/wallet_providers.dart';
import '../widgets/wallet_styles.dart';
import '../widgets/withdraw_bottom_sheet.dart';

class MyWalletScreen extends ConsumerStatefulWidget {
  const MyWalletScreen({super.key});

  @override
  ConsumerState<MyWalletScreen> createState() => _MyWalletScreenState();
}

class _MyWalletScreenState extends ConsumerState<MyWalletScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.invalidate(stripeConnectStatusProvider);
      ref.read(walletControllerProvider.notifier).refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final walletState = ref.watch(walletControllerProvider);
    final stripeStatusAsync = ref.watch(stripeConnectStatusProvider);

    return Scaffold(
      backgroundColor: WalletStyles.background,
      appBar: AppBar(
        backgroundColor: WalletStyles.background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: WalletStyles.iconGrey),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(Routes.sitterAccount);
            }
          },
        ),
        title: Text(
          'My Wallet',
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w600,
            color: WalletStyles.iconGrey,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: WalletStyles.iconGrey),
            onPressed: () {
              ref.read(walletControllerProvider.notifier).refresh();
              ref.invalidate(stripeConnectStatusProvider);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await ref.read(walletControllerProvider.notifier).refresh();
            ref.invalidate(stripeConnectStatusProvider);
          },
          child: ListView(
            padding: EdgeInsets.only(
              left: WalletStyles.horizontalPadding.w,
              right: WalletStyles.horizontalPadding.w,
              top: 16.h,
              bottom: 80.h, // Extra bottom padding for system navigation bar
            ),
            children: [
              _buildBalanceCard(context, walletState, stripeStatusAsync),
              SizedBox(height: 16.h),
              _buildPayoutSetupRow(stripeStatusAsync.valueOrNull),
              SizedBox(height: 20.h),
              _buildSectionHeader(
                title: 'Add Payment Method',
                trailing: Icons.add,
              ),
              SizedBox(height: 12.h),
              _buildPaymentMethodsCard(context),
              SizedBox(height: 20.h),
              _buildSectionHeader(title: 'Payout History'),
              SizedBox(height: 12.h),
              _buildPayoutHistoryCard(context),
              SizedBox(height: 12.h),
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  onPressed: () {
                    context.push(Routes.sitterPayoutHistory);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: WalletStyles.primaryBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    'View Payout History',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceCard(
    BuildContext context,
    WalletState walletState,
    AsyncValue<StripeConnectStatus> stripeStatusAsync,
  ) {
    final balance = walletState.balance;

    if (walletState.isLoading && balance == null) {
      return Container(
        padding: EdgeInsets.all(WalletStyles.cardPadding.w),
        decoration: WalletStyles.cardDecoration(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Balance',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: WalletStyles.textSecondary,
                  ),
                ),
                SizedBox(height: 8.h),
                SizedBox(
                  width: 120.w,
                  height: 22.h,
                  child: const LinearProgressIndicator(),
                ),
              ],
            ),
            SizedBox(
              width: 32.w,
              height: 32.w,
              child: const CircularProgressIndicator(),
            ),
          ],
        ),
      );
    }

    if (walletState.error != null && balance == null) {
      final message = AppErrorHandler.parse(walletState.error!).message;
      return Container(
        padding: EdgeInsets.all(WalletStyles.cardPadding.w),
        decoration: WalletStyles.cardDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: TextStyle(
                fontSize: 14.sp,
                color: WalletStyles.textSecondary,
              ),
            ),
            SizedBox(height: 12.h),
            TextButton(
              onPressed: () =>
                  ref.read(walletControllerProvider.notifier).refresh(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final displayBalance = balance?.formattedBalance ?? '\$0.00';

    return Container(
      padding: EdgeInsets.all(WalletStyles.cardPadding.w),
      decoration: WalletStyles.cardDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Balance',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: WalletStyles.textSecondary,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                displayBalance,
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w700,
                  color: WalletStyles.textPrimary,
                ),
              ),
            ],
          ),
          Container(
            height: 36.h,
            constraints: BoxConstraints(minWidth: 90.w),
            child: OutlinedButton(
              onPressed: () => _handleWithdraw(
                context,
                balance,
                stripeStatusAsync.valueOrNull,
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: WalletStyles.primaryBlue),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.w),
              ),
              child: Text(
                'Withdraw',
                style: TextStyle(
                  color: WalletStyles.primaryBlue,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPayoutSetupRow(StripeConnectStatus? status) {
    final label = _payoutStatusLabel(status);

    return InkWell(
      onTap: () => context.push(Routes.sitterPayoutSetup),
      child: Container(
        padding: EdgeInsets.all(WalletStyles.cardPadding.w),
        decoration: WalletStyles.cardDecoration(),
        child: Row(
          children: [
            Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: WalletStyles.primaryBlue.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: const Icon(
                Icons.account_balance_wallet_outlined,
                color: WalletStyles.primaryBlue,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Payout Setup',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: WalletStyles.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: WalletStyles.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: WalletStyles.iconGrey),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader({required String title, IconData? trailing}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: WalletStyles.textPrimary,
          ),
        ),
        if (trailing != null)
          Icon(trailing, color: WalletStyles.iconGrey, size: 20.sp),
      ],
    );
  }

  Widget _buildPaymentMethodsCard(BuildContext context) {
    return Container(
      decoration: WalletStyles.cardDecoration(),
      child: Column(
        children: [
          _buildPaymentRow(
            context,
            title: 'Credit Card Or Debit Card',
            trailingText: 'Coming soon',
            onTap: () {
              AppToast.show(
                context,
                const SnackBar(content: Text('Card payments coming soon')),
              );
            },
          ),
          Divider(height: 1.h, color: const Color(0xFFE4F4FC)),
          _buildPaymentRow(
            context,
            title: 'Bank Account',
            trailingIcon: Icons.chevron_right,
            onTap: () => context.push(Routes.sitterPayoutSetup),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentRow(
    BuildContext context, {
    required String title,
    String? trailingText,
    IconData? trailingIcon,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: WalletStyles.textPrimary,
                ),
              ),
            ),
            if (trailingText != null)
              Text(
                trailingText,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: WalletStyles.textSecondary,
                ),
              ),
            if (trailingIcon != null)
              Icon(trailingIcon, color: WalletStyles.iconGrey),
          ],
        ),
      ),
    );
  }

  Widget _buildPayoutHistoryCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(WalletStyles.cardPadding.w),
      decoration: WalletStyles.cardDecoration(),
      child: Text(
        'No payouts yet',
        style: TextStyle(
          fontSize: 14.sp,
          color: WalletStyles.textSecondary,
        ),
      ),
    );
  }

  String _payoutStatusLabel(StripeConnectStatus? status) {
    if (status == null) return 'Loading payout status';
    switch (status.status) {
      case StripeConnectStatusType.complete:
        return 'Payouts Active';
      case StripeConnectStatusType.pending:
        return 'Verification pending';
      case StripeConnectStatusType.restricted:
        return 'Action required';
      case StripeConnectStatusType.notStarted:
        return 'Complete setup to enable payouts';
    }
  }

  Future<void> _handleWithdraw(
    BuildContext context,
    WalletBalance? balance,
    StripeConnectStatus? stripeStatus,
  ) async {
    if (stripeStatus == null || !stripeStatus.isFullyOnboarded) {
      await _showSetupDialog(context);
      return;
    }

    if (balance == null) {
      AppToast.show(
        context,
        const SnackBar(content: Text('Balance not available yet.')),
      );
      return;
    }

    if (balance.availableForWithdrawalCents <= 0) {
      AppToast.show(
        context,
        const SnackBar(content: Text('No available balance to withdraw.')),
      );
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (sheetContext) {
        return WithdrawBottomSheet(
          availableCents: balance.availableForWithdrawalCents,
          onSuccess: () {
            ref.read(walletControllerProvider.notifier).refresh();
          },
        );
      },
    );
  }

  Future<void> _showSetupDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Payout Setup Required'),
          content: const Text('Complete payout setup to withdraw.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.push(Routes.sitterPayoutSetup);
              },
              child: const Text('Complete Setup'),
            ),
          ],
        );
      },
    );
  }
}
