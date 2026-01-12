import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class JobDraftSavedDialog extends StatelessWidget {
  final VoidCallback onEditJob;
  final VoidCallback onGoToHome;
  final VoidCallback onClose;

  const JobDraftSavedDialog({
    super.key,
    required this.onEditJob,
    required this.onGoToHome,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                const Text(
                  'Your Job Has Been Saved\nFor Later.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0B1736), // Deep Navy
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 16),

                // Description
                const Text(
                  'Your job posting is saved. Review and submit it anytime. You’ll be notified if any changes are needed.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF667085), // Grey
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),

                // Buttons Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Edit Job (Text Button)
                    Expanded(
                      flex: 4,
                      child: TextButton(
                        onPressed: onEditJob,
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF667085),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        child: const Text('Edit Job'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Go to Home (Primary)
                    Expanded(
                      flex: 6,
                      child: PrimaryButton(
                        label: 'Go to Home',
                        onPressed: onGoToHome,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Close Button
          Positioned(
            right: 8,
            top: 8,
            child: IconButton(
              icon: const Icon(Icons.close, color: Color(0xFF98A2B3)),
              onPressed: onClose,
            ),
          ),
        ],
      ),
    );
  }
}
