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
import 'presentation/screens/sitter_all_jobs_screen.dart';
import '../background_check/data/models/background_check_status_model.dart';
import '../background_check/presentation/providers/background_check_status_provider.dart';
import '../saved_jobs/presentation/providers/saved_jobs_providers.dart';
import 'package:babysitter_app/src/common_widgets/app_toast.dart';

/// Sitter home screen - Jobs near you
class SitterHomeScreen extends ConsumerWidget {
  const SitterHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    final user = userAsync.valueOrNull;

    final jobsAsync = ref.watch(jobPreviewsNotifierProvider);
    final savedJobsState = ref.watch(savedJobsControllerProvider);
    ref.watch(savedJobsListProvider);

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
                      print('DEBUG HomeScreen: Search field tapped');
                      // Fetch jobs before navigating to ensure data is loaded
                      ref.read(jobSearchNotifierProvider.notifier).resetAndFetch();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SitterAllJobsScreen(),
                        ),
                      );
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
                  return;
                }
                if (status == BackgroundCheckStatusType.pending) {
                  context.push(Routes.sitterBackgroundCheck);
                  return;
                }
                if (status == BackgroundCheckStatusType.rejected) {
                  context.push(Routes.sitterVerifyIdentity);
                  return;
                }
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
                    print('DEBUG HomeScreen: See All tapped, navigating to AllJobsScreen');
                    // Reset and fetch to ensure All Jobs screen shows same data
                    ref.read(jobSearchNotifierProvider.notifier).resetAndFetch();
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
          // Job List with Pull to Refresh
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await ref.read(jobPreviewsNotifierProvider.notifier).refresh();
              },
              child: jobsAsync.when(
                data: (jobPreviews) {
                  if (jobPreviews.isEmpty) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(height: 100.h),
                        Center(
                          child: Text(
                            'No jobs found nearby.\nPull down to refresh.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  return ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.only(
                      bottom: 20.h + MediaQuery.of(context).padding.bottom,
                    ),
                    itemCount: jobPreviews.length,
                    itemBuilder: (context, index) {
                      final preview = jobPreviews[index];
                      // Update bookmark status from local state
                      final isSaved =
                          savedJobsState.savedJobIds.contains(preview.id);
                      final updatedPreview =
                          preview.copyWith(isBookmarked: isSaved);
                      return JobPreviewCard(
                        job: updatedPreview,
                        onViewDetails: () {
                          context
                              .push('${Routes.sitterJobDetails}/${preview.id}');
                        },
                        onBookmark: () {
                          if (preview.id.isEmpty) {
                            AppToast.show(
                              context,
                              const SnackBar(content: Text('Missing job ID')),
                            );
                            return;
                          }
                          ref
                              .read(savedJobsControllerProvider.notifier)
                              .toggleSaved(preview.id)
                              .then((isSaved) {
                            AppToast.show(
                              context,
                              SnackBar(
                                content: Text(
                                  isSaved ? 'Job saved' : 'Job unsaved',
                                ),
                                backgroundColor: const Color(0xFF22C55E),
                              ),
                            );
                          }).catchError((error) {
                            AppToast.show(
                              context,
                              SnackBar(
                                content: Text(error
                                    .toString()
                                    .replaceFirst('Exception: ', '')),
                                backgroundColor: Colors.red,
                              ),
                            );
                          });
                        },
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(height: 100.h),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0.w),
                        child: Text(
                          'Error loading jobs.\nPull down to retry.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.red, fontSize: 13.sp),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
