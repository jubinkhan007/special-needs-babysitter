import 'package:flutter/material.dart';
import '../../../../theme/app_tokens.dart';
import 'package:go_router/go_router.dart';
import '../../../../routing/routes.dart';

import '../../domain/job_details.dart';
import 'models/job_details_ui_model.dart';
import '../widgets/jobs_app_bar.dart';
import '../widgets/job_status_chip.dart';
import 'widgets/section_title.dart';
import 'widgets/key_value_row.dart';
import 'widgets/section_divider.dart';
import 'widgets/bottom_action_stack.dart';

class JobDetailsScreen extends StatelessWidget {
  final JobDetails job; // In real app, might pass ID and fetch

  const JobDetailsScreen({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    // Convert to UI model
    final uiModel = JobDetailsUiModel.fromDomain(job);

    return Scaffold(
      backgroundColor: AppTokens.jobDetailsBg,
      appBar: const JobsAppBar(
        title: 'Job Details',
        showSupportIcon: true,
      ), // Reusing common app bar
      body: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
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
                  ...uiModel.childDetailsRows.map((entry) => KeyValueRow(
                        label: entry.key,
                        value: entry.value,
                      )),
                  const SectionDivider(),

                  // 6. Schedule & Location
                  const SectionTitle(title: 'Schedule & Location'),
                  KeyValueRow(label: 'Date', value: uiModel.dateRangeText),
                  KeyValueRow(label: 'Time', value: uiModel.timeRangeText),
                  KeyValueRow(
                      label: 'Address',
                      value: uiModel.addressText,
                      isMultiline: true),
                  const SectionDivider(),

                  // 7. Emergency Contact
                  const SectionTitle(title: 'Emergency Contact'),
                  KeyValueRow(label: 'Name', value: uiModel.emergencyName),
                  KeyValueRow(
                      label: 'Phone Number', value: uiModel.emergencyPhone),
                  KeyValueRow(
                      label: 'Relations', value: uiModel.emergencyRelation),
                  const SectionDivider(),

                  // 8. Additional Details & Pay Rate
                  const SectionTitle(title: 'Additional Details & Pay Rate'),
                  Text(
                    uiModel.additionalNotes,
                    style: AppTokens.jobDetailsParagraphStyle,
                  ),
                  const SizedBox(height: 16),
                  KeyValueRow(
                      label: 'Hourly rate', value: uiModel.hourlyRateText),
                  const SectionDivider(),

                  // 9. Applicants
                  const SectionTitle(title: 'Applicants'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total', style: AppTokens.jobDetailsLabelStyle),
                      Text(uiModel.applicantsTotalText,
                          style: AppTokens.jobDetailsValueStyle),
                    ],
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomActionStack(
        primaryLabel: 'Edit job',
        secondaryLabel: 'Manage Applicants',
        outlinedLabel: 'Delete Job',
        onPrimary: () {}, // Edit
        onSecondary: () => context.push(Routes.applications), // Manage
        onOutlined: () {}, // Delete
      ),
    );
  }
}
