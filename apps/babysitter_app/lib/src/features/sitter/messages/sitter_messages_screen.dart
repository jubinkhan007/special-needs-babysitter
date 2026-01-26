import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../routing/routes.dart';
import '../../messages/presentation/messages_screen.dart';
import '../../messages/domain/chat_thread_args.dart';

/// Sitter messages screen
class SitterMessagesScreen extends StatelessWidget {
  const SitterMessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MessagesScreen(
      showBackButton: false,
      onThreadSelected: (conversation) {
        final args = ChatThreadArgs(
          otherUserId: conversation.id,
          otherUserName: conversation.participantName,
          otherUserAvatarUrl: conversation.participantAvatarUrl,
          isVerified: conversation.isVerified,
        );
        context.go('/sitter/messages/chat/${conversation.id}', extra: args);
      },
    );
  }
}
