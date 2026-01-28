import 'package:flutter/material.dart';

class FormFieldCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const FormFieldCard({
    super.key,
    required this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height:
            56, // Standard height per generic mobile design, or match Figma exactly if different.
        // Screenshot looks standard ~52-56.
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12), // Rounded corners
          border: Border.all(
            color: colorScheme.outline, // Light Blue border #B2DDFF
            width: 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.centerLeft, // Align content
        child: child,
      ),
    );
  }
}
