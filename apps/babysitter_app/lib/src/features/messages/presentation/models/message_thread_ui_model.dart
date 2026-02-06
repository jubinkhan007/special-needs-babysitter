import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:domain/domain.dart';
import '../../domain/message_thread.dart' as local; // Keep for backward compatibility if needed, or remove if unused.

/// UI-ready model for a message thread row.
/// All formatting is done in the mapper, widgets are "dumb".
class MessageThreadUiModel {
  final String id;
  final String title;
  final String previewText;
  final String timeText;
  final bool showCallEndedIcon;
  final int unreadCount;
  final String? avatarUrl;
  final bool isVerified;
  final bool isSystemThread;

  const MessageThreadUiModel({
    required this.id,
    required this.title,
    required this.previewText,
    required this.timeText,
    this.showCallEndedIcon = false,
    this.unreadCount = 0,
    this.avatarUrl,
    this.isVerified = false,
    this.isSystemThread = false,
  });

  /// Maps domain model to UI model.
  factory MessageThreadUiModel.fromDomain(local.MessageThread thread) {
    final timeFormat = DateFormat('h:mm a'); // "4:27 PM"
    final timeText = timeFormat.format(thread.lastMessageTime);

    String previewText = _formatLocalPreviewText(thread.lastMessage, thread.lastMessageType);
    bool showCallIcon = thread.lastMessageType == local.MessageType.callEnded ||
                        thread.lastMessageType == local.MessageType.callLog ||
                        _isCallInviteJson(thread.lastMessage);

    return MessageThreadUiModel(
      id: thread.id,
      title: thread.title,
      previewText: previewText,
      timeText: timeText,
      showCallEndedIcon: showCallIcon,
      unreadCount: thread.unreadCount,
      avatarUrl: thread.avatarUrl,
      isVerified: thread.isVerified,
      isSystemThread: thread.isSystemThread,
    );
  }

  factory MessageThreadUiModel.fromConversation(Conversation conversation) {
    final timeFormat = DateFormat('h:mm a');
    final timeText = timeFormat.format(conversation.lastMessageTime);

    String previewText = _formatDomainPreviewText(conversation.lastMessage, conversation.lastMessageType);
    bool showCallIcon = conversation.lastMessageType == MessageType.callEnded ||
                        conversation.lastMessageType == MessageType.callLog ||
                        _isCallInviteJson(conversation.lastMessage);

    return MessageThreadUiModel(
      id: conversation.id,
      title: conversation.participantName,
      previewText: previewText,
      timeText: timeText,
      showCallEndedIcon: showCallIcon,
      unreadCount: conversation.unreadCount,
      avatarUrl: conversation.participantAvatarUrl,
      isVerified: conversation.isVerified,
      isSystemThread: conversation.isSystem,
    );
  }

  /// Helper to format preview text for local MessageType
  static String _formatLocalPreviewText(String lastMessage, local.MessageType messageType) {
    // Handle different message types
    switch (messageType) {
      case local.MessageType.image:
        return 'Photo';
      case local.MessageType.callEnded:
        return 'Call Ended';
      case local.MessageType.callLog:
        return _callPreviewFromJson(lastMessage);
      case local.MessageType.system:
        return lastMessage;
      case local.MessageType.text:
      default:
        break;
    }

    // Check if the message is a call_invite JSON (filter out system call invites)
    if (_isCallInviteJson(lastMessage)) {
      return _callPreviewFromJson(lastMessage);
    }

    return lastMessage;
  }

  /// Helper to format preview text for domain MessageType
  static String _formatDomainPreviewText(String lastMessage, MessageType messageType) {
    // Handle different message types
    switch (messageType) {
      case MessageType.image:
        return 'Photo';
      case MessageType.callEnded:
        return 'Call Ended';
      case MessageType.callLog:
        return _callPreviewFromJson(lastMessage);
      case MessageType.system:
        return lastMessage;
      case MessageType.text:
      default:
        break;
    }

    // Check if the message is a call_invite JSON (filter out system call invites)
    if (_isCallInviteJson(lastMessage)) {
      return _callPreviewFromJson(lastMessage);
    }

    return lastMessage;
  }

  /// Check if the message text is a call_invite JSON.
  /// Uses substring check to handle truncated JSON from server.
  static bool _isCallInviteJson(String text) {
    if (text.isEmpty) return false;
    return text.trimLeft().startsWith('{') && text.contains('call_invite');
  }

  /// Extract a human-readable preview from a call_invite message.
  static String _callPreviewFromJson(String text) {
    try {
      final decoded = jsonDecode(text);
      if (decoded is Map<String, dynamic>) {
        final callType = (decoded['callType'] as String?)?.toLowerCase();
        if (callType == 'video') return 'Video Call';
      }
    } catch (_) {
      // JSON may be truncated; check for callType in raw text
      if (text.contains('"video"')) return 'Video Call';
    }
    return 'Voice Call';
  }
}
