import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auth/auth.dart';
import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:realtime/realtime.dart';

import '../../../sitters/data/sitters_data_di.dart';
import '../../data/chat_media_upload_remote_datasource.dart';

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

// Chat initialization provider - call this when entering chat feature
final chatInitProvider = FutureProvider.autoDispose<ChatInitResult>((ref) async {
  print('DEBUG: chatInitProvider initializing...');
  final repository = ref.watch(chatRepositoryProvider);
  final result = await repository.initChat();
  print('DEBUG: Chat initialized with Agora username: ${result.agoraUsername}');
  return result;
});

// Messages provider for a specific conversation
final chatMessagesProvider = AsyncNotifierProvider.autoDispose
    .family<ChatMessagesNotifier, List<ChatMessageEntity>, String>(
  ChatMessagesNotifier.new,
);

class ChatMessagesNotifier extends AutoDisposeFamilyAsyncNotifier<List<ChatMessageEntity>, String> {
  @override
  Future<List<ChatMessageEntity>> build(String otherUserId) async {
    print('DEBUG: ChatMessagesNotifier.build($otherUserId)');

    final repository = ref.watch(chatRepositoryProvider);
    final chatService = ref.watch(chatServiceProvider);

    try {
      await repository.initChat();
    } catch (e) {
      print('DEBUG: Chat init failed: $e');
    }

    // Listen to real-time events for this conversation
    final subscription = chatService.events.listen((event) {
      if (event is MessageReceivedEvent && event.peerId == otherUserId) {
        // Refresh messages when we receive a message from this user
        ref.invalidateSelf();
      } else if (event is MessageSentEvent && event.peerId == otherUserId) {
        // Refresh messages when we receive a message from this user
        ref.invalidateSelf();
      }
    });

    final poller = Timer.periodic(const Duration(seconds: 5), (_) {
      ref.invalidateSelf();
    });

    ref.onDispose(() {
      print('DEBUG: ChatMessagesNotifier disposing listener');
      subscription.cancel();
      poller.cancel();
    });

    // Mark conversation as read when viewing
    try {
      await repository.markAsRead(otherUserId);
      ref.invalidate(chatConversationsProvider);
    } catch (e) {
      print('DEBUG: Error marking conversation as read: $e');
    }

    final messages = await repository.getMessages(otherUserId);
    print('DEBUG: Loaded ${messages.length} messages for conversation with $otherUserId');
    return messages;
  }

  Future<void> sendMessage(String text) async {
    final repository = ref.read(chatRepositoryProvider);
    final otherUserId = arg;

    try {
      print('DEBUG: Sending message to $otherUserId: $text');
      final sentMessage = await repository.sendMessage(
        recipientUserId: otherUserId,
        text: text,
      );

      // Optimistically add the message to the list
      final currentMessages = state.valueOrNull ?? [];
      state = AsyncValue.data([...currentMessages, sentMessage]);

      // Also refresh conversations list
      ref.invalidate(chatConversationsProvider);
    } catch (e) {
      print('DEBUG: Error sending message: $e');
      rethrow;
    }
  }

  Future<void> sendMediaMessage({
    required String mediaUrl,
    required String mediaType,
    String? text,
  }) async {
    final repository = ref.read(chatRepositoryProvider);
    final otherUserId = arg;

    try {
      print('DEBUG: Sending media message to $otherUserId');
      final sentMessage = await repository.sendMediaMessage(
        recipientUserId: otherUserId,
        mediaUrl: mediaUrl,
        mediaType: mediaType,
        text: text,
      );

      // Optimistically add the message to the list
      final currentMessages = state.valueOrNull ?? [];
      state = AsyncValue.data([...currentMessages, sentMessage]);

      // Also refresh conversations list
      ref.invalidate(chatConversationsProvider);
    } catch (e) {
      print('DEBUG: Error sending media message: $e');
      rethrow;
    }
  }

  Future<void> sendAttachment({
    required File file,
    String? text,
  }) async {
    final repository = ref.read(chatRepositoryProvider);
    final uploader = ref.read(chatMediaUploadDataSourceProvider);
    final otherUserId = arg;

    try {
      print('DEBUG: Uploading chat attachment for $otherUserId');
      final uploadResult = await uploader.uploadFile(file);

      final sentMessage = await repository.sendMediaMessage(
        recipientUserId: otherUserId,
        mediaUrl: uploadResult.publicUrl,
        mediaType: uploadResult.mediaType,
        text: text,
      );

      final currentMessages = state.valueOrNull ?? [];
      state = AsyncValue.data([...currentMessages, sentMessage]);

      ref.invalidate(chatConversationsProvider);
    } catch (e) {
      print('DEBUG: Error sending attachment: $e');
      rethrow;
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build(arg));
  }

}

// Controller / List Provider
final chatConversationsProvider =
    AsyncNotifierProvider.autoDispose<ChatConversationsNotifier, List<Conversation>>(
  ChatConversationsNotifier.new,
);

class ChatConversationsNotifier
    extends AutoDisposeAsyncNotifier<List<Conversation>> {
  @override
  Future<List<Conversation>> build() async {
    print('DEBUG: ChatConversationsNotifier.build() START');

    try {
      print('DEBUG: Watching getConversationsUseCaseProvider...');
      final useCase = ref.watch(getConversationsUseCaseProvider);

      print('DEBUG: Watching chatServiceProvider...');
      final chatService = ref.watch(chatServiceProvider);

      print('DEBUG: Setting up event listener...');
      // Listen to real-time events
      final subscription = chatService.events.listen(_onChatEvent);
      ref.onDispose(() {
        print('DEBUG: ChatConversationsNotifier disposing listener');
        subscription.cancel();
      });

      final poller = Timer.periodic(const Duration(seconds: 5), (_) {
        ref.invalidateSelf();
      });
      ref.onDispose(poller.cancel);

      final repository = ref.watch(chatRepositoryProvider);
      try {
        await repository.initChat();
      } catch (e) {
        print('DEBUG: Chat init failed: $e');
      }

      print('DEBUG: Reading currentUserProvider...');
      // Ensure chat service is logged in
      final userAsync = ref.read(currentUserProvider);
      print('DEBUG: currentUserProvider state: isLoading=${userAsync.isLoading}, hasValue=${userAsync.hasValue}');

      final user = userAsync.value;
      print('DEBUG: Current User ID: ${user?.id}');

      if (user == null) {
        print('DEBUG: User is null, skipping chat login');
      }

      print('DEBUG: Calling getConversationsUseCase()...');
      final result = await useCase();
      print('DEBUG: getConversationsUseCase returned ${result.length} conversations');

      return result;
    } catch (e, stack) {
      print('DEBUG: ChatConversationsNotifier CRITICAL ERROR: $e');
      print('DEBUG: Stack trace: $stack');
      rethrow;
    } finally {
      print('DEBUG: ChatConversationsNotifier.build() END');
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
