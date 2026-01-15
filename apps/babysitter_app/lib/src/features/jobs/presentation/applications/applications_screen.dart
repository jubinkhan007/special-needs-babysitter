import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../theme/app_tokens.dart';
import 'models/application_item_ui_model.dart';
import 'widgets/application_card.dart';
import '../widgets/jobs_app_bar.dart';
import 'package:go_router/go_router.dart';
import '../../../../routing/routes.dart';
import '../widgets/reject_reason_bottom_sheet.dart';
import 'providers/applications_providers.dart';
import '../../domain/rejection_reason.dart';

class ApplicationsScreen extends ConsumerWidget {
  final String jobId;

  const ApplicationsScreen({super.key, required this.jobId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applicationsAsync = ref.watch(applicationsProvider(jobId));

    // MOCK DATA helper for booking application details
    // MOCK DATA helper removed - fetching from API now

    return Scaffold(
      backgroundColor: AppTokens.applicationsBg,
      appBar: JobsAppBar(
        title: 'Applications',
        showSupportIcon: false,
        onBack: () => context.pop(),
      ),
      body: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
        child: applicationsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text('Failed to load applications',
                    style: TextStyle(color: Colors.grey[600])),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => ref.invalidate(applicationsProvider(jobId)),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
          data: (applications) {
            if (applications.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inbox_outlined,
                        size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text('No applications yet',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600])),
                    const SizedBox(height: 8),
                    Text('Applications will appear here when sitters apply',
                        style: TextStyle(color: Colors.grey[500])),
                  ],
                ),
              );
            }

            return CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.only(
                    left: AppTokens.applicationsHorizontalPadding,
                    right: AppTokens.applicationsHorizontalPadding,
                    top: AppTokens.applicationsTopPadding,
                    bottom: AppTokens.applicationsCardGap,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = applications[index];
                        final ui = ApplicationItemUiModel.fromDomain(item);

                        return Padding(
                          padding: const EdgeInsets.only(
                              bottom: AppTokens.applicationsCardGap),
                          child: ApplicationCard(
                            ui: ui,
                            onAccept: () async {
                              try {
                                final repo =
                                    ref.read(applicationsRepositoryProvider);
                                await repo.acceptApplication(
                                  jobId: jobId,
                                  applicationId: item.id,
                                );
                                // Refresh the list
                                ref.invalidate(applicationsProvider(jobId));
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Application accepted!'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Failed to accept: $e'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            },
                            onViewApplication: () {
                              context.push(
                                Routes.bookingApplication,
                                extra: {
                                  'jobId': jobId,
                                  'applicationId': item.id,
                                },
                              );
                            },
                            onReject: () async {
                              final result =
                                  await showRejectReasonBottomSheet(context);
                              if (result != null) {
                                try {
                                  final repo =
                                      ref.read(applicationsRepositoryProvider);
                                  final reason = result.reason ==
                                          RejectionReason.other
                                      ? result.otherText ?? 'No reason provided'
                                      : result.reason.displayLabel;
                                  await repo.declineApplication(
                                    jobId: jobId,
                                    applicationId: item.id,
                                    reason: reason,
                                  );
                                  // Refresh the list
                                  ref.invalidate(applicationsProvider(jobId));
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Application declined'),
                                        backgroundColor: Colors.orange,
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Failed to decline: $e'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              }
                            },
                            onMoreOptions: () {},
                          ),
                        );
                      },
                      childCount: applications.length,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
