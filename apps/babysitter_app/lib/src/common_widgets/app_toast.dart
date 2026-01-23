import 'dart:async';

import 'package:flutter/material.dart';

class AppToast {
  static OverlayEntry? _entry;
  static Timer? _timer;

  static void show(BuildContext context, SnackBar snackBar) {
    _timer?.cancel();
    _removeEntry();

    final overlay = Overlay.of(context, rootOverlay: true);
    if (overlay == null) {
      return;
    }

    final media = MediaQuery.of(context);
    final topInset = media.padding.top;
    final theme = Theme.of(context);
    final backgroundColor =
        snackBar.backgroundColor ?? theme.colorScheme.onSurface;
    final contentTextStyle = theme.snackBarTheme.contentTextStyle ??
        theme.textTheme.bodyMedium?.copyWith(color: Colors.white);

    final entry = OverlayEntry(
      builder: (overlayContext) {
        return Positioned(
          top: topInset + 12,
          left: 16,
          right: 16,
          child: Material(
            color: Colors.transparent,
            child: _ToastCard(
              content: snackBar.content,
              backgroundColor: backgroundColor,
              textStyle: contentTextStyle,
            ),
          ),
        );
      },
    );

    overlay.insert(entry);
    _entry = entry;

    final duration = snackBar.duration == Duration.zero
        ? const Duration(seconds: 3)
        : snackBar.duration;
    _timer = Timer(duration, _removeEntry);
  }

  static void _removeEntry() {
    _entry?.remove();
    _entry = null;
  }
}

class _ToastCard extends StatefulWidget {
  final Widget content;
  final Color backgroundColor;
  final TextStyle? textStyle;

  const _ToastCard({
    required this.content,
    required this.backgroundColor,
    required this.textStyle,
  });

  @override
  State<_ToastCard> createState() => _ToastCardState();
}

class _ToastCardState extends State<_ToastCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, -0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Container(
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: DefaultTextStyle(
            style: widget.textStyle ?? const TextStyle(color: Colors.white),
            child: IconTheme(
              data: IconThemeData(
                color: widget.textStyle?.color ?? Colors.white,
              ),
              child: widget.content,
            ),
          ),
        ),
      ),
    );
  }
}
