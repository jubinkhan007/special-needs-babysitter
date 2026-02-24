import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:babysitter_app/src/packages/auth/auth.dart';
import 'package:babysitter_app/src/packages/realtime/call_service.dart';
import 'package:babysitter_app/src/packages/realtime/chat_service.dart';
import 'package:babysitter_app/src/packages/realtime/agora_call_service.dart';
import 'package:babysitter_app/src/packages/realtime/agora_rtm_chat_service.dart';
import 'package:babysitter_app/src/packages/realtime/token/agora_token_provider.dart';
import 'package:babysitter_app/src/packages/realtime/token/api_agora_token_provider.dart';

/// Provider for AgoraTokenProvider - uses API-backed token fetching
final agoraTokenProviderProvider = Provider<AgoraTokenProvider>((ref) {
  final dio = ref.watch(authDioProvider);
  return ApiAgoraTokenProvider(dio);
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
