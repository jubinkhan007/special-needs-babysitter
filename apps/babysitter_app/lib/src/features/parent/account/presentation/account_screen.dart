import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart'; // For AppSpacing/Colors if needed, but using custom constants mostly

import 'account_ui_constants.dart';
import 'controllers/account_controller.dart';
import 'widgets/profile_header_card.dart';
import 'widgets/stats_row.dart';
import 'widgets/account_menu_list.dart';
import 'package:babysitter_app/src/routing/routes.dart';

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
            return Center(child: Text('Error: ${state.errorMessage}'));
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
                    // Navigate to saved sitters
                  },
                ),
                const SizedBox(height: 20),
                AccountMenuList(
                  onTapPayment: () {},
                  onTapSettings: () {},
                  onTapAbout: () {},
                  onTapTerms: () {},
                  onTapHelp: () {},
                  onTapSignOut: () {
                    ref
                        .read(accountControllerProvider.notifier)
                        .signOut()
                        .then((_) {
                      if (context.mounted) {
                        context.go(Routes.signIn);
                      }
                    });
                  },
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Failed to load account'),
              const SizedBox(height: 8),
              ElevatedButton(
                  onPressed: () {
                    ref.invalidate(accountControllerProvider);
                  },
                  child: const Text('Retry')),
            ],
          ),
        ),
      ),
    );
  }
}
