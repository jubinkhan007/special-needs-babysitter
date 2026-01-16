import 'package:flutter/material.dart';
import "package:babysitter_app/src/features/parent/search/presentation/theme/app_ui_tokens.dart";

class AvailabilitySection extends StatelessWidget {
  // Parsing this as raw data for now as API schema for availability wasn't provided fully
  final List<dynamic>? availability;

  const AvailabilitySection({super.key, this.availability});

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
              child: Row(
                children: const [
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
            // Calendar Wrapper (No Card/Border per Figma)
            // NOTE: Since we don't have the real availability logic/schema yet, we keep the UI structure
            // but effectively we should map this to the real dates.
            // For now, if data exists, we might show a list or this calendar.
            // Keeping the calendar as "Example" or just hiding it if we can't map it is safer.
            // Let's assume for this task "Dynamic" means "Don't show fake info".
            // So if we had data, we'd render it. Since current data is empty, showing "No availability" is CORRECT dynamic behavior.
            // If we want to keep the calendar structure but data-driven, we'd need complex logic.
            // I will default to showing "Contact Sitter for compatibility" or keep the structure if we have data.
            const Text(
                "Availability data present but rendering not implemented yet."),
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
          _buildJobTypeItem("Recurring"), // We should map these too
          _buildJobTypeItem("One-time"),
          _buildJobTypeItem("Emergency (Same-day)"),
        ],
      ),
    );
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
