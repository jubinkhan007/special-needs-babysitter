import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:ui_kit/ui_kit.dart';

class JobPostSuccessDialog extends StatelessWidget {
  final VoidCallback onInviteSitters;
  final VoidCallback onGoToHome;
  final VoidCallback onEditJob;
  final VoidCallback onClose;

  const JobPostSuccessDialog({
    super.key,
    required this.onInviteSitters,
    required this.onGoToHome,
    required this.onEditJob,
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
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                // Celebration Icon (Party Popper)
                const Icon(
                  Icons.celebration,
                  size: 64,
                  color: AppColors.primary, // Light Blue
                ),
                const SizedBox(height: 24),

                // Title
                const Text(
                  'Your Job Request Has\nBeen Sent.',
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
                  'Your job posting is under review. You will receive a notification once it is successfully posted or if any changes are required.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF667085), // Grey
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),

                // Primary Action: Invite Sitters
                PrimaryButton(
                  label: 'Invite Sitters',
                  onPressed: onInviteSitters,
                ),
                const SizedBox(height: 12),

                // Secondary Action: Go to Home
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: onGoToHome,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: Color(0xFFD0D5DD)),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusMd),
                      ),
                    ),
                    child: const Text(
                      'Go to Home',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF344054), // Dark Grey
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Tertiary Action: Edit Job
                TextButton(
                  onPressed: onEditJob,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Edit Job',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF667085), // Grey
                    ),
                  ),
                ),
                  ],
                ),
              ),
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
