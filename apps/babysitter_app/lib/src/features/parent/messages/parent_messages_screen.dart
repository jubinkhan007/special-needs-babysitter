import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import '../../../routing/routes.dart';
import '../../messages/presentation/messages_screen.dart';
import '../../messages/domain/chat_thread_args.dart';

/// Parent messages screen - shows conversation list.
class ParentMessagesScreen extends StatelessWidget {
  const ParentMessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MessagesScreen(
      onBack: () => context.go(Routes.parentHome),
      onThreadSelected: (conversation) {
        final args = ChatThreadArgs(
          otherUserId: conversation.id,
          otherUserName: conversation.participantName,
          otherUserAvatarUrl: conversation.participantAvatarUrl,
          isVerified: conversation.isVerified,
        );
        context.push('/parent/messages/chat/${conversation.id}', extra: args);
      },
    );
  }
}
