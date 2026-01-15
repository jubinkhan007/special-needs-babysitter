import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../theme/app_tokens.dart';
import 'package:go_router/go_router.dart';
import '../../../../routing/routes.dart';

import 'models/job_details_ui_model.dart';
import 'job_details_provider.dart';
import '../widgets/jobs_app_bar.dart';
import '../widgets/job_status_chip.dart';
import 'widgets/section_title.dart';
import 'widgets/key_value_row.dart';
import 'widgets/section_divider.dart';
import 'widgets/bottom_action_stack.dart';

import '../../data/jobs_data_di.dart'; // For repository
import '../providers/jobs_providers.dart';

class JobDetailsScreen extends ConsumerStatefulWidget {
  final String jobId;

  const JobDetailsScreen({super.key, required this.jobId});

  @override
  ConsumerState<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends ConsumerState<JobDetailsScreen> {
  bool _isDeleting = false;

  Future<void> _deleteJob(String jobId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Delete Job', style: TextStyle(color: Colors.black)),
        content: const Text(
          'Are you sure you want to delete this job? This action cannot be undone.',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => context.pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isDeleting = true);

    try {
      final repo = ref.read(jobsRepositoryProvider);
      await repo.deleteJob(jobId);

      // Invalidate the list provider so it refreshes when we navigate back
      ref.invalidate(allJobsProvider);

      if (mounted) {
        // Navigate back to the jobs list
        context.go(Routes.parentJobs);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting job: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isDeleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final jobAsync = ref.watch(jobDetailsProvider(widget.jobId));

    return Scaffold(
      backgroundColor: AppTokens.jobDetailsBg,
      appBar: const JobsAppBar(
        title: 'Job Details',
        showSupportIcon: true,
      ),
      body: _isDeleting
          ? const Center(child: CircularProgressIndicator())
          : jobAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
              data: (job) {
                final uiModel = JobDetailsUiModel.fromDomain(job);
                return MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(textScaler: TextScaler.noScaling),
                  child: CustomScrollView(
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.only(
                          left: AppTokens.jobDetailsHorizontalPadding,
                          right: AppTokens.jobDetailsHorizontalPadding,
                          top: AppTokens.jobDetailsTopPadding,
                          bottom: AppTokens.jobDetailsBottomPaddingForScroll,
                        ),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate([
                            // 1. Status Chip
                            Align(
                              alignment: Alignment.centerLeft,
                              child: JobStatusChip(isActive: uiModel.isActive),
                            ),
                            const SizedBox(height: 12),

                            // 2. Title
                            Text(
                              uiModel.title,
                              style: AppTokens.jobDetailsTitleStyle,
                            ),
                            const SizedBox(height: 8),

                            // 3. Subtitle
                            Text(
                              uiModel.postedAgoText,
                              style: AppTokens.jobDetailsSubtitleStyle,
                            ),

                            // 4. Divider
                            const SectionDivider(),

                            // 5. Child Details Section
                            const SectionTitle(title: 'Child Details'),
                            ...uiModel.childDetailsRows
                                .map((entry) => KeyValueRow(
                                      label: entry.key,
                                      value: entry.value,
                                    )),
                            const SectionDivider(),

                            // 6. Schedule & Location
                            const SectionTitle(title: 'Schedule & Location'),
                            KeyValueRow(
                                label: 'Date', value: uiModel.dateRangeText),
                            KeyValueRow(
                                label: 'Time', value: uiModel.timeRangeText),
                            KeyValueRow(
                                label: 'Address',
                                value: uiModel.addressText,
                                isMultiline: true),
                            const SectionDivider(),

                            // 7. Emergency Contact
                            const SectionTitle(title: 'Emergency Contact'),
                            KeyValueRow(
                                label: 'Name', value: uiModel.emergencyName),
                            KeyValueRow(
                                label: 'Phone Number',
                                value: uiModel.emergencyPhone),
                            KeyValueRow(
                                label: 'Relations',
                                value: uiModel.emergencyRelation),
                            const SectionDivider(),

                            // 8. Additional Details & Pay Rate
                            const SectionTitle(
                                title: 'Additional Details & Pay Rate'),
                            Text(
                              uiModel.additionalNotes,
                              style: AppTokens.jobDetailsParagraphStyle,
                            ),
                            const SizedBox(height: 16),
                            KeyValueRow(
                                label: 'Hourly rate',
                                value: uiModel.hourlyRateText),
                            const SectionDivider(),

                            // 9. Applicants
                            const SectionTitle(title: 'Applicants'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Total',
                                    style: AppTokens.jobDetailsLabelStyle),
                                Text(uiModel.applicantsTotalText,
                                    style: AppTokens.jobDetailsValueStyle),
                              ],
                            ),
                          ]),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: jobAsync.maybeWhen(
        data: (job) => BottomActionStack(
          primaryLabel: 'Edit job',
          secondaryLabel: 'Manage Applicants',
          outlinedLabel: 'Delete Job',
          onPrimary: _isDeleting
              ? () {}
              : () async {
                  await context.push(
                    Routes.editJob,
                    extra: job.id,
                  );
                  ref.invalidate(jobDetailsProvider(widget.jobId));
                },
          onSecondary: () => context.push(Routes.applications),
          onOutlined: _isDeleting ? () {} : () => _deleteJob(job.id),
        ),
        orElse: () => const SizedBox.shrink(),
      ),
    );
  }
}
