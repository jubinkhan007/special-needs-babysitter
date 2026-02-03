import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../domain/entities/call_enums.dart';
import '../controllers/call_state.dart';
import '../providers/calls_providers.dart';
import '../widgets/call_app_bar.dart';
import '../widgets/call_avatar.dart';
import '../widgets/call_background.dart';
import '../../services/call_notification_service.dart';
import '../../../../theme/app_tokens.dart';
import 'in_call_screen.dart';

/// Screen shown when sitter receives an incoming call
class IncomingCallScreen extends ConsumerWidget {
  final String callId;
  final CallType callType;
  final String callerName;
  final String callerUserId;
  final String? callerAvatar;

  const IncomingCallScreen({
    super.key,
    required this.callId,
    required this.callType,
    required this.callerName,
    required this.callerUserId,
    this.callerAvatar,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final callState = ref.watch(callControllerProvider);

    // Listen for state changes
    ref.listen<CallState>(callControllerProvider, (previous, next) {
      if (next is InCall) {
        // End CallKit UI and navigate to in-call screen
        CallNotificationService.endCall(callId);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const InCallScreen()),
        );
      } else if (next is CallEnded || next is CallIdle) {
        CallNotificationService.endCall(callId);
        Navigator.of(context).pop();
      } else if (next is CallError) {
        CallNotificationService.endCall(callId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.message), backgroundColor: Colors.red),
        );
        Navigator.of(context).pop();
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
                            avatarUrl: callerAvatar,
                            size: AppTokens.callAvatarLargeSize,
                          ),
                          SizedBox(height: AppTokens.callVerticalSpacingMd),
                          Text(
                            callerName,
                            style: AppTokens.callNameLargeStyle,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: AppTokens.callVerticalSpacingSm),
                          Text(
                            _getCallTypeLabel(),
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
                child: _buildActionButtons(context, ref, callState),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getCallTypeLabel() {
    return callType == CallType.video
        ? 'Incoming Video Call'
        : 'Incoming Audio Call';
  }

  Widget _buildActionButtons(
    BuildContext context,
    WidgetRef ref,
    CallState state,
  ) {
    final isLoading = state is CallLoading;

    return Container(
      width: ScreenUtil().screenWidth * AppTokens.callControlsBarWidthFactor,
      height: AppTokens.callControlsBarHeight,
      padding: EdgeInsets.symmetric(
        horizontal: AppTokens.callControlsBarPadding,
      ),
      decoration: BoxDecoration(
        color: AppTokens.callControlBarBg,
        borderRadius: BorderRadius.circular(AppTokens.callControlsBarRadius),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(
            icon: Icons.call_end_rounded,
            color: AppTokens.callEndButtonBg,
            onTap: isLoading
                ? null
                : () => ref.read(callControllerProvider.notifier).declineCall(),
          ),
          _buildActionButton(
            icon:
                callType == CallType.video ? Icons.videocam_rounded : Icons.call,
            color: const Color(0xFF22C55E),
            onTap: isLoading
                ? null
                : () => ref.read(callControllerProvider.notifier).acceptCall(),
            isLoading: isLoading,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback? onTap,
    bool isLoading = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppTokens.callEndButtonSize,
        height: AppTokens.callEndButtonSize,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: isLoading
            ? SizedBox(
                width: 24.w,
                height: 24.w,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Icon(
                icon,
                color: AppTokens.callControlIconColor,
                size: AppTokens.callControlIconSize,
              ),
      ),
    );
  }
}
