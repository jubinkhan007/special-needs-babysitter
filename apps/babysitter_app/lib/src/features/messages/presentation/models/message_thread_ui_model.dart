import 'package:intl/intl.dart';
import '../../domain/message_thread.dart';

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
  factory MessageThreadUiModel.fromDomain(MessageThread thread) {
    final timeFormat = DateFormat('h:mm a'); // "4:27 PM"
    final timeText = timeFormat.format(thread.lastMessageTime);

    String previewText = thread.lastMessage;
    bool showCallIcon = false;

    if (thread.lastMessageType == MessageType.callEnded) {
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
}
