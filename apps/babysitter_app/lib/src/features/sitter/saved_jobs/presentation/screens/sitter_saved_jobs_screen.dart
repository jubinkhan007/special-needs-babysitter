import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../home/presentation/widgets/app_search_field.dart';
import '../../../home/presentation/widgets/job_preview_card.dart';
import '../../../home/presentation/mappers/job_preview_mapper.dart';
import '../providers/saved_jobs_providers.dart';
import '../providers/location_provider.dart';
import 'package:babysitter_app/src/common_widgets/app_toast.dart';
import 'package:babysitter_app/src/routing/routes.dart';

class SitterSavedJobsScreen extends ConsumerWidget {
  const SitterSavedJobsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedJobsAsync = ref.watch(savedJobsListProvider);
    final savedJobsState = ref.watch(savedJobsControllerProvider);
    final userLocationAsync = ref.watch(sitterLocationProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: const Color(0xFF667085), size: 24.w),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(Routes.sitterAccount);
            }
          },
        ),
        centerTitle: true,
        title: Text(
          'Saved Jobs',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1D2939),
            fontFamily: 'Inter',
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: AppSearchField(
              hintText: 'Search saved jobs',
              onTap: () {},
            ),
          ),
          Expanded(
            child: savedJobsAsync.when(
              data: (jobs) {
                final savedIds = savedJobsState.savedJobIds;
                final visibleJobs = savedIds.isEmpty
                    ? jobs
                    : jobs.where((job) => savedIds.contains(job.id ?? '')).toList();

                if (visibleJobs.isEmpty) {
                  return Center(
                    child: Text(
                      'No saved jobs yet.',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: const Color(0xFF98A2B3),
                        fontFamily: 'Inter',
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(savedJobsListProvider);
                    ref.invalidate(sitterLocationProvider);
                  },
                  child: ListView.builder(
                    padding: EdgeInsets.only(
                      bottom: 20.h + MediaQuery.of(context).padding.bottom,
                    ),
                    itemCount: visibleJobs.length,
                    itemBuilder: (context, index) {
                      final job = visibleJobs[index];
                      final jobId = job.id ?? '';
                      final isSaved = savedJobsState.savedJobIds.contains(jobId);
                      final preview = JobPreviewMapper.map(
                        job,
                        isBookmarked: isSaved,
                        userLocation: userLocationAsync.valueOrNull,
                      );

                      return JobPreviewCard(
                        job: preview,
                        onViewDetails: () {
                          context.push('${Routes.sitterJobDetails}/${job.id}');
                        },
                        onBookmark: () {
                          if (jobId.isEmpty) {
                            AppToast.show(
                              context,
                              const SnackBar(content: Text('Missing job ID')),
                            );
                            return;
                          }
                          ref
                              .read(savedJobsControllerProvider.notifier)
                              .toggleSaved(jobId)
                              .then((isNowSaved) {
                            if (!isNowSaved) {
                              ref.invalidate(savedJobsListProvider);
                            }
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
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Text(
                    'Failed to load saved jobs',
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
