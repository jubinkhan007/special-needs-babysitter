import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:auth/auth.dart';

import '../../../routing/routes.dart';

import 'presentation/widgets/sitter_home_header.dart';
import 'presentation/widgets/app_search_field.dart';
import 'presentation/widgets/job_preview_card.dart';
import 'presentation/widgets/background_check_banner.dart';
import 'presentation/providers/sitter_home_providers.dart';
import 'presentation/mappers/job_preview_mapper.dart';
import 'presentation/screens/sitter_all_jobs_screen.dart';
import '../background_check/data/models/background_check_status_model.dart';
import '../background_check/presentation/providers/background_check_status_provider.dart';

/// Sitter home screen - Jobs near you
class SitterHomeScreen extends ConsumerWidget {
  const SitterHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('DEBUG: SitterHomeScreen build called');
    final userAsync = ref.watch(currentUserProvider);
    final user = userAsync.valueOrNull;

    print('DEBUG: SitterHomeScreen watching jobsNotifierProvider');
    final jobsAsync = ref.watch(jobsNotifierProvider);
    print('DEBUG: jobsAsync state: ${jobsAsync.toString()}');

    final backgroundCheckAsync = ref.watch(backgroundCheckStatusProvider);
    final status = backgroundCheckAsync.valueOrNull?.status ??
        BackgroundCheckStatusType.notStarted;

    // Status string for Banner
    String statusStr = 'not_started';
    if (status == BackgroundCheckStatusType.pending) statusStr = 'pending';
    if (status == BackgroundCheckStatusType.rejected) statusStr = 'rejected';
    if (status == BackgroundCheckStatusType.approved) statusStr = 'approved';

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Colored Top Section (extends behind status bar)
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFE7F5FC),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32.r),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  SitterHomeHeader(
                    userName: user?.firstName ?? 'Krystina',
                    location:
                        'Nashville, TN', // specific request or current user loc
                    avatarUrl: user?.avatarUrl,
                    onNotificationTap: () {
                      // TODO: Navigate to notifications
                    },
                    // You could pass the 'verified' status to the header here if needed
                    isVerified: status == BackgroundCheckStatusType.approved,
                  ),
                  SizedBox(height: 12.h),
                  AppSearchField(
                    hintText: 'Search jobs by location, date, or keyword',
                    onTap: () {
                      // TODO: Navigate to search screen
                    },
                  ),
                  SizedBox(height: 24.h), // Bottom padding
                ],
              ),
            ),
          ),
          SizedBox(height: 20.h),

          // Background Check Banner (Hidden if approved)
          if (status != BackgroundCheckStatusType.approved) ...[
            BackgroundCheckBanner(
              status: statusStr,
              onStart: () {
                if (status == BackgroundCheckStatusType.notStarted) {
                  context.push(Routes.sitterVerifyIdentity);
                }
                // For pending/rejected, maybe navigate to status details or support
              },
            ),
            SizedBox(height: 20.h),
          ],
          // Section Title
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Jobs near you',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1D2939),
                    fontFamily: 'Inter',
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SitterAllJobsScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'See All',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF667085),
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          // Job List
          Expanded(
            child: jobsAsync.when(
              data: (jobs) {
                if (jobs.isEmpty) {
                  return Center(
                    child: Text(
                      'No jobs found nearby.',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey,
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  padding: EdgeInsets.only(
                    bottom: 20.h + MediaQuery.of(context).padding.bottom,
                  ),
                  itemCount: jobs.length,
                  itemBuilder: (context, index) {
                    final job = jobs[index];
                    final preview = JobPreviewMapper.map(job);
                    return JobPreviewCard(
                      job: preview,
                      onViewDetails: () {
                        context.push('${Routes.sitterJobDetails}/${job.id}');
                      },
                      onBookmark: () {
                        // TODO: Toggle bookmark
                      },
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0.w),
                  child: Text(
                    'Error loading jobs',
                    style: TextStyle(color: Colors.red, fontSize: 13.sp),
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
