import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import '../../../routing/routes.dart';
import '../../../theme/app_tokens.dart';
import '../../messages/domain/message_thread.dart';
import '../../messages/presentation/models/message_thread_ui_model.dart';
import '../../messages/presentation/widgets/messages_app_bar.dart';
import '../../messages/presentation/widgets/message_thread_tile.dart';

/// Parent messages screen - shows conversation list.
class ParentMessagesScreen extends StatelessWidget {
  const ParentMessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Lock text scaling for pixel-perfect rendering
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        backgroundColor: AppTokens.messagesScreenBg,
        appBar: MessagesAppBar(
          onBack: () => context.go(Routes.parentHome),
        ),
        body: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final uiModel = _mockThreads[index];
                  return MessageThreadTile(
                    uiModel: uiModel,
                    onTap: () {
                      // Navigate to chat thread
                      // Using full path or relative path depending on GoRouter setup
                      // Route is /parent/messages/chat/:id
                      context.go('/parent/messages/chat/${uiModel.id}');
                    },
                  );
                },
                childCount: _mockThreads.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Mock data matching Figma screenshot
final List<MessageThreadUiModel> _mockThreads = [
  MessageThreadUiModel.fromDomain(MessageThread(
    id: '1',
    title: 'Krystina',
    lastMessage: "Hey there! How's Your Day Going?",
    lastMessageType: MessageType.text,
    lastMessageTime: DateTime(2024, 1, 14, 16, 27),
    unreadCount: 2,
    avatarUrl: 'https://randomuser.me/api/portraits/women/44.jpg',
    isVerified: true,
  )),
  MessageThreadUiModel.fromDomain(MessageThread(
    id: '2',
    title: 'Chloe',
    lastMessage: 'Call Ended',
    lastMessageType: MessageType.callEnded,
    lastMessageTime: DateTime(2024, 1, 14, 16, 27),
    unreadCount: 0,
    avatarUrl: 'https://randomuser.me/api/portraits/women/65.jpg',
    isVerified: true,
  )),
  MessageThreadUiModel.fromDomain(MessageThread(
    id: '3',
    title: 'Jessica',
    lastMessage: 'Yes! I am available',
    lastMessageType: MessageType.text,
    lastMessageTime: DateTime(2024, 1, 14, 16, 27),
    unreadCount: 0,
    avatarUrl: 'https://randomuser.me/api/portraits/women/32.jpg',
    isVerified: true,
  )),
  MessageThreadUiModel.fromDomain(MessageThread(
    id: '4',
    title: 'Special Needs Sitters App Team',
    lastMessage: 'Welcome to Special Needs Sitters App!',
    lastMessageType: MessageType.system,
    lastMessageTime: DateTime(2024, 1, 14, 16, 27),
    unreadCount: 0,
    isVerified: false,
    isSystemThread: true,
  )),
  MessageThreadUiModel.fromDomain(MessageThread(
    id: '5',
    title: 'Initial Live Chat',
    lastMessage: 'Welcome to Special Needs Sitters App!',
    lastMessageType: MessageType.system,
    lastMessageTime: DateTime(2024, 1, 14, 16, 27),
    unreadCount: 0,
    isVerified: false,
    isSystemThread: true,
  )),
];
