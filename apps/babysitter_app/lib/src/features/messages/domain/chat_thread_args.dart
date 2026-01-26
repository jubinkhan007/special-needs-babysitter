/// Arguments for navigating to the chat thread screen
class ChatThreadArgs {
  final String otherUserId;
  final String otherUserName;
  final String? otherUserAvatarUrl;
  final bool isVerified;

  const ChatThreadArgs({
    required this.otherUserId,
    required this.otherUserName,
    this.otherUserAvatarUrl,
    this.isVerified = false,
  });
}
