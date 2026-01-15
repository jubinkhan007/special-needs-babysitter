import 'package:intl/intl.dart';
import 'package:babysitter_app/src/features/messages/domain/chat_message.dart';
import 'support_chat_ui_model.dart';

class SupportChatUiMapper {
  static List<SupportChatUiModel> map(List<ChatMessage> messages) {
    // Basic mapping, assume mock data provides correct grouping for now.
    // In real app, would compare timestamps/senders to determine showAvatar.

    return messages.asMap().entries.map((entry) {
      final index = entry.key;
      final msg = entry.value;

      // Determine if we show avatar:
      // Show if it's the last message in a group from same sender?
      // Screenshot:
      // Support messages: Avatar is at TOP LEFT of the group? No, looks like it's next to the "Hello!..." block.
      // Wait, screenshot A:
      // Support msg 1: Avatar left.
      // Support msg 2: No avatar left (implied same sender).
      // So show avatar if PREVIOUS message was DIFFERENT sender.

      final isFirstInGroup =
          index == 0 || messages[index - 1].senderId != msg.senderId;

      // For User (Right side):
      // Avatar is shown next to the bubble.
      // Screenshot shows avatar next to the customized "My zip code..." message.
      // It seems strictly 1:1 in the mock.

      final dateStr = DateFormat('h:mm a').format(msg.createdAt);

      String meta;
      if (msg.senderType == ChatMessageSenderType.support) {
        meta = 'Support • $dateStr';
      } else {
        meta = '$dateStr • You';
      }

      return SupportChatUiModel(
        id: msg.id,
        text: msg.text ?? '',
        metaText: meta,
        isSupport: msg.senderType == ChatMessageSenderType.support,
        isMe: msg.isMe,
        showAvatar: isFirstInGroup, // Simple logic matching observation
        userAvatarUrl: msg.senderAvatarUrl,
      );
    }).toList();
  }
}
