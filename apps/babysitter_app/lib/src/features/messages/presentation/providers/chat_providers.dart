import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:auth/auth.dart';
import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:realtime/realtime.dart';

import '../../../sitters/data/sitters_data_di.dart';
import '../../data/chat_media_upload_remote_datasource.dart';
import 'package:flutter/foundation.dart';

// Remote Data Source
final chatRemoteDataSourceProvider = Provider<ChatRemoteDataSource>((ref) {
  return ChatRemoteDataSourceImpl(ref.watch(authDioProvider));
});

// Repository
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepositoryImpl(ref.watch(chatRemoteDataSourceProvider));
});

final chatMediaUploadDataSourceProvider =
    Provider<ChatMediaUploadRemoteDataSource>((ref) {
  return ChatMediaUploadRemoteDataSource(ref.watch(authDioProvider));
});

// Use Case
final getConversationsUseCaseProvider = Provider<GetConversationsUseCase>((ref) {
  return GetConversationsUseCase(ref.watch(chatRepositoryProvider));
});

// User Profile Provider for Chat Header
final chatUserProfileProvider = FutureProvider.family.autoDispose<Map<String, dynamic>, String>((ref, userId) async {
  final repository = ref.watch(sittersRepositoryProvider);
  return repository.getUserProfile(userId);
});

// Chat initialization provider - persists for the session (no autoDispose)
final chatInitProvider = FutureProvider<ChatInitResult>((ref) async {
  debugPrint('DEBUG: chatInitProvider initializing...');
  final repository = ref.watch(chatRepositoryProvider);
  final result = await repository.initChat();
  debugPrint('DEBUG: Chat initialized with Agora username: ${result.agoraUsername}');
  return result;
});

// Messages provider for a specific conversation
final chatMessagesProvider = AsyncNotifierProvider
    .family<ChatMessagesNotifier, List<ChatMessageEntity>, String>(
  (otherUserId) => ChatMessagesNotifier(otherUserId),
);

class ChatMessagesNotifier extends AsyncNotifier<List<ChatMessageEntity>> {
  ChatMessagesNotifier(this._otherUserId);

  final String _otherUserId;

  @override
  Future<List<ChatMessageEntity>> build() async {
    debugPrint('DEBUG: ChatMessagesNotifier.build($_otherUserId)');

    final repository = ref.watch(chatRepositoryProvider);
    final chatService = ref.watch(chatServiceProvider);

    // Ensure chat is initialized (cached, won't re-call if already done)
    await ref.watch(chatInitProvider.future);

    // Listen to real-time events for this conversation
    final subscription = chatService.events.listen((event) {
      if (event is MessageReceivedEvent && event.peerId == _otherUserId) {
        // Refresh messages when we receive a message from this user
        ref.invalidateSelf();
      } else if (event is MessageSentEvent && event.peerId == _otherUserId) {
        // Refresh messages when we receive a message from this user
        ref.invalidateSelf();
      }
    });

    ref.onDispose(() {
      debugPrint('DEBUG: ChatMessagesNotifier disposing listener');
      subscription.cancel();
    });

    // Mark conversation as read when viewing
    try {
      await repository.markAsRead(_otherUserId);
      ref.invalidate(chatConversationsProvider);
    } catch (e) {
      debugPrint('DEBUG: Error marking conversation as read: $e');
    }

    final messages = await repository.getMessages(_otherUserId);
    debugPrint('DEBUG: Loaded ${messages.length} messages for conversation with $_otherUserId');
    return messages;
  }

  Future<void> sendMessage(String text) async {
    final repository = ref.read(chatRepositoryProvider);

    try {
      debugPrint('DEBUG: Sending message to $_otherUserId: $text');
      final sentMessage = await repository.sendMessage(
        recipientUserId: _otherUserId,
        text: text,
      );

      // Optimistically add the message to the list
      final currentMessages = state.value ?? [];
      state = AsyncValue.data([...currentMessages, sentMessage]);

      // Also refresh conversations list
      ref.invalidate(chatConversationsProvider);
    } catch (e) {
      debugPrint('DEBUG: Error sending message: $e');
      rethrow;
    }
  }

