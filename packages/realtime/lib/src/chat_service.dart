import 'models/chat_event.dart';

/// Interface for in-app messaging service
/// Token is resolved internally via AgoraTokenProvider
abstract interface class ChatService {
  /// Initialize the chat service
  Future<void> init();

  /// Login to chat service
  /// Token is resolved internally; pass userId only
  Future<void> login({required String userId, String? token});

  /// Logout from chat service
  Future<void> logout();

  /// Send a peer-to-peer message
  Future<void> sendPeerMessage({required String peerId, required String text});

  /// Stream of chat events
  Stream<ChatEvent> get events;

  /// Wait for the RTM connection to be established
  Future<bool> waitForConnected({Duration timeout});

  /// Dispose resources
  Future<void> dispose();
}
