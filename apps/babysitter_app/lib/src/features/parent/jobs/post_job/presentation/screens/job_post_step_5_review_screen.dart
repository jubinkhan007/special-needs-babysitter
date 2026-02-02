import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../routing/routes.dart';
import '../providers/job_post_providers.dart';
import '../controllers/job_post_controller.dart';
import '../widgets/job_draft_saved_dialog.dart';
import 'job_post_step_header.dart';
import '../../../../booking_flow/data/providers/bookings_di.dart';
import 'package:babysitter_app/src/common_widgets/app_toast.dart';
import 'package:babysitter_app/src/common_widgets/payment_method_selector.dart';

/// Job Post Step 5: Review
/// Pixel-perfect implementation matching Figma design
class JobPostStep5ReviewScreen extends ConsumerStatefulWidget {
  final VoidCallback onSubmit;
  final VoidCallback onBack;
  final VoidCallback? onEditJobDetail;
  final VoidCallback? onEditChild;
  final VoidCallback? onEditAdditional;

  const JobPostStep5ReviewScreen({
    super.key,
    required this.onSubmit,
    required this.onBack,
    this.onEditJobDetail,
    this.onEditChild,
    this.onEditAdditional,
  });

  @override
  ConsumerState<JobPostStep5ReviewScreen> createState() =>
      _JobPostStep5ReviewScreenState();
}