  Future<void> sendMediaMessage({
    required String mediaUrl,
    required String mediaType,
    String? text,
  }) async {
    final repository = ref.read(chatRepositoryProvider);

    try {
      debugPrint('DEBUG: Sending media message to $_otherUserId');
      final sentMessage = await repository.sendMediaMessage(
        recipientUserId: _otherUserId,
        mediaUrl: mediaUrl,
        mediaType: mediaType,
        text: text,
      );

      // Optimistically add the message to the list
      final currentMessages = state.value ?? [];
      state = AsyncValue.data([...currentMessages, sentMessage]);

      // Also refresh conversations list
      ref.invalidate(chatConversationsProvider);
    } catch (e) {
      debugPrint('DEBUG: Error sending media message: $e');
      rethrow;
    }
  }

  Future<void> sendAttachment({
    required File file,
    String? text,
  }) async {
    final repository = ref.read(chatRepositoryProvider);
    final uploader = ref.read(chatMediaUploadDataSourceProvider);

    try {
      debugPrint('DEBUG: Uploading chat attachment for $_otherUserId');
      final uploadResult = await uploader.uploadFile(file);

      final sentMessage = await repository.sendMediaMessage(
        recipientUserId: _otherUserId,
        mediaUrl: uploadResult.publicUrl,
        mediaType: uploadResult.mediaType,
        text: text,
      );

      final currentMessages = state.value ?? [];
      state = AsyncValue.data([...currentMessages, sentMessage]);

      ref.invalidate(chatConversationsProvider);
    } catch (e) {
      debugPrint('DEBUG: Error sending attachment: $e');
      rethrow;
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build());
  }

}

// Controller / List Provider - persists for session (no autoDispose)
final chatConversationsProvider =
    AsyncNotifierProvider<ChatConversationsNotifier, List<Conversation>>(
  ChatConversationsNotifier.new,
);

class ChatConversationsNotifier
    extends AsyncNotifier<List<Conversation>> {
  @override
  Future<List<Conversation>> build() async {
    debugPrint('DEBUG: ChatConversationsNotifier.build() START');

    try {
      debugPrint('DEBUG: Watching getConversationsUseCaseProvider...');
      final useCase = ref.watch(getConversationsUseCaseProvider);

      debugPrint('DEBUG: Watching chatServiceProvider...');
      final chatService = ref.watch(chatServiceProvider);

      debugPrint('DEBUG: Setting up event listener...');
      // Listen to real-time events
      final subscription = chatService.events.listen(_onChatEvent);
      ref.onDispose(() {
        debugPrint('DEBUG: ChatConversationsNotifier disposing listener');
        subscription.cancel();
      });

      // Ensure chat is initialized (cached, won't re-call if already done)
      await ref.watch(chatInitProvider.future);

      debugPrint('DEBUG: Reading currentUserProvider...');
      // Ensure chat service is logged in
      final userAsync = ref.read(currentUserProvider);
      debugPrint('DEBUG: currentUserProvider state: isLoading=${userAsync.isLoading}, hasValue=${userAsync.hasValue}');

      final user = userAsync.value;
      debugPrint('DEBUG: Current User ID: ${user?.id}');

      if (user == null) {
        debugPrint('DEBUG: User is null, skipping chat login');
      }

      debugPrint('DEBUG: Calling getConversationsUseCase()...');
      final result = await useCase();
      debugPrint('DEBUG: getConversationsUseCase returned ${result.length} conversations');

      return result;
    } catch (e, stack) {
      debugPrint('DEBUG: ChatConversationsNotifier CRITICAL ERROR: $e');
      debugPrint('DEBUG: Stack trace: $stack');
      rethrow;
    } finally {
      debugPrint('DEBUG: ChatConversationsNotifier.build() END');
    }
  }

  void _onChatEvent(ChatEvent event) {
      if (event is MessageReceivedEvent || event is MessageSentEvent) {
          // For now, simplest approach is to refresh the list to get updated order/content
          // Optimistic updates can be added later
          ref.invalidateSelf();
      }
  }

  Future<void> refresh() async {
      state = const AsyncValue.loading();
      state = await AsyncValue.guard(() => ref.read(getConversationsUseCaseProvider).call());
  }
}
