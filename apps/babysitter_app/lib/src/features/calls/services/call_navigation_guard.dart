import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../domain/entities/call_enums.dart';
import '../presentation/screens/incoming_call_screen.dart';
import '../presentation/screens/in_call_screen.dart';

/// Centralized navigation guard to prevent duplicate call screens
///
/// This prevents flashing when multiple handlers detect the same call
class CallNavigationGuard {
  final GlobalKey<NavigatorState> navigatorKey;

  String? _currentIncomingCallId;
  bool _isInCallScreenShowing = false;

  CallNavigationGuard({required this.navigatorKey});

  /// Check if incoming call screen is already showing for this call
  bool isShowingIncomingCall(String callId) => _currentIncomingCallId == callId;

  /// Check if in-call screen is showing
  bool get isShowingInCallScreen => _isInCallScreenShowing;

  /// Show incoming call screen (guards against duplicates)
  /// Returns true if screen was shown, false if already showing
  bool showIncomingCallScreen({
    required String callId,
    required CallType callType,
    required String callerName,
    required String callerUserId,
    String? callerAvatar,
  }) {
    // Guard: Already showing this call
    if (_currentIncomingCallId == callId) {
      developer.log(
        'IncomingCallScreen already showing for $callId, skipping',
        name: 'Calls',
      );
      return false;
    }

    // Guard: Already in a call
    if (_isInCallScreenShowing) {
      developer.log(
        'InCallScreen already showing, skipping incoming call screen',
        name: 'Calls',
      );
      return false;
    }

    final navigator = navigatorKey.currentState;
    if (navigator == null) {
      developer.log('Navigator not available', name: 'Calls');
      return false;
    }

    _currentIncomingCallId = callId;

    developer.log('Showing IncomingCallScreen for $callId', name: 'Calls');

    navigator.push(
      MaterialPageRoute(
        builder: (_) => IncomingCallScreen(
          callId: callId,
          callType: callType,
          callerName: callerName,
          callerUserId: callerUserId,
          callerAvatar: callerAvatar,
        ),
      ),
    ).then((_) {
      // Clear when screen is popped
      if (_currentIncomingCallId == callId) {
        _currentIncomingCallId = null;
      }
    });

    return true;
  }

  /// Show in-call screen (replaces current screens)
  void showInCallScreen() {
    final navigator = navigatorKey.currentState;
    if (navigator == null) {
      developer.log(
        '[CALL_NAV] showInCallScreen FAILED: navigator is null',
        name: 'Calls',
      );
      debugPrint('[CALL_NAV] showInCallScreen FAILED: navigator is null');
      return;
    }

    _currentIncomingCallId = null;
    _isInCallScreenShowing = true;

    developer.log('[CALL_NAV] Showing InCallScreen via pushAndRemoveUntil', name: 'Calls');
    debugPrint('[CALL_NAV] Showing InCallScreen via pushAndRemoveUntil');

    navigator.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const InCallScreen()),
      (route) => route.isFirst,
    );
  }

  /// Clear incoming call (when declined/cancelled)
  void clearIncomingCall(String callId) {
    if (_currentIncomingCallId == callId) {
      _currentIncomingCallId = null;
    }
  }

  /// Clear in-call screen state
  void clearInCallScreen() {
    _isInCallScreenShowing = false;
  }

  /// Pop to root and clear all state
  void popToRootAndClear() {
    final navigator = navigatorKey.currentState;
    if (navigator == null) return;

    _currentIncomingCallId = null;
    _isInCallScreenShowing = false;

    navigator.popUntil((route) => route.isFirst);
  }

  /// Reset all state
  void reset() {
    _currentIncomingCallId = null;
    _isInCallScreenShowing = false;
  }
}

/// Provider for CallNavigationGuard
final callNavigationGuardProvider = Provider.family<CallNavigationGuard, GlobalKey<NavigatorState>>(
  (ref, navigatorKey) => CallNavigationGuard(navigatorKey: navigatorKey),
);
