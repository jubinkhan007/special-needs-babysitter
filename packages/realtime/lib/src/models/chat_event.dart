/// Events emitted by the chat service
sealed class ChatEvent {}

/// Message received from a peer
class MessageReceivedEvent extends ChatEvent {
  final String peerId;
  final String text;
  final DateTime timestamp;

  MessageReceivedEvent({
    required this.peerId,
    required this.text,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

/// Message sent successfully
class MessageSentEvent extends ChatEvent {
  final String peerId;
  final String text;

  MessageSentEvent({required this.peerId, required this.text});
}

/// Message send failed
class MessageFailedEvent extends ChatEvent {
  final String peerId;
  final String text;
  final String error;

  MessageFailedEvent({
    required this.peerId,
    required this.text,
    required this.error,
  });
}

/// Connection state changed
class ConnectionStateEvent extends ChatEvent {
  final ChatConnectionState state;

  ConnectionStateEvent({required this.state});
}

/// Login success
class LoginSuccessEvent extends ChatEvent {
  final String userId;

  LoginSuccessEvent({required this.userId});
}

/// Login failed
class LoginFailedEvent extends ChatEvent {
  final String error;
  final int? code;

  LoginFailedEvent({required this.error, this.code});
}

/// Logout completed
class LogoutEvent extends ChatEvent {}

/// Chat error
class ChatErrorEvent extends ChatEvent {
  final String message;
  final int? code;

  ChatErrorEvent({required this.message, this.code});
}

/// Connection states
enum ChatConnectionState {
  disconnected,
  connecting,
  connected,
  reconnecting,
  aborted,
}
