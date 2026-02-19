import 'package:core/core.dart';
import 'package:flutter/material.dart';
import '../theme/booking_ui_tokens.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({super.key});

  void _showCancellationPolicy(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color(0xFFE4E7EC)),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Cancellation Policy',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF101828),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
                // Content
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(20),
                    children: [
                      _buildPolicySection(
                        'Immediate Cancellation',
                        'If you cancel within 120 seconds of placing your booking, you will receive a 100% refund. No questions asked.',
                        Icons.timer_outlined,
                      ),
                      const SizedBox(height: 20),
                      _buildPolicySection(
                        'More Than 24 Hours Before',
                        'Cancellations made more than 24 hours before the scheduled start time will receive a full refund.',
                        Icons.calendar_today_outlined,
                      ),
                      const SizedBox(height: 20),
                      _buildPolicySection(
                        'Less Than 24 Hours Before',
                        'Cancellations made less than 24 hours before the scheduled start time will be charged 50% of the total booking amount.',
                        Icons.warning_amber_outlined,
                      ),
                      const SizedBox(height: 20),
                      _buildPolicySection(
                        'No-Show Policy',
                        'If you do not show up for the booking and do not cancel, you will be charged the full booking amount.',
                        Icons.block_outlined,
                      ),
                      const SizedBox(height: 20),
                      _buildPolicySection(
                        'Sitter Cancellation',
                        'If the sitter cancels the booking, you will receive a full refund regardless of the timing.',
                        Icons.check_circle_outline,
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3F2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFFECDCA)),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: AppColors.error,
                              size: 20,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Avoid cancellation as it leads to penalty and affects your reliability score.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFFB42318),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildPolicySection(String title, String description, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.surfaceTint,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: 24,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF101828),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF667085),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'If you cancel within 120 seconds of placing your booking, a 100% refund\n\n',
                      style: BookingUiTokens.noteBody,
                    ),
                    const Text(
                      'Avoid cancellation as it leads to penalty.\n',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: Color(0xFF667085),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _showCancellationPolicy(context),
                      child: const Text(
                        '*Read Cancellation Policy',
                        style: BookingUiTokens.noteLink,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