class _JobPostStep5ReviewScreenState
    extends ConsumerState<JobPostStep5ReviewScreen> {
  // Design Constants
  static const _bgColor = Color(0xFFEAF6FF); // Light sky background
  static const _titleColor = Color(0xFF0B1736); // Deep navy
  static const _secondaryText = Color(0xFF6F7C8A); // Secondary grey
  static const _lightGrey = Color(0xFF8793A1); // Lighter grey
  static const _primaryBtn = Color(0xFF8CCFF0); // Submit button
  static const _editIconColor = Color(0xFF7C8A9A); // Edit icon grey

  bool _isProcessingPayment = false;

  /// Check if this is an update to an existing posted job
  bool get _isExistingJob {
    final state = ref.read(jobPostControllerProvider);
    return state.jobId != null && state.jobId!.isNotEmpty;
  }

  /// Update an existing job without payment flow
  Future<void> _updateExistingJob() async {
    final controller = ref.read(jobPostControllerProvider.notifier);

    setState(() => _isProcessingPayment = true);

    try {
      final success = await controller.submitJob();
      if (!success) {
        if (mounted) {
          final latestError = ref.read(jobPostControllerProvider).error;
          if (latestError != null) {
            AppToast.show(context,
              SnackBar(
                content: Text(latestError),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
        return;
      }

      if (mounted) {
        AppToast.show(context,
          const SnackBar(
            content: Text('Job updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        widget.onSubmit();
      }
    } catch (e) {
      if (mounted) {
        AppToast.show(context,
          SnackBar(
            content: Text('Error updating job: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessingPayment = false);
      }
    }
  }

  Future<void> _submitWithPayment() async {
    final controller = ref.read(jobPostControllerProvider.notifier);
    final bookingsRepo = ref.read(bookingsRepositoryProvider);

    // Step 1: Submit the job
    final success = await controller.submitJob();
    if (!success) {
      if (mounted) {
        final latestError = ref.read(jobPostControllerProvider).error;
        if (latestError != null) {
          AppToast.show(context,
            SnackBar(content: Text(latestError)),
          );
        }
      }
      return;
    }

    // Step 2: Get the job ID from state
    final jobId = ref.read(jobPostControllerProvider).jobId;
    if (jobId == null || jobId.isEmpty) {
      if (mounted) {
        AppToast.show(context,
          const SnackBar(content: Text('Job created but no ID returned')),
        );
      }
      // Still call onSubmit since job was created
      widget.onSubmit();
      return;
    }

    setState(() => _isProcessingPayment = true);

    try {
      // Step 3: Create payment intent
      print('DEBUG: JobPostStep5 creating payment intent for jobId: $jobId');
      final paymentIntent = await bookingsRepo.createPaymentIntent(jobId);
      print('DEBUG: PaymentIntent created: ${paymentIntent.paymentIntentId}');

      // Get pay rate from state
      final state = ref.read(jobPostControllerProvider);
      final amount = _calculateTotalAmount(state);
      print(
          'DEBUG: JobPostStep5 calculated amount: $amount (rate=${state.payRate}, start=${state.startDate} ${state.startTime}, end=${state.endDate} ${state.endTime})');

      if (mounted) {
        setState(() => _isProcessingPayment = false);

        // Step 4: Show payment method selector
        await PaymentMethodSelector.show(
          context: context,
          amount: amount,
          paymentIntentClientSecret: paymentIntent.clientSecret,
          onPaymentSuccess: () {
            print('DEBUG: Payment completed successfully');
            widget.onSubmit();
          },
          onPaymentError: (error) {
            print('DEBUG: Payment error: $error');
            AppToast.show(context,
              SnackBar(
                content: Text('Payment error: $error'),
                backgroundColor: Colors.red,
              ),
            );
            // Job is created but payment failed - still proceed to success
            widget.onSubmit();
          },
        );
      }
    } catch (e) {
      print('DEBUG: JobPostStep5 error: $e');
      if (mounted) {
        setState(() => _isProcessingPayment = false);
        AppToast.show(context,
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  double _calculateTotalAmount(JobPostState state) {
    final totalHours = _calculateTotalHours(
      rawStartDate: state.rawStartDate,
      rawEndDate: state.rawEndDate,
      startTime: state.startTime,
      endTime: state.endTime,
    );

    if (totalHours <= 0) {
      return state.payRate;
    }

    return totalHours * state.payRate;
  }

  double _calculateTotalHours({
    required DateTime? rawStartDate,
    required DateTime? rawEndDate,
    required String startTime,
    required String endTime,
  }) {
    if (rawStartDate == null ||
        rawEndDate == null ||
        startTime.isEmpty ||
        endTime.isEmpty) {
      return 0;
    }

    final startTimeOfDay = _parseTimeString(startTime);
    final endTimeOfDay = _parseTimeString(endTime);
    if (startTimeOfDay == null || endTimeOfDay == null) {
      return 0;
    }

    final startDateTime = DateTime(
      rawStartDate.year,
      rawStartDate.month,
      rawStartDate.day,
      startTimeOfDay.hour,
      startTimeOfDay.minute,
    );
    final endDateTime = DateTime(
      rawEndDate.year,
      rawEndDate.month,
      rawEndDate.day,
      endTimeOfDay.hour,
      endTimeOfDay.minute,
    );

    final duration = endDateTime.difference(startDateTime);
    if (duration.inMinutes <= 0) {
      return 0;
    }

    return duration.inMinutes / 60.0;
  }

  TimeOfDay? _parseTimeString(String timeStr) {
    final cleanTime = timeStr.trim();
    final parts = cleanTime.split(' ');
    if (parts.length != 2) return null;

    final timeParts = parts[0].split(':');
    if (timeParts.length != 2) return null;

    final period = parts[1].toUpperCase();
    final hour = int.tryParse(timeParts[0]);
    final minute = int.tryParse(timeParts[1]);
    if (hour == null || minute == null) return null;

    int resolvedHour = hour;
    if (period == 'PM' && resolvedHour != 12) resolvedHour += 12;
    if (period == 'AM' && resolvedHour == 12) resolvedHour = 0;

    return TimeOfDay(hour: resolvedHour, minute: minute);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(jobPostControllerProvider);
    final profileDetailsAsync = ref.watch(profileDetailsProvider);
    final isLoading = state.isLoading || _isProcessingPayment;

    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top Header (Step 5 of 5)
            JobPostStepHeader(
              activeStep: 5,
              totalSteps: 5,
              onBack: widget.onBack,
            ),

            // Main Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    // Section A: Job Detail
                    _buildSectionHeader('Job Detail', widget.onEditJobDetail),
                    const SizedBox(height: 12),
                    _buildTextLine(state.title),
                    const SizedBox(height: 10),
                    _buildTextLine('${state.startDate} - ${state.endDate}'),
                    const SizedBox(height: 10),
                    _buildTextLine('${state.startTime} to ${state.endTime}'),

                    const SizedBox(height: 32),

                    // Section B: Child
                    _buildSectionHeader('Child', widget.onEditChild),
                    const SizedBox(height: 12),
                    profileDetailsAsync.when(
                      data: (details) {
                        final selectedChildren = details.children
                            .where((c) => state.childIds.contains(c.id))
                            .toList();
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: selectedChildren.map((child) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: _buildChildRow(
                                  '${child.firstName} ${child.lastName}',
                                  child.ageDisplay),
                            );
                          }).toList(),
                        );
                      },
                      loading: () => const CircularProgressIndicator(),
                      error: (err, stack) =>
                          Text('Error loading children: $err'),
                    ),

                    const SizedBox(height: 32),

                    // Section C: Additional Details & Pay Rate
                    _buildSectionHeader('Additional Details & Pay Rate',
                        widget.onEditAdditional),
                    const SizedBox(height: 12),
                    Text(
                      state.additionalDetails,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: _secondaryText,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Pay Rate
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '\$ ${state.payRate.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: _titleColor,
                          ),
                        ),
                        const Text(
                          '/hr',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: _lightGrey,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),

            // Bottom Bar
            _buildBottomBar(context, isLoading),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback? onEdit) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: _titleColor,
            ),
          ),
        ),
        GestureDetector(
          onTap: onEdit,
          child: const Icon(
            Icons.edit_outlined,
            size: 20,
            color: _editIconColor,
          ),
        ),
      ],
    );
  }

  Widget _buildTextLine(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: _secondaryText,
      ),
    );
  }

  Widget _buildChildRow(String name, String age) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$name ',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600, // Semi-bold for name
              color: _titleColor,
            ),
          ),
          TextSpan(
            text: '($age)',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400, // Regular for age
              color: _lightGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, bool isLoading) {
    final isExisting = _isExistingJob;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 10, 24, 22),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Save For Later Button - Hidden for existing/posted jobs
          if (!isExisting)
            TextButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      final success = await ref
                          .read(jobPostControllerProvider.notifier)
                          .saveJobDraft();
                      if (success && context.mounted) {
                        showDialog(
                          context: context,
                          builder: (context) => JobDraftSavedDialog(
                            onEditJob: () {
                              Navigator.of(context).pop(); // Close dialog
                            },
                            onGoToHome: () {
                              ref
                                  .read(jobPostControllerProvider.notifier)
                                  .resetState();
                              Navigator.of(context).pop(); // Close dialog
                              context.go(Routes.parentHome);
                            },
                            onClose: () {
                              Navigator.of(context).pop(); // Close dialog
                            },
                          ),
                        );
                      } else if (context.mounted) {
                        final latestError =
                            ref.read(jobPostControllerProvider).error;
                        if (latestError != null) {
                          AppToast.show(context,
                            SnackBar(content: Text(latestError)),
                          );
                        }
                      }
                    },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'Save For Later',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF667085), // Grey
                ),
              ),
            )
          else
            const SizedBox.shrink(), // Placeholder when hidden

          // Submit/Update Button
          Flexible(
            child: GestureDetector(
              onTap: isLoading
                  ? null
                  : (isExisting ? _updateExistingJob : _submitWithPayment),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: isExisting ? 160 : 200, // Adjust width for "Update Job"
                  minWidth: isExisting ? 140 : 160,
                ),
                height: 60,
                decoration: BoxDecoration(
                  color: isLoading ? _primaryBtn.withOpacity(0.5) : _primaryBtn,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          isExisting ? 'Update Job' : 'Submit & Pay',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
