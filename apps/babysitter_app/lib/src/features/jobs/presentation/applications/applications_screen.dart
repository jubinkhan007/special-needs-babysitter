import 'package:flutter/material.dart';
import '../../../../theme/app_tokens.dart';
import '../../domain/applications/application_item.dart';
import 'models/application_item_ui_model.dart';
import 'widgets/application_card.dart';
import '../widgets/jobs_app_bar.dart';
import 'package:go_router/go_router.dart';
import '../../../../routing/routes.dart';
import '../../domain/applications/booking_application.dart';
import '../widgets/reject_reason_bottom_sheet.dart';

class ApplicationsScreen extends StatelessWidget {
  const ApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // MOCK DATA helper
    BookingApplication _getMockBookingApp(String id) {
      return BookingApplication(
        id: id,
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
            'Hey Christie! This is Krystina. I am interested in sitting for you on March 4th from 10am - 5pm. I have over 7 years of experience, I have my own car, and I know how to perform CPR. I also am a great cook, and am familiar with local parks. Let\'s chat!',
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
          'Walking only (short distance)',
          'Family vehicle with car seat provided',
          'Ride-share allowed (with parent consent)',
        ],
        equipmentAndSafety: [
          'Car seat required',
          'Booster seat required',
        ],
        pickupDropoffDetails: [
          'Sunshine Elementary School, Gate 3',
          'Home — 42 Greenview Avenue, Apt 5B',
          'Pick up at the school gate only. Please avoid using highways as my child gets motion sickness.',
        ],
      );
    }

    // MOCK DATA for now
    final mockItems = [
      ApplicationItem(
        id: '1',
        sitterName: 'Krystina',
        avatarUrl: '',
        isVerified: true,
        distanceMiles: 5.0,
        rating: 4.5,
        responseRatePercent: 95,
        reliabilityRatePercent: 95,
        experienceYears: 5,
        jobTitle: 'Part Time Sitter Needed',
        scheduledDate: DateTime(2025, 5, 20),
        isApplication: true,
      ),
      ApplicationItem(
        id: '2',
        sitterName: 'Krystina', // Reusing name per screenshot/mock
        avatarUrl: '',
        isVerified: true,
        distanceMiles: 5.0,
        rating: 4.5,
        responseRatePercent: 95,
        reliabilityRatePercent: 95,
        experienceYears: 5,
        jobTitle: 'Part Time Sitter Needed',
        scheduledDate: DateTime(2025, 5, 20),
        isApplication: false, // Maybe standard view?
      ),
    ];

    return Scaffold(
      backgroundColor: AppTokens.applicationsBg,
      appBar: const JobsAppBar(
        title: 'Applications',
        showSupportIcon:
            false, // Screenshot showed bell, but let's stick to standard or bell if needed.
        // Note: Generic JobsAppBar has notifications by default if showSupportIcon is false.
      ),
      body: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.only(
                left: AppTokens.applicationsHorizontalPadding,
                right: AppTokens.applicationsHorizontalPadding,
                top: AppTokens.applicationsTopPadding,
                bottom: AppTokens.applicationsCardGap,
              ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = mockItems[index];
                    final ui = ApplicationItemUiModel.fromDomain(item);

                    return Padding(
                      padding: const EdgeInsets.only(
                          bottom: AppTokens.applicationsCardGap),
                      child: ApplicationCard(
                        ui: ui,
                        onAccept: () {},
                        onViewApplication: () {
                          context.push(
                            Routes.bookingApplication,
                            extra: _getMockBookingApp(item.id),
                          );
                        },
                        onReject: () async {
                          final result =
                              await showRejectReasonBottomSheet(context);
                          if (result != null) {
                            // Handle rejection logic here
                            debugPrint(
                                'Rejected with: ${result.reason} - ${result.otherText}');
                          }
                        },
                        onMoreOptions: () {},
                      ),
                    );
                  },
                  childCount: mockItems.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
