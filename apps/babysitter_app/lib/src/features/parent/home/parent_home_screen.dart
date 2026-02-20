import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:auth/auth.dart';
import '../../bookings/domain/booking.dart';
import '../../bookings/domain/booking_status.dart';
import '../../../routing/routes.dart';
import 'presentation/theme/home_design_tokens.dart';
import 'presentation/widgets/active_booking_card.dart';
import 'presentation/widgets/complete_profile_card.dart';
import 'presentation/widgets/home_header.dart';
import 'presentation/widgets/home_search_bar.dart';
import 'presentation/widgets/parent_home_banner_card.dart';
import 'presentation/widgets/saved_sitter_card.dart';
import 'presentation/widgets/sitter_near_you_card.dart';
import 'presentation/providers/parent_home_providers.dart';
import '../../sitters/presentation/saved/saved_sitters_controller.dart';
import '../account/presentation/controllers/account_controller.dart';
import '../shared/providers/location_access_provider.dart';
import '../shared/widgets/location_access_banner.dart';
import '../search/utils/location_helper.dart';
import 'package:babysitter_app/src/common_widgets/app_toast.dart';

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
    final savedSittersAsync = ref.watch(savedSittersControllerProvider);
    final accountAsync = ref.watch(accountControllerProvider);
    final locationStatusAsync = ref.watch(locationAccessStatusProvider);
    final locationStatus = locationStatusAsync.maybeWhen(
      data: (status) => status,
      orElse: () => null,
    );
    final headerLocation = bookingsAsync.maybeWhen(
      data: _resolveHeaderLocation,
      orElse: () => 'Location not set',
    );

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA), // Light grey bg
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: 100 + MediaQuery.of(context).padding.bottom,
          ), // Space for bottom nav + safe area
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
              if (locationStatus != null &&
                  locationStatus != LocationAccessStatus.available) ...[
                LocationAccessBanner(
                  title: _locationTitle(locationStatus),
                  message: _locationMessage(locationStatus),
                  actionLabel: _locationActionLabel(locationStatus),
                  onAction: () {
                    _handleLocationAction(
                      ref,
                      locationStatus,
                    );
                  },
                ),
                const SizedBox(height: HomeDesignTokens.itemSpacing),
              ],
              sittersAsync.when(
                loading: () => const SizedBox(
                  height: HomeDesignTokens.sitterNearYouHeight,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, stack) => SizedBox(
                  height: HomeDesignTokens.sitterNearYouHeight,
                  child: Center(
                    child: Text('Error loading sitters: $error'),
                  ),
                ),
                data: (sitters) {
                  final displaySitters = sitters.take(6).toList();
                  final savedSitters = savedSittersAsync.value ?? [];

                  if (displaySitters.isEmpty) {
                    return const SizedBox(
                      height: HomeDesignTokens.sitterNearYouHeight,
                      child: Center(child: Text('No sitters found.')),
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
                        final isBookmarked = savedSitters
                            .any((s) => s.userId == sitter.userId);

                        return SitterNearYouCard(
                          sitter: sitter,
                          isBookmarked: isBookmarked,
                          onBookmarkTap: () {
                            ref
                                .read(savedSittersControllerProvider.notifier)
                                .toggleBookmark(sitter.userId,
                                    isCurrentlySaved: isBookmarked,
                                    sitterItem: sitter);
                            
                            AppToast.show(context,
                              SnackBar(
                                content: Text(isBookmarked
                                    ? 'Sitter removed from bookmarks'
                                    : 'Sitter bookmarked'),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: HomeDesignTokens.sectionSpacing),
              _buildSectionHeader('Saved Sitters', onSeeAll: () {
                context.push(Routes.parentSavedSitters);
              }),
              const SizedBox(height: HomeDesignTokens.itemSpacing),
              savedSittersAsync.when(
                loading: () => const SizedBox(
                  height: HomeDesignTokens.savedSitterHeight,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, stack) => const SizedBox(
                  height: HomeDesignTokens.savedSitterHeight,
                  child: Center(child: Text('Error loading saved sitters')),
                ),
                data: (savedSitters) {
                  if (savedSitters.isEmpty) {
                    return const SizedBox(
                      height: HomeDesignTokens.savedSitterHeight,
                      child: Center(child: Text('No saved sitters yet.')),
                    );
                  }
                  return SizedBox(
                    height: HomeDesignTokens.savedSitterHeight,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      scrollDirection: Axis.horizontal,
                      clipBehavior: Clip.none,
                      itemCount: savedSitters.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        final sitter = savedSitters[index];
                        return SavedSitterCard(
                          sitter: sitter,
                          onTap: () {
                            context.push(Routes.sitterProfilePath(sitter.id));
                          },
                          onBookmarkTap: () async {
                            final success = await ref
                                .read(savedSittersControllerProvider.notifier)
                                .removeBookmark(sitter.userId);
                            if (context.mounted) {
                              AppToast.show(
                                context,
                                SnackBar(
                                  content: Text(success
                                      ? 'Sitter removed from saved list'
                                      : 'Failed to remove sitter'),
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                  );
                },
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

Future<void> _handleLocationAction(
  WidgetRef ref,
  LocationAccessStatus status,
) async {
  switch (status) {
    case LocationAccessStatus.permissionDenied:
      await LocationHelper.requestPermission();
      break;
    case LocationAccessStatus.permissionDeniedForever:
      await LocationHelper.openAppSettings();
      break;
    case LocationAccessStatus.serviceDisabled:
      await LocationHelper.openLocationSettings();
      break;
    case LocationAccessStatus.available:
      return;
  }

  ref.invalidate(locationAccessStatusProvider);
  ref.invalidate(parentHomeSittersProvider);
}

String _locationTitle(LocationAccessStatus status) {
  switch (status) {
    case LocationAccessStatus.serviceDisabled:
      return 'Turn on location services';
    case LocationAccessStatus.permissionDenied:
      return 'Enable location access';
    case LocationAccessStatus.permissionDeniedForever:
      return 'Location access blocked';
    case LocationAccessStatus.available:
      return '';
  }
}

String _locationMessage(LocationAccessStatus status) {
  switch (status) {
    case LocationAccessStatus.serviceDisabled:
      return 'Enable location services to see sitters near you.';
    case LocationAccessStatus.permissionDenied:
      return 'Allow location access to show nearby sitters.';
    case LocationAccessStatus.permissionDeniedForever:
      return 'Open settings to allow location access.';
    case LocationAccessStatus.available:
      return '';
  }
}

String _locationActionLabel(LocationAccessStatus status) {
  switch (status) {
    case LocationAccessStatus.serviceDisabled:
      return 'Turn On';
    case LocationAccessStatus.permissionDenied:
      return 'Allow';
    case LocationAccessStatus.permissionDeniedForever:
      return 'Open Settings';
    case LocationAccessStatus.available:
      return '';
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
    if (booking.status == BookingStatus.active ||
        booking.status == BookingStatus.clockedOut) {
      active = booking;
      break;
    }
  }
  if (active != null) {
    return _HomeBookingSelection(
      booking: active,
      sectionTitle: 'Active Booking',
      statusLabel: _statusLabel(active.status),
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
    case BookingStatus.clockedOut:
      return 'Clocked out';
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
