import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:core/core.dart';

import '../../../../../routing/routes.dart';
import '../../../../../common_widgets/app_toast.dart';
import '../../data/models/stripe_connect_status.dart';
import '../providers/stripe_connect_providers.dart';
import '../widgets/onboarding_status_card.dart';

/// Sitter wallet screen for managing Stripe Connect payouts
class SitterWalletScreen extends ConsumerStatefulWidget {
  const SitterWalletScreen({super.key});

  @override
  ConsumerState<SitterWalletScreen> createState() => _SitterWalletScreenState();
}

class _SitterWalletScreenState extends ConsumerState<SitterWalletScreen>
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
    // Refresh status when returning to app (e.g., after completing Stripe flow)
    if (state == AppLifecycleState.resumed) {
      ref.invalidate(stripeConnectStatusProvider);
    }
  }

  Future<void> _handleAction(StripeConnectStatus status) async {
    final controller = ref.read(stripeConnectOnboardingControllerProvider.notifier);
    String? url;

    if (status.status == StripeConnectStatusType.complete) {
      url = await controller.openDashboard();
    } else {
      url = await controller.startOnboarding();
    }

    if (url != null && mounted) {
      await _launchUrl(url);
    }
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    try {
      final canLaunch = await canLaunchUrl(uri);
      if (canLaunch) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          AppToast.show(
            context,
            const SnackBar(content: Text('Could not open the link')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        AppToast.show(
          context,
          SnackBar(content: Text('Error opening link: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusAsync = ref.watch(stripeConnectStatusProvider);
    final onboardingState = ref.watch(stripeConnectOnboardingControllerProvider);

    // Listen for errors from the controller
    ref.listen(stripeConnectOnboardingControllerProvider, (previous, next) {
      if (next.error != null && previous?.error != next.error) {
        AppToast.show(
          context,
          SnackBar(content: Text(next.error!)),
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.surfaceTint,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceTint,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF54595C)),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(Routes.sitterAccount);
            }
          },
        ),
        title: Text(
          'Payout Setup',
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF54595C),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFF54595C)),
            onPressed: () {
              ref.invalidate(stripeConnectStatusProvider);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: statusAsync.when(
          data: (status) => SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header section
                Text(
                  'Payout Setup',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1B2225),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Manage how you receive payments for completed jobs',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF6B7680),
                  ),
                ),
                SizedBox(height: 24.h),

                // Status card
                OnboardingStatusCard(
                  status: status,
                  onActionPressed: () => _handleAction(status),
                  isLoading: onboardingState.isLoading,
                ),

                SizedBox(height: 24.h),

                // Info section
                _buildInfoSection(),
              ],
            ),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stack) {
            final appError = AppErrorHandler.parse(error);
            return GlobalErrorWidget(
              title: appError.title,
              message: appError.message,
              onRetry: () {
                ref.invalidate(stripeConnectStatusProvider);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F4FD),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 20.sp,
                color: AppColors.primary,
              ),
              SizedBox(width: 8.w),
              Text(
                'About Payouts',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1B2225),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          _buildInfoItem(
            'Secure Payments',
            'All transactions are processed securely through Stripe.',
          ),
          SizedBox(height: 8.h),
          _buildInfoItem(
            'Fast Transfers',
            'Payouts are typically deposited within 2-3 business days.',
          ),
          SizedBox(height: 8.h),
          _buildInfoItem(
            'No Hidden Fees',
            'Standard payout fees are covered by the platform.',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 6.h),
          width: 6.w,
          height: 6.w,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFF6B7680),
                height: 1.4,
              ),
              children: [
                TextSpan(
                  text: '$title: ',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(text: description),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
