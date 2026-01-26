import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_tokens.dart';
import '../../messages/domain/chat_thread_args.dart';

import 'models/active_booking_details_ui_model.dart';
import 'widgets/active_bottom_cta_bar.dart';
import 'widgets/booking_details_app_bar.dart';
import 'widgets/dashed_divider.dart';
import 'widgets/details_section_header.dart';
import 'widgets/key_value_row.dart';
import 'widgets/live_tracking_section.dart';
import 'widgets/sitter_summary_card.dart';

class ActiveBookingDetailsScreen extends StatelessWidget {
  final String bookingId;

  const ActiveBookingDetailsScreen({
    super.key,
    required this.bookingId,
  });

  @override
  Widget build(BuildContext context) {
    // MOCK DATA for verification
    const mockUiModel = ActiveBookingDetailsUiModel(
      sitterId: 'mock-sitter-id', // TODO: Replace with actual sitter ID from booking
      sitterName: 'Krystina',
      avatarUrl:
          'assets/images/sitters/krystina_sitter.png', // Ensure this asset exists or use placeholder
      isVerified: true,
      rating: '4.5',
      distance: '2 Miles Away',
      responseRate: '95%',
      reliabilityRate: '95%',
      experience: '5 Years',
      skillTags: ['CPR', 'First-aid', 'Special Needs Training'],
      familyName: 'Smith',
      childrenCount: '3',
      dateRange: '14 Aug - 17 Aug',
      timeRange: '09 AM - 06 PM',
      hourlyRate: '\$ 20/hr',
      days: '4',
      notes: 'We Have Two Black Cats',
      address:
          '7448, Kub Oval, 2450 Brian Meadow, District of Columbia, Lake Edna',
    );

    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1)),
      child: Scaffold(
        backgroundColor: AppTokens.bg,
        appBar: const BookingDetailsAppBar(
          title: 'Active Booking',
        ),
        bottomNavigationBar: ActiveBottomCtaBar(
          onMessageTap: () {
            final args = ChatThreadArgs(
              otherUserId: mockUiModel.sitterId,
              otherUserName: mockUiModel.sitterName,
              otherUserAvatarUrl: mockUiModel.avatarUrl,
              isVerified: mockUiModel.isVerified,
            );
            context.push(
              '/parent/messages/chat/${mockUiModel.sitterId}',
              extra: args,
            );
          },
          onCallTap: () {},
        ),
        body: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // 1. Sitter Summary Card
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppTokens.detailsHorizontalPadding,
                AppTokens.detailsHeaderBottomGap,
                AppTokens.detailsHorizontalPadding,
                0, // Bottom padding handled by next section gap
              ),
              sliver: SliverToBoxAdapter(
                child: SitterSummaryCard(uiModel: mockUiModel),
              ),
            ),

            // 2. Live Tracking Section
            const SliverPadding(
              padding: EdgeInsets.fromLTRB(
                AppTokens.detailsHorizontalPadding,
                AppTokens.detailsSectionTopGap,
                AppTokens.detailsHorizontalPadding,
                0,
              ),
              sliver: SliverToBoxAdapter(
                child: LiveTrackingSection(),
              ),
            ),

            // 3. Service Details Header
            const SliverPadding(
              padding: EdgeInsets.fromLTRB(
                AppTokens.detailsHorizontalPadding,
                AppTokens.detailsSectionTopGap, // Gap before header
                AppTokens.detailsHorizontalPadding,
                16, // Gap between header and divider/list
              ),
              sliver: SliverToBoxAdapter(
                child: DetailsSectionHeader(),
              ),
            ),

            // 4. Dashed Divider
            const SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: AppTokens.detailsHorizontalPadding,
              ),
              sliver: SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 24),
                  child: DashedDivider(
                    color: AppTokens.dashedDividerColor,
                    dashWidth: 6,
                  ),
                ),
              ),
            ),

            // 5. Service Details List
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTokens.detailsHorizontalPadding,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  KeyValueRow(
                      label: 'Family Name', value: mockUiModel.familyName),
                  KeyValueRow(
                      label: 'No. Of Children',
                      value: mockUiModel.childrenCount),
                  KeyValueRow(label: 'Date', value: mockUiModel.dateRange),
                  KeyValueRow(label: 'Time', value: mockUiModel.timeRange),
                  KeyValueRow(
                      label: 'Hourly Rate', value: mockUiModel.hourlyRate),
                  KeyValueRow(label: 'No of Days', value: mockUiModel.days),
                  KeyValueRow(
                      label: 'Additional Notes', value: mockUiModel.notes),
                  KeyValueRow(label: 'Address', value: mockUiModel.address),
                ]),
              ),
            ),

            // Bottom Spacer
            const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
          ],
        ),
      ),
    );
  }
}
