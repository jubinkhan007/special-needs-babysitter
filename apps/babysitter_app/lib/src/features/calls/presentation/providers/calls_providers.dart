// Re-export CallService from realtime package
export 'package:realtime/realtime.dart' show callServiceProvider, CallService;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auth/auth.dart';
import 'package:realtime/realtime.dart';

import '../../data/datasources/calls_remote_data_source.dart';
import '../../data/repositories/calls_repository_impl.dart';
import '../../domain/entities/call_config.dart';
import '../../domain/repositories/calls_repository.dart';
import '../../domain/usecases/get_call_config_usecase.dart';
import '../../domain/usecases/initiate_call_usecase.dart';
import '../../domain/usecases/accept_call_usecase.dart';
import '../../domain/usecases/decline_call_usecase.dart';
import '../../domain/usecases/end_call_usecase.dart';
import '../../domain/usecases/get_call_details_usecase.dart';
import '../../domain/usecases/refresh_call_token_usecase.dart';
import '../../domain/usecases/get_call_history_usecase.dart';
import '../controllers/call_controller.dart';
import '../controllers/call_state.dart';

// ==================== Data Layer ====================

/// Remote data source for calls API
final callsRemoteDataSourceProvider = Provider<CallsRemoteDataSource>((ref) {
  final dio = ref.watch(authDioProvider);
  return CallsRemoteDataSourceImpl(dio);
});

/// Repository for call operations
final callsRepositoryProvider = Provider<CallsRepository>((ref) {
  final dataSource = ref.watch(callsRemoteDataSourceProvider);
  return CallsRepositoryImpl(dataSource);
});

// ==================== Use Cases ====================

final getCallConfigUseCaseProvider = Provider<GetCallConfigUseCase>((ref) {
  return GetCallConfigUseCase(ref.watch(callsRepositoryProvider));
});

final initiateCallUseCaseProvider = Provider<InitiateCallUseCase>((ref) {
  return InitiateCallUseCase(ref.watch(callsRepositoryProvider));
});

final acceptCallUseCaseProvider = Provider<AcceptCallUseCase>((ref) {
  return AcceptCallUseCase(ref.watch(callsRepositoryProvider));
});

final declineCallUseCaseProvider = Provider<DeclineCallUseCase>((ref) {
  return DeclineCallUseCase(ref.watch(callsRepositoryProvider));
});

final endCallUseCaseProvider = Provider<EndCallUseCase>((ref) {
  return EndCallUseCase(ref.watch(callsRepositoryProvider));
});

final getCallDetailsUseCaseProvider = Provider<GetCallDetailsUseCase>((ref) {
  return GetCallDetailsUseCase(ref.watch(callsRepositoryProvider));
});

final refreshCallTokenUseCaseProvider = Provider<RefreshCallTokenUseCase>((ref) {
  return RefreshCallTokenUseCase(ref.watch(callsRepositoryProvider));
});

final getCallHistoryUseCaseProvider = Provider<GetCallHistoryUseCase>((ref) {
  return GetCallHistoryUseCase(ref.watch(callsRepositoryProvider));
});

// ==================== Call Config (Cached) ====================

/// FIX #3: Fetch and cache Agora appId from backend /calls/config
final callConfigProvider = FutureProvider<CallConfig>((ref) async {
  final useCase = ref.watch(getCallConfigUseCaseProvider);
  return useCase.call();
});

/// Get cached appId (returns null if not loaded yet)
final agoraAppIdProvider = Provider<String?>((ref) {
  final configAsync = ref.watch(callConfigProvider);
  return configAsync.valueOrNull?.appId;
});

// ==================== Main Call Controller ====================

/// Main call controller for managing call state
final callControllerProvider = NotifierProvider<CallController, CallState>(() {
  return CallController();
});

