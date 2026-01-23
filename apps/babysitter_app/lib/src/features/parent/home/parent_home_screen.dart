import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:auth/auth.dart';
import '../../bookings/domain/booking.dart';
import '../../bookings/domain/booking_status.dart';
import '../../../routing/routes.dart';
import 'presentation/models/home_mock_models.dart';
import 'presentation/theme/home_design_tokens.dart';
import 'presentation/widgets/active_booking_card.dart';
import 'presentation/widgets/complete_profile_card.dart';
import 'presentation/widgets/home_header.dart';
import 'presentation/widgets/home_search_bar.dart';
import 'presentation/widgets/parent_home_banner_card.dart';
import 'presentation/widgets/saved_sitter_card.dart';
import 'presentation/widgets/sitter_near_you_card.dart';
import 'presentation/providers/parent_home_providers.dart';
import '../account/presentation/controllers/account_controller.dart';

class ParentHomeScreen extends ConsumerWidget {
  const ParentHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final user = authState.value?.user;
    final displayName = (user?.firstName?.isNotEmpty ?? false)
        ? user!.firstName!
        : (user?.fullName.isNotEmpty ?? false)
            ? user!.fullName
            : 'there';
    final bookingsAsync = ref.watch(parentHomeBookingsProvider);
    final sittersAsync = ref.watch(parentHomeSittersProvider);
    final accountAsync = ref.watch(accountControllerProvider);
    final headerLocation = bookingsAsync.maybeWhen(
      data: _resolveHeaderLocation,
      orElse: () => 'Location not set',
    );

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA), // Light grey bg
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100), // Space for bottom nav
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeHeader(
                displayName: displayName,
                locationText: headerLocation,
                avatarUrl: user?.avatarUrl,
                onNotificationTap: () {},
              ),
              const SizedBox(height: HomeDesignTokens.headerBottomSpacing),
              HomeSearchBar(
                onTap: () => context.push(Routes.sitterSearch),
              ),
              const SizedBox(height: HomeDesignTokens.sectionSpacing),
              const ParentHomeBannerCard(),
              const SizedBox(height: HomeDesignTokens.sectionSpacing),
              bookingsAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, stack) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text('Error loading bookings: $error'),
                ),
                data: (bookings) {
                  final selection = _selectBooking(bookings);
                  if (selection == null) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text('No bookings yet.'),
                    );
                  }

                  return ActiveBookingCard(
                    booking: selection.booking,
                    sectionTitle: selection.sectionTitle,
                    statusLabel: selection.statusLabel,
                  );
                },
              ),
              const SizedBox(height: HomeDesignTokens.sectionSpacing),
              _buildSectionHeader('Sitters Near You', onSeeAll: () {}),
              const SizedBox(height: HomeDesignTokens.itemSpacing),
              sittersAsync.when(
                loading: () => SizedBox(
                  height: HomeDesignTokens.sitterNearYouHeight,
                  child: const Center(child: CircularProgressIndicator()),
                ),
                error: (error, stack) => SizedBox(
                  height: HomeDesignTokens.sitterNearYouHeight,
                  child: Center(
                    child: Text('Error loading sitters: $error'),
                  ),
                ),
                data: (sitters) {
                  final displaySitters = sitters.take(6).toList();
                  if (displaySitters.isEmpty) {
                    return SizedBox(
                      height: HomeDesignTokens.sitterNearYouHeight,
                      child: const Center(child: Text('No sitters found.')),
                    );
                  }
                  return SizedBox(
                    height: HomeDesignTokens
                        .sitterNearYouHeight, // Fixed height for cards
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      scrollDirection: Axis.horizontal,
                      clipBehavior: Clip.none, // Allow shadow overflow
                      itemCount: displaySitters.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        final sitter = displaySitters[index];
                        return SitterNearYouCard(sitter: sitter);
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: HomeDesignTokens.sectionSpacing),
              _buildSectionHeader('Saved Sitters', onSeeAll: () {}),
              const SizedBox(height: HomeDesignTokens.itemSpacing),
              SizedBox(
                height: HomeDesignTokens.savedSitterHeight,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  itemCount: HomeMockData.savedSitters.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    final sitter = HomeMockData.savedSitters[index];
                    return SavedSitterCard(sitter: sitter);
                  },
                ),
              ),
              accountAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (error, stack) => const SizedBox.shrink(),
                data: (state) {
                  final percent = state.overview?.profileCompletionPercent;
                  if (percent == null) {
                    return const SizedBox.shrink();
                  }
                  return CompleteProfileCard(completionPercent: percent);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onSeeAll}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: HomeDesignTokens.sectionHeader,
          ),
          if (onSeeAll != null)
            GestureDetector(
              onTap: onSeeAll,
              child: Text(
                'See All',
                style: HomeDesignTokens.seeAllText,
              ),
            ),
        ],
      ),
    );
  }
}

class _HomeBookingSelection {
  final Booking booking;
  final String sectionTitle;
  final String statusLabel;

  const _HomeBookingSelection({
    required this.booking,
    required this.sectionTitle,
    required this.statusLabel,
  });
}

_HomeBookingSelection? _selectBooking(List<Booking> bookings) {
  if (bookings.isEmpty) return null;

  Booking? active;
  for (final booking in bookings) {
    if (booking.status == BookingStatus.active) {
      active = booking;
      break;
    }
  }
  if (active != null) {
    return _HomeBookingSelection(
      booking: active,
      sectionTitle: 'Active Booking',
      statusLabel: 'Active',
    );
  }

  final upcoming = bookings
      .where((booking) => booking.status == BookingStatus.upcoming)
      .toList()
    ..sort((a, b) => a.scheduledDate.compareTo(b.scheduledDate));
  if (upcoming.isNotEmpty) {
    return _HomeBookingSelection(
      booking: upcoming.first,
      sectionTitle: 'Upcoming Booking',
      statusLabel: 'Upcoming',
    );
  }

  final last = bookings.toList()
    ..sort((a, b) => b.scheduledDate.compareTo(a.scheduledDate));
  return _HomeBookingSelection(
    booking: last.first,
    sectionTitle: 'Last Booking',
    statusLabel: _statusLabel(last.first.status),
  );
}

String _statusLabel(BookingStatus status) {
  switch (status) {
    case BookingStatus.active:
      return 'Active';
    case BookingStatus.upcoming:
      return 'Upcoming';
    case BookingStatus.pending:
      return 'Pending';
    case BookingStatus.completed:
      return 'Completed';
    case BookingStatus.cancelled:
      return 'Cancelled';
  }
}

String _resolveHeaderLocation(List<Booking> bookings) {
  for (final booking in bookings) {
    final location = booking.distanceText.trim();
    if (location.isNotEmpty && location.toLowerCase() != 'unknown location') {
      return location;
    }
  }
  return 'Location not set';
}
