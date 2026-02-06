import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auth/auth.dart';
import 'package:domain/domain.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

import '../../../theme/app_tokens.dart';
import '../domain/chat_thread_args.dart';
import 'providers/chat_providers.dart';
import 'widgets/chat_thread_app_bar.dart';
import 'widgets/chat_background.dart';
import 'widgets/chat_day_separator.dart';
import 'widgets/message_bubble.dart';
import 'widgets/call_log_tile.dart';
import 'widgets/chat_composer_bar.dart';
import 'models/chat_message_ui_model.dart';

import '../../calls/presentation/screens/outgoing_call_screen.dart';
import '../../calls/domain/entities/call_enums.dart';
import '../../calls/domain/entities/call_history_item.dart';
import '../../calls/presentation/providers/calls_providers.dart';
import '../../../routing/app_router.dart';

/// Fetches call history and indexes by callId for quick lookup.
/// Watches chatMessagesProvider so it re-fetches when messages refresh
/// (e.g. after a call ends and the new call_invite message appears).
final _callHistoryLookupProvider = FutureProvider.autoDispose
    .family<Map<String, CallHistoryItem>, String>((ref, otherUserId) async {
  // Re-fetch whenever messages change (messages poll every 5s)
  ref.watch(chatMessagesProvider(otherUserId));

  final repo = ref.watch(callsRepositoryProvider);
  try {
    final page = await repo.getCallHistory(limit: 100, offset: 0);
    return {for (final item in page.items) item.callId: item};
  } catch (_) {
    return {};
  }
});

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
  final _imagePicker = ImagePicker();
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

  Future<void> _sendAttachment(File file) async {
    if (_isSending) return;

    setState(() {
      _isSending = true;
    });

    final caption = _messageController.text.trim();

    try {
      await ref
          .read(chatMessagesProvider(widget.args.otherUserId).notifier)
          .sendAttachment(
            file: file,
            text: caption.isNotEmpty ? caption : null,
          );
      _messageController.clear();
      _scrollToBottom();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send attachment: $e')),
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

  Future<void> _pickAttachment() async {
    if (_isSending) return;
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.any,
    );

    if (result == null || result.files.isEmpty) return;
    final path = result.files.single.path;
    if (path == null || path.isEmpty) return;

    await _sendAttachment(File(path));
  }

  Future<void> _pickFromCamera() async {
    if (_isSending) return;
    final picked = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );
    if (picked == null) return;

    await _sendAttachment(File(picked.path));
  }

  Future<void> _pickFromGallery() async {
    if (_isSending) return;
    final picked = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked == null) return;

    await _sendAttachment(File(picked.path));
  }

  Future<void> _showCameraPicker() async {
    if (_isSending) return;
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_camera_outlined),
                  title: const Text('Camera'),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    _pickFromCamera();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_outlined),
                  title: const Text('Photo Library'),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    _pickFromGallery();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync =
        ref.watch(chatMessagesProvider(widget.args.otherUserId));
    final callHistoryMap =
        ref.watch(_callHistoryLookupProvider(widget.args.otherUserId)).valueOrNull ?? {};
    final sessionUser = ref.watch(authNotifierProvider).valueOrNull?.user;
    final currentUser = ref.watch(currentUserProvider).valueOrNull;
    final currentUserId = sessionUser?.id ?? currentUser?.id ?? '';

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        backgroundColor: AppTokens.chatScreenBg,
        appBar: ChatThreadAppBar(
          title: widget.args.otherUserName,
          isVerified: widget.args.isVerified,
          avatarUrl: widget.args.otherUserAvatarUrl,
          onVoiceCall: () {
            final navigator = rootNavigatorKey.currentState;
            if (navigator == null) return;
            navigator.push(
              MaterialPageRoute(
                builder: (_) => OutgoingCallScreen(
                  recipientUserId: widget.args.otherUserId,
                  recipientName: widget.args.otherUserName,
                  recipientAvatar: widget.args.otherUserAvatarUrl,
                  callType: CallType.audio,
                ),
              ),
            );
          },
          onVideoCall: () {
            final navigator = rootNavigatorKey.currentState;
            if (navigator == null) return;
            navigator.push(
              MaterialPageRoute(
                builder: (_) => OutgoingCallScreen(
                  recipientUserId: widget.args.otherUserId,
                  recipientName: widget.args.otherUserName,
                  recipientAvatar: widget.args.otherUserAvatarUrl,
                  callType: CallType.video,
                ),
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
                      // Wait for currentUserId to be available to avoid
                      // messages briefly showing on wrong side
                      if (currentUserId.isEmpty) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

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

                      final uiModels =
                          _convertToUiModels(messages, currentUserId, callHistoryMap);

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
                              if (item.isCallLog)
                                CallLogTile(uiModel: item)
                              else
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
                  onAttach: _pickAttachment,
                  onCamera: _showCameraPicker,
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
    Map<String, CallHistoryItem> callHistoryMap,
  ) {
    final uiModels = <ChatMessageUiModel>[];
    String? lastDateStr;

    for (final message in messages) {
      final dateStr = _formatDate(message.createdAt);
      final showDaySeparator = dateStr != lastDateStr;
      lastDateStr = dateStr;

      // Determine if message is from current user:
      // 1. senderUserId matches currentUserId, OR
      // 2. recipientUserId is the other user (meaning we sent it)
      final isMe = message.senderUserId == currentUserId ||
          message.recipientUserId == widget.args.otherUserId;

      // Check if this is a call log message
      final isCallLog = _isCallLogMessage(message);

      if (isCallLog) {
        // Parse call log details, cross-referencing with call history
        final callDetails = _parseCallLogDetails(message, isMe, callHistoryMap);
        uiModels.add(ChatMessageUiModel(
          id: message.id,
          isMe: isMe,
          bubbleText: '',
          showDaySeparator: showDaySeparator,
          dayLabel: _getDayLabel(message.createdAt),
          isCallLog: true,
          callTitle: callDetails['title'],
          callSubtitle: callDetails['subtitle'],
          callTime: _formatTime(message.createdAt),
          isVideoCall: callDetails['isVideo'] ?? false,
          isMissedCall: callDetails['isMissed'] ?? false,
        ));
      } else {
        // Regular message
        final messageText = message.textContent?.trim().isNotEmpty == true
            ? message.textContent!
            : '';
        final hasMedia =
            message.mediaUrl?.isNotEmpty == true &&
            message.type != ChatMessageType.text;
        final mediaType = hasMedia ? message.type.name : null;
        final fileName = hasMedia ? _fileNameFromUrl(message.mediaUrl!) : null;

        uiModels.add(ChatMessageUiModel(
          id: message.id,
          isMe: isMe,
          bubbleText: messageText,
          mediaUrl: hasMedia ? message.mediaUrl : null,
          mediaType: mediaType,
          fileName: fileName,
          showDaySeparator: showDaySeparator,
          dayLabel: _getDayLabel(message.createdAt),
          headerMetaLeft: !isMe
              ? '${widget.args.otherUserName} • ${_formatTime(message.createdAt)}'
              : null,
          headerMetaRight:
              isMe ? '${_formatTime(message.createdAt)} • You' : null,
          showAvatar: !isMe,
          avatarUrl: !isMe ? widget.args.otherUserAvatarUrl : null,
          isCallLog: false,
        ));
      }
    }

    return uiModels;
  }

  /// Check if a message is a call log
  bool _isCallLogMessage(ChatMessageEntity message) {
    // Check explicit call log type
    if (message.type.name == 'callLog' || message.type.name == 'call_log') {
      return true;
    }

    // Check for call_invite JSON in text (substring check for robustness)
    final text = message.textContent?.trim() ?? '';
    if (text.isEmpty) return false;
    return text.startsWith('{') && text.contains('call_invite');
  }

  /// Parse call log details from message, cross-referencing with call history API.
  Map<String, dynamic> _parseCallLogDetails(
    ChatMessageEntity message,
    bool isMe,
    Map<String, CallHistoryItem> callHistoryMap,
  ) {
    final text = message.textContent?.trim() ?? '';
    bool isVideo = false;
    bool isMissed = false;
    String? duration;
    String? callId;

    // Try to parse call_invite JSON for callId and callType
    if (text.contains('call_invite')) {
      try {
        final decoded = jsonDecode(text);
        if (decoded is Map<String, dynamic>) {
          callId = decoded['callId'] as String?;
          final callType = decoded['callType'] as String?;
          isVideo = callType == 'video';
        }
      } catch (_) {
        // Fallback: check raw text for call type
        if (text.contains('"video"')) isVideo = true;
        // Try to extract callId from raw text
        final match = RegExp(r'"callId"\s*:\s*"([^"]+)"').firstMatch(text);
        callId = match?.group(1);
      }
    }

    // Cross-reference with call history for accurate duration/status
    final historyItem = callId != null ? callHistoryMap[callId] : null;
    if (historyItem != null) {
      isVideo = historyItem.callType == CallType.video;
      isMissed = historyItem.wasMissed;

      if (historyItem.duration != null && historyItem.duration! > 0) {
        final minutes = historyItem.duration! ~/ 60;
        final seconds = historyItem.duration! % 60;
        duration = '$minutes Min $seconds Sec';
      }

      // Use isInitiator from history for accurate direction
      final isOutgoing = historyItem.isInitiator;

      String title;
      if (isMissed) {
        title = isVideo ? 'Missed Video Call' : 'Missed Voice Call';
      } else if (isOutgoing) {
        title = isVideo ? 'Outgoing Video Call' : 'Outgoing Voice Call';
      } else {
        title = isVideo ? 'Incoming Video Call' : 'Incoming Voice Call';
      }

      return {
        'title': title,
        'subtitle': duration,
        'isVideo': isVideo,
        'isMissed': isMissed,
      };
    }

    // Fallback when no call history is available
    String title;
    if (isMe) {
      title = isVideo ? 'Outgoing Video Call' : 'Outgoing Voice Call';
    } else {
      title = isVideo ? 'Incoming Video Call' : 'Incoming Voice Call';
    }

    return {
      'title': title,
      'subtitle': duration,
      'isVideo': isVideo,
      'isMissed': isMissed,
    };
  }

  String _fileNameFromUrl(String url) {
    final uri = Uri.tryParse(url);
    if (uri != null && uri.pathSegments.isNotEmpty) {
      return uri.pathSegments.last.split('?').first;
    }
    final parts = url.split('/');
    return parts.isNotEmpty ? parts.last.split('?').first : 'Attachment';
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
