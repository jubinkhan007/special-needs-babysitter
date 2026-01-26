import 'package:equatable/equatable.dart';

/// Result from initializing the chat service
class ChatInitResult extends Equatable {
  final String agoraUsername;
  final String agoraToken;

  const ChatInitResult({
    required this.agoraUsername,
    required this.agoraToken,
  });

  @override
  List<Object?> get props => [agoraUsername, agoraToken];
}
