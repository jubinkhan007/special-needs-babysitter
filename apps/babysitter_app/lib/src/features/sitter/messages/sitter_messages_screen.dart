import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../routing/routes.dart';
import '../../messages/presentation/messages_screen.dart';

/// Sitter messages screen
class SitterMessagesScreen extends StatelessWidget {
  const SitterMessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MessagesScreen(
      showBackButton: false,
      // For sitter home, back button usually isn't shown if it's a tab, 
      // but if MessagesScreen shows it, we might want to hide it or handle it.
      // MessagesAppBar has a default pop. If this is a main tab, maybe we don't want a back button?
      // MessagesAppBar checks if onBack is provided. If null, it pops.
      // If it's a root tab, popping might exit app or do nothing.
      // We can pass an empty callback if we want to disable it, or just let it be.
      // However, MessagesAppBar shows the arrow if onBack is null or not.
      // Let's assume for tabs we don't want back button. 
      // But MessagesAppBar currently always shows it. 
      // I should update MessagesAppBar to optionally hide back button.
      onThreadSelected: (conversationId) {
        context.go('/sitter/messages/chat/$conversationId');
      },
    );
  }
}
