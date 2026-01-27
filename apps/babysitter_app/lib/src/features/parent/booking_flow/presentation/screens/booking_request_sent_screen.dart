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

          // Bottom Card
          Align(
            alignment: Alignment.bottomCenter,
            child: SuccessBottomCard(
              sitterName: widget.sitterName,
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
