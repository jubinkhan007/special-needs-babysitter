import 'package:flutter/material.dart';
import '../theme/booking_ui_tokens.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: BookingUiTokens.noteCardBackground,
        borderRadius: BorderRadius.circular(BookingUiTokens.noteCardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Note:',
            style: BookingUiTokens.noteTitle,
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 2), // Align icon with text
                child: Icon(
                  Icons.info_outline_rounded,
                  size: 20,
                  color: BookingUiTokens.valueText,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: RichText(
                  text: const TextSpan(
                    style: BookingUiTokens.noteBody,
                    children: [
                      TextSpan(
                        text:
                            'If you cancel within 120 seconds of placing your booking, a 100% refund\n\n',
                      ),
                      TextSpan(
                        text: 'Avoid cancellation as it leads to penalty.\n',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      TextSpan(
                        text: '*Read Cancellation Policy',
                        style: BookingUiTokens.noteLink,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
