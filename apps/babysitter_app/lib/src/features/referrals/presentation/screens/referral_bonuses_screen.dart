import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:core/core.dart';

import '../../../../routing/routes.dart';
import '../../../../common_widgets/app_toast.dart';
import '../../models/referral_generate_response.dart';
import '../../models/referrals_list_response.dart';
import '../providers/referral_providers.dart';
import '../widgets/bonus_info_card.dart';
import '../widgets/invite_sitters_card.dart';
import '../widgets/referral_bonuses_styles.dart';
import '../widgets/reward_row.dart';

class ReferralBonusesScreen extends ConsumerWidget {
  const ReferralBonusesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final referralCodeAsync = ref.watch(referralGenerateProvider);
    final rewardsAsync = ref.watch(rewardedReferralsProvider);

    final codeErrorMessage = referralCodeAsync.hasError
        ? AppErrorHandler.parse(referralCodeAsync.error!).message
        : null;

    return Scaffold(
      backgroundColor: ReferralBonusesStyles.background,
      appBar: AppBar(
        title: const Text(
          'Referral & Bonuses',
          style: TextStyle(
            color: ReferralBonusesStyles.textSecondary,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: ReferralBonusesStyles.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ReferralBonusesStyles.iconGrey),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(Routes.sitterAccount);
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_none,
              color: ReferralBonusesStyles.iconGrey,
            ),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: () => _refresh(ref),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              ReferralBonusesStyles.horizontalPadding,
              12,
              ReferralBonusesStyles.horizontalPadding,
              120,
            ),
            children: [
              InviteSittersCard(
                referralCode: referralCodeAsync.value?.referralCode,
                isLoading: referralCodeAsync.isLoading,
                errorMessage: codeErrorMessage,
                onRetry: () => ref.invalidate(referralGenerateProvider),
                onCopy: () => _copyReferralCode(
                  context,
                  referralCodeAsync.value?.referralCode ?? '',
                ),
              ),
              const SizedBox(height: 12),
              const BonusInfoCard(
                title: 'High Rating Bonus',
                description:
                    'Maintain a 4.5+ rating for 10 bookings and enjoy reduced platform fees (from 5% to 3%).',
              ),
              const SizedBox(height: 12),
              const BonusInfoCard(
                title: 'Surge Pricing Incentives',
                description:
                    'Earn up to 1.5x your rate during peak demand times.',
              ),
              const SizedBox(height: 12),
              const BonusInfoCard(
                title: 'Training Rewards',
                description:
                    'Complete additional certifications to unlock badges and priority visibility.',
              ),
              const SizedBox(height: 20),
              Text('Your Rewards', style: ReferralBonusesStyles.sectionTitle),
              const SizedBox(height: 8),
              _buildRewardsSection(
                ref,
                rewardsAsync,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            ReferralBonusesStyles.horizontalPadding,
            12,
            ReferralBonusesStyles.horizontalPadding,
            20,
          ),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () => _shareReferral(context, ref),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF89CFF0),
                foregroundColor: AppColors.textOnButton,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: const Text('Invite More Sitters'),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _refresh(WidgetRef ref) async {
    await Future.wait([
      ref.refresh(referralGenerateProvider.future),
      ref.refresh(rewardedReferralsProvider.future),
    ]);
  }

  Widget _buildRewardsSection(
    WidgetRef ref,
    AsyncValue<ReferralsListResponse> rewardsAsync,
  ) {
    if (rewardsAsync.isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (rewardsAsync.hasError) {
      final message = AppErrorHandler.parse(rewardsAsync.error!).message;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message, style: ReferralBonusesStyles.body),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => ref.invalidate(rewardedReferralsProvider),
            child: const Text('Retry'),
          ),
        ],
      );
    }

    final referrals = rewardsAsync.value?.referrals ?? const [];
    if (referrals.isEmpty) {
      return Text(
        'No rewards yet — invite sitters to earn bonuses.',
        style: ReferralBonusesStyles.body,
      );
    }

    return Column(
      children: [
        for (var i = 0; i < referrals.length; i++) ...[
          RewardRow(referral: referrals[i]),
          if (i != referrals.length - 1) const SizedBox(height: 12),
        ],
      ],
    );
  }

  Future<void> _copyReferralCode(BuildContext context, String code) async {
    if (code.isEmpty) {
      AppToast.show(
        context,
        const SnackBar(content: Text('Referral code not available yet.')),
      );
      return;
    }

    await Clipboard.setData(ClipboardData(text: code));
    if (!context.mounted) return;
    AppToast.show(
      context,
      const SnackBar(content: Text('Referral code copied')),
    );
  }

  Future<void> _shareReferral(BuildContext context, WidgetRef ref) async {
    ReferralGenerateResponse? response;

    final referralState = ref.read(referralGenerateProvider);
    if (referralState is AsyncData<ReferralGenerateResponse>) {
      response = referralState.value;
    }

    if (response == null) {
      AppToast.show(
        context,
        const SnackBar(content: Text('Loading referral code...')),
      );
      try {
        response = await ref.read(referralGenerateProvider.future);
      } catch (error) {
        if (!context.mounted) return;
        final message = AppErrorHandler.parse(error).message;
        AppToast.show(context, SnackBar(content: Text(message)));
        return;
      }
    }

    if (!context.mounted) return;

    final resolvedResponse = response;
    if (resolvedResponse == null) return;

    final code = resolvedResponse.referralCode;

    if (code.isEmpty) {
      AppToast.show(
        context,
        const SnackBar(content: Text('Referral code not available yet.')),
      );
      return;
    }

    final shareText =
        'Join Special Sitters with my referral code $code and earn a bonus after your first booking!';
    final box = context.findRenderObject() as RenderBox?;
    final shareOrigin = box == null
        ? null
        : box.localToGlobal(Offset.zero) & box.size;

    await Share.share(
      shareText,
      sharePositionOrigin: shareOrigin,
    );
  }
}
