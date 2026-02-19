import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auth/auth.dart';
import '../../../../theme/app_tokens.dart';
import 'package:go_router/go_router.dart';
import '../../../../routing/routes.dart';

import '../../domain/job_details.dart';
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
import 'package:babysitter_app/src/common_widgets/app_toast.dart';
import 'package:babysitter_app/src/common_widgets/payment_method_selector.dart';
import 'package:babysitter_app/src/features/parent/booking_flow/data/providers/bookings_di.dart';

class JobDetailsScreen extends ConsumerStatefulWidget {
  final String jobId;

  const JobDetailsScreen({super.key, required this.jobId});

  @override
  ConsumerState<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends ConsumerState<JobDetailsScreen> {
  bool _isDeleting = false;
  bool _isProcessingPayment = false;

  void _showNotEditableToast() {
    AppToast.show(
      context,
      const SnackBar(
        content: Text(
          'This job can\'t be edited or deleted once it is in progress or completed.',
        ),
      ),
    );
  }

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
        AppToast.show(context, 
          SnackBar(content: Text('Error deleting job: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isDeleting = false);
    }
  }

  Future<void> _handlePayment(JobDetails job) async {
    final bookingsRepo = ref.read(bookingsRepositoryProvider);

    setState(() => _isProcessingPayment = true);

    try {
      // Create payment intent for the job
      debugPrint('DEBUG: JobDetails creating payment intent for jobId: ${job.id}');
      final paymentIntent = await bookingsRepo.createPaymentIntent(job.id);
      debugPrint('DEBUG: PaymentIntent created: ${paymentIntent.paymentIntentId}');

      // Calculate amount based on job details
      final amount = _calculateTotalAmount(job);
      debugPrint('DEBUG: JobDetails calculated amount: $amount');

      if (mounted) {
        setState(() => _isProcessingPayment = false);

        // Show payment method selector
        await PaymentMethodSelector.show(
          context: context,
          amount: amount,
          paymentIntentClientSecret: paymentIntent.clientSecret,
          onPaymentSuccess: () {
            debugPrint('DEBUG: Payment completed successfully');
            // Refresh job details to update payment status
            ref.invalidate(jobDetailsProvider(widget.jobId));
            AppToast.show(context,
              const SnackBar(
                content: Text('Payment completed successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          },
          onPaymentError: (error) {
            debugPrint('DEBUG: Payment error: $error');
            if (error.contains('cancelled')) {
              // User cancelled, no need to show error
              return;
            }
            AppToast.show(context,
              SnackBar(
                content: Text('Payment failed: $error'),
                backgroundColor: Colors.red,
              ),
            );
          },
        );
      }
    } catch (e) {
      debugPrint('DEBUG: JobDetails payment error: $e');
      if (mounted) {
        setState(() => _isProcessingPayment = false);
        AppToast.show(context,
          SnackBar(
            content: Text('Error processing payment: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  double _calculateTotalAmount(JobDetails job) {
    // Calculate total hours
    final startDateTime = DateTime(
      job.scheduleStartDate.year,
      job.scheduleStartDate.month,
      job.scheduleStartDate.day,
      job.scheduleStartTime.hour,
      job.scheduleStartTime.minute,
    );
    final endDateTime = DateTime(
      job.scheduleEndDate.year,
      job.scheduleEndDate.month,
      job.scheduleEndDate.day,
      job.scheduleEndTime.hour,
      job.scheduleEndTime.minute,
    );

    final duration = endDateTime.difference(startDateTime);
    final totalHours = duration.inMinutes / 60.0;

    if (totalHours <= 0) {
      return job.hourlyRate;
    }

    return totalHours * job.hourlyRate;
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
                // Get current user to check if they own this job
                final currentUser = ref.read(authNotifierProvider).value?.user;
                final isJobOwner = currentUser != null && job.isOwnedBy(currentUser.id);
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
                            // Payment Pending Warning (only visible to job owner)
                            if (job.isDraft && isJobOwner) ...[
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.orange.shade200),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.warning_amber_rounded, 
                                      color: Colors.orange.shade700),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        '⚠️ DRAFT: This job is not yet posted. Complete payment to make it visible to sitters.',
                                        style: TextStyle(
                                          color: Colors.orange.shade800,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],

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
        data: (job) {
          final isEditable = job.isEditable;
          final requiresPayment = job.requiresPayment;
          // Get current user to check if they own this job
          final currentUser = ref.read(authNotifierProvider).value?.user;
          final isJobOwner = currentUser != null && job.isOwnedBy(currentUser.id);
          return BottomActionStack(
            primaryLabel: 'Edit job',
            secondaryLabel: 'Manage Applicants',
            outlinedLabel: 'Delete Job',
            onPrimary: _isDeleting || _isProcessingPayment
                ? () {}
                : () async {
                    if (!isEditable) {
                      _showNotEditableToast();
                      return;
                    }
                    await context.push(
                      Routes.editJob,
                      extra: job.id,
                    );
                    ref.invalidate(jobDetailsProvider(widget.jobId));
                  },
            onSecondary: _isProcessingPayment
                ? () {}
                : () => context.push(Routes.applications, extra: job.id),
            onOutlined: _isDeleting || _isProcessingPayment
                ? () {}
                : () {
                    if (!isEditable) {
                      _showNotEditableToast();
                      return;
                    }
                    _deleteJob(job.id);
                  },
            // Payment button (only visible to job owner)
            showPaymentButton: requiresPayment && isJobOwner,
            paymentLabel: _isProcessingPayment ? 'Processing...' : '⚠ Pay Now to Post Job',
            onPayment: _isProcessingPayment
                ? () {}
                : () => _handlePayment(job),
          );
        },
        orElse: () => const SizedBox.shrink(),
      ),
    );
  }
}
