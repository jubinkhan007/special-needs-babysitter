import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:domain/domain.dart';
import '../../../theme/app_tokens.dart';
import 'models/message_thread_ui_model.dart';
import 'widgets/messages_app_bar.dart';
import 'widgets/message_thread_tile.dart';
import 'providers/chat_providers.dart';

class MessagesScreen extends ConsumerWidget {
  final VoidCallback? onBack;
  final Function(Conversation conversation) onThreadSelected;
  final bool showBackButton;

  const MessagesScreen({
    super.key,
    this.onBack,
    required this.onThreadSelected,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversationsAsync = ref.watch(chatConversationsProvider);

    // Lock text scaling for pixel-perfect rendering
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        backgroundColor: AppTokens.messagesScreenBg,
        appBar: MessagesAppBar(
          onBack: onBack,
          showBackButton: showBackButton,
        ),
        body: RefreshIndicator(
          onRefresh: () => ref.read(chatConversationsProvider.notifier).refresh(),
          child: CustomScrollView(
            slivers: [
              conversationsAsync.when(
                data: (conversations) {
                  if (conversations.isEmpty) {
                    return const SliverFillRemaining(
                      child: Center(
                        child: Text(
                          'No messages yet',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    );
                  }
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final conversation = conversations[index];
                        final uiModel =
                            MessageThreadUiModel.fromConversation(conversation);
                        return MessageThreadTile(
                          uiModel: uiModel,
                          onTap: () => onThreadSelected(conversation),
                        );
                      },
                      childCount: conversations.length,
                    ),
                  );
                },
                loading: () => const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, stack) => SliverFillRemaining(
                  child: Center(child: Text('Error loading messages: $error')),
                ),
              ),
            ],
          ),
        ),
        // Bottom nav will be integrated via shell route or parent widget
      ),
    );
  }
}
