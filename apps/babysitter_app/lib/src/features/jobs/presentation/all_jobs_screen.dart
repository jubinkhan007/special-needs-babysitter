import 'package:flutter/material.dart';
import '../../../theme/app_tokens.dart';
import '../domain/job.dart';
import 'models/job_ui_model.dart';
import 'widgets/job_card.dart';
import 'widgets/jobs_app_bar.dart';
import '../domain/job_details.dart';
import 'package:go_router/go_router.dart';
import '../../../routing/routes.dart';

class AllJobsScreen extends StatelessWidget {
  const AllJobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // MOCK DATA for verification
    final mockJobs = [
      Job(
        id: '1',
        title: 'Part Time Sitter Needed',
        status: JobStatus.active,
        location: 'Brooklyn, NY 11201',
        scheduleDate: DateTime(2025, 5, 20),
        rateText: '\$25/hr',
        children: [
          const ChildDetail(name: 'Ally', ageYears: 4),
          const ChildDetail(name: 'Jason', ageYears: 2),
        ],
      ),
      Job(
        id: '2',
        title: 'Full Time Nanny Needed',
        status: JobStatus.active,
        location: 'Manhattan, NY 10001',
        scheduleDate: DateTime(2025, 6, 15),
        rateText: '\$30/hr',
        children: [
          const ChildDetail(name: 'Sarah', ageYears: 6),
        ],
      ),
      Job(
        id: '3',
        title: 'Weekend Sitter',
        status: JobStatus.active,
        location: 'Queens, NY 11101',
        scheduleDate: DateTime(2025, 5, 25),
        rateText: '\$22/hr',
        children: [
          const ChildDetail(name: 'Mike', ageYears: 8),
          const ChildDetail(name: 'Emma', ageYears: 5),
        ],
      ),
    ];

    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
        backgroundColor: AppTokens.jobsScreenBg,
        appBar: const JobsAppBar(),
        body: ListView.separated(
          padding: const EdgeInsets.fromLTRB(
            AppTokens.jobsListHorizontalPadding,
            AppTokens.jobsListTopPadding,
            AppTokens.jobsListHorizontalPadding,
            80, // Bottom padding for nav bar space
          ),
          itemCount: mockJobs.length,
          separatorBuilder: (context, index) =>
              const SizedBox(height: AppTokens.jobsCardSpacing),
          itemBuilder: (context, index) {
            final job = mockJobs[index];
            final uiModel = JobUiModel.fromDomain(job);

            return JobCard(
              job: uiModel,
              onViewDetails: () {
                context.push(
                  Routes.jobDetails,
                  extra: _getMockJobDetails(job.id),
                );
              },
              onManageApplication: () {
                context.push(Routes.applications);
              },
            );
          },
        ),
      ),
    );
  }

  // Temporary mock helper
  JobDetails _getMockJobDetails(String id) {
    return JobDetails(
      id: id,
      status: JobStatus.active,
      title: 'Part Time Sitter Needed',
      postedAt: DateTime.now().subtract(const Duration(hours: 12)),
      children: [
        const ChildDetail(name: 'Ally', ageYears: 4),
        const ChildDetail(name: 'Jason', ageYears: 2),
      ],
      scheduleStartDate: DateTime(2025, 8, 14),
      scheduleEndDate: DateTime(2025, 8, 17),
      scheduleStartTime: const TimeOfDay(hour: 9, minute: 0),
      scheduleEndTime: const TimeOfDay(hour: 18, minute: 0),
      address:
          '7448, Kub Oval, 2450 Brian Meadow, District of Columbia, Lake Edna',
      emergencyContactName: 'Ally Ronson',
      emergencyContactPhone: '+987452135',
      emergencyContactRelation: 'Father',
      additionalNotes:
          'My son is sensitive to loud noises, so please keep a calm and quiet environment.',
      hourlyRate: 20.0,
      applicantsCount: 5,
    );
  }
} // Close class
