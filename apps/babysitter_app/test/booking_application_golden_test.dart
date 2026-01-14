import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:babysitter_app/src/features/jobs/presentation/applications/booking_application_screen.dart';
import 'package:babysitter_app/src/features/jobs/domain/applications/booking_application.dart';

void main() {
  Widget createScreen() {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: BookingApplicationScreen(
            application: BookingApplication(
              id: '1',
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
