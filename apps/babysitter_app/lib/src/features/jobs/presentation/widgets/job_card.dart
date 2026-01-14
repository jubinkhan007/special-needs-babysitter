import 'package:flutter/material.dart';
import '../../../../theme/app_tokens.dart';
import '../models/job_ui_model.dart';
import 'job_status_chip.dart';
import 'job_info_item.dart';
import 'job_rich_child_details.dart';
import 'jobs_buttons.dart';

class JobCard extends StatelessWidget {
  final JobUiModel job;
  final VoidCallback? onViewDetails;
  final VoidCallback? onManageApplication;

  const JobCard({
    super.key,
    required this.job,
    this.onViewDetails,
    this.onManageApplication,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTokens.jobsCardBg,
        borderRadius: BorderRadius.circular(AppTokens.jobsCardRadius),
        border: Border.all(color: AppTokens.jobsCardBorder),
        boxShadow: AppTokens.jobsCardShadow,
      ),
      padding: const EdgeInsets.all(AppTokens.jobsCardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                job.title,
                style: AppTokens.jobsCardTitleStyle,
              ),
              JobStatusChip(isActive: job.isActive),
            ],
          ),

          const SizedBox(height: AppTokens.jobInfoColumnGap),

          // 2. Info Grid
          // Row 1: Location & Schedule
          Row(
            children: [
              Expanded(
                child: JobInfoItem(
                  icon: Icons.location_on_outlined,
                  label: 'Location',
                  value: job.location, // Brooklyn, NY 11201
                ),
              ),
              const SizedBox(width: AppTokens.jobInfoRowGap),
              Expanded(
                child: JobInfoItem(
                  icon: Icons.schedule, // Or similar time icon
                  label: 'Schedule',
                  value: job.scheduleLabel, // 20 May, 2025
                ),
              ),
            ],
          ),

          const SizedBox(height: AppTokens.jobInfoColumnGap),

          // Row 2: Rate & Child Details
          Row(
            children: [
              Expanded(
                child: JobInfoItem(
                  icon: Icons.attach_money,
                  label: 'Rate',
                  value: job.rateLabel, // $25/hr
                ),
              ),
              const SizedBox(width: AppTokens.jobInfoRowGap),
              Expanded(
                child: JobInfoItem(
                  icon: Icons.face_outlined,
                  label: 'Child Details',
                  value: '', // Ignored when customValueWidget is present
                  customValueWidget: JobRichChildDetails(parts: job.childParts),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppTokens.jobInfoColumnGap),

          // 3. Divider (Optional visuals show a separation but maybe just space. Screenshot shows space? No, distinct separation.)
          // Actually screenshot doesn't show a strong divider line, but a clear gap between details and buttons.
          // Let's add a subtle divider just in case.
          const Divider(
            height: 1,
            thickness: AppTokens.jobDividerThickness,
            color: AppTokens.jobDividerColor,
          ),

          const SizedBox(height: AppTokens.jobButtonsTopPadding),

          // 4. Buttons
          JobsPrimaryButton(
            text: 'View Details',
            onTap: onViewDetails ?? () {},
          ),

          const SizedBox(height: 12), // Gap between buttons

          JobsSecondaryButton(
            text: 'Manage Application',
            onTap: onManageApplication ?? () {},
          ),
        ],
      ),
    );
  }
}
