import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../call_service.dart';
import '../chat_service.dart';
import '../agora_call_service.dart';
import '../agora_rtm_chat_service.dart';
import '../token/agora_token_provider.dart';
import '../token/env_agora_token_provider.dart';

/// Provider for AgoraTokenProvider
final agoraTokenProviderProvider = Provider<AgoraTokenProvider>((ref) {
  return EnvAgoraTokenProvider();
});

/// Provider for CallService
final callServiceProvider = Provider<CallService>((ref) {
  final tokenProvider = ref.watch(agoraTokenProviderProvider);
  return AgoraCallService(tokenProvider: tokenProvider);
});

/// Provider for ChatService
final chatServiceProvider = Provider<ChatService>((ref) {
  final tokenProvider = ref.watch(agoraTokenProviderProvider);
  return AgoraRtmChatService(tokenProvider: tokenProvider);
});
