import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/providers/bookings_di.dart';
import '../../../../bookings/application/bookings_controller.dart';
import '../theme/booking_ui_tokens.dart';
import '../widgets/success_bottom_card.dart';
import 'package:babysitter_app/src/common_widgets/app_toast.dart';
import 'package:babysitter_app/src/routing/routes.dart';

class BookingRequestSentScreen extends ConsumerStatefulWidget {
  final String bookingId;
  final String sitterName;

  const BookingRequestSentScreen({
    super.key,
    required this.bookingId,
    required this.sitterName,
  });

  @override
  ConsumerState<BookingRequestSentScreen> createState() =>
      _BookingRequestSentScreenState();
}

class _BookingRequestSentScreenState
    extends ConsumerState<BookingRequestSentScreen> {
  bool _isCancelling = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(bookingsControllerProvider).refresh();
    });
  }

  Future<void> _cancelRequest() async {
    if (_isCancelling) {
      return;
    }
    if (widget.bookingId.isEmpty) {
      AppToast.show(context,
        const SnackBar(content: Text('Missing booking ID to cancel request')),
      );
      return;
    }
    setState(() => _isCancelling = true);
    try {
      await ref
          .read(bookingsRepositoryProvider)
          .cancelDirectBooking(widget.bookingId);
      await ref.read(bookingsControllerProvider).refresh();
      if (!mounted) return;
      AppToast.show(context,
        const SnackBar(content: Text('Request cancelled')),
      );
      context.go('${Routes.parentBookings}?tab=cancelled');
    } catch (e) {
      if (!mounted) return;
      AppToast.show(context,
        SnackBar(content: Text('Failed to cancel request: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isCancelling = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BookingUiTokens.pageBackground,
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            bottom: 200, // Leave some space at bottom, though content covers it
            child: Image.asset(
              'assets/images/booking_request.png',
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),

          // Close Icon
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 24,
            child: GestureDetector(
              onTap: () {
                // Navigate back to home or root
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Icon(
                Icons.close,
                size: 28,
                color: Color(0xFF7A8186),
              ),
            ),
          ),
          
          // Status Badge - Shows Pending Status
          Positioned(
            top: MediaQuery.of(context).padding.top + 80,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7), // Amber background
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFD97706)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.access_time,
                      color: Color(0xFFD97706),
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Status: Pending Confirmation',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF92400E),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Card
          Align(
            alignment: Alignment.bottomCenter,
            child: SuccessBottomCard(
              sitterName: widget.sitterName,
              bookingStatus: 'Pending',
              onViewStatus: () {
                context.go('${Routes.parentBookings}?tab=pending');
              },
              onCancel: () {
                _cancelRequest();
              },
            ),
          ),
        ],
      ),
    );
  }
}
