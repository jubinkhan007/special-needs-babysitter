import 'package:flutter/material.dart';
import '../../../../common_widgets/dialogs/app_confirm_dialog.dart';

class DeleteAccountDialog extends StatelessWidget {
  const DeleteAccountDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AppConfirmDialog(
      title: "Delete Account",
      message:
          "Are you sure you want to delete your account? This action is permanent and cannot be undone.",
      primaryActionLabel: "Cancel", // Right button, filled blue
      secondaryActionLabel: "Delete Account", // Left button, gray text
      onPrimary: () {
        // Cancel -> Close dialog with false
        Navigator.of(context).pop(false);
      },
      onSecondary: () {
        // Delete -> Close dialog with true
        Navigator.of(context).pop(true);
      },
      onClose: () {
        // X -> Close dialog with false
        Navigator.of(context).pop(false);
      },
    );
  }
}
