import 'package:flutter/material.dart';
import '../sitter_account_ui_constants.dart';

class SitterStatsRow extends StatelessWidget {
  final int completedJobsCount;
  final int savedJobsCount;
  final VoidCallback onTapCompletedJobs;
  final VoidCallback onTapSavedJobs;

  const SitterStatsRow({
    super.key,
    required this.completedJobsCount,
    required this.savedJobsCount,
    required this.onTapCompletedJobs,
    required this.onTapSavedJobs,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'Completed Jobs',
            count: completedJobsCount,
            onTap: onTapCompletedJobs,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _StatCard(
            label: 'Saved Jobs',
            count: savedJobsCount,
            onTap: onTapSavedJobs,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final int count;
  final VoidCallback onTap;

  const _StatCard({
    required this.label,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: SitterAccountUI.cardDecoration,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              count.toString(),
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: SitterAccountUI.textDark,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    label,
                    style: SitterAccountUI.subtitleStyle.copyWith(fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(
                  Icons.arrow_forward,
                  size: 16,
                  color: SitterAccountUI.textGray,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
