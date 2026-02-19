import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../routing/routes.dart';
import 'presentation/widgets/sitter_job_application_card.dart';
import 'presentation/widgets/job_status_badge.dart';
import 'presentation/providers/sitter_job_applications_provider.dart';

/// Sitter jobs screen with tabbed application views
class SitterJobsScreen extends ConsumerWidget {
  const SitterJobsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: AppColors.surfaceTint,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: AppColors.surfaceTint,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          ),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: const Color(0xFF667085), size: 24.w),
            onPressed: () {
              context.go(Routes.sitterHome);
            },
          ),
          centerTitle: true,
          title: Text(
            'Jobs',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.buttonDark,
              fontFamily: 'Inter',
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.notifications_none_outlined,
                  color: const Color(0xFF667085), size: 24.w),
              onPressed: () {},
            ),
          ],
          bottom: null,
        ),
        body: Column(
          children: [
            Container(
              color: Colors.white, // Match body color
              width: double.infinity,
              height: 48.h,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(bottom: 8.h),
              child: TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                dividerColor: Colors.transparent,
                padding:
                    EdgeInsets.symmetric(horizontal: 20.w), // Outer padding
                labelPadding: EdgeInsets.only(right: 12.w), // Gap between tabs
                labelColor: Colors.white,
                unselectedLabelColor: const Color(0xFF667085),
                indicatorSize: TabBarIndicatorSize
                    .tab, // Use 'tab' to circle the whole widget
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.r), // More rounded
                  color: const Color(
                      0xFF87C4F2), // Lighter blue matching typical UI
                ),
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                labelStyle: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter'),
                unselectedLabelStyle: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Inter'),
                tabs: [
                  _buildTab('Applied'),
                  _buildTab('Requests'),
                  _buildTab('Completed'),
                  _buildTab('Cancelled'),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: TabBarView(
                  children: [
                    _buildJobList(ref, type: 'applied'),
                    _buildRequestsList(ref), // Special handling for requests
                    _buildJobList(ref, status: 'completed'),
                    _buildJobList(ref, status: 'cancelled'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String text) {
    return Tab(
      height: 36.h,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
          // border: Border.all(color: Colors.transparent), // Placeholder for unselected border if needed
        ),
        child: Text(text),
      ),
    );
  }

  /// Builds the Requests tab showing both invitations and direct bookings
  Widget _buildRequestsList(WidgetRef ref) {
    final applicationsAsync = ref.watch(sitterJobRequestsProvider);

    return applicationsAsync.when(
      data: (applications) {
        if (applications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.assignment_outlined,
                    size: 64.w, color: Colors.grey[300]),
                SizedBox(height: 16.h),
                Text(
                  'No job requests found',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey[500],
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: EdgeInsets.all(20.w),
          itemCount: applications.length,
          separatorBuilder: (context, index) => SizedBox(height: 16.h),
          itemBuilder: (context, index) {
            final app = applications[index];
            final job = app.job;

            JobApplicationStatus statusEnum;
            try {
              statusEnum = JobApplicationStatus.values.firstWhere(
                (e) => e.name.toLowerCase() == app.status.toLowerCase(),
                orElse: () => JobApplicationStatus.pending,
              );
            } catch (_) {
              statusEnum = JobApplicationStatus.pending;
            }

            // Simple date formatting
            final date = job.startDate;

            return SitterJobApplicationCard(
              id: app.id,
              jobId: job.id,
              jobTitle: job.title,
              familyName: job.familyName,
              childCount: '${job.childrenCount} Children',
              avatarUrl:
                  job.familyPhotoUrl ?? 'https://via.placeholder.com/150',
              location: job.location,
              distance: '2.5 km away', // Mock distance for now
              hourlyRate: job.payRate,
              scheduledDate: date,
              status: statusEnum,
              onViewDetails: () {
                // For both invitations and direct bookings:
                // If accepted, navigate to booking details
                // Otherwise, navigate to job request details for accept/decline
                if (app.status.toLowerCase() == 'accepted') {
                  context.push('${Routes.sitterBookingDetails}/${app.id}');
                } else {
                  context.push(
                      '${Routes.sitterJobRequestDetails}/${app.id}?type=${app.applicationType}&status=${app.status}');
                }
              },
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }

  Widget _buildJobList(WidgetRef ref, {String? type, String? status}) {
    final filter = ApplicationsFilter(type: type, status: status);
    final applicationsAsync = ref.watch(sitterJobApplicationsProvider(filter));

    return applicationsAsync.when(
      data: (applications) {
        if (applications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.assignment_outlined,
                    size: 64.w, color: Colors.grey[300]),
                SizedBox(height: 16.h),
                Text(
                  'No jobs found',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey[500],
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: EdgeInsets.all(20.w),
          itemCount: applications.length,
          separatorBuilder: (context, index) => SizedBox(height: 16.h),
          itemBuilder: (context, index) {
            final app = applications[index];
            final job = app.job;

            JobApplicationStatus statusEnum;
            try {
              statusEnum = JobApplicationStatus.values.firstWhere(
                (e) => e.name.toLowerCase() == app.status.toLowerCase(),
                orElse: () => JobApplicationStatus.pending,
              );
            } catch (_) {
              statusEnum = JobApplicationStatus.pending;
            }

            // Simple date formatting
            final date = job.startDate; // Should format this nicely

            return SitterJobApplicationCard(
              id: app.id,
              jobId: job.id,
              jobTitle: job.title,
              familyName: job.familyName,
              childCount: '${job.childrenCount} Children',
              avatarUrl:
                  job.familyPhotoUrl ?? 'https://via.placeholder.com/150',
              location: job.location,
              distance: '2.5 km away', // Mock distance for now
              hourlyRate: job.payRate,
              scheduledDate: date,
              status: statusEnum,
              onViewDetails: () {
                // Navigate based on type and status
                if (type == 'invited') {
                  // If accepted, navigate to booking details instead of job request
                  if (app.status.toLowerCase() == 'accepted') {
                    context.push('${Routes.sitterBookingDetails}/${app.id}');
                  } else {
                    context.push(
                        '${Routes.sitterJobRequestDetails}/${app.id}?type=${app.applicationType}&status=${app.status}');
                  }
                } else if (status != null &&
                    status.toLowerCase() == 'completed') {
                  context.push(
                      '${Routes.sitterBookingDetails}/${app.id}?status=${app.status}');
                } else {
                  context.push('${Routes.sitterApplicationDetails}/${app.id}');
                }
              },
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
