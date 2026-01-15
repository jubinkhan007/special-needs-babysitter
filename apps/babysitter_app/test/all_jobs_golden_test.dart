import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:babysitter_app/src/features/jobs/presentation/all_jobs_screen.dart';
import 'package:babysitter_app/src/features/jobs/presentation/providers/jobs_providers.dart';
import 'package:babysitter_app/src/features/jobs/domain/job.dart';

void main() {
  testWidgets('All Jobs Screen - Golden Test', (tester) async {
    // Mock Data matching previous hardcoded values to preserve golden
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

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          allJobsProvider.overrideWith((ref) => mockJobs),
        ],
        child: ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (context, child) {
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: AllJobsScreen(),
            );
          },
        ),
      ),
    );

    await tester.pumpAndSettle();

    await expectLater(
      find.byType(AllJobsScreen),
      matchesGoldenFile('goldens/all_jobs_screen.png'),
    );
  });
}
