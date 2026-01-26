import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import '../../../routing/routes.dart';
import '../../messages/presentation/messages_screen.dart';

/// Parent messages screen - shows conversation list.
class ParentMessagesScreen extends StatelessWidget {
  const ParentMessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MessagesScreen(
      onBack: () => context.go(Routes.parentHome),
      onThreadSelected: (conversationId) {
        context.go('/parent/messages/chat/$conversationId');
      },
    );
  }
}
