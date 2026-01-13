import 'package:flutter/material.dart';
import '../theme/booking_ui_tokens.dart';
import '../widgets/success_bottom_card.dart';

class BookingRequestSentScreen extends StatelessWidget {
  const BookingRequestSentScreen({super.key});

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
              onViewStatus: () {
                // Navigate to status
              },
              onCancel: () {
                // Cancel logic
              },
            ),
          ),
        ],
      ),
    );
  }
}
