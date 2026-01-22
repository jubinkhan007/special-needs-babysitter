import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';

import '../../../routing/routes.dart';
import '../../account/about/presentation/about_special_needs_sitters_screen.dart';
import '../../account/terms/presentation/terms_and_conditions_screen.dart';
import '../../account/help_support/presentation/help_support_screen.dart';
import '../../account/dialogs/show_sign_out_dialog.dart';
import 'presentation/sitter_account_ui_constants.dart';
import 'presentation/controllers/sitter_account_controller.dart';
import 'presentation/widgets/sitter_profile_header_card.dart';
import 'presentation/widgets/sitter_stats_row.dart';
import 'presentation/widgets/sitter_account_menu_list.dart';

/// Sitter account screen
class SitterAccountScreen extends ConsumerStatefulWidget {
  const SitterAccountScreen({super.key});

  @override
  ConsumerState<SitterAccountScreen> createState() =>
      _SitterAccountScreenState();
}

class _SitterAccountScreenState extends ConsumerState<SitterAccountScreen> {
  @override
  Widget build(BuildContext context) {
    final stateForLoad = ref.watch(sitterAccountControllerProvider);

    ref.listen(sitterAccountControllerProvider, (previous, next) {
      if (next.hasError && !next.isLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${next.error}')),
        );
      }
    });

    return Scaffold(
      backgroundColor: SitterAccountUI.backgroundBlue,
      appBar: AppBar(
        title: const Text(
          'Account',
          style: TextStyle(
            color: SitterAccountUI.textGray,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: SitterAccountUI.backgroundBlue,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: SitterAccountUI.textGray),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(Routes.sitterHome);
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none,
                color: SitterAccountUI.textGray),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
        ],
      ),
      body: stateForLoad.when(
        data: (state) {
          if (state.isLoading && state.overview == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.errorMessage != null && state.overview == null) {
            return GlobalErrorWidget(
              title: 'Error',
              message: state.errorMessage!,
              onRetry: () {
                ref.invalidate(sitterAccountControllerProvider);
              },
            );
          }
          if (state.overview == null) {
            return const Center(child: Text('No account data'));
          }
          final user = state.overview!.user;
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: SitterAccountUI.screenPadding,
              vertical: 8,
            ),
            child: Column(
              children: [
                SitterProfileHeaderCard(
                  userName: user.fullName,
                  userEmail: user.email,
                  avatarUrl: user.avatarUrl,
                  completionPercent: state.overview!.profileCompletionPercent,
                  onTapDetails: () {
                    context.push(Routes.sitterProfileDetails);
                  },
                ),
                const SizedBox(height: 20),
                SitterStatsRow(
                  completedJobsCount: state.overview!.completedJobsCount,
                  savedJobsCount: state.overview!.savedJobsCount,
                  onTapCompletedJobs: () {
                    // TODO: Navigate to completed jobs
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Completed jobs coming soon')),
                    );
                  },
                  onTapSavedJobs: () {
                    // TODO: Navigate to saved jobs
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Saved jobs coming soon')),
                    );
                  },
                ),
                const SizedBox(height: 20),
                SitterAccountMenuList(
                  onTapRatingsReviews: () {
                    // TODO: Navigate to ratings & reviews
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Ratings & Reviews coming soon')),
                    );
                  },
                  onTapWallet: () {
                    // TODO: Navigate to wallet
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('My Wallet coming soon')),
                    );
                  },
                  onTapReferralBonuses: () {
                    // TODO: Navigate to referral & bonuses
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Referral & Bonuses coming soon')),
                    );
                  },
                  onTapSettings: () {
                    // TODO: Navigate to settings when available
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Settings coming soon')),
                    );
                  },
                  onTapAbout: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const AboutSpecialNeedsSittersScreen(),
                    ),
                  ),
                  onTapTerms: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const TermsAndConditionsScreen(),
                    ),
                  ),
                  onTapHelp: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const HelpSupportScreen(),
                    ),
                  ),
                  onTapSignOut: () async {
                    final confirmed = await showSignOutDialog(context);
                    if (confirmed == true && context.mounted) {
                      ref
                          .read(sitterAccountControllerProvider.notifier)
                          .signOut()
                          .then((_) {
                        if (context.mounted) {
                          context.go(Routes.signIn);
                        }
                      });
                    }
                  },
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) {
          final appError = AppErrorHandler.parse(err);
          return GlobalErrorWidget(
            title: appError.title,
            message: appError.message,
            onRetry: () {
              ref.invalidate(sitterAccountControllerProvider);
            },
          );
        },
      ),
    );
  }
}
