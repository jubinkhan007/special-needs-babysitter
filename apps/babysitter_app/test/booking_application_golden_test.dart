import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:babysitter_app/src/features/jobs/presentation/applications/booking_application_screen.dart';
import 'package:babysitter_app/src/features/jobs/domain/applications/booking_application.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:babysitter_app/src/features/jobs/presentation/applications/providers/applications_providers.dart';

import 'package:babysitter_app/src/features/jobs/domain/jobs_repository.dart';
import 'package:babysitter_app/src/features/jobs/domain/applications/applications_repository.dart';
import 'package:babysitter_app/src/features/jobs/domain/job.dart';
import 'package:babysitter_app/src/features/jobs/domain/job_details.dart';
import 'package:babysitter_app/src/features/jobs/domain/applications/application_item.dart';

// Mocks
class MockJobsRepository implements JobsRepository {
  @override
  Future<List<Job>> getJobs() async => [];

  @override
  Future<JobDetails> getJobDetails(String id) async {
    return JobDetails(
      id: 'job-123',
      status: JobStatus.active,
      title: 'Test Job',
      postedAt: DateTime(2025, 1, 1),
      children: [], // Empty for test
      scheduleStartDate: DateTime(2025, 8, 14),
      scheduleEndDate: DateTime(2025, 8, 17),
      scheduleStartTime: const TimeOfDay(hour: 9, minute: 0),
      scheduleEndTime: const TimeOfDay(hour: 18, minute: 0),
      address: const Address(
        streetAddress: '7448, Kub Oval',
        aptUnit: '',
        city: 'Lake Edna',
        state: 'DC',
        zipCode: '20001',
      ),
      emergencyContactName: '',
      emergencyContactPhone: '',
      emergencyContactRelation: '',
      additionalNotes: 'We Have Two Black Cats',
      hourlyRate: 20.0,
      applicantsCount: 1,
    );
  }

  @override
  Future<void> updateJob(String id, Map<String, dynamic> data) async {}

  @override
  Future<void> deleteJob(String id) async {}
}

class MockApplicationsRepository implements ApplicationsRepository {
  @override
  Future<List<ApplicationItem>> getApplications(String jobId) async {
    return [
      ApplicationItem(
        id: 'app-123',
        sitterName: 'Krystina',
        avatarUrl: '',
        isVerified: true,
        distanceMiles: 2.0,
        rating: 4.5,
        responseRatePercent: 95,
        reliabilityRatePercent: 95,
        experienceYears: 5,
        jobTitle: 'Job Title',
        scheduledDate: DateTime.now(),
        isApplication: true,
        coverLetter:
            'Hey Christie! This is Krystina. I am interested in sitting for you on March 4th from 10am - 5pm. I have over 7 years of experience.',
        skills: ['CPR', 'First-aid', 'Special Needs Training'],
      ),
    ];
  }

  @override
  Future<BookingApplication> getApplicationDetail(
      {required String jobId, required String applicationId}) async {
    throw UnimplementedError('Not used in composite provider');
  }

  @override
  Future<void> acceptApplication(
      {required String jobId, required String applicationId}) async {}

  @override
  Future<void> declineApplication(
      {required String jobId,
      required String applicationId,
      required String reason}) async {}
}

void main() {
  final mockBookingApp = BookingApplication(
    id: 'app-123',
    sitterName: 'Krystina',
    avatarUrl: '',
    isVerified: true,
    distanceMiles: 2.0,
    rating: 4.5,
    responseRatePercent: 95,
    reliabilityRatePercent: 95,
    experienceYears: 5,
    skills: ['CPR', 'First-aid', 'Special Needs Training'],
    coverLetter:
        'Hey Christie! This is Krystina. I am interested in sitting for you on March 4th from 10am - 5pm. I have over 7 years of experience.',
    familyName: 'Smith',
    numberOfChildren: 3,
    startDate: DateTime(2025, 8, 14),
    endDate: DateTime(2025, 8, 17),
    startTime: DateTime(2025, 1, 1, 9, 0),
    endTime: DateTime(2025, 1, 1, 18, 0),
    hourlyRate: 20.0,
    numberOfDays: 4,
    additionalNotes: 'We Have Two Black Cats',
    address:
        '7448, Kub Oval, 2450 Brian Meadow, District of Columbia, Lake Edna',
    transportationModes: [
      'No transportation (care at home only)',
    ],
    equipmentAndSafety: [
      'Car seat required',
    ],
    pickupDropoffDetails: [
      'Sunshine Elementary School, Gate 3',
    ],
  );

  Widget createScreen() {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) {
        return ProviderScope(
          overrides: [
            applicationDetailProvider.overrideWith(
              (ref, args) => Future.value(mockBookingApp),
            ),
            applicationsRepositoryProvider
                .overrideWithValue(MockApplicationsRepository()),
          ],
          child: const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: BookingApplicationScreen(
              jobId: 'job-123',
              applicationId: 'app-123',
            ),
          ),
        );
      },
    );
  }

  testWidgets('Booking Application Screen - Golden Test', (tester) async {
    await tester.pumpWidget(createScreen());
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(BookingApplicationScreen),
      matchesGoldenFile('goldens/booking_application_screen.png'),
    );
  });
}
