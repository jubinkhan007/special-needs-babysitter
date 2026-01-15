import 'package:flutter/material.dart';
import '../../../theme/app_tokens.dart';
import '../domain/chat_message.dart';
import 'models/chat_message_ui_model.dart';
import 'widgets/chat_thread_app_bar.dart';
import 'widgets/chat_background.dart';
import 'widgets/chat_day_separator.dart';
import 'widgets/message_bubble.dart';
import 'widgets/call_log_tile.dart';
import 'widgets/chat_composer_bar.dart';

import 'package:go_router/go_router.dart';
import '../../../routing/routes.dart';
import '../../calls/domain/audio_call_args.dart';
import '../../calls/domain/video_call_args.dart';

// ... other imports

class ChatThreadScreen extends StatelessWidget {
  const ChatThreadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Data matching Figma Screenshot
    final messages = _getMockMessages();
    final uiModels = ChatMessageUiModel.fromDomainList(messages);

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        backgroundColor: AppTokens.chatScreenBg,
        appBar: ChatThreadAppBar(
          title: 'Krystina',
          isVerified: true,
          avatarUrl: 'https://randomuser.me/api/portraits/women/44.jpg',
          onVoiceCall: () {
            context.push(
              Routes.audioCall,
              extra: const AudioCallArgs(
                remoteName: 'Krystina',
                remoteAvatarUrl:
                    'https://randomuser.me/api/portraits/women/44.jpg',
                isInitialCalling: true,
              ),
            );
          },
          onVideoCall: () {
            context.push(
              Routes.videoCall,
              extra: const VideoCallArgs(
                remoteName: 'Krystina',
                remoteVideoUrl:
                    'https://randomuser.me/api/portraits/women/44.jpg', // Placeholder
                localPreviewUrl:
                    'https://randomuser.me/api/portraits/women/68.jpg', // Placeholder for self
              ),
            );
          },
        ),
        body: Stack(
          children: [
            // Fixed Background
            const Positioned.fill(
              child: ChatBackground(),
            ),

            // Scrollable Content
            Column(
              children: [
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      SliverPadding(
                        padding: EdgeInsets.only(top: AppTokens.listTopPadding),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final item = uiModels[index];

                              return Column(
                                children: [
                                  if (item.showDaySeparator)
                                    ChatDaySeparator(text: item.dayLabel),
                                  if (item.isCallLog)
                                    CallLogTile(uiModel: item)
                                  else
                                    MessageBubble(uiModel: item),
                                ],
                              );
                            },
                            childCount: uiModels.length,
                          ),
                        ),
                      ),
                      // Bottom spacer to ensure last message isn't hidden by composer
                      // Composer height + extra padding
                      SliverToBoxAdapter(
                        child: SizedBox(height: AppTokens.composerHeight),
                      ),
                    ],
                  ),
                ),

                // Sticky Composer
                const ChatComposerBar(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<ChatMessage> _getMockMessages() {
    final now = DateTime(2024, 1, 14, 16, 27); // 4:27 PM

    return [
      // 1. Incoming Text
      ChatMessage.text(
        id: '1',
        senderId: 'krystina',
        senderName: 'Krystina',
        senderAvatarUrl: 'https://randomuser.me/api/portraits/women/44.jpg',
        isMe: false,
        text: 'Hey there! How\'s Your Day Going?',
        createdAt: now,
      ),

      // 2. Outgoing Text
      ChatMessage.text(
        id: '2',
        senderId: 'me',
        senderName: 'Me',
        isMe: true, // "You"
        text: 'Really Great! What about You? Are You available this weekend?',
        createdAt: now,
      ),

      // 3. Voice Call (Incoming/Completed)
      // Icon: diag arrow (call made/received?)
      // Screenshot shows "Voice Call" with arrow down-left. usually means received.
      // But text says "Voice Call" generic.
      // Let's assume its a log entry.
      ChatMessage.callLog(
        id: '3',
        senderId: 'krystina',
        senderName: 'Krystina',
        isMe: false,
        callType: CallType.voice,
        callStatus: CallStatus.completed,
        duration: const Duration(minutes: 5, seconds: 43),
        createdAt: now, // 4:27 PM
      ),

      // 4. Missed Voice Call
      ChatMessage.callLog(
        id: '4',
        senderId: 'krystina',
        senderName: 'Krystina',
        isMe: false,
        callType: CallType.voice,
        callStatus: CallStatus.missed,
        duration: const Duration(
            minutes: 5,
            seconds:
                43), // Duration on missed call? Maybe ringing time? or just copying screenshot.
        createdAt: now,
      ),

      // 5. Missed Video Call
      ChatMessage.callLog(
        id: '5',
        senderId: 'krystina',
        senderName: 'Krystina',
        isMe: false,
        callType: CallType.video,
        callStatus: CallStatus.missed, // Screenshot says Missed Video Call
        duration: const Duration(minutes: 5, seconds: 43),
        createdAt: now,
      ),
    ];
  }
}
