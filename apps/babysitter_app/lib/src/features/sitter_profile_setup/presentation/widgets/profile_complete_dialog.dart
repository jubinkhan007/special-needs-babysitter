import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../routing/routes.dart';

/// Shows the Profile Complete dialog after successful Step 9 submission.
///
/// This dialog is non-dismissible by tapping outside.
/// User can close via the X icon or the Continue button.
/// Continue button navigates to the sitter home (limited access).
Future<void> showProfileCompleteDialog(BuildContext context) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withValues(alpha: 0.65),
    barrierLabel: 'Profile Complete Dialog',
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (context, animation, secondaryAnimation) {
      return const _ProfileCompleteDialogContent();
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.95, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOut),
          ),
          child: child,
        ),
      );
    },
  );
}

class _ProfileCompleteDialogContent extends StatelessWidget {
  const _ProfileCompleteDialogContent();

  // Design tokens
  static const _primaryBlue = AppColors.primary;
  static const _successGreen = AppColors.success;
  static const _textDark = Color(0xFF1A1A1A);
  static const _textGrey = Color(0xFF667085);
  static const _closeIconColor = Color(0xFF98A2B3);

  @override
  Widget build(BuildContext context) {
    return Center(
      key: const Key('profileCompleteDialog'),
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          constraints: const BoxConstraints(maxWidth: 340),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Close Icon (top right)
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    key: const Key('profileCompleteClose'),
                    onTap: () => Navigator.of(context).pop(),
                    child: const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.close,
                        size: 24,
                        color: _closeIconColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Green Check Circle (centered)
                Center(
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                      color: _successGreen,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Title
                const Text(
                  'Your Profile Is Complete!\nYou\'re almost ready to\naccess all sitters\nfeatures.',
                  key: Key('profileCompleteTitle'),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: _textDark,
                    height: 1.3,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 20),

                // Body Text
                const Text(
                  'Your background check is still being\nprocessed. This usually takes 1-2\nbusiness days. We\'ll notify you once\nit\'s approved.',
                  key: Key('profileCompleteBody'),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: _textGrey,
                    height: 1.5,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 32),

                // Continue Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    key: const Key('profileCompleteContinue'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.go(Routes.sitterHome);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryBlue,
                      foregroundColor: AppColors.textOnButton,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          '(Limited Access Until Approval)',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
