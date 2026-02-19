import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:babysitter_app/src/theme/app_tokens.dart';
import 'package:babysitter_app/src/features/messages/domain/chat_message.dart';
import 'package:babysitter_app/src/features/support/domain/support_chat_args.dart';

import 'models/support_chat_ui_mapper.dart';
import 'widgets/support_chat_app_bar.dart';
import 'widgets/support_message_bubble.dart';
import 'widgets/user_message_bubble.dart';
import 'widgets/support_composer_bar.dart';

class SupportChatScreen extends StatefulWidget {
  final SupportChatArgs args;

  const SupportChatScreen({
    super.key,
    required this.args,
  });

  @override
  State<SupportChatScreen> createState() => _SupportChatScreenState();
}

class _SupportChatScreenState extends State<SupportChatScreen> {
  late List<ChatMessage> _messages;
  final TextEditingController _composerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMockData();
  }

  void _loadMockData() {
    // Generate mock data based on args.isInitialVerification (State A vs B)
    if (widget.args.isInitialVerification) {
      // Mock State A (Zip code flow)
      _messages = [
        ChatMessage.text(
          id: '1',
          senderId: 'support',
          senderName: 'Support',
          senderType: ChatMessageSenderType.support,
          isMe: false,
          text:
              "Hello! I see you’re having trouble accessing your account. Please let me know if you don’t have access to your phone or email, and I’ll help verify your identity another way",
          createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
        ),
        ChatMessage.text(
          id: '2',
          senderId: 'support',
          senderName: 'Support',
          senderType: ChatMessageSenderType.support,
          isMe: false,
          text:
              "There are two methods for verification. You can either answer the security question or enter your zip code.",
          createdAt: DateTime.now().subtract(const Duration(minutes: 4)),
        ),
        ChatMessage.text(
          id: '3',
          senderId: 'user',
          senderName: 'Me',
          senderType: ChatMessageSenderType.user,
          senderAvatarUrl: 'https://randomuser.me/api/portraits/women/68.jpg',
          isMe: true,
          text:
              "My zip code is 079882. The answer to the security question is “Burt the Lhasa Apso.”",
          createdAt: DateTime.now().subtract(const Duration(minutes: 2)),
        ),
        ChatMessage.text(
          id: '4',
          senderId: 'support',
          senderName: 'Support',
          senderType: ChatMessageSenderType.support,
          isMe: false,
          text:
              "Password reset successful! Please log in with your new password. Reset link here: www.passwordreset.com",
          createdAt: DateTime.now().subtract(const Duration(minutes: 1)),
        ),
        ChatMessage.text(
          id: '5',
          senderId: 'support',
          senderName: 'Support',
          senderType: ChatMessageSenderType.support,
          isMe: false,
          text:
              "Please rate your help chat experience or ask any additional questions. We",
          createdAt: DateTime.now(),
        ),
      ];
    } else {
      // Mock State B (Access denied/Prompt flow) - reused logic but different text
      _messages = [
        ChatMessage.text(
          id: '1',
          senderId: 'support',
          senderName: 'Support',
          senderType: ChatMessageSenderType.support,
          isMe: false,
          text:
              "Hello! I see you’re having trouble accessing your account. Please let me know if you don’t have access to your phone or email, and I’ll help verify your identity another way",
          createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
        ),
        ChatMessage.text(
          id: '3',
          senderId: 'support',
          senderName: 'Support',
          senderType: ChatMessageSenderType.support,
          isMe: false,
          text:
              "There are two methods for verification. You can either answer the security question or enter your zip code.",
          createdAt: DateTime.now().subtract(const Duration(minutes: 9)),
        ),
        ChatMessage.text(
          id: '4',
          senderId: 'user',
          senderName: 'Me',
          senderType: ChatMessageSenderType.user,
          senderAvatarUrl: 'https://randomuser.me/api/portraits/women/68.jpg',
          isMe: true,
          text:
              "I do not have access to my zip code or security question at this time.",
          createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
        ),
        ChatMessage.text(
          id: '5',
          senderId: 'support',
          senderName: 'Support',
          senderType: ChatMessageSenderType.support,
          isMe: false,
          text: "Prompt: Do you need more help?",
          createdAt: DateTime.now().subtract(const Duration(minutes: 4)),
        ),
        ChatMessage.text(
          id: '6',
          senderId: 'user',
          senderName: 'Me',
          senderType: ChatMessageSenderType.user,
          senderAvatarUrl: 'https://randomuser.me/api/portraits/women/68.jpg',
          isMe: true,
          text: "Yes, I need more help.",
          createdAt: DateTime.now().subtract(const Duration(minutes: 2)),
        ),
        ChatMessage.text(
          id: '7',
          senderId: 'support',
          senderName: 'Support',
          senderType: ChatMessageSenderType.support,
          isMe: false,
          text: "You can verify your identity with the following information:",
          createdAt: DateTime.now(),
        ),
      ];
    }
  }

  void _onSend() {
    if (_composerController.text.trim().isEmpty) return;

    final text = _composerController.text;
    setState(() {
      _messages.add(
        ChatMessage.text(
          id: DateTime.now().toString(),
          senderId: 'user',
          senderName: 'Me',
          senderType: ChatMessageSenderType.user,
          senderAvatarUrl: 'https://randomuser.me/api/portraits/women/68.jpg',
          isMe: true,
          text: text,
          createdAt: DateTime.now(),
        ),
      );
      _composerController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Map messages to UI models
    final uiModels = SupportChatUiMapper.map(_messages);

    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
        extendBodyBehindAppBar:
            true, // Allow body to scroll behind? No, layout is Column.
        // AppBar
        appBar: SupportChatAppBar(
          onBackPressed: () => Navigator.of(context).maybePop(),
          onVideoCall: () {}, // Stub
          onAudioCall: () {}, // Stub
        ),
        body: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  // 1. Decorative Background (Wave)
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white,
                            AppColors.surfaceTint, // Pale blue hint
                            Colors.white,
                          ],
                          stops: [0.0, 0.5, 1.0],
                        ),
                      ),
                      // Ideally use an image asset for specific wave pattern
                      // child: Image.asset('assets/images/chat_bg_wave.png', fit: BoxFit.cover),
                    ),
                  ),

                  // 2. Messages List
                  ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppTokens.chatHPadding,
                      vertical: AppTokens.chatVPadding,
                    ),
                    itemCount:
                        uiModels.length + 1, // +1 for "Today" separator at top
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 24.h),
                          child: Center(
                            child: Text(
                              "Today",
                              style: TextStyle(
                                fontFamily: AppTokens.fontFamily,
                                color: AppTokens.chatDaySeparatorText,
                                fontSize: 13.sp,
                              ),
                            ),
                          ),
                        );
                      }

                      final item = uiModels[index - 1]; // Offset by 1

                      if (!item.isMe) {
                        return SupportMessageBubble(
                          text: item.text,
                          metaText: item.metaText, // "Support • 4:27 PM"
                          showAvatar: item.showAvatar,
                        );
                      } else {
                        return UserMessageBubble(
                          text: item.text,
                          metaText: item.metaText, // "4:27 PM • You"
                          userAvatarUrl: item.userAvatarUrl,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),

            // Composer Bar (Fixed)
            SupportComposerBar(
              controller: _composerController,
              onSend: _onSend,
              onCameraTap: () {},
              onAttachTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
