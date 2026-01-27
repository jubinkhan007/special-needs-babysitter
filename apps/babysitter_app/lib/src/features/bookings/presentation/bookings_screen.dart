import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../routing/routes.dart';
import '../../../theme/app_tokens.dart';
import '../application/bookings_controller.dart';
import '../domain/booking_details.dart';
import '../domain/booking_status.dart';
import '../../messages/domain/chat_thread_args.dart';
import 'widgets/booking_card.dart';
import 'widgets/bookings_app_bar.dart';
import 'widgets/bookings_tabs.dart';

class BookingsScreen extends ConsumerStatefulWidget {
  final BookingStatus? initialTab;

  const BookingsScreen({super.key, this.initialTab});

  @override
  ConsumerState<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends ConsumerState<BookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime? _lastRefreshAt;

  final List<BookingStatus> _tabs = [
    BookingStatus.active,
    BookingStatus.upcoming,
    BookingStatus.pending,
    BookingStatus.completed,
    BookingStatus.cancelled,
  ];

  @override
  void initState() {
    super.initState();
    final initialIndex = widget.initialTab != null
        ? _tabs.indexOf(widget.initialTab!)
        : 0;
    _tabController = TabController(
      length: _tabs.length,
      vsync: this,
      initialIndex: initialIndex >= 0 ? initialIndex : 0,
    );
    Future.microtask(() {
      ref.read(bookingsControllerProvider).refresh();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(bookingsControllerProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _maybeRefreshBookings();
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const BookingsAppBar(),
      body: Column(
        children: [
          BookingsTabs(controller: _tabController, tabs: _tabs),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _tabs.map((status) {
                final bookings = controller.bookingsFor(status);

                if (bookings.isEmpty) {
                  return Center(
                    child: Text(
                      'No ${status.name} bookings',
                      style: AppTokens.cardMeta,
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(
                    left: AppTokens.screenHorizontalPadding,
                    right: AppTokens.screenHorizontalPadding,
                    top: 18,
                    bottom: 24,
                  ),
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    final booking = bookings[index];
                    return BookingCard(
                      booking: booking,
                      onMessage: () {
                        if (booking.sitterId.isNotEmpty) {
                          final args = ChatThreadArgs(
                            otherUserId: booking.sitterId,
                            otherUserName: booking.sitterName,
                            otherUserAvatarUrl: booking.avatarAssetOrUrl,
                            isVerified: booking.isVerified,
                          );
                          context.push(
                            '/parent/messages/chat/${booking.sitterId}',
                            extra: args,
                          );
                        }
                      },
                      onViewDetails: () {
                        if (booking.status == BookingStatus.active ||
                            booking.status == BookingStatus.clockedOut) {
                          context.push(
                            Routes.activeBooking,
                            extra: booking.id,
                          );
                        } else {
                          context.push(
                            Routes.bookingDetails,
                            extra: BookingDetailsArgs(
                              bookingId: booking.id,
                              status: booking.status,
                            ),
                          );
                        }
                      },
                      onMenuTap: () {},
                    );
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _maybeRefreshBookings() {
    final route = ModalRoute.of(context);
    if (route == null || !route.isCurrent) {
      return;
    }
    final now = DateTime.now();
    final last = _lastRefreshAt;
    if (last != null && now.difference(last) < const Duration(seconds: 5)) {
      return;
    }
    _lastRefreshAt = now;
    ref.read(bookingsControllerProvider).refresh();
  }
}
