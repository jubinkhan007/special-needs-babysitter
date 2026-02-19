import 'package:core/core.dart';
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
import 'dart:async';
import '../widgets/job_filter_sheet.dart';

class SitterAllJobsScreen extends ConsumerStatefulWidget {
  const SitterAllJobsScreen({super.key});

  @override
  ConsumerState<SitterAllJobsScreen> createState() =>
      _SitterAllJobsScreenState();
}

class _SitterAllJobsScreenState extends ConsumerState<SitterAllJobsScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    print('DEBUG AllJobsScreen: initState called');
    
    // Initialize search with current query if any
    final query = ref.read(jobSearchFiltersProvider).searchQuery;
    if (query != null && query.isNotEmpty) {
      _searchController.text = query;
    }

    // Set up scroll listener for pagination
    _scrollController.addListener(_onScroll);

    // Initial fetch immediately (like home screen) - don't wait for location
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('DEBUG AllJobsScreen: postFrameCallback - calling resetAndFetch');
      // Complete reset to match home screen behavior
      // This will fetch jobs without location first
      ref.read(jobSearchNotifierProvider.notifier).resetAndFetch();
      
      // Update location in background WITHOUT triggering another fetch
      // The location will be used for the next refresh/search
      _updateLocationInBackground();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(jobSearchNotifierProvider.notifier).loadMore();
    }
  }

  void _onSearchChanged(String query) {
    print('DEBUG _onSearchChanged: query="$query"');
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final trimmedQuery = query.trim();
      print('DEBUG _onSearchChanged debounce fired: trimmedQuery="$trimmedQuery"');
      if (trimmedQuery.isEmpty) {
        // When search is cleared, reset filters and fetch all jobs
        print('DEBUG _onSearchChanged: calling resetAndFetch()');
        ref.read(jobSearchNotifierProvider.notifier).resetAndFetch();
      } else {
        ref.read(jobSearchFiltersProvider.notifier).setSearchQuery(trimmedQuery);
        ref.read(jobSearchNotifierProvider.notifier).fetchJobs();
      }
    });
  }

  /// Update location in background without triggering a fetch
  /// This allows the location to be available for next search/refresh
  Future<void> _updateLocationInBackground() async {
    try {
      final position = await ref.read(deviceLocationProvider.future);
      if (position != null) {
        // Directly update filters without triggering refresh
        final currentFilters = ref.read(jobSearchFiltersProvider);
        if (currentFilters.latitude != position.latitude ||
            currentFilters.longitude != position.longitude) {
          ref.read(jobSearchFiltersProvider.notifier).state = 
              currentFilters.copyWith(
                latitude: position.latitude,
                longitude: position.longitude,
              );
          print('DEBUG AllJobsScreen: Location updated in background: ${position.latitude}, ${position.longitude}');
        }
      }
    } catch (e) {
      print('DEBUG AllJobsScreen: Error getting location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(jobSearchNotifierProvider);
    final filters = ref.watch(jobSearchFiltersProvider);
    final savedJobsState = ref.watch(savedJobsControllerProvider);
    ref.watch(savedJobsListProvider);

    // Debug logging
    print('DEBUG AllJobsScreen: isLoading=${searchState.isLoading}, jobs=${searchState.jobs.length}, error=${searchState.error}');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceTint,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 24.w),
          onPressed: () => Navigator.of(context).pop(),
        ),
                centerTitle: true,
                title: Text(
                  'Search',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF101828),            fontFamily: 'Inter',
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
            color: AppColors.surfaceTint,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: AppSearchField(
              hintText: 'Search jobs by location, date, or keyword',
              enabled: true,
              controller: _searchController,
              onChanged: _onSearchChanged,
              autofocus: _searchController.text.isEmpty,
            ),
          ),
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Showing ${searchState.jobs.length} Jobs',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xFF475467),
                    fontFamily: 'Inter',
                  ),
                ),
                GestureDetector(
                  onTap: () => JobFilterSheet.show(context),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: const Color(0xFFD0D5DD)),
                      color: filters.hasActiveFilters
                          ? const Color(0xFFEFF8FF)
                          : Colors.transparent,
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Filter By${filters.hasActiveFilters ? " (${filters.activeFilterCount})" : ""}',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: filters.hasActiveFilters
                                ? const Color(0xFF175CD3)
                                : const Color(0xFF344054),
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (!filters.hasActiveFilters) ...[
                          SizedBox(width: 4.w),
                          Icon(Icons.keyboard_arrow_down,
                              size: 16.w, color: const Color(0xFF344054)),
                        ],
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: _buildBody(searchState, savedJobsState),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(JobSearchState state, dynamic savedJobsState) {
    if (state.isLoading && state.jobs.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.jobs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: ${state.error}'),
            TextButton(
              onPressed: () =>
                  ref.read(jobSearchNotifierProvider.notifier).fetchJobs(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state.jobs.isEmpty) {
      return Center(
        child: Text(
          'No jobs found matching your criteria',
          style: TextStyle(
            fontSize: 14.sp,
            color: const Color(0xFF667085),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(jobSearchNotifierProvider.notifier).refresh();
      },
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.only(
            bottom: 20.h + MediaQuery.of(context).padding.bottom),
        itemCount: state.jobs.length + (state.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == state.jobs.length) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(16.h),
                child: const CircularProgressIndicator(),
              ),
            );
          }

          final preview = state.jobs[index];
          final isSaved = savedJobsState.savedJobIds.contains(preview.id);
          final updatedPreview = preview.copyWith(isBookmarked: isSaved);

          return JobPreviewCard(
            job: updatedPreview,
            onViewDetails: () {
              context.push('${Routes.sitterJobDetails}/${preview.id}');
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
                    backgroundColor: AppColors.success,
                  ),
                );
              }).catchError((error) {
                AppToast.show(
                  context,
                  SnackBar(
                    content:
                        Text(error.toString().replaceFirst('Exception: ', '')),
                    backgroundColor: Colors.red,
                  ),
                );
              });
            },
          );
        },
      ),
    );
  }
}
