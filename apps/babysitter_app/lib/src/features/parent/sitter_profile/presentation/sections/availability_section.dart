import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:babysitter_app/src/features/parent/home/presentation/theme/home_design_tokens.dart';

class AvailabilitySection extends StatelessWidget {
  const AvailabilitySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Availability Title
          const Text(
            "Availability",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary),
          ),
          const SizedBox(height: 16),

          // Calendar Custom UI
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.neutral30), // Grey border
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // Month/Year Selectors
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSelector("Aug"),
                    _buildSelector("2025"),
                  ],
                ),
                const SizedBox(height: 16),

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
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 12),

                // Calendar Grid (Mocked for visual match)
                // Row 1
                _buildCalendarRow([
                  "26",
                  "27",
                  "28",
                  "29",
                  "30",
                  "31",
                  "1"
                ], [
                  true,
                  true,
                  true,
                  true,
                  true,
                  true,
                  false
                ]), // disable prev month
                const SizedBox(height: 12),
                // Row 2
                _buildCalendarRow(["2", "3", "4", "5", "6", "7", "8"], []),
                const SizedBox(height: 12),
                // Row 3
                _buildCalendarRow(
                    ["9", "10", "11", "12", "13", "14", "15"], []),
                const SizedBox(height: 12),
                // Row 4 (Selected range 17-20)
                _buildCalendarRow(
                  ["16", "17", "18", "19", "20", "21", "22"],
                  [],
                  selectedIndices: [1, 2, 3, 4], // 17, 18, 19, 20
                ),
                const SizedBox(height: 12),
                // Row 5 (Disabled 24-27)
                _buildCalendarRow(
                  ["23", "24", "25", "26", "27", "28", "29"],
                  [],
                  disabledIndices: [1, 2, 3, 4], // 24, 25, 26, 27
                ),
                const SizedBox(height: 12),
                // Row 6
                _buildCalendarRow(["30", "1", "2", "3", "4", "5", "6"],
                    [false, true, true, true, true, true, true]),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Job Types Accepted
          const Text(
            "Job Types Accepted",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary),
          ),
          const SizedBox(height: 12),
          _buildJobTypeItem("Recurring"),
          _buildJobTypeItem("One-time"),
          _buildJobTypeItem("Emergency (Same-day)"),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSelector(String label) {
    return Row(
      children: [
        const Icon(Icons.chevron_left, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary),
        ),
        const Icon(Icons.arrow_drop_down, color: AppColors.textPrimary),
        const SizedBox(width: 8),
        const Icon(Icons.chevron_right, color: AppColors.textSecondary),
      ],
    );
  }

  Widget _buildCalendarRow(List<String> days, List<bool> prevNextMonth,
      {List<int> selectedIndices = const [],
      List<int> disabledIndices = const []}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(days.length, (index) {
        bool isPrevNext = prevNextMonth.isNotEmpty &&
            (prevNextMonth.length > index ? prevNextMonth[index] : false);
        bool isSelected = selectedIndices.contains(index);
        bool isDisabled = disabledIndices.contains(index);

        return Container(
          width: 32,
          height: 32,
          decoration: isSelected
              ? BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: Colors.green, width: 1.5), // Green circle
                  color: Colors.white,
                )
              : isDisabled
                  ? const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFE4E7EC), // Grey circle background
                    )
                  : null,
          child: Center(
            child: Text(
              days[index],
              style: TextStyle(
                fontSize: 14,
                fontWeight: isDisabled ? FontWeight.w400 : FontWeight.w500,
                color: isPrevNext || isDisabled
                    ? AppColors.neutral40
                    : AppColors.textPrimary,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildJobTypeItem(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.check, size: 16, color: AppColors.textPrimary),
          const SizedBox(width: 8),
          Text(label,
              style: const TextStyle(
                  fontSize: 14, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
