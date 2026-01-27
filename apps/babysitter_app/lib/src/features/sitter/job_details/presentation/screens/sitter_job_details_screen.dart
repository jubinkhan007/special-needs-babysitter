import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../theme/app_tokens.dart';
import '../../../../../routing/routes.dart';
import '../../../home/presentation/widgets/app_tag_chip.dart';
import '../providers/job_details_providers.dart';
import '../widgets/job_details_app_bar.dart';
import '../widgets/job_header_block.dart';
import '../widgets/job_meta_rows.dart';
import '../widgets/service_details_table.dart';
import '../widgets/transportation_section.dart';

import '../widgets/cover_letter_box.dart';
import '../widgets/job_details_bottom_bar.dart';
import 'package:babysitter_app/src/common_widgets/app_toast.dart';
import '../../../saved_jobs/presentation/providers/saved_jobs_providers.dart';

/// Sitter job details screen.
class SitterJobDetailsScreen extends ConsumerStatefulWidget {
  final String jobId;

  const SitterJobDetailsScreen({
    super.key,
    required this.jobId,
  });

  @override
  ConsumerState<SitterJobDetailsScreen> createState() =>
      _SitterJobDetailsScreenState();
}

class _SitterJobDetailsScreenState
    extends ConsumerState<SitterJobDetailsScreen> {
  final _coverLetterController = TextEditingController();

  @override
  void dispose() {
    _coverLetterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final jobDetailsAsync = ref.watch(sitterJobDetailsProvider(widget.jobId));

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // App bar
          const JobDetailsAppBar(),
          // Content
          Expanded(
            child: jobDetailsAsync.when(
              data: (job) {
                print('DEBUG: SitterJobDetailsScreen loaded job: ${job.title}');
                return _buildContent(context, job);
              },
              loading: () {
                print(
                    'DEBUG: SitterJobDetailsScreen loading for jobId=${widget.jobId}');
                return const Center(child: CircularProgressIndicator());
              },
              error: (error, stack) {
                print('DEBUG: SitterJobDetailsScreen ERROR: $error');
                print('DEBUG: Stack: $stack');
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Error loading job details',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          error.toString(),
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Bottom bar (only show when data is available)
          jobDetailsAsync.maybeWhen(
            data: (job) => JobDetailsBottomBar(
              hourlyRate: job.hourlyRate,
              onApply: () {
                final coverLetter = _coverLetterController.text.trim();
                if (coverLetter.isEmpty) {
                  AppToast.show(context, 
                    SnackBar(
                      content:
                          const Text('Please write a cover letter to apply'),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                      margin: EdgeInsets.all(16.w),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  );
                  return;
                }

                context.push(
                  '${Routes.sitterJobDetails}/${widget.jobId}/application-preview',
                  extra: coverLetter,
                );
              },
            ),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, dynamic job) {
    final savedJobsState = ref.watch(savedJobsControllerProvider);
    final jobId = job.id as String;
    final isSaved = savedJobsState.savedJobIds.contains(jobId);
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),
          // Header block
          JobHeaderBlock(
            title: job.title,
            postedTimeAgo: job.postedTimeAgo,
            isBookmarked: isSaved,
            onBookmarkTap: () {
              ref
                  .read(savedJobsControllerProvider.notifier)
                  .toggleSaved(jobId)
                  .catchError((error) {
                AppToast.show(
                  context,
                  SnackBar(
                    content: Text(
                        error.toString().replaceFirst('Exception: ', '')),
                    backgroundColor: Colors.red,
                  ),
                );
              });
            },
          ),
          SizedBox(height: 16.h),
          // Meta rows
          JobMetaRows(
            familyName: job.familyName,
            familyAvatarUrl: job.familyAvatarUrl,
            childrenCount: job.childrenCount,
            children: job.children,
            location: job.location,
            distance: job.distance,
          ),
          SizedBox(height: 16.h),
          // Divider
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Divider(
              height: 1,
              thickness: 1,
              color: AppTokens.dividerSoft,
            ),
          ),
          SizedBox(height: 20.h),
          // Service details
          ServiceDetailsTable(
            dateRange: job.dateRange,
            timeRange: job.timeRange,
            personality: job.personality,
            allergies: job.allergies,
            triggers: job.triggers,
            calmingMethods: job.calmingMethods,
            additionalNotes: job.additionalNotes,
          ),
          SizedBox(height: 20.h),
          // Transportation section
          TransportationSection(
            transportationModes: job.transportationModes,
            equipmentSafety: job.equipmentSafety,
            pickupDropoffDetails: job.pickupDropoffDetails,
          ),
          SizedBox(height: 20.h),
          // Skills chips
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: job.requiredSkills
                  .map<Widget>((skill) => AppTagChip(label: skill))
                  .toList(),
            ),
          ),
          SizedBox(height: 20.h),
          // Cover letter
          CoverLetterBox(
            controller: _coverLetterController,
          ),
        ],
      ),
    );
  }
}
