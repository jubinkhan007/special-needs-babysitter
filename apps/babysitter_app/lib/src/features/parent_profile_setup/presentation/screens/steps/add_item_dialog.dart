import 'package:flutter/material.dart';
import '../../../../../../common/theme/auth_theme.dart';

class AddItemDialog extends StatefulWidget {
  final String title;
  final Function(String) onAdd;
  final String? initialValue;
  final String confirmLabel;

  const AddItemDialog({
    super.key,
    required this.title,
    required this.onAdd,
    this.initialValue,
    this.confirmLabel = 'Add',
  });

  @override
  State<AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    if (widget.initialValue != null) {
      _controller.text = widget.initialValue!;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent, // Remove tint
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        widget.title,
        style: const TextStyle(
          color: Color(0xFF1A1A1A), // Dark text
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: TextField(
        controller: _controller,
        style: const TextStyle(color: Color(0xFF1A1A1A)),
        decoration: InputDecoration(
          hintText: 'Enter name',
          hintStyle: const TextStyle(color: Color(0xFF667085)),
          filled: true,
          fillColor: const Color(0xFFF2F4F7), // Light grey input bg
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        autofocus: true,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Cancel',
            style: TextStyle(
                color: Color(0xFF667085), fontWeight: FontWeight.w600),
          ),
        ),
        TextButton(
          onPressed: () {
            if (_controller.text.trim().isNotEmpty) {
              widget.onAdd(_controller.text.trim());
              Navigator.pop(context);
            }
          },
          child: Text(
            widget.confirmLabel,
            style: const TextStyle(
                color: AuthTheme.primaryBlue, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
