import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../routing/routes.dart';
import '../providers/sitter_home_providers.dart';
import '../widgets/job_preview_card.dart';
import '../widgets/app_search_field.dart';
import '../../../saved_jobs/presentation/providers/saved_jobs_providers.dart';
import 'package:babysitter_app/src/common_widgets/app_toast.dart';

class SitterAllJobsScreen extends ConsumerWidget {
  const SitterAllJobsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobsAsync = ref.watch(jobPreviewsNotifierProvider);
    final savedJobsState = ref.watch(savedJobsControllerProvider);
    ref.watch(savedJobsListProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFE7F5FC),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 24.w),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text(
          'Jobs',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF101828),
            fontFamily: 'Inter',
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined,
                color: Colors.black, size: 24.w),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: const Color(0xFFE7F5FC),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: AppSearchField(
              hintText: 'Search jobs by location, date, or keyword',
              onTap: () {
                // TODO: Search
              },
            ),
          ),
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Showing ${jobsAsync.valueOrNull?.length ?? 0} Sitters', // Should be Jobs, but matching user mockup text
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xFF475467),
                    fontFamily: 'Inter',
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: const Color(0xFFD0D5DD)),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Filter By:',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: const Color(0xFF344054),
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Icon(Icons.keyboard_arrow_down,
                          size: 16.w, color: const Color(0xFF344054)),
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: jobsAsync.when(
              data: (jobPreviews) {
                if (jobPreviews.isEmpty) {
                  return const Center(child: Text('No jobs found'));
                }
                return ListView.builder(
                  padding: EdgeInsets.only(bottom: 20.h),
                  itemCount: jobPreviews.length,
                  itemBuilder: (context, index) {
                    final preview = jobPreviews[index];
                    final isSaved =
                        savedJobsState.savedJobIds.contains(preview.id);
                    final updatedPreview = preview.copyWith(isBookmarked: isSaved);
                    return JobPreviewCard(
                      job: updatedPreview,
                      onViewDetails: () {
                        context.push('${Routes.sitterJobDetails}/${preview.id}');
                      },
                      onBookmark: () {
                        if (preview.id.isEmpty) {
                          AppToast.show(context,
                            const SnackBar(content: Text('Missing job ID')),
                          );
                          return;
                        }
                        ref
                            .read(savedJobsControllerProvider.notifier)
                            .toggleSaved(preview.id)
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
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }
}
