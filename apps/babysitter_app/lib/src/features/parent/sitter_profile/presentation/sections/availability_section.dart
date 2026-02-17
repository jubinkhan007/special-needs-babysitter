import 'package:flutter/material.dart';
import "package:babysitter_app/src/features/parent/search/presentation/theme/app_ui_tokens.dart";

import 'package:intl/intl.dart';

class AvailabilitySection extends StatelessWidget {
  // Parsing this as raw data for now as API schema for availability wasn't provided fully
  final List<dynamic>? availability;
  final Map<String, bool>? jobTypesAccepted;

  const AvailabilitySection(
      {super.key, this.availability, this.jobTypesAccepted});

  @override
  Widget build(BuildContext context) {
    bool hasAvailability = availability != null && availability!.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Availability Title
          const Text(
            "Availability",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppUiTokens.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 16),

          if (!hasAvailability)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFEAECF0)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.calendar_today_rounded,
                      color: AppUiTokens.textSecondary, size: 20),
                  SizedBox(width: 12),
                  Text(
                    "No specific availability listed",
                    style: TextStyle(
                        fontSize: 15,
                        color: AppUiTokens.textSecondary,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            )
          else ...[
            ...availability!.map((item) {
              // Safe parsing
              if (item is! Map<String, dynamic>) return const SizedBox.shrink();

              final dateStr = item['date'] as String? ?? '';
              final startTime = item['startTime'] as String? ?? '';
              final endTime = item['endTime'] as String? ?? '';
              if (dateStr.isEmpty) return const SizedBox.shrink();

              DateTime? date = DateTime.tryParse(dateStr);
              if (date == null) return const SizedBox.shrink();

              // formatting
              final dayStr = DateFormat('EEE, MM/dd/yyyy').format(date);

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F9FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.access_time_rounded,
                          size: 18, color: AppUiTokens.verifiedBlue),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      dayStr,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppUiTokens.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "$startTime - $endTime",
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppUiTokens.textSecondary,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],

          const SizedBox(height: 32),

          // Job Types Accepted
          const Text(
            "Job Types Accepted",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppUiTokens.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          if (jobTypesAccepted == null || jobTypesAccepted!.isEmpty)
            const Text(
              "No specific job types listed",
              style: TextStyle(color: AppUiTokens.textSecondary),
            )
          else
            ...jobTypesAccepted!.entries.where((e) => e.value).map((e) {
              return _buildJobTypeItem(_formatJobType(e.key));
            }),
        ],
      ),
    );
  }

  String _formatJobType(String key) {
    switch (key.toLowerCase()) {
      case 'recurring':
        return 'Recurring';
      case 'onetime':
      case 'one-time':
        return 'One-time';
      case 'emergency':
        return 'Emergency (Same-day)';
      default:
        // Capitalize first letter
        if (key.isEmpty) return key;
        return key[0].toUpperCase() + key.substring(1);
    }
  }

  Widget _buildJobTypeItem(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Icon(Icons.check, size: 18, color: AppUiTokens.textPrimary),
          const SizedBox(width: 12),
          Text(label,
              style: const TextStyle(
                  fontSize: 15, color: AppUiTokens.textSecondary)),
        ],
      ),
    );
  }
}
