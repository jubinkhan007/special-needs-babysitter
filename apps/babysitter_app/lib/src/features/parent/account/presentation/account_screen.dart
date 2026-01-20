import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';
import 'package:ui_kit/ui_kit.dart'; // For AppSpacing/Colors if needed, but using custom constants mostly

import 'account_ui_constants.dart';
import 'controllers/account_controller.dart';
import 'widgets/profile_header_card.dart';
import 'widgets/stats_row.dart';
import 'widgets/account_menu_list.dart';
import 'package:babysitter_app/src/routing/routes.dart';
import 'package:babysitter_app/src/features/account/about/presentation/about_special_needs_sitters_screen.dart';
import 'package:babysitter_app/src/features/account/terms/presentation/terms_and_conditions_screen.dart';
import 'package:babysitter_app/src/features/account/help_support/presentation/help_support_screen.dart';
import 'package:babysitter_app/src/features/account/dialogs/show_sign_out_dialog.dart';

class AccountScreen extends ConsumerStatefulWidget {
  const AccountScreen({super.key});

  @override
  ConsumerState<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    final stateForLoad = ref.watch(accountControllerProvider);

    // We can also listen to errors here
    ref.listen(accountControllerProvider, (previous, next) {
      if (next.hasError && !next.isLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${next.error}')),
        );
      }
    });

    return Scaffold(
      backgroundColor: AccountUI.backgroundBlue,
      appBar: AppBar(
        title: const Text('Account',
            style: TextStyle(
                color: AccountUI.textGray,
                fontSize: 17,
                fontWeight: FontWeight.w600)),
        backgroundColor: AccountUI.backgroundBlue,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AccountUI.textGray),
          onPressed: () {
            // Can't pop if it's a shell route tab?
            // Usually Back on a tab works if there's history, but if it's the root of the tab...
            if (context.canPop()) {
              context.pop();
            } else {
              // Maybe go home? Or do nothing.
              // Design shows back arrow.
              context.go(Routes.parentHome);
            }
          },
        ),
        actions: [
          IconButton(
            icon:
                const Icon(Icons.notifications_none, color: AccountUI.textGray),
            onPressed: () {
              // TODO: Notification route
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
            // Handle legacy errorMessage if any, though we prefer throwing
            return GlobalErrorWidget(
              title: 'Error',
              message: state.errorMessage!,
              onRetry: () {
                ref.invalidate(accountControllerProvider);
              },
            );
          }
          if (state.overview == null) {
            return const Center(child: Text('No account data'));
          }
          final user = state.overview!.user;
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AccountUI.screenPadding,
              vertical: 8,
            ),
            child: Column(
              children: [
                ProfileHeaderCard(
                  userName: user.fullName,
                  userEmail: user.email,
                  avatarUrl: user.avatarUrl,
                  completionPercent: state.overview!.profileCompletionPercent,
                  onTapDetails: () {
                    // Navigate to profile details
                    context.go('/parent/account/profile');
                  },
                ),
                const SizedBox(height: 20),
                StatsRow(
                  bookingCount: state.overview!.bookingHistoryCount,
                  savedSitterCount: state.overview!.savedSittersCount,
                  onTapBookings: () {
                    // Navigate to bookings
                  },
                  onTapSaved: () {
                    context.push(Routes.parentSavedSitters);
                  },
                ),
                const SizedBox(height: 20),
                AccountMenuList(
                  onTapPayment: () => context.push(Routes.parentPayment),
                  onTapSettings: () => context.push(Routes.parentSettings),
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
                          .read(accountControllerProvider.notifier)
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
              ref.invalidate(accountControllerProvider);
            },
          );
        },
      ),
    );
  }
}
