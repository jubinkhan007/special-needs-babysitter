import 'package:flutter/material.dart';
import 'dart:async';

/// A utility mixin that provides debouncing functionality to prevent
/// multiple rapid taps on buttons.
/// 
/// Usage:
/// ```dart
/// class MyWidget extends StatefulWidget {
///   @override
///   State<MyWidget> createState() => _MyWidgetState();
/// }
/// 
/// class _MyWidgetState extends State<MyWidget> with DebouncedAction {
///   void _handleTap() {
///     withDebounce(() {
///       // Your action here
///     });
///   }
/// }
/// ```
mixin DebouncedAction<T extends StatefulWidget> on State<T> {
  Timer? _debounceTimer;
  bool _isActionInProgress = false;

  /// Executes the given action with debouncing.
  /// [delay] specifies the debounce duration (default: 500ms).
  /// [blockWhileProcessing] if true, blocks subsequent taps until action completes.
  Future<void> withDebounce(
    VoidCallback action, {
    Duration delay = const Duration(milliseconds: 500),
    bool blockWhileProcessing = true,
  }) async {
    if (_debounceTimer?.isActive == true) return;
    if (blockWhileProcessing && _isActionInProgress) return;

    _debounceTimer?.cancel();
    _debounceTimer = Timer(delay, () {});

    if (blockWhileProcessing) {
      _isActionInProgress = true;
    }

    try {
      action();
    } finally {
      if (blockWhileProcessing) {
        _isActionInProgress = false;
      }
    }
  }

  /// Executes the given async action with debouncing.
  Future<void> withDebounceAsync(
    Future<void> Function() action, {
    Duration delay = const Duration(milliseconds: 500),
  }) async {
    if (_debounceTimer?.isActive == true) return;
    if (_isActionInProgress) return;

    _debounceTimer?.cancel();
    _debounceTimer = Timer(delay, () {});
    _isActionInProgress = true;

    try {
      await action();
    } finally {
      _isActionInProgress = false;
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}

/// A widget that wraps a child with debouncing functionality.
/// Prevents rapid repeated taps on interactive elements.
class DebouncedGestureDetector extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final Duration debounceDuration;

  const DebouncedGestureDetector({
    super.key,
    required this.child,
    required this.onTap,
    this.debounceDuration = const Duration(milliseconds: 500),
  });

  @override
  State<DebouncedGestureDetector> createState() =>
      _DebouncedGestureDetectorState();
}

class _DebouncedGestureDetectorState extends State<DebouncedGestureDetector> {
  DateTime? _lastTap;

  void _handleTap() {
    final now = DateTime.now();
    if (_lastTap != null &&
        now.difference(_lastTap!) < widget.debounceDuration) {
      return; // Ignore rapid taps
    }
    _lastTap = now;
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      behavior: HitTestBehavior.translucent,
      child: widget.child,
    );
  }
}

/// An ElevatedButton that debounces tap events.
class DebouncedElevatedButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Duration debounceDuration;
  final ButtonStyle? style;
  final bool isLoading;

  const DebouncedElevatedButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.debounceDuration = const Duration(milliseconds: 500),
    this.style,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return DebouncedGestureDetector(
      onTap: isLoading ? () {} : onPressed,
      debounceDuration: debounceDuration,
      child: AbsorbPointer(
        absorbing: isLoading,
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: style,
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(label),
        ),
      ),
    );
  }
}
