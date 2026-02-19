import 'package:flutter/material.dart';
import 'delete_account_dialog.dart';

Future<bool?> showDeleteAccountDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) => const DeleteAccountDialog(),
    barrierColor: Colors.black.withValues(alpha: 0.4), // Standard dim
  );
}
