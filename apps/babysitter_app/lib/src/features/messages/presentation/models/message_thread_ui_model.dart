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

    String previewText = thread.lastMessage;
    bool showCallIcon = false;

    if (thread.lastMessageType == local.MessageType.callEnded) {
      previewText = 'Call Ended';
      showCallIcon = true;
    }

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

    String previewText = conversation.lastMessage;
    bool showCallIcon = false;

    if (conversation.lastMessageType == MessageType.callEnded) {
      previewText = 'Call Ended';
      showCallIcon = true;
    }

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
}
