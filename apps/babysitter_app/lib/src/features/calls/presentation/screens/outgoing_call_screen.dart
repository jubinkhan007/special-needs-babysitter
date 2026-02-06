import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:auth/auth.dart';

import '../../domain/entities/call_enums.dart';
import '../controllers/call_state.dart';
import '../providers/calls_providers.dart';
import '../widgets/call_app_bar.dart';
import '../widgets/call_avatar.dart';
import '../widgets/call_background.dart';
import '../widgets/call_control_bar.dart';
import '../../../../theme/app_tokens.dart';
import 'in_call_screen.dart';

/// Screen shown when parent is calling a sitter
class OutgoingCallScreen extends ConsumerStatefulWidget {
  final String recipientUserId;
  final String recipientName;
  final String? recipientAvatar;
  final CallType callType;

  const OutgoingCallScreen({
    super.key,
    required this.recipientUserId,
    required this.recipientName,
    this.recipientAvatar,
    required this.callType,
  });

  @override
  ConsumerState<OutgoingCallScreen> createState() => _OutgoingCallScreenState();
}

class _OutgoingCallScreenState extends ConsumerState<OutgoingCallScreen> {
  late bool _isVideoEnabled;
  bool _isSpeakerOn = false;
  bool _isMicOn = true;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _isVideoEnabled = widget.callType == CallType.video;
    // Initiate call on screen load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Ensure user ID is set before initiating call
      final currentUser = ref.read(currentUserProvider).valueOrNull;
      if (currentUser?.id != null) {
        ref.read(callControllerProvider.notifier).setCurrentUserId(currentUser!.id);
      }
      ref.read(callControllerProvider.notifier).initiateCall(
        recipientUserId: widget.recipientUserId,
        recipientName: widget.recipientName,
        recipientAvatar: widget.recipientAvatar,
        callType: widget.callType,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final callState = ref.watch(callControllerProvider);

    // Listen for state changes (with guard against duplicate navigation)
    ref.listen<CallState>(callControllerProvider, (previous, next) {
      if (_hasNavigated || !mounted) return;

      if (next is InCall) {
        _hasNavigated = true;
        // Navigate to in-call screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const InCallScreen()),
        );
      } else if (next is CallEnded) {
        _hasNavigated = true;
        _showCallEndedAndPop(next.reason);
      } else if (next is CallError) {
        _hasNavigated = true;
        _showErrorAndPop(next.message);
      }
    });

    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
        body: Stack(
          children: [
            const Positioned.fill(child: CallBackground()),
            SafeArea(
              child: Column(
                children: [
                  const CallAppBar(title: 'Special Needs Sitters App'),
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CallAvatar(
                            avatarUrl: widget.recipientAvatar,
                            size: AppTokens.callAvatarLargeSize,
                          ),
                          SizedBox(height: AppTokens.callVerticalSpacingMd),
                          Text(
                            widget.recipientName,
                            style: AppTokens.callNameLargeStyle,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: AppTokens.callVerticalSpacingSm),
                          Text(
                            _getStatusText(callState),
                            style: AppTokens.callStatusStyle,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: MediaQuery.of(context).padding.bottom + 20.h,
              child: Center(
                child: CallControlBar(
                  isVideoEnabled: _isVideoEnabled,
                  isSpeakerOn: _isSpeakerOn,
                  isMicOn: _isMicOn,
                  onEndCall: _endCall,
                  onToggleMic: _toggleMic,
                  onToggleSpeaker: _toggleSpeaker,
                  onToggleVideo: _toggleVideo,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getStatusText(CallState state) {
    return switch (state) {
      CallLoading(:final message) => message,
      OutgoingRinging() => 'Calling...',
      _ => 'Connecting...',
    };
  }

  void _toggleMic() {
    setState(() {
      _isMicOn = !_isMicOn;
    });
  }

  void _toggleSpeaker() {
    setState(() {
      _isSpeakerOn = !_isSpeakerOn;
    });
  }

  void _toggleVideo() {
    setState(() {
      _isVideoEnabled = !_isVideoEnabled;
    });
  }

  void _endCall() {
    ref.read(callControllerProvider.notifier).cancelCall();
  }

  void _showCallEndedAndPop(CallEndReason reason) {
    final message = switch (reason) {
      CallEndReason.declined => 'Call declined',
      CallEndReason.missed => 'No answer',
      CallEndReason.remoteEnded => 'Call ended',
      CallEndReason.busy => 'User is busy',
      _ => 'Call ended',
    };

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
      Navigator.of(context).pop();
    }
  }

  void _showErrorAndPop(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
      Navigator.of(context).pop();
    }
  }
}
