import 'package:flutter/material.dart';
import 'package:babysitter_app/src/common_widgets/dialogs/app_confirm_dialog.dart';

/// Sign Out confirmation dialog.
/// Uses the reusable AppConfirmDialog with sign out specific text.
class SignOutDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const SignOutDialog({
    super.key,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AppConfirmDialog(
      title: 'Sign Out',
      message: 'Are you sure you want to sign out?',
      primaryActionLabel: 'Log Out',
      secondaryActionLabel: 'Cancel',
      onPrimary: onConfirm,
      onSecondary: onCancel,
      onClose: onCancel,
    );
  }
}
