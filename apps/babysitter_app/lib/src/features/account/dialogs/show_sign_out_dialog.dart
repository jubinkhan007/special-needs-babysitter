import 'package:flutter/material.dart';
import 'sign_out_dialog.dart';

/// Shows the sign out confirmation dialog.
/// Returns true if user confirmed sign out, false otherwise.
Future<bool?> showSignOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    barrierColor: Colors.black.withOpacity(0.5),
    builder: (context) => SignOutDialog(
      onConfirm: () => Navigator.of(context).pop(true),
      onCancel: () => Navigator.of(context).pop(false),
    ),
  );
}
