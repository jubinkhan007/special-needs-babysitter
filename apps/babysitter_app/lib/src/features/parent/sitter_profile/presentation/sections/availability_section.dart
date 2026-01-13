import 'package:flutter/material.dart';
import "package:babysitter_app/src/features/parent/search/presentation/theme/app_ui_tokens.dart";

class AvailabilitySection extends StatelessWidget {
  const AvailabilitySection({super.key});

  @override
  Widget build(BuildContext context) {
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

          // Calendar Wrapper (No Card/Border per Figma)
          Column(
            children: [
              // Month/Year Selectors
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSelector("Aug"),
                  _buildSelector("2025"),
                ],
              ),
              const SizedBox(height: 24), // Airy spacing

              // Days Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: ["S", "M", "T", "W", "T", "F", "S"]
                    .map((d) => SizedBox(
                          width: 32,
                          child: Center(
                            child: Text(
                              d,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppUiTokens.textPrimary,
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 16),

              // Calendar Grid
              // Row 1
              _buildCalendarRow(["26", "27", "28", "29", "30", "31", "1"],
                  [true, true, true, true, true, true, false]),
              const SizedBox(height: 16),
              // Row 2
              _buildCalendarRow(["2", "3", "4", "5", "6", "7", "8"], []),
              const SizedBox(height: 16),
              // Row 3
              _buildCalendarRow(["9", "10", "11", "12", "13", "14", "15"], []),
              const SizedBox(height: 16),
              // Row 4 (Available ranges ex: 17-20)
              _buildCalendarRow(
                ["16", "17", "18", "19", "20", "21", "22"],
                [],
                availableIndices: [
                  1,
                  2,
                  3,
                  4
                ], // 17, 18, 19, 20 are available (Green Outline)
              ),
              const SizedBox(height: 16),
              // Row 5 (Grey/Unavailable 24-27)
              _buildCalendarRow(
                ["23", "24", "25", "26", "27", "28", "29"],
                [],
                disabledIndices: [1, 2, 3, 4], // 24, 25, 26, 27
              ),
              const SizedBox(height: 16),
              // Row 6
              _buildCalendarRow(["30", "1", "2", "3", "4", "5", "6"],
                  [false, true, true, true, true, true, true]),
            ],
          ),
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
          _buildJobTypeItem("Recurring"),
          _buildJobTypeItem("One-time"),
          _buildJobTypeItem("Emergency (Same-day)"),
        ],
      ),
    );
  }

  Widget _buildSelector(String label) {
    return Row(
      children: [
        const Icon(Icons.chevron_left,
            color: AppUiTokens.textSecondary, size: 24),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppUiTokens.textPrimary),
        ),
        const SizedBox(width: 4),
        const Icon(Icons.arrow_drop_down,
            color: AppUiTokens.textPrimary, size: 20),
        const SizedBox(width: 12),
        const Icon(Icons.chevron_right,
            color: AppUiTokens.textSecondary, size: 24),
      ],
    );
  }

  Widget _buildCalendarRow(List<String> days, List<bool> prevNextMonth,
      {List<int> availableIndices = const [],
      List<int> disabledIndices = const []}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(days.length, (index) {
        bool isPrevNext = prevNextMonth.isNotEmpty &&
            (prevNextMonth.length > index ? prevNextMonth[index] : false);
        bool isAvailable = availableIndices.contains(index); // Green Outline
        bool isDisabled = disabledIndices.contains(index); // Grey filled

        return Container(
          width: 36, // Slightly larger touch target visually
          height: 36,
          decoration: isAvailable
              ? BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: const Color(0xFF6CE9A6),
                      width: 1.5), // Green stroke
                  color: Colors.transparent,
                )
              : isDisabled
                  ? const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFF2F4F7), // Grey circle background
                    )
                  : null,
          child: Center(
            child: Text(
              days[index],
              style: TextStyle(
                fontSize: 14,
                fontWeight: isDisabled ? FontWeight.w400 : FontWeight.w500,
                color: isPrevNext || isDisabled
                    ? const Color(0xFFD0D5DD) // Lighter grey text for disabled
                    : AppUiTokens.textPrimary,
              ),
            ),
          ),
        );
      }),
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
