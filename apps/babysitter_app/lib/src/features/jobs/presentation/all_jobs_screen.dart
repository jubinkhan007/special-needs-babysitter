import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:domain/domain.dart' as domain;
import '../../../theme/app_tokens.dart';
import '../domain/job.dart';
import 'models/job_ui_model.dart';
import 'widgets/job_card.dart';
import 'widgets/jobs_app_bar.dart';
import 'package:go_router/go_router.dart';
import '../../../routing/routes.dart';
import 'providers/jobs_providers.dart';
import '../../parent/jobs/post_job/presentation/providers/job_post_providers.dart';

class AllJobsScreen extends ConsumerWidget {
  const AllJobsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobsAsync = ref.watch(allJobsProvider);
    final profileAsync = ref.watch(profileDetailsProvider);
    final profileDetails = profileAsync.valueOrNull;
    final childrenById = {
      for (final child in profileDetails?.children ?? <domain.Child>[])
        child.id: child,
    };

    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
        backgroundColor: AppTokens.jobsScreenBg,
        appBar: JobsAppBar(
          onBack: () => context.go(Routes.parentHome),
        ),
        body: jobsAsync.when(
          data: (jobs) {
            if (jobs.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.work_off_outlined,
                      size: 64,
                      color: AppTokens.textSecondary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No jobs found',
                      style: AppTokens.sectionTitle.copyWith(
                        color: AppTokens.textSecondary,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                AppTokens.jobsListHorizontalPadding,
                AppTokens.jobsListTopPadding,
                AppTokens.jobsListHorizontalPadding,
                80, // Bottom padding for nav bar space
              ),
              itemCount: jobs.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppTokens.jobsCardSpacing),
              itemBuilder: (context, index) {
                final job = jobs[index];
                final resolvedChildren =
                    _resolveChildren(job, childrenById);
                final uiModel = JobUiModel.fromDomain(
                  job,
                  childrenOverride: resolvedChildren,
                );

                return JobCard(
                  job: uiModel,
                  onViewDetails: () {
                    context.push(Routes.jobDetails, extra: job.id);
                  },
                  onManageApplication: () {
                    context.push(Routes.applications, extra: job.id);
                  },
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline,
                      size: 48, color: AppTokens.textSecondary),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading jobs',
                    style: AppTokens.sectionTitle,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    error.toString(),
                    textAlign: TextAlign.center,
                    style: AppTokens.kvValue,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () => ref.refresh(allJobsProvider),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTokens.primaryBlue,
                        foregroundColor: AppColors.textOnButton,
                      ),
                      child: const Text('Retry'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<ChildDetail> _resolveChildren(
    Job job,
    Map<String, domain.Child> childrenById,
  ) {
    if (job.childIds.isEmpty) {
      return job.children;
    }

    final resolved = <ChildDetail>[];
    for (final childId in job.childIds) {
      final child = childrenById[childId];
      if (child != null) {
        final name = child.firstName.isNotEmpty ? child.firstName : child.fullName;
        resolved.add(
          ChildDetail(
            name: name.isNotEmpty ? name : 'Child',
            ageYears: child.age,
          ),
        );
      }
    }

    return resolved.isNotEmpty ? resolved : job.children;
  }
} // Close class
