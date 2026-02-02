import 'package:intl/intl.dart';
import '../../domain/chat_message.dart';

/// UI model for a chat message list item.
class ChatMessageUiModel {
  final String id;
  final bool showDaySeparator;
  final String dayLabel;
  final String? headerMetaLeft; // "Krystina • 4:27 PM"
  final String? headerMetaRight; // "4:27 PM • You"
  final String bubbleText;
  final String? mediaUrl;
  final String? mediaType;
  final String? fileName;
  final bool isMe;
  final bool showAvatar;
  final String? avatarUrl;
  final bool isCallLog;
  final String? callTitle;
  final String? callSubtitle;
  final String? callTime;
  final bool isVideoCall;
  final bool isMissedCall;

  const ChatMessageUiModel({
    required this.id,
    this.showDaySeparator = false,
    this.dayLabel = '',
    this.headerMetaLeft,
    this.headerMetaRight,
    this.bubbleText = '',
    this.mediaUrl,
    this.mediaType,
    this.fileName,
    required this.isMe,
    this.showAvatar = false,
    this.avatarUrl,
    this.isCallLog = false,
    this.callTitle,
    this.callSubtitle,
    this.callTime,
    this.isVideoCall = false,
    this.isMissedCall = false,
  });

  static List<ChatMessageUiModel> fromDomainList(List<ChatMessage> messages) {
    final List<ChatMessageUiModel> uiList = [];
    final timeFormat = DateFormat('h:mm a');

    for (int i = 0; i < messages.length; i++) {
      final msg = messages[i];
      final isFirst = i == 0;

      // Day Separator Logic (Simplified for strict "Today" requirement of this task)
      // In real app, compare dates. Here we just show "Today" at top.
      if (isFirst) {
        // We handle day separator as a property on the first message
        // OR better: we can insert a separate item type, but for simplicity
        // of this List<UiModel>, we'll use flags.
      }

      final timeStr = timeFormat.format(msg.createdAt);

      String? metaLeft;
      String? metaRight;

      if (msg.type == ChatMessageType.text) {
        if (msg.isMe) {
          metaRight = "$timeStr • You";
        } else {
          metaLeft = "${msg.senderName} • $timeStr";
        }
      }

      String? callTitle;
      String? callSubtitle;
      bool isVideo = false;
      bool isMissed = false;

      if (msg.type == ChatMessageType.callLog) {
        isVideo = msg.callType == CallType.video;
        isMissed = msg.callStatus == CallStatus.missed;

        if (isMissed) {
          callTitle = isVideo ? "Missed Video Call" : "Missed Voice Call";
        } else {
          callTitle = isVideo ? "Video Call" : "Voice Call";
        }

        if (msg.duration != null) {
          final minutes = msg.duration!.inMinutes;
          final seconds = msg.duration!.inSeconds % 60;
          callSubtitle = "$minutes Min $seconds Sec";
        }
      }

      uiList.add(ChatMessageUiModel(
        id: msg.id,
        showDaySeparator: isFirst, // Hardcoded "Today" logic for top item
        dayLabel: "Today",
        headerMetaLeft: metaLeft,
        headerMetaRight: metaRight,
        bubbleText: msg.text ?? '',
        isMe: msg.isMe,
        showAvatar: !msg.isMe &&
            msg.type == ChatMessageType.text, // Only show for recipient texts
        avatarUrl: msg.senderAvatarUrl,
        isCallLog: msg.type == ChatMessageType.callLog,
        callTitle: callTitle,
        callSubtitle: callSubtitle,
        callTime: timeStr,
        isVideoCall: isVideo,
        isMissedCall: isMissed,
      ));
    }
    return uiList;
  }
}
