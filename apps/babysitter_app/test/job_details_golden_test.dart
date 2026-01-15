import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:babysitter_app/src/features/jobs/domain/job.dart';
import 'package:babysitter_app/src/features/jobs/domain/job_details.dart';
import 'package:babysitter_app/src/features/jobs/presentation/job_details/job_details_screen.dart';
import 'package:babysitter_app/src/features/jobs/presentation/job_details/job_details_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  // Mock Data
  final mockJobDetails = JobDetails(
    id: '1',
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
    address: const Address(
      streetAddress: '7448, Kub Oval',
      aptUnit: '',
      city: 'Lake Edna',
      state: 'DC',
      zipCode: '2450',
    ),
    emergencyContactName: 'Ally Ronson',
    emergencyContactPhone: '+987452135',
    emergencyContactRelation: 'Father',
    additionalNotes:
        'My son is sensitive to loud noises, so please keep a calm and quiet environment.',
    hourlyRate: 20.0,
    applicantsCount: 5,
  );

  Widget createScreen() {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) {
        return ProviderScope(
          overrides: [
            jobDetailsProvider(mockJobDetails.id)
                .overrideWith((ref) => Future.value(mockJobDetails)),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: JobDetailsScreen(jobId: mockJobDetails.id),
          ),
        );
      },
    );
  }

  testWidgets('Job Details Screen - Golden Test', (tester) async {
    // 1. Pump widget
    await tester.pumpWidget(createScreen());

    // 2. Wait for rendering
    await tester.pumpAndSettle();

    // 3. Match golden file
    await expectLater(
      find.byType(JobDetailsScreen),
      matchesGoldenFile('goldens/job_details_screen.png'),
    );
  });
}
