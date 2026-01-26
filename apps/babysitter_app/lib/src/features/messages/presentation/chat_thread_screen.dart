import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auth/auth.dart';
import 'package:domain/domain.dart';

import '../../../theme/app_tokens.dart';
import '../domain/chat_thread_args.dart';
import 'providers/chat_providers.dart';
import 'widgets/chat_thread_app_bar.dart';
import 'widgets/chat_background.dart';
import 'widgets/chat_day_separator.dart';
import 'widgets/message_bubble.dart';
import 'widgets/chat_composer_bar.dart';
import 'models/chat_message_ui_model.dart';

import 'package:go_router/go_router.dart';
import '../../../routing/routes.dart';
import '../../calls/domain/audio_call_args.dart';
import '../../calls/domain/video_call_args.dart';

class ChatThreadScreen extends ConsumerStatefulWidget {
  final ChatThreadArgs args;

  const ChatThreadScreen({
    super.key,
    required this.args,
  });

  @override
  ConsumerState<ChatThreadScreen> createState() => _ChatThreadScreenState();
}

class _ChatThreadScreenState extends ConsumerState<ChatThreadScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isSending = false;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _isSending) return;

    setState(() {
      _isSending = true;
    });

    try {
      await ref
          .read(chatMessagesProvider(widget.args.otherUserId).notifier)
          .sendMessage(text);
      _messageController.clear();
      _scrollToBottom();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send message: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(chatMessagesProvider(widget.args.otherUserId));
    final currentUser = ref.watch(currentUserProvider).valueOrNull;
    final currentUserId = currentUser?.id ?? '';

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        backgroundColor: AppTokens.chatScreenBg,
        appBar: ChatThreadAppBar(
          title: widget.args.otherUserName,
          isVerified: widget.args.isVerified,
          avatarUrl: widget.args.otherUserAvatarUrl,
          onVoiceCall: () {
            context.push(
              Routes.audioCall,
              extra: AudioCallArgs(
                remoteName: widget.args.otherUserName,
                remoteAvatarUrl: widget.args.otherUserAvatarUrl,
                isInitialCalling: true,
              ),
            );
          },
          onVideoCall: () {
            context.push(
              Routes.videoCall,
              extra: VideoCallArgs(
                remoteName: widget.args.otherUserName,
                remoteVideoUrl: widget.args.otherUserAvatarUrl,
                localPreviewUrl: currentUser?.profilePhoto,
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
                  child: messagesAsync.when(
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    error: (error, stack) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Error loading messages: $error'),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => ref.invalidate(
                              chatMessagesProvider(widget.args.otherUserId),
                            ),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                    data: (messages) {
                      if (messages.isEmpty) {
                        return const Center(
                          child: Text(
                            'No messages yet.\nStart the conversation!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        );
                      }

                      final uiModels = _convertToUiModels(messages, currentUserId);

                      return ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.only(
                          top: AppTokens.listTopPadding,
                          bottom: AppTokens.composerHeight + 16,
                        ),
                        itemCount: uiModels.length,
                        itemBuilder: (context, index) {
                          final item = uiModels[index];

                          return Column(
                            children: [
                              if (item.showDaySeparator)
                                ChatDaySeparator(text: item.dayLabel),
                              MessageBubble(uiModel: item),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),

                // Sticky Composer
                ChatComposerBar(
                  controller: _messageController,
                  onSend: _sendMessage,
                ),
              ],
            ),

            // Loading overlay when sending
            if (_isSending)
              Positioned.fill(
                child: Container(
                  color: Colors.black12,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<ChatMessageUiModel> _convertToUiModels(
    List<ChatMessageEntity> messages,
    String currentUserId,
  ) {
    final uiModels = <ChatMessageUiModel>[];
    String? lastDateStr;

    for (final message in messages) {
      final dateStr = _formatDate(message.createdAt);
      final showDaySeparator = dateStr != lastDateStr;
      lastDateStr = dateStr;

      uiModels.add(ChatMessageUiModel(
        id: message.id,
        isMe: message.senderUserId == currentUserId,
        text: message.textContent ?? '',
        time: _formatTime(message.createdAt),
        showDaySeparator: showDaySeparator,
        dayLabel: _getDayLabel(message.createdAt),
        avatarUrl: message.senderUserId != currentUserId
            ? widget.args.otherUserAvatarUrl
            : null,
        isCallLog: false,
      ));
    }

    return uiModels;
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _formatTime(DateTime date) {
    final hour = date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  }

  String _getDayLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(date.year, date.month, date.day);

    if (messageDate == today) {
      return 'Today';
    } else if (messageDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }
}
