import 'package:flutter/material.dart';
import '../../../../theme/app_tokens.dart';
import '../widgets/jobs_app_bar.dart'; // Reuse
import '../job_details/widgets/section_title.dart'; // Reuse
import '../job_details/widgets/key_value_row.dart'; // Reuse
import 'models/booking_application_ui_model.dart';
import 'widgets/sitter_header_card.dart';
import 'widgets/dashed_divider.dart';
import 'widgets/transport_preferences_table.dart';
import 'widgets/bottom_decision_bar.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'controllers/applications_controller.dart';
import '../widgets/reject_reason_bottom_sheet.dart';
import '../../domain/rejection_reason.dart';
import 'package:go_router/go_router.dart';
import 'providers/applications_providers.dart';
import 'package:babysitter_app/src/common_widgets/app_toast.dart';

class BookingApplicationScreen extends ConsumerWidget {
  final String jobId;
  final String applicationId;

  const BookingApplicationScreen({
    super.key,
    required this.jobId,
    required this.applicationId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args =
        ApplicationDetailArgs(jobId: jobId, applicationId: applicationId);
    final applicationAsync = ref.watch(applicationDetailProvider(args));

    // Listen for controller state changes
    ref.listen<AsyncValue<void>>(
      applicationsControllerProvider,
      (prev, next) {
        next.whenOrNull(
          error: (error, stack) {
            AppToast.show(context, 
              SnackBar(content: Text('Error: $error')),
            );
          },
          data: (_) {
            if (prev?.isLoading == true) {
              // Success!
              AppToast.show(context, 
                const SnackBar(content: Text('Action completed successfully')),
              );
              context.pop(); // Go back to applications list
            }
          },
        );
      },
    );

    return applicationAsync.when(
      loading: () => const Scaffold(
        backgroundColor: AppTokens.applicationsBg,
        appBar: JobsAppBar(
          title: 'Booking Application',
          showSupportIcon: true,
        ),
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        backgroundColor: AppTokens.applicationsBg,
        appBar: const JobsAppBar(
          title: 'Booking Application',
          showSupportIcon: true,
        ),
        body: Center(child: Text('Error: $error')),
      ),
      data: (application) {
        final ui = BookingApplicationUiModel.fromDomain(application);
        final isPending =
            application.status == null || application.status == 'pending';

        return Scaffold(
          backgroundColor: AppTokens.applicationsBg,
          appBar: const JobsAppBar(
            title: 'Booking Application',
            showSupportIcon: true,
          ),
          body: MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.noScaling),
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTokens.applicationsHorizontalPadding,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const SizedBox(height: AppTokens.sectionTopGap),

                      // A) Sitter Summary Card
                      SitterHeaderCard(ui: ui),

                      const SizedBox(height: AppTokens.sectionGap),

                      // B) Cover Letter
                      const SectionTitle(title: 'Cover Letter'),
                      const SizedBox(height: 12),
                      const DashedDivider(),
                      const SizedBox(height: 16),
                      Text(
                        ui.coverLetter,
                        style: AppTokens.bodyParagraphStyle,
                      ),
                      const SizedBox(height: 16),
                      const DashedDivider(),

                      const SizedBox(height: AppTokens.sectionGap),

                      // C) Service Details
                      const SectionTitle(title: 'Service Details'),
                      const SizedBox(height: 12),
                      const DashedDivider(),
                      const SizedBox(height: 16),
                      KeyValueRow(label: 'Family Name', value: ui.familyName),
                      KeyValueRow(
                          label: 'No. Of Children',
                          value: ui.numberOfChildrenText),
                      KeyValueRow(label: 'Date', value: ui.dateRangeText),
                      KeyValueRow(label: 'Time', value: ui.timeRangeText),
                      KeyValueRow(
                          label: 'Hourly Rate', value: ui.hourlyRateText),
                      KeyValueRow(
                          label: 'No of Days', value: ui.numberOfDaysText),
                      KeyValueRow(
                          label: 'Additional Notes',
                          value: ui.additionalNotes,
                          isMultiline: true),
                      KeyValueRow(
                          label: 'Address',
                          value: ui.address,
                          isMultiline: true),
                      const SizedBox(height: 16),
                      const DashedDivider(),

                      const SizedBox(height: AppTokens.sectionGap),

                      // D) Transportation Preferences
                      if (ui.transportationModes.isNotEmpty ||
                          ui.equipmentAndSafety.isNotEmpty ||
                          ui.pickupDropoffDetails.isNotEmpty) ...[
                        Text('Transportation Preferences (Optional)',
                            style: AppTokens.sectionTitleStyle),
                        const SizedBox(height: 16),
                        TransportPreferencesTable(
                          modes: ui.transportationModes,
                          equipment: ui.equipmentAndSafety,
                          pickupDetails: ui.pickupDropoffDetails,
                        ),
                        const SizedBox(height: 16),
                        const DashedDivider(),
                      ],

                      const SizedBox(height: AppTokens.pageBottomSpacer),
                    ]),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: isPending
              ? BottomDecisionBar(
                  primaryLabel: 'Accept',
                  secondaryLabel: 'Reject',
                  onPrimary: () {
                    ref
                        .read(applicationsControllerProvider.notifier)
                        .acceptApplication(jobId, applicationId);
                  },
                  onSecondary: () async {
                    final result = await showRejectReasonBottomSheet(context);
                    if (result != null) {
                      final reason =
                          result.otherText ?? result.reason.displayLabel;
                      ref
                          .read(applicationsControllerProvider.notifier)
                          .declineApplication(
                            jobId,
                            applicationId,
                            reason,
                          );
                    }
                  },
                )
              : _buildStatusBar(application.status ?? 'processed'),
        );
      },
    );
  }

  Widget _buildStatusBar(String status) {
    Color bgColor;
    Color textColor;
    String displayText;

    switch (status.toLowerCase()) {
      case 'accepted':
        bgColor = const Color(0xFFE8F5E9);
        textColor = const Color(0xFF2E7D32);
        displayText = 'Application Accepted';
        break;
      case 'rejected':
      case 'declined':
        bgColor = const Color(0xFFFFEBEE);
        textColor = const Color(0xFFC62828);
        displayText = 'Application Rejected';
        break;
      default:
        bgColor = const Color(0xFFF5F5F5);
        textColor = const Color(0xFF757575);
        displayText = 'Status: ${status.toUpperCase()}';
    }

    return Material(
      color: bgColor,
      elevation: 8,
      child: SafeArea(
        top: false,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          child: Text(
            displayText,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
