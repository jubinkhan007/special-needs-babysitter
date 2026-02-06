import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:auth/auth.dart';
import 'package:realtime/realtime.dart';

import '../../domain/entities/call_enums.dart';
import '../controllers/call_state.dart';
import '../providers/calls_providers.dart';
import '../widgets/call_timer.dart';
import '../../services/call_notification_service.dart';

/// Active call screen with video/audio controls
///
/// FIX #2: Uses the same Agora engine from AgoraCallService
/// Does NOT create a new engine or call joinChannel
class InCallScreen extends ConsumerStatefulWidget {
  const InCallScreen({super.key});

  @override
  ConsumerState<InCallScreen> createState() => _InCallScreenState();
}

class _InCallScreenState extends ConsumerState<InCallScreen> {
  bool _hasNavigated = false;

  @override
  Widget build(BuildContext context) {
    final callState = ref.watch(callControllerProvider);

    // Handle state changes (with guard against duplicate navigation)
    ref.listen<CallState>(callControllerProvider, (previous, next) {
      if (_hasNavigated || !mounted) return;

      if (next is CallEnded || next is CallError || next is CallIdle) {
        _hasNavigated = true;
        // Cleanup CallKit UI
        if (previous is InCall) {
          CallNotificationService.endCall(previous.session.callId);
        }
        Navigator.of(context).pop();
      }
    });

    if (callState is! InCall) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final currentUserId = ref.read(currentUserProvider).valueOrNull?.id ?? '';
    final remoteParticipant = callState.session.getRemoteParticipant(currentUserId);
    final isVideoCall = callState.session.callType == CallType.video;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Main content: Video or Audio UI
          if (isVideoCall && callState.isVideoEnabled)
            _buildVideoUI(callState)
          else
            _buildAudioUI(callState, remoteParticipant?.name ?? 'Unknown'),

          // Top bar with call info
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildTopBar(callState, remoteParticipant?.name ?? '', isVideoCall),
          ),

          // Bottom control bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildControlBar(callState, isVideoCall),
          ),
        ],
      ),
    );
  }

  /// FIX #2: Build video UI using the SAME engine from AgoraCallService
  Widget _buildVideoUI(InCall callState) {
    // Get the engine from the CallService (same instance)
    final callService = ref.read(callServiceProvider);
    RtcEngine? engine;

    if (callService is AgoraCallService) {
      engine = callService.engine;
    }

    if (engine == null) {
      return Center(
        child: Text(
          'Video not available',
          style: TextStyle(color: Colors.white, fontSize: 16.sp),
        ),
      );
    }

    return Stack(
      children: [
        // Remote video (full screen)
        if (callState.remoteJoined &&
            callState.remoteUid != null &&
            !callState.remoteVideoMuted)
          Positioned.fill(
            child: AgoraVideoView(
              controller: VideoViewController.remote(
                rtcEngine: engine,
                canvas: VideoCanvas(uid: callState.remoteUid!),
                connection: RtcConnection(
                  channelId: callState.session.channelName,
                ),
              ),
            ),
          )
        else
          Positioned.fill(
            child: Container(
              color: Colors.grey[900],
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      callState.remoteVideoMuted
                          ? Icons.videocam_off_rounded
                          : Icons.videocam_outlined,
                      size: 64.sp,
                      color: Colors.grey[600],
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      callState.remoteVideoMuted
                          ? 'Camera is off'
                          : 'Waiting for video...',
                      style: TextStyle(color: Colors.grey[400], fontSize: 16.sp),
                    ),
                  ],
                ),
              ),
            ),
          ),

        // Local video (PiP) - using same engine
        Positioned(
          top: MediaQuery.of(context).padding.top + 80.h,
          right: 16.w,
          child: GestureDetector(
            onTap: () {
              // Optionally swap local/remote views
            },
            child: Container(
              width: 100.w,
              height: 140.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: AgoraVideoView(
                controller: VideoViewController(
                  rtcEngine: engine,
                  canvas: const VideoCanvas(uid: 0), // 0 = local user
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAudioUI(InCall callState, String remoteName) {
    final remoteParticipant = callState.session.getRemoteParticipant(
      ref.read(currentUserProvider).valueOrNull?.id ?? '',
    );
    final isConnected = callState.remoteJoined ||
        callState.session.status == CallStatus.accepted;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF1E88E5),
            Colors.grey[900]!,
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Avatar
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 24,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 60.r,
                backgroundColor: Colors.grey[700],
                backgroundImage: remoteParticipant?.avatar != null
                    ? NetworkImage(remoteParticipant!.avatar!)
                    : null,
                child: remoteParticipant?.avatar == null
                    ? Text(
                        remoteName.isNotEmpty ? remoteName[0].toUpperCase() : '?',
                        style: TextStyle(
                          fontSize: 48.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              remoteName,
              style: TextStyle(
                fontSize: 24.sp,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            CallTimer(elapsedSeconds: callState.elapsedSeconds),
            SizedBox(height: 8.h),
            if (isConnected)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.circle,
                    size: 8.sp,
                    color: Colors.green,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'Connected',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.green,
                    ),
                  ),
                ],
              )
            else
              Text(
                'Connecting...',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[400],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(InCall callState, String remoteName, bool isVideoCall) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16.h,
        left: 16.w,
        right: 16.w,
        bottom: 16.h,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.7),
            Colors.transparent,
          ],
        ),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                remoteName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4.h),
              CallTimer(
                elapsedSeconds: callState.elapsedSeconds,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
          const Spacer(),
          if (isVideoCall)
            IconButton(
              icon: Icon(
                callState.isFrontCamera
                    ? Icons.camera_front
                    : Icons.camera_rear,
                color: Colors.white,
              ),
              onPressed: () =>
                  ref.read(callControllerProvider.notifier).switchCamera(),
            ),
        ],
      ),
    );
  }

  Widget _buildControlBar(InCall callState, bool isVideoCall) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 24.h,
        top: 24.h,
        left: 24.w,
        right: 24.w,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.black.withOpacity(0.9),
            Colors.transparent,
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Mute button
          _buildControlButton(
            icon: callState.isAudioMuted ? Icons.mic_off : Icons.mic,
            label: callState.isAudioMuted ? 'Unmute' : 'Mute',
            isActive: !callState.isAudioMuted,
            onTap: () => ref.read(callControllerProvider.notifier).toggleMute(),
          ),
          // Video toggle (for video calls)
          if (isVideoCall)
            _buildControlButton(
              icon: callState.isVideoEnabled
                  ? Icons.videocam
                  : Icons.videocam_off,
              label: callState.isVideoEnabled ? 'Video' : 'Video Off',
              isActive: callState.isVideoEnabled,
              onTap: () =>
                  ref.read(callControllerProvider.notifier).toggleVideo(),
            ),
          // Speaker toggle
          _buildControlButton(
            icon: callState.isSpeakerOn
                ? Icons.volume_up
                : Icons.volume_down,
            label: callState.isSpeakerOn ? 'Speaker' : 'Phone',
            isActive: callState.isSpeakerOn,
            onTap: () =>
                ref.read(callControllerProvider.notifier).toggleSpeaker(),
          ),
          // End call button
          _buildControlButton(
            icon: Icons.call_end,
            label: 'End',
            backgroundColor: Colors.red,
            onTap: () => ref.read(callControllerProvider.notifier).endCall(),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    bool isActive = true,
    Color? backgroundColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56.w,
            height: 56.w,
            decoration: BoxDecoration(
              color: backgroundColor ??
                  (isActive ? Colors.white.withOpacity(0.2) : Colors.grey[700]),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 28.sp,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}
