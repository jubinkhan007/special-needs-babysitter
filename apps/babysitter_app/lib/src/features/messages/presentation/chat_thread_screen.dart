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

class _ConversationCallHistory {
  final Map<String, CallHistoryItem> byCallId;
  final List<CallHistoryItem> items;

  const _ConversationCallHistory({
    required this.byCallId,
    required this.items,
  });
}

class _TimelineEntry {
  final DateTime timestamp;
  final ChatMessageEntity? message;
  final CallHistoryItem? historyItem;

  const _TimelineEntry({
    required this.timestamp,
    this.message,
    this.historyItem,
  });
}

DateTime _callHistorySortTime(CallHistoryItem item) {
  return item.createdAt ??
      item.startedAt ??
      item.endedAt ??
      DateTime.fromMillisecondsSinceEpoch(0);
}

/// Fetches call history scoped to this conversation, and indexes by callId.
/// Watches chatMessagesProvider so it re-fetches when messages refresh.
final _callHistoryLookupProvider = FutureProvider.autoDispose
    .family<_ConversationCallHistory, String>((ref, otherUserId) async {
  ref.watch(chatMessagesProvider(otherUserId));

  final repo = ref.watch(callsRepositoryProvider);
  try {
    final page = await repo.getCallHistory(limit: 100, offset: 0);

    // Debug logging to identify filtering issues
    debugPrint(
        'DEBUG [CallHistory]: Fetched ${page.items.length} total call history items');
    debugPrint('DEBUG [CallHistory]: Looking for otherUserId = "$otherUserId"');

    for (final item in page.items) {
      final participantId = item.otherParticipant.userId;
      final matches = participantId == otherUserId;
      debugPrint('DEBUG [CallHistory]: Call ${item.callId} - '
          'otherParticipant.userId="$participantId", '
          'callType=${item.callType}, '
          'createdAt=${item.createdAt}, '
          'matches=$matches');
    }

    final filtered = page.items
        .where((item) => item.otherParticipant.userId == otherUserId)
        .toList()
      ..sort(
          (a, b) => _callHistorySortTime(a).compareTo(_callHistorySortTime(b)));

    debugPrint(
        'DEBUG [CallHistory]: After filtering: ${filtered.length} calls for this conversation');

    return _ConversationCallHistory(
      byCallId: {for (final item in filtered) item.callId: item},
      items: filtered,
    );
  } catch (e, stack) {
    debugPrint('DEBUG [CallHistory]: Error fetching call history: $e');
    debugPrint('DEBUG [CallHistory]: Stack: $stack');
    return const _ConversationCallHistory(
      byCallId: <String, CallHistoryItem>{},
      items: <CallHistoryItem>[],
    );
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
    // If the passed username is just "Chat" (default from notification tap),
    // fetch the actual user profile to get name and avatar.
    final needsProfileFetch = widget.args.otherUserName == 'Chat' ||
        widget.args.otherUserName.isEmpty;

    // Only watch if needed to avoid unnecessary API calls
    final userProfileAsync = needsProfileFetch
        ? ref.watch(chatUserProfileProvider(widget.args.otherUserId))
        : null;

    final fetchedProfile = userProfileAsync?.valueOrNull;

    // Debug logging
    if (needsProfileFetch) {
      debugPrint(
          'DEBUG: ChatThreadScreen - Needs profile fetch for user: ${widget.args.otherUserId}');
      debugPrint(
          'DEBUG: ChatThreadScreen - Async state: ${userProfileAsync?.toString()}');
      if (fetchedProfile != null) {
        debugPrint(
            'DEBUG: ChatThreadScreen - Fetched profile keys: ${fetchedProfile.keys.toList()}');
      }
    }

    String displayUserName = widget.args.otherUserName;
    String? displayAvatarUrl = widget.args.otherUserAvatarUrl;

    if (fetchedProfile != null) {
      // Robust name parsing – handle both camelCase and snake_case API responses
      final firstName =
          (fetchedProfile['firstName'] ?? fetchedProfile['first_name'])
                  ?.toString() ??
              '';
      final lastName =
          (fetchedProfile['lastName'] ?? fetchedProfile['last_name'])
                  ?.toString() ??
              '';
      final name = (fetchedProfile['name'] ??
                  fetchedProfile['fullName'] ??
                  fetchedProfile['full_name'])
              ?.toString() ??
          '';

      if (firstName.isNotEmpty) {
        displayUserName = '$firstName $lastName'.trim();
      } else if (name.isNotEmpty) {
        displayUserName = name;
      }

      // Robust avatar parsing – check all known key variants
      displayAvatarUrl = (fetchedProfile['avatarUrl'] ??
                  fetchedProfile['profilePhoto'] ??
                  fetchedProfile['profilePhotoUrl'] ??
                  fetchedProfile['photoUrl'] ??
                  fetchedProfile['photoURL'] ??
                  fetchedProfile['photo_url'] ??
                  fetchedProfile['imageUrl'] ??
                  fetchedProfile['profileImageUrl'])
              ?.toString() ??
          displayAvatarUrl;

      debugPrint(
          'DEBUG: ChatThreadScreen - Resolved name: "$displayUserName", avatar: "$displayAvatarUrl"');
    }

    final messagesAsync =
        ref.watch(chatMessagesProvider(widget.args.otherUserId));
    final callHistoryData = ref
            .watch(_callHistoryLookupProvider(widget.args.otherUserId))
            .valueOrNull ??
        const _ConversationCallHistory(byCallId: {}, items: []);
    final sessionUser = ref.watch(authNotifierProvider).valueOrNull?.user;
    final currentUser = ref.watch(currentUserProvider).valueOrNull;
    final currentUserId = sessionUser?.id ?? currentUser?.id ?? '';

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: const TextScaler.linear(1.0),
      ),
      child: Scaffold(
        backgroundColor: AppTokens.chatScreenBg,
        appBar: ChatThreadAppBar(
          title: displayUserName,
          isVerified: widget.args.isVerified,
          avatarUrl: displayAvatarUrl,
          onVoiceCall: () {
            final navigator = rootNavigatorKey.currentState;
            if (navigator == null) return;
            navigator.push(
              MaterialPageRoute(
                builder: (_) => OutgoingCallScreen(
                  recipientUserId: widget.args.otherUserId,
                  recipientName: displayUserName,
                  recipientAvatar: displayAvatarUrl,
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
                  recipientName: displayUserName,
                  recipientAvatar: displayAvatarUrl,
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

                      final uiModels = _convertToUiModels(
                        messages,
                        currentUserId,
                        callHistoryData,
                      );

                      if (uiModels.isEmpty) {
                        return const Center(
                          child: Text(
                            'No messages or calls yet.\nStart the conversation!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        );
                      }

                      // Scroll to bottom on initial load by using reverse ListView
                      // with reversed items list
                      final reversedModels = uiModels.reversed.toList();

                      return ListView.builder(
                        controller: _scrollController,
                        reverse: true, // Start from bottom (latest messages)
                        padding: EdgeInsets.only(
                          top: AppTokens.listTopPadding,
                          bottom: AppTokens.composerHeight + 16,
                        ),
                        itemCount: reversedModels.length,
                        itemBuilder: (context, index) {
                          final item = reversedModels[index];

                          return Column(
                            children: [
                              // Note: day separator comes AFTER message in reversed list
                              if (item.isCallLog)
                                CallLogTile(uiModel: item)
                              else
                                MessageBubble(uiModel: item),
                              if (item.showDaySeparator)
                                ChatDaySeparator(text: item.dayLabel),
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
    _ConversationCallHistory callHistoryData,
  ) {
    final callHistoryMap = callHistoryData.byCallId;
    final uiModels = <ChatMessageUiModel>[];
    String? lastDateStr;

    final timeline = <_TimelineEntry>[];
    final messageCallIds = <String>{};

    for (final message in messages) {
      timeline
          .add(_TimelineEntry(timestamp: message.createdAt, message: message));
      final callId = _extractCallIdFromMessage(message);
      if (callId != null && callId.isNotEmpty) {
        messageCallIds.add(callId);
      }
    }

    for (final item in callHistoryData.items) {
      if (messageCallIds.contains(item.callId)) continue;
      timeline.add(
        _TimelineEntry(
          timestamp: _callHistorySortTime(item),
          historyItem: item,
        ),
      );
    }

    timeline.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    for (final entry in timeline) {
      final dateStr = _formatDate(entry.timestamp);
      final showDaySeparator = dateStr != lastDateStr;
      lastDateStr = dateStr;

      final message = entry.message;
      if (message == null) {
        final historyItem = entry.historyItem!;
        final callDetails = _callDetailsFromHistory(historyItem);
        uiModels.add(
          ChatMessageUiModel(
            id: 'call-history-${historyItem.callId}',
            isMe: historyItem.isInitiator,
            bubbleText: '',
            showDaySeparator: showDaySeparator,
            dayLabel: _getDayLabel(entry.timestamp),
            isCallLog: true,
            callTitle: callDetails['title'],
            callSubtitle: callDetails['subtitle'],
            callTime: _formatTime(entry.timestamp),
            isVideoCall: callDetails['isVideo'] ?? false,
            isMissedCall: callDetails['isMissed'] ?? false,
          ),
        );
        continue;
      }

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
          dayLabel: _getDayLabel(entry.timestamp),
          isCallLog: true,
          callTitle: callDetails['title'],
          callSubtitle: callDetails['subtitle'],
          callTime: _formatTime(entry.timestamp),
          isVideoCall: callDetails['isVideo'] ?? false,
          isMissedCall: callDetails['isMissed'] ?? false,
        ));
      } else {
        // Regular message
        final messageText = message.textContent?.trim().isNotEmpty == true
            ? message.textContent!
            : '';
        final hasMedia = message.mediaUrl?.isNotEmpty == true &&
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
          dayLabel: _getDayLabel(entry.timestamp),
          headerMetaLeft: !isMe
              ? '${widget.args.otherUserName} • ${_formatTime(entry.timestamp)}'
              : null,
          headerMetaRight:
              isMe ? '${_formatTime(entry.timestamp)} • You' : null,
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
      return _callDetailsFromHistory(
        historyItem,
        fallbackTimestamp: message.createdAt,
      );
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

  String? _extractCallIdFromMessage(ChatMessageEntity message) {
    final text = message.textContent?.trim() ?? '';
    if (text.isEmpty ||
        !text.startsWith('{') ||
        !text.contains('call_invite')) {
      return null;
    }

    try {
      final decoded = jsonDecode(text);
      if (decoded is Map<String, dynamic>) {
        final callId = decoded['callId'] as String?;
        if (callId != null && callId.isNotEmpty) {
          return callId;
        }
      }
    } catch (_) {
      // Fall through to regex extraction for partially malformed JSON payloads.
    }

    final match = RegExp(r'"callId"\s*:\s*"([^"]+)"').firstMatch(text);
    return match?.group(1);
  }

  Map<String, dynamic> _callDetailsFromHistory(
    CallHistoryItem item, {
    DateTime? fallbackTimestamp,
  }) {
    final isVideo = item.callType == CallType.video;
    final isMissed = item.wasMissed;
    String? duration;

    if (item.duration != null && item.duration! > 0) {
      final minutes = item.duration! ~/ 60;
      final seconds = item.duration! % 60;
      duration = '$minutes Min $seconds Sec';
    }

    String title;
    if (isMissed) {
      title = isVideo ? 'Missed Video Call' : 'Missed Voice Call';
    } else if (item.isInitiator) {
      title = isVideo ? 'Outgoing Video Call' : 'Outgoing Voice Call';
    } else {
      title = isVideo ? 'Incoming Video Call' : 'Incoming Voice Call';
    }

    return {
      'title': title,
      'subtitle': duration,
      'isVideo': isVideo,
      'isMissed': isMissed,
      'timestamp': item.createdAt ??
          item.startedAt ??
          item.endedAt ??
          fallbackTimestamp ??
          DateTime.fromMillisecondsSinceEpoch(0),
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
