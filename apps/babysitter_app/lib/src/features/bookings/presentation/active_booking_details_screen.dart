import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_tokens.dart';
import '../../messages/domain/chat_thread_args.dart';

import 'models/active_booking_details_ui_model.dart';
import 'providers/booking_details_provider.dart';
import 'widgets/active_bottom_cta_bar.dart';
import 'widgets/booking_details_app_bar.dart';
import 'widgets/dashed_divider.dart';
import 'widgets/details_section_header.dart';
import 'widgets/key_value_row.dart';
import 'widgets/live_tracking_section.dart';
import 'widgets/sitter_summary_card.dart';

class ActiveBookingDetailsScreen extends ConsumerWidget {
  final String bookingId;

  const ActiveBookingDetailsScreen({
    super.key,
    required this.bookingId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailsAsync = ref.watch(bookingDetailsProvider(bookingId));

    return detailsAsync.when(
      loading: () => MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1)),
        child: const Scaffold(
          backgroundColor: AppTokens.bg,
          appBar: BookingDetailsAppBar(
            title: 'Active Booking',
          ),
          body: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (error, stack) => MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1)),
        child: Scaffold(
          backgroundColor: AppTokens.bg,
          appBar: const BookingDetailsAppBar(
            title: 'Active Booking',
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 12),
                  Text(
                    'Failed to load booking details.',
                    style: AppTokens.cardMeta,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () =>
                        ref.refresh(bookingDetailsProvider(bookingId)),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      data: (details) {
        final uiModel = ActiveBookingDetailsUiModel.fromDomain(details);
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
                if (uiModel.sitterId.isEmpty) {
                  return;
                }
                final args = ChatThreadArgs(
                  otherUserId: uiModel.sitterId,
                  otherUserName: uiModel.sitterName,
                  otherUserAvatarUrl: uiModel.avatarUrl,
                  isVerified: uiModel.isVerified,
                );
                context.push(
                  '/parent/messages/chat/${uiModel.sitterId}',
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
                    child: SitterSummaryCard(uiModel: uiModel),
                  ),
                ),

                // 2. Live Tracking Section
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppTokens.detailsHorizontalPadding,
                AppTokens.detailsSectionTopGap,
                AppTokens.detailsHorizontalPadding,
                0,
              ),
              sliver: SliverToBoxAdapter(
                child: LiveTrackingSection(bookingId: bookingId),
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
                          label: 'Family Name', value: uiModel.familyName),
                      KeyValueRow(
                          label: 'No. Of Children',
                          value: uiModel.childrenCount),
                      KeyValueRow(label: 'Date', value: uiModel.dateRange),
                      KeyValueRow(label: 'Time', value: uiModel.timeRange),
                      KeyValueRow(
                          label: 'Hourly Rate', value: uiModel.hourlyRate),
                      KeyValueRow(label: 'No of Days', value: uiModel.days),
                      KeyValueRow(
                          label: 'Additional Notes', value: uiModel.notes),
                      KeyValueRow(label: 'Address', value: uiModel.address),
                    ]),
                  ),
                ),

                // Bottom Spacer
                const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
              ],
            ),
          ),
        );
      },
    );
  }
}
