import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_ui_tokens.dart';
import '../widgets/search_top_bar.dart';
import '../widgets/filter_row.dart';
import '../widgets/sitter_card.dart';
import '../../../../../routing/routes.dart';

import '../filter/filter_bottom_sheet.dart';
import '../providers/sitters_list_provider.dart';
import '../providers/search_filter_provider.dart';

import 'package:babysitter_app/src/features/jobs/data/jobs_data_di.dart';
import 'package:babysitter_app/src/common_widgets/app_toast.dart';

class SitterSearchResultsScreen extends ConsumerStatefulWidget {
  const SitterSearchResultsScreen({super.key});

  @override
  ConsumerState<SitterSearchResultsScreen> createState() =>
      _SitterSearchResultsScreenState();
}

class _SitterSearchResultsScreenState
    extends ConsumerState<SitterSearchResultsScreen> {
  // Track invited sitters to update UI state locally if needed
  final Set<String> _invitedSitterIds = {};

  Future<void> _inviteSitter(
      String jobId, String sitterId, String userId) async {
    try {
      // API expects userId
      await ref.read(jobsRepositoryProvider).inviteSitter(jobId, userId);
      if (mounted) {
        setState(() {
          // UI tracking uses sitterId
          _invitedSitterIds.add(sitterId);
        });
        AppToast.show(context,
          const SnackBar(content: Text('Sitter invited successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        String message = 'Failed to invite sitter.';
        if (e.toString().contains('posted jobs')) {
          message =
              'Job is still processing. Please wait a moment and try again.';
        } else {
          message = e.toString().replaceAll('Exception: ', '');
        }

        AppToast.show(context,
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check for jobId in extra or query params
    final Map<String, dynamic>? extra =
        GoRouterState.of(context).extra as Map<String, dynamic>?;
    final String? jobId = extra?['jobId'] ??
        GoRouterState.of(context).uri.queryParameters['jobId'];

    // Watch the filter state
    final filterState = ref.watch(searchFilterProvider).value;

    // Watch the sitters list provider with current filters
    final asyncSitters = ref.watch(sittersListProvider(filterState));

    // Using standard standard density to avoid spacing shifts
    return Theme(
      data: Theme.of(context).copyWith(visualDensity: VisualDensity.standard),
      child: Scaffold(
        backgroundColor: AppUiTokens.scaffoldBackground,
        body: Column(
          children: [
            // Top Bar (Blue background)
            const SearchTopBar(),

            // Content
            Expanded(
              child: asyncSitters.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, stack) => Center(
                  child: Text('Error loading sitters: $error'),
                ),
                data: (sitters) => Column(
                  children: [
                    // Filter Row (White background)
                    FilterRow(
                      count: sitters.length,
                      onFilterTap: () {
                        FilterBottomSheet.show(context);
                      },
                    ),

                    // List of Cards
                    Expanded(
                      child: sitters.isEmpty
                          ? const Center(child: Text("No sitters found."))
                          : ListView.separated(
                              padding: EdgeInsets.only(
                                top: AppUiTokens.itemSpacing,
                                bottom: MediaQuery.of(context).padding.bottom +
                                    16, // Safe area + spacing
                              ),
                              itemCount: sitters.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                      height: AppUiTokens.itemSpacing),
                              itemBuilder: (context, index) {
                                final sitter = sitters[index];
                                final bool isInvited =
                                    _invitedSitterIds.contains(sitter.id);

                                return SitterCard(
                                  sitter: sitter,
                                  onTap: () {
                                    // Navigate to profile using the ID
                                    context.push(
                                        Routes.sitterProfilePath(sitter.id));
                                  },
                                  onInvite: jobId != null
                                      ? () {
                                          if (!isInvited) {
                                            _inviteSitter(jobId, sitter.id,
                                                sitter.userId);
                                          }
                                        }
                                      : null,
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
