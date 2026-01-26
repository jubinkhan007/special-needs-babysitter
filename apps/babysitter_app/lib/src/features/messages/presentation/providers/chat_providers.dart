import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auth/auth.dart';
import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:realtime/realtime.dart';

// Remote Data Source
final chatRemoteDataSourceProvider = Provider<ChatRemoteDataSource>((ref) {
  return ChatRemoteDataSourceImpl(ref.watch(authDioProvider));
});

// Repository
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepositoryImpl(ref.watch(chatRemoteDataSourceProvider));
});

// Use Case
final getConversationsUseCaseProvider = Provider<GetConversationsUseCase>((ref) {
  return GetConversationsUseCase(ref.watch(chatRepositoryProvider));
});

// Controller / List Provider
final chatConversationsProvider = AsyncNotifierProvider<ChatConversationsNotifier, List<Conversation>>(ChatConversationsNotifier.new);

class ChatConversationsNotifier extends AsyncNotifier<List<Conversation>> {
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
      
      print('DEBUG: Reading currentUserProvider...');
      // Ensure chat service is logged in
      final userAsync = ref.read(currentUserProvider);
      print('DEBUG: currentUserProvider state: isLoading=${userAsync.isLoading}, hasValue=${userAsync.hasValue}');
      
      final user = userAsync.value;
      print('DEBUG: Current User ID: ${user?.id}');
      
      if (user != null) {
         print('DEBUG: Initiating chatService.login for user ${user.id}...');
         chatService.login(userId: user.id).then((_) {
             print('DEBUG: Chat login initiated successfully');
         }).catchError((e) {
             print('DEBUG: Chat login failed: $e');
         });
      } else {
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
