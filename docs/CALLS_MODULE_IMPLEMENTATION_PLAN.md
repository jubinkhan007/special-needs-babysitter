# Agora Audio/Video Calling Module - Complete Implementation Plan

## Critical Fixes Applied

The following issues were identified and fixed in the implementation:

| # | Issue | Fix Applied |
|---|-------|-------------|
| 1 | `CallHistoryState` factory constructors (requires Freezed) | Removed factory constructors, use subclasses + `when()` extension |
| 2 | `InCallScreen` creates second Agora engine | Uses same engine from `AgoraCallService` via `callService.engine` |
| 3 | Hardcoded `EnvConfig.agoraAppId` | Fetches from `GET /calls/config` via `callConfigProvider` |
| 4 | `CallNotificationHandler` accepts `RemoteMessage` | Changed to accept `Map<String, dynamic>` with wrapper for `RemoteMessage` |
| 5 | UID from `callId.hashCode` (collision) | UID from `currentUserId.hashCode` (stable per user) |
| 6 | Token refresh doesn't call `renewToken` | Now calls `_callService.renewToken(refresh.rtcToken)` |
| 7 | `UserLeftEvent` auto-calls `/end` | Treats as `remoteEnded` locally, only calls `/end` for user-initiated end |
| 8 | No cancellation detection for incoming | Polls `/calls/{callId}` while `IncomingRinging` to detect caller cancel |
| 9 | No CallKit UI cleanup | Calls `CallNotificationService.endCall(callId)` in accept/decline/end |
| 10 | Busy handling just logs | Auto-declines with reason "busy" if already in call |

---

## Table of Contents
1. [Overview](#1-overview)
2. [File Structure](#2-file-structure)
3. [Data Layer Implementation](#3-data-layer-implementation)
4. [Domain Layer Implementation](#4-domain-layer-implementation)
5. [Presentation Layer Implementation](#5-presentation-layer-implementation)
6. [Agora RTC Integration](#6-agora-rtc-integration)
7. [Incoming Call Notifications](#7-incoming-call-notifications)
8. [Platform Configuration](#8-platform-configuration)
9. [Manual Test Checklist](#9-manual-test-checklist)

---

## 1. Overview

### Current State
- Basic UI screens exist (`AudioCallScreen`, `VideoCallScreen`) with local state
- `AgoraCallService` exists in `packages/realtime` but is not connected to backend
- No data layer for calls API endpoints
- No incoming call notification handling

### What This Implementation Adds
- Complete data layer with DTOs, data sources, and repository
- Domain layer with entities, abstract repository, and use cases
- Riverpod-based state management with `CallController`
- Backend API integration for all 8 endpoints
- Incoming call notifications (Android full-screen + iOS CallKit)
- Call history with pagination
- Token refresh and call status polling

---

## 2. File Structure

```
apps/babysitter_app/lib/src/features/calls/
├── data/
│   ├── datasources/
│   │   └── calls_remote_data_source.dart
│   ├── models/
│   │   ├── call_config_dto.dart
│   │   ├── call_session_dto.dart
│   │   ├── call_participant_dto.dart
│   │   ├── call_history_dto.dart
│   │   └── call_token_dto.dart
│   └── repositories/
│       └── calls_repository_impl.dart
├── domain/
│   ├── entities/
│   │   ├── call_config.dart
│   │   ├── call_session.dart
│   │   ├── call_participant.dart
│   │   ├── call_history_item.dart
│   │   └── call_enums.dart
│   ├── repositories/
│   │   └── calls_repository.dart
│   └── usecases/
│       ├── get_call_config_usecase.dart
│       ├── initiate_call_usecase.dart
│       ├── accept_call_usecase.dart
│       ├── decline_call_usecase.dart
│       ├── end_call_usecase.dart
│       ├── get_call_details_usecase.dart
│       ├── refresh_call_token_usecase.dart
│       └── get_call_history_usecase.dart
├── presentation/
│   ├── providers/
│   │   ├── calls_providers.dart
│   │   └── call_history_provider.dart
│   ├── controllers/
│   │   ├── call_controller.dart
│   │   ├── call_state.dart
│   │   └── call_history_controller.dart
│   ├── screens/
│   │   ├── outgoing_call_screen.dart
│   │   ├── incoming_call_screen.dart
│   │   ├── in_call_screen.dart
│   │   └── call_history_screen.dart
│   ├── widgets/
│   │   ├── call_action_buttons.dart
│   │   ├── call_avatar_header.dart
│   │   ├── call_status_banner.dart
│   │   ├── call_timer.dart
│   │   └── video_view_container.dart
│   └── models/
│       └── call_ui_state.dart
└── services/
    ├── call_notification_service.dart
    └── incoming_call_handler.dart

packages/notifications/lib/src/
├── call_notification_handler.dart  (NEW)
└── callkit_service.dart            (NEW)
```

---

## 3. Data Layer Implementation

### 3.1 DTOs

#### `call_config_dto.dart`
```dart
// apps/babysitter_app/lib/src/features/calls/data/models/call_config_dto.dart

class CallConfigDto {
  final String appId;

  const CallConfigDto({required this.appId});

  factory CallConfigDto.fromJson(Map<String, dynamic> json) {
    return CallConfigDto(
      appId: json['appId'] as String? ?? '',
    );
  }
}
```

#### `call_participant_dto.dart`
```dart
// apps/babysitter_app/lib/src/features/calls/data/models/call_participant_dto.dart

class CallParticipantDto {
  final String userId;
  final String name;
  final String? avatar;
  final String role;

  const CallParticipantDto({
    required this.userId,
    required this.name,
    this.avatar,
    required this.role,
  });

  factory CallParticipantDto.fromJson(Map<String, dynamic> json) {
    return CallParticipantDto(
      userId: json['userId'] as String? ?? json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      avatar: json['avatar'] as String? ?? json['avatarUrl'] as String?,
      role: json['role'] as String? ?? 'parent',
    );
  }
}
```

#### `call_session_dto.dart`
```dart
// apps/babysitter_app/lib/src/features/calls/data/models/call_session_dto.dart

import 'call_participant_dto.dart';

class CallSessionDto {
  final String callId;
  final String channelName;
  final String? rtcToken;
  final String? tokenExpiresAt;
  final String status;
  final String callType;
  final CallParticipantDto? initiator;
  final CallParticipantDto? recipient;
  final CallParticipantDto? user;
  final String? createdAt;
  final String? startedAt;
  final String? endedAt;
  final int? duration;

  const CallSessionDto({
    required this.callId,
    required this.channelName,
    this.rtcToken,
    this.tokenExpiresAt,
    required this.status,
    required this.callType,
    this.initiator,
    this.recipient,
    this.user,
    this.createdAt,
    this.startedAt,
    this.endedAt,
    this.duration,
  });

  factory CallSessionDto.fromJson(Map<String, dynamic> json) {
    return CallSessionDto(
      callId: json['callId'] as String? ?? json['id'] as String? ?? '',
      channelName: json['channelName'] as String? ?? '',
      rtcToken: json['rtcToken'] as String?,
      tokenExpiresAt: json['tokenExpiresAt'] as String?,
      status: json['status'] as String? ?? 'unknown',
      callType: json['callType'] as String? ?? 'audio',
      initiator: json['initiator'] != null
          ? CallParticipantDto.fromJson(json['initiator'] as Map<String, dynamic>)
          : null,
      recipient: json['recipient'] != null
          ? CallParticipantDto.fromJson(json['recipient'] as Map<String, dynamic>)
          : null,
      user: json['user'] != null
          ? CallParticipantDto.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      createdAt: json['createdAt'] as String?,
      startedAt: json['startedAt'] as String?,
      endedAt: json['endedAt'] as String?,
      duration: json['duration'] as int?,
    );
  }
}
```

#### `call_history_dto.dart`
```dart
// apps/babysitter_app/lib/src/features/calls/data/models/call_history_dto.dart

import 'call_participant_dto.dart';

class CallHistoryItemDto {
  final String callId;
  final String callType;
  final String status;
  final bool isInitiator;
  final CallParticipantDto otherParticipant;
  final String? createdAt;
  final String? startedAt;
  final String? endedAt;
  final int? duration;

  const CallHistoryItemDto({
    required this.callId,
    required this.callType,
    required this.status,
    required this.isInitiator,
    required this.otherParticipant,
    this.createdAt,
    this.startedAt,
    this.endedAt,
    this.duration,
  });

  factory CallHistoryItemDto.fromJson(Map<String, dynamic> json) {
    return CallHistoryItemDto(
      callId: json['callId'] as String? ?? json['id'] as String? ?? '',
      callType: json['callType'] as String? ?? 'audio',
      status: json['status'] as String? ?? 'ended',
      isInitiator: json['isInitiator'] as bool? ?? false,
      otherParticipant: CallParticipantDto.fromJson(
        json['otherParticipant'] as Map<String, dynamic>? ?? {},
      ),
      createdAt: json['createdAt'] as String?,
      startedAt: json['startedAt'] as String?,
      endedAt: json['endedAt'] as String?,
      duration: json['duration'] as int?,
    );
  }
}

class CallHistoryResponseDto {
  final List<CallHistoryItemDto> calls;
  final int total;
  final int limit;
  final int offset;

  const CallHistoryResponseDto({
    required this.calls,
    required this.total,
    required this.limit,
    required this.offset,
  });

  factory CallHistoryResponseDto.fromJson(Map<String, dynamic> json) {
    final callsList = (json['calls'] as List<dynamic>?)
            ?.map((e) => CallHistoryItemDto.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    final pagination = json['pagination'] as Map<String, dynamic>? ?? {};

    return CallHistoryResponseDto(
      calls: callsList,
      total: pagination['total'] as int? ?? callsList.length,
      limit: pagination['limit'] as int? ?? 20,
      offset: pagination['offset'] as int? ?? 0,
    );
  }
}
```

#### `call_token_dto.dart`
```dart
// apps/babysitter_app/lib/src/features/calls/data/models/call_token_dto.dart

class CallTokenDto {
  final String rtcToken;
  final String channelName;
  final String expiresAt;

  const CallTokenDto({
    required this.rtcToken,
    required this.channelName,
    required this.expiresAt,
  });

  factory CallTokenDto.fromJson(Map<String, dynamic> json) {
    return CallTokenDto(
      rtcToken: json['rtcToken'] as String? ?? '',
      channelName: json['channelName'] as String? ?? '',
      expiresAt: json['expiresAt'] as String? ?? '',
    );
  }
}
```

### 3.2 Remote Data Source

```dart
// apps/babysitter_app/lib/src/features/calls/data/datasources/calls_remote_data_source.dart

import 'dart:developer' as developer;
import 'package:dio/dio.dart';

import '../models/call_config_dto.dart';
import '../models/call_session_dto.dart';
import '../models/call_history_dto.dart';
import '../models/call_token_dto.dart';

abstract interface class CallsRemoteDataSource {
  /// GET /calls/config - Get Agora App ID
  Future<CallConfigDto> getCallConfig();

  /// POST /calls/initiate - Parent initiates call to sitter
  Future<CallSessionDto> initiateCall({
    required String recipientUserId,
    required String callType,
  });

  /// POST /calls/{callId}/accept - Sitter accepts incoming call
  Future<CallSessionDto> acceptCall(String callId);

  /// POST /calls/{callId}/decline - Sitter declines incoming call
  Future<void> declineCall(String callId, {String? reason});

  /// POST /calls/{callId}/end - Either participant ends call
  Future<void> endCall(String callId);

  /// GET /calls/{callId} - Get call details
  Future<CallSessionDto> getCallDetails(String callId);

  /// POST /calls/{callId}/token - Refresh RTC token
  Future<CallTokenDto> refreshToken(String callId);

  /// GET /calls/history - Get call history with pagination
  Future<CallHistoryResponseDto> getCallHistory({
    int limit = 20,
    int offset = 0,
  });
}

class CallsRemoteDataSourceImpl implements CallsRemoteDataSource {
  final Dio _dio;

  CallsRemoteDataSourceImpl(this._dio);

  @override
  Future<CallConfigDto> getCallConfig() async {
    try {
      developer.log('CallsRemoteDataSource.getCallConfig()', name: 'Calls');
      final response = await _dio.get('/calls/config');

      final data = _extractData(response.data);
      return CallConfigDto.fromJson(data);
    } catch (e, stack) {
      _logError('getCallConfig', e, stack);
      rethrow;
    }
  }

  @override
  Future<CallSessionDto> initiateCall({
    required String recipientUserId,
    required String callType,
  }) async {
    try {
      developer.log(
        'CallsRemoteDataSource.initiateCall($recipientUserId, $callType)',
        name: 'Calls',
      );
      final response = await _dio.post(
        '/calls/initiate',
        data: {
          'recipientUserId': recipientUserId,
          'callType': callType,
        },
      );

      final data = _extractData(response.data);
      return CallSessionDto.fromJson(data);
    } catch (e, stack) {
      _logError('initiateCall', e, stack);
      rethrow;
    }
  }

  @override
  Future<CallSessionDto> acceptCall(String callId) async {
    try {
      developer.log('CallsRemoteDataSource.acceptCall($callId)', name: 'Calls');
      final response = await _dio.post(
        '/calls/$callId/accept',
        data: {'callId': callId}, // Some backends expect body too
      );

      final data = _extractData(response.data);
      return CallSessionDto.fromJson(data);
    } catch (e, stack) {
      _logError('acceptCall', e, stack);
      rethrow;
    }
  }

  @override
  Future<void> declineCall(String callId, {String? reason}) async {
    try {
      developer.log('CallsRemoteDataSource.declineCall($callId)', name: 'Calls');
      await _dio.post(
        '/calls/$callId/decline',
        data: {
          'callId': callId,
          if (reason != null) 'reason': reason,
        },
      );
    } catch (e, stack) {
      _logError('declineCall', e, stack);
      rethrow;
    }
  }

  @override
  Future<void> endCall(String callId) async {
    try {
      developer.log('CallsRemoteDataSource.endCall($callId)', name: 'Calls');
      await _dio.post(
        '/calls/$callId/end',
        data: {'callId': callId},
      );
    } catch (e, stack) {
      _logError('endCall', e, stack);
      rethrow;
    }
  }

  @override
  Future<CallSessionDto> getCallDetails(String callId) async {
    try {
      developer.log('CallsRemoteDataSource.getCallDetails($callId)', name: 'Calls');
      final response = await _dio.get('/calls/$callId');

      final data = _extractData(response.data);
      return CallSessionDto.fromJson(data);
    } catch (e, stack) {
      _logError('getCallDetails', e, stack);
      rethrow;
    }
  }

  @override
  Future<CallTokenDto> refreshToken(String callId) async {
    try {
      developer.log('CallsRemoteDataSource.refreshToken($callId)', name: 'Calls');
      final response = await _dio.post('/calls/$callId/token');

      final data = _extractData(response.data);
      return CallTokenDto.fromJson(data);
    } catch (e, stack) {
      _logError('refreshToken', e, stack);
      rethrow;
    }
  }

  @override
  Future<CallHistoryResponseDto> getCallHistory({
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      developer.log(
        'CallsRemoteDataSource.getCallHistory(limit: $limit, offset: $offset)',
        name: 'Calls',
      );
      final response = await _dio.get(
        '/calls/history',
        queryParameters: {
          'limit': limit,
          'offset': offset,
        },
      );

      final data = _extractData(response.data);
      return CallHistoryResponseDto.fromJson(data);
    } catch (e, stack) {
      _logError('getCallHistory', e, stack);
      rethrow;
    }
  }

  Map<String, dynamic> _extractData(dynamic responseData) {
    if (responseData == null) {
      return {};
    }
    if (responseData is Map<String, dynamic>) {
      // Handle nested data field
      if (responseData.containsKey('data')) {
        final data = responseData['data'];
        return data is Map<String, dynamic> ? data : responseData;
      }
      return responseData;
    }
    return {};
  }

  void _logError(String method, Object e, StackTrace stack) {
    developer.log('Error in $method: $e', name: 'Calls');
    developer.log('Stack trace: $stack', name: 'Calls');
    if (e is DioException) {
      developer.log('Dio Response: ${e.response?.data}', name: 'Calls');
    }
  }
}
```

### 3.3 Repository Implementation

```dart
// apps/babysitter_app/lib/src/features/calls/data/repositories/calls_repository_impl.dart

import '../../domain/entities/call_config.dart';
import '../../domain/entities/call_session.dart';
import '../../domain/entities/call_history_item.dart';
import '../../domain/entities/call_enums.dart';
import '../../domain/entities/call_participant.dart';
import '../../domain/repositories/calls_repository.dart';
import '../datasources/calls_remote_data_source.dart';
import '../models/call_session_dto.dart';
import '../models/call_participant_dto.dart';
import '../models/call_history_dto.dart';

class CallsRepositoryImpl implements CallsRepository {
  final CallsRemoteDataSource _remoteDataSource;

  CallsRepositoryImpl(this._remoteDataSource);

  @override
  Future<CallConfig> getCallConfig() async {
    final dto = await _remoteDataSource.getCallConfig();
    return CallConfig(appId: dto.appId);
  }

  @override
  Future<CallSession> initiateCall({
    required String recipientUserId,
    required CallType callType,
  }) async {
    final dto = await _remoteDataSource.initiateCall(
      recipientUserId: recipientUserId,
      callType: callType.name,
    );
    return _mapSessionFromDto(dto);
  }

  @override
  Future<CallSession> acceptCall(String callId) async {
    final dto = await _remoteDataSource.acceptCall(callId);
    return _mapSessionFromDto(dto);
  }

  @override
  Future<void> declineCall(String callId, {String? reason}) async {
    await _remoteDataSource.declineCall(callId, reason: reason);
  }

  @override
  Future<void> endCall(String callId) async {
    await _remoteDataSource.endCall(callId);
  }

  @override
  Future<CallSession> getCallDetails(String callId) async {
    final dto = await _remoteDataSource.getCallDetails(callId);
    return _mapSessionFromDto(dto);
  }

  @override
  Future<CallTokenRefresh> refreshToken(String callId) async {
    final dto = await _remoteDataSource.refreshToken(callId);
    return CallTokenRefresh(
      rtcToken: dto.rtcToken,
      channelName: dto.channelName,
      expiresAt: DateTime.tryParse(dto.expiresAt) ?? DateTime.now(),
    );
  }

  @override
  Future<CallHistoryPage> getCallHistory({
    int limit = 20,
    int offset = 0,
  }) async {
    final dto = await _remoteDataSource.getCallHistory(
      limit: limit,
      offset: offset,
    );
    return CallHistoryPage(
      items: dto.calls.map(_mapHistoryItemFromDto).toList(),
      total: dto.total,
      limit: dto.limit,
      offset: dto.offset,
    );
  }

  CallSession _mapSessionFromDto(CallSessionDto dto) {
    return CallSession(
      callId: dto.callId,
      channelName: dto.channelName,
      rtcToken: dto.rtcToken,
      tokenExpiresAt: dto.tokenExpiresAt != null
          ? DateTime.tryParse(dto.tokenExpiresAt!)
          : null,
      status: CallStatus.fromString(dto.status),
      callType: CallType.fromString(dto.callType),
      initiator: dto.initiator != null
          ? _mapParticipantFromDto(dto.initiator!)
          : null,
      recipient: dto.recipient != null
          ? _mapParticipantFromDto(dto.recipient!)
          : null,
      createdAt: dto.createdAt != null
          ? DateTime.tryParse(dto.createdAt!)
          : null,
      startedAt: dto.startedAt != null
          ? DateTime.tryParse(dto.startedAt!)
          : null,
      endedAt: dto.endedAt != null
          ? DateTime.tryParse(dto.endedAt!)
          : null,
      duration: dto.duration,
    );
  }

  CallParticipant _mapParticipantFromDto(CallParticipantDto dto) {
    return CallParticipant(
      userId: dto.userId,
      name: dto.name,
      avatar: dto.avatar,
      role: dto.role == 'sitter' ? UserRole.sitter : UserRole.parent,
    );
  }

  CallHistoryItem _mapHistoryItemFromDto(CallHistoryItemDto dto) {
    return CallHistoryItem(
      callId: dto.callId,
      callType: CallType.fromString(dto.callType),
      status: CallStatus.fromString(dto.status),
      isInitiator: dto.isInitiator,
      otherParticipant: _mapParticipantFromDto(dto.otherParticipant),
      createdAt: dto.createdAt != null
          ? DateTime.tryParse(dto.createdAt!)
          : null,
      startedAt: dto.startedAt != null
          ? DateTime.tryParse(dto.startedAt!)
          : null,
      endedAt: dto.endedAt != null
          ? DateTime.tryParse(dto.endedAt!)
          : null,
      duration: dto.duration,
    );
  }
}
```

---

## 4. Domain Layer Implementation

### 4.1 Entities

#### `call_enums.dart`
```dart
// apps/babysitter_app/lib/src/features/calls/domain/entities/call_enums.dart

enum CallType {
  audio,
  video;

  static CallType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'video':
        return CallType.video;
      case 'audio':
      default:
        return CallType.audio;
    }
  }
}

enum CallStatus {
  ringing,
  accepted,
  declined,
  ended,
  missed,
  unknown;

  static CallStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'ringing':
        return CallStatus.ringing;
      case 'accepted':
        return CallStatus.accepted;
      case 'declined':
        return CallStatus.declined;
      case 'ended':
        return CallStatus.ended;
      case 'missed':
        return CallStatus.missed;
      default:
        return CallStatus.unknown;
    }
  }

  bool get isActive => this == CallStatus.ringing || this == CallStatus.accepted;
}

enum UserRole {
  parent,
  sitter,
}
```

#### `call_participant.dart`
```dart
// apps/babysitter_app/lib/src/features/calls/domain/entities/call_participant.dart

import 'call_enums.dart';

class CallParticipant {
  final String userId;
  final String name;
  final String? avatar;
  final UserRole role;

  const CallParticipant({
    required this.userId,
    required this.name,
    this.avatar,
    required this.role,
  });
}
```

#### `call_session.dart`
```dart
// apps/babysitter_app/lib/src/features/calls/domain/entities/call_session.dart

import 'call_enums.dart';
import 'call_participant.dart';

class CallSession {
  final String callId;
  final String channelName;
  final String? rtcToken;
  final DateTime? tokenExpiresAt;
  final CallStatus status;
  final CallType callType;
  final CallParticipant? initiator;
  final CallParticipant? recipient;
  final DateTime? createdAt;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final int? duration;

  const CallSession({
    required this.callId,
    required this.channelName,
    this.rtcToken,
    this.tokenExpiresAt,
    required this.status,
    required this.callType,
    this.initiator,
    this.recipient,
    this.createdAt,
    this.startedAt,
    this.endedAt,
    this.duration,
  });

  bool isInitiator(String currentUserId) => initiator?.userId == currentUserId;

  CallParticipant? getRemoteParticipant(String currentUserId) {
    if (initiator?.userId == currentUserId) return recipient;
    return initiator;
  }

  CallSession copyWith({
    String? callId,
    String? channelName,
    String? rtcToken,
    DateTime? tokenExpiresAt,
    CallStatus? status,
    CallType? callType,
    CallParticipant? initiator,
    CallParticipant? recipient,
    DateTime? createdAt,
    DateTime? startedAt,
    DateTime? endedAt,
    int? duration,
  }) {
    return CallSession(
      callId: callId ?? this.callId,
      channelName: channelName ?? this.channelName,
      rtcToken: rtcToken ?? this.rtcToken,
      tokenExpiresAt: tokenExpiresAt ?? this.tokenExpiresAt,
      status: status ?? this.status,
      callType: callType ?? this.callType,
      initiator: initiator ?? this.initiator,
      recipient: recipient ?? this.recipient,
      createdAt: createdAt ?? this.createdAt,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      duration: duration ?? this.duration,
    );
  }
}

class CallTokenRefresh {
  final String rtcToken;
  final String channelName;
  final DateTime expiresAt;

  const CallTokenRefresh({
    required this.rtcToken,
    required this.channelName,
    required this.expiresAt,
  });
}
```

#### `call_config.dart`
```dart
// apps/babysitter_app/lib/src/features/calls/domain/entities/call_config.dart

class CallConfig {
  final String appId;

  const CallConfig({required this.appId});
}
```

#### `call_history_item.dart`
```dart
// apps/babysitter_app/lib/src/features/calls/domain/entities/call_history_item.dart

import 'call_enums.dart';
import 'call_participant.dart';

class CallHistoryItem {
  final String callId;
  final CallType callType;
  final CallStatus status;
  final bool isInitiator;
  final CallParticipant otherParticipant;
  final DateTime? createdAt;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final int? duration;

  const CallHistoryItem({
    required this.callId,
    required this.callType,
    required this.status,
    required this.isInitiator,
    required this.otherParticipant,
    this.createdAt,
    this.startedAt,
    this.endedAt,
    this.duration,
  });

  String get durationFormatted {
    if (duration == null || duration! <= 0) return '--:--';
    final minutes = duration! ~/ 60;
    final seconds = duration! % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  bool get wasMissed => status == CallStatus.missed ||
      (status == CallStatus.ended && startedAt == null);
}

class CallHistoryPage {
  final List<CallHistoryItem> items;
  final int total;
  final int limit;
  final int offset;

  const CallHistoryPage({
    required this.items,
    required this.total,
    required this.limit,
    required this.offset,
  });

  bool get hasMore => offset + items.length < total;
}
```

### 4.2 Repository Interface

```dart
// apps/babysitter_app/lib/src/features/calls/domain/repositories/calls_repository.dart

import '../entities/call_config.dart';
import '../entities/call_session.dart';
import '../entities/call_history_item.dart';
import '../entities/call_enums.dart';

abstract interface class CallsRepository {
  Future<CallConfig> getCallConfig();

  Future<CallSession> initiateCall({
    required String recipientUserId,
    required CallType callType,
  });

  Future<CallSession> acceptCall(String callId);

  Future<void> declineCall(String callId, {String? reason});

  Future<void> endCall(String callId);

  Future<CallSession> getCallDetails(String callId);

  Future<CallTokenRefresh> refreshToken(String callId);

  Future<CallHistoryPage> getCallHistory({
    int limit = 20,
    int offset = 0,
  });
}
```

### 4.3 Use Cases

```dart
// apps/babysitter_app/lib/src/features/calls/domain/usecases/initiate_call_usecase.dart

import '../entities/call_session.dart';
import '../entities/call_enums.dart';
import '../repositories/calls_repository.dart';

class InitiateCallParams {
  final String recipientUserId;
  final CallType callType;

  const InitiateCallParams({
    required this.recipientUserId,
    required this.callType,
  });
}

class InitiateCallUseCase {
  final CallsRepository _repository;

  InitiateCallUseCase(this._repository);

  Future<CallSession> call(InitiateCallParams params) {
    return _repository.initiateCall(
      recipientUserId: params.recipientUserId,
      callType: params.callType,
    );
  }
}
```

```dart
// apps/babysitter_app/lib/src/features/calls/domain/usecases/accept_call_usecase.dart

import '../entities/call_session.dart';
import '../repositories/calls_repository.dart';

class AcceptCallUseCase {
  final CallsRepository _repository;

  AcceptCallUseCase(this._repository);

  Future<CallSession> call(String callId) {
    return _repository.acceptCall(callId);
  }
}
```

```dart
// apps/babysitter_app/lib/src/features/calls/domain/usecases/decline_call_usecase.dart

import '../repositories/calls_repository.dart';

class DeclineCallParams {
  final String callId;
  final String? reason;

  const DeclineCallParams({
    required this.callId,
    this.reason,
  });
}

class DeclineCallUseCase {
  final CallsRepository _repository;

  DeclineCallUseCase(this._repository);

  Future<void> call(DeclineCallParams params) {
    return _repository.declineCall(params.callId, reason: params.reason);
  }
}
```

```dart
// apps/babysitter_app/lib/src/features/calls/domain/usecases/end_call_usecase.dart

import '../repositories/calls_repository.dart';

class EndCallUseCase {
  final CallsRepository _repository;

  EndCallUseCase(this._repository);

  Future<void> call(String callId) {
    return _repository.endCall(callId);
  }
}
```

```dart
// apps/babysitter_app/lib/src/features/calls/domain/usecases/get_call_history_usecase.dart

import '../entities/call_history_item.dart';
import '../repositories/calls_repository.dart';

class GetCallHistoryParams {
  final int limit;
  final int offset;

  const GetCallHistoryParams({
    this.limit = 20,
    this.offset = 0,
  });
}

class GetCallHistoryUseCase {
  final CallsRepository _repository;

  GetCallHistoryUseCase(this._repository);

  Future<CallHistoryPage> call(GetCallHistoryParams params) {
    return _repository.getCallHistory(
      limit: params.limit,
      offset: params.offset,
    );
  }
}
```

---

## 5. Presentation Layer Implementation

### 5.1 Call State

```dart
// apps/babysitter_app/lib/src/features/calls/presentation/controllers/call_state.dart

import 'package:flutter/foundation.dart';
import '../../domain/entities/call_session.dart';
import '../../domain/entities/call_participant.dart';
import '../../domain/entities/call_enums.dart';

@immutable
sealed class CallState {
  const CallState();
}

class CallIdle extends CallState {
  const CallIdle();
}

class CallLoading extends CallState {
  final String message;
  const CallLoading([this.message = 'Loading...']);
}

class OutgoingRinging extends CallState {
  final CallSession session;
  const OutgoingRinging(this.session);
}

class IncomingRinging extends CallState {
  final String callId;
  final CallType callType;
  final CallParticipant caller;
  final CallSession? fullSession; // Lazy loaded

  const IncomingRinging({
    required this.callId,
    required this.callType,
    required this.caller,
    this.fullSession,
  });

  IncomingRinging withSession(CallSession session) {
    return IncomingRinging(
      callId: callId,
      callType: callType,
      caller: caller,
      fullSession: session,
    );
  }
}

class InCall extends CallState {
  final CallSession session;
  final bool isAudioMuted;
  final bool isVideoEnabled;
  final bool isSpeakerOn;
  final bool isFrontCamera;
  final int? remoteUid;
  final bool remoteJoined;
  final int elapsedSeconds;

  const InCall({
    required this.session,
    this.isAudioMuted = false,
    this.isVideoEnabled = true,
    this.isSpeakerOn = false,
    this.isFrontCamera = true,
    this.remoteUid,
    this.remoteJoined = false,
    this.elapsedSeconds = 0,
  });

  InCall copyWith({
    CallSession? session,
    bool? isAudioMuted,
    bool? isVideoEnabled,
    bool? isSpeakerOn,
    bool? isFrontCamera,
    int? remoteUid,
    bool? remoteJoined,
    int? elapsedSeconds,
  }) {
    return InCall(
      session: session ?? this.session,
      isAudioMuted: isAudioMuted ?? this.isAudioMuted,
      isVideoEnabled: isVideoEnabled ?? this.isVideoEnabled,
      isSpeakerOn: isSpeakerOn ?? this.isSpeakerOn,
      isFrontCamera: isFrontCamera ?? this.isFrontCamera,
      remoteUid: remoteUid ?? this.remoteUid,
      remoteJoined: remoteJoined ?? this.remoteJoined,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
    );
  }
}

class CallEnded extends CallState {
  final String callId;
  final CallEndReason reason;
  final int? duration;

  const CallEnded({
    required this.callId,
    required this.reason,
    this.duration,
  });
}

class CallError extends CallState {
  final String message;
  final String? code;

  const CallError({
    required this.message,
    this.code,
  });
}

enum CallEndReason {
  userEnded,
  remoteEnded,
  declined,
  missed,
  error,
}
```

### 5.2 Call Controller

```dart
// apps/babysitter_app/lib/src/features/calls/presentation/controllers/call_controller.dart

import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:realtime/realtime.dart';

import '../../domain/entities/call_session.dart';
import '../../domain/entities/call_enums.dart';
import '../../domain/entities/call_participant.dart';
import '../../domain/repositories/calls_repository.dart';
import 'call_state.dart';

class CallController extends Notifier<CallState> {
  Timer? _pollingTimer;
  Timer? _callTimer;
  Timer? _tokenRefreshTimer;
  StreamSubscription<CallEvent>? _callEventSubscription;

  @override
  CallState build() => const CallIdle();

  CallsRepository get _repository => ref.read(callsRepositoryProvider);
  CallService get _callService => ref.read(callServiceProvider);

  /// Parent initiates a call to a sitter
  Future<void> initiateCall({
    required String recipientUserId,
    required String recipientName,
    String? recipientAvatar,
    required CallType callType,
  }) async {
    state = const CallLoading('Initiating call...');

    try {
      final session = await _repository.initiateCall(
        recipientUserId: recipientUserId,
        callType: callType,
      );

      state = OutgoingRinging(session);

      // Start polling for status updates
      _startStatusPolling(session.callId);
    } catch (e) {
      developer.log('Failed to initiate call: $e', name: 'Calls');
      state = CallError(message: _extractErrorMessage(e));
    }
  }

  /// Handle incoming call from push notification
  Future<void> handleIncomingCall({
    required String callId,
    required CallType callType,
    required String callerName,
    required String callerUserId,
    String? callerAvatar,
  }) async {
    final caller = CallParticipant(
      userId: callerUserId,
      name: callerName,
      avatar: callerAvatar,
      role: UserRole.parent,
    );

    state = IncomingRinging(
      callId: callId,
      callType: callType,
      caller: caller,
    );

    // Fetch full call details in background
    try {
      final session = await _repository.getCallDetails(callId);
      if (state is IncomingRinging) {
        state = (state as IncomingRinging).withSession(session);
      }
    } catch (e) {
      developer.log('Failed to fetch call details: $e', name: 'Calls');
    }
  }

  /// Sitter accepts incoming call
  Future<void> acceptCall() async {
    final currentState = state;
    if (currentState is! IncomingRinging) return;

    state = const CallLoading('Connecting...');

    try {
      final session = await _repository.acceptCall(currentState.callId);

      // Initialize and join Agora channel
      await _joinAgoraChannel(session);

      state = InCall(
        session: session,
        isVideoEnabled: session.callType == CallType.video,
      );

      _startCallTimer();
      _scheduleTokenRefresh(session);
    } catch (e) {
      developer.log('Failed to accept call: $e', name: 'Calls');
      state = CallError(message: _extractErrorMessage(e));
    }
  }

  /// Sitter declines incoming call
  Future<void> declineCall({String? reason}) async {
    final currentState = state;
    if (currentState is! IncomingRinging) return;

    try {
      await _repository.declineCall(currentState.callId, reason: reason);
      state = CallEnded(
        callId: currentState.callId,
        reason: CallEndReason.declined,
      );
    } catch (e) {
      developer.log('Failed to decline call: $e', name: 'Calls');
      state = CallError(message: _extractErrorMessage(e));
    }
  }

  /// Either participant ends the call
  Future<void> endCall() async {
    final callId = _getCurrentCallId();
    if (callId == null) return;

    try {
      await _repository.endCall(callId);
      await _leaveAgoraChannel();

      final duration = state is InCall ? (state as InCall).elapsedSeconds : null;

      state = CallEnded(
        callId: callId,
        reason: CallEndReason.userEnded,
        duration: duration,
      );
    } catch (e) {
      developer.log('Failed to end call: $e', name: 'Calls');
      // Still cleanup locally
      await _leaveAgoraChannel();
      state = CallEnded(
        callId: callId,
        reason: CallEndReason.error,
      );
    } finally {
      _cleanup();
    }
  }

  /// Cancel outgoing call (before answer)
  Future<void> cancelCall() async {
    final currentState = state;
    if (currentState is! OutgoingRinging) return;

    try {
      await _repository.endCall(currentState.session.callId);
      state = CallEnded(
        callId: currentState.session.callId,
        reason: CallEndReason.userEnded,
      );
    } catch (e) {
      developer.log('Failed to cancel call: $e', name: 'Calls');
    } finally {
      _cleanup();
    }
  }

  // === Call Controls ===

  void toggleMute() {
    if (state is! InCall) return;
    final current = state as InCall;
    final newMuted = !current.isAudioMuted;
    _callService.muteLocalAudio(newMuted);
    state = current.copyWith(isAudioMuted: newMuted);
  }

  void toggleVideo() {
    if (state is! InCall) return;
    final current = state as InCall;
    final newEnabled = !current.isVideoEnabled;
    _callService.enableLocalVideo(newEnabled);
    state = current.copyWith(isVideoEnabled: newEnabled);
  }

  void toggleSpeaker() {
    if (state is! InCall) return;
    final current = state as InCall;
    final newEnabled = !current.isSpeakerOn;
    _callService.enableSpeakerphone(newEnabled);
    state = current.copyWith(isSpeakerOn: newEnabled);
  }

  void switchCamera() {
    if (state is! InCall) return;
    final current = state as InCall;
    _callService.switchCamera();
    state = current.copyWith(isFrontCamera: !current.isFrontCamera);
  }

  /// Reset to idle state
  void reset() {
    _cleanup();
    state = const CallIdle();
  }

  // === Private Methods ===

  void _startStatusPolling(String callId) {
    _pollingTimer?.cancel();
    int attempts = 0;
    const maxAttempts = 40; // ~40 seconds at 1s intervals

    _pollingTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      attempts++;

      try {
        final session = await _repository.getCallDetails(callId);

        if (session.status == CallStatus.accepted) {
          timer.cancel();
          await _joinAgoraChannel(session);
          state = InCall(
            session: session,
            isVideoEnabled: session.callType == CallType.video,
          );
          _startCallTimer();
          _scheduleTokenRefresh(session);
        } else if (session.status == CallStatus.declined) {
          timer.cancel();
          state = CallEnded(callId: callId, reason: CallEndReason.declined);
          _cleanup();
        } else if (session.status == CallStatus.ended) {
          timer.cancel();
          state = CallEnded(callId: callId, reason: CallEndReason.remoteEnded);
          _cleanup();
        } else if (attempts >= maxAttempts) {
          timer.cancel();
          // Timeout - try to end the call
          try {
            await _repository.endCall(callId);
          } catch (_) {}
          state = CallEnded(callId: callId, reason: CallEndReason.missed);
          _cleanup();
        }
      } catch (e) {
        developer.log('Polling error: $e', name: 'Calls');
        if (attempts >= maxAttempts) {
          timer.cancel();
          state = CallError(message: 'Connection lost');
          _cleanup();
        }
      }
    });
  }

  Future<void> _joinAgoraChannel(CallSession session) async {
    await _callService.initialize();

    // Generate stable UID from user ID
    final uid = _generateUid(session.callId);

    // Subscribe to call events
    _callEventSubscription = _callService.events.listen(_handleCallEvent);

    if (session.callType == CallType.video) {
      await _callService.enableLocalVideo(true);
    }

    await _callService.joinChannel(
      channelName: session.channelName,
      uid: uid,
      token: session.rtcToken,
    );
  }

  Future<void> _leaveAgoraChannel() async {
    _callEventSubscription?.cancel();
    _callEventSubscription = null;
    await _callService.leaveChannel();
  }

  void _handleCallEvent(CallEvent event) {
    if (state is! InCall) return;
    final current = state as InCall;

    switch (event) {
      case UserJoinedEvent(:final uid):
        state = current.copyWith(remoteUid: uid, remoteJoined: true);
      case UserLeftEvent():
        // Remote user left - likely call ended
        endCall();
      case CallErrorEvent(:final message):
        developer.log('Agora error: $message', name: 'Calls');
      default:
        break;
    }
  }

  void _startCallTimer() {
    _callTimer?.cancel();
    _callTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state is InCall) {
        final current = state as InCall;
        state = current.copyWith(elapsedSeconds: current.elapsedSeconds + 1);
      }
    });
  }

  void _scheduleTokenRefresh(CallSession session) {
    if (session.tokenExpiresAt == null) return;

    final expiresIn = session.tokenExpiresAt!.difference(DateTime.now());
    // Refresh 60 seconds before expiry
    final refreshIn = expiresIn - const Duration(seconds: 60);

    if (refreshIn.isNegative) {
      // Token already expired or about to, refresh now
      _refreshToken(session.callId);
      return;
    }

    _tokenRefreshTimer?.cancel();
    _tokenRefreshTimer = Timer(refreshIn, () => _refreshToken(session.callId));
  }

  Future<void> _refreshToken(String callId) async {
    try {
      final refresh = await _repository.refreshToken(callId);
      // Renew token in Agora engine
      // Note: agora_rtc_engine renewToken method
      developer.log('Token refreshed for call: $callId', name: 'Calls');

      // Schedule next refresh
      if (state is InCall) {
        final newSession = (state as InCall).session.copyWith(
          rtcToken: refresh.rtcToken,
          tokenExpiresAt: refresh.expiresAt,
        );
        _scheduleTokenRefresh(newSession);
      }
    } catch (e) {
      developer.log('Token refresh failed: $e', name: 'Calls');
      // Retry once
      await Future.delayed(const Duration(seconds: 5));
      try {
        await _repository.refreshToken(callId);
      } catch (_) {
        // If retry also fails, end call gracefully
        endCall();
      }
    }
  }

  int _generateUid(String callId) {
    // Generate a stable UID from call ID
    return callId.hashCode.abs() % 2147483647;
  }

  String? _getCurrentCallId() {
    return switch (state) {
      OutgoingRinging(:final session) => session.callId,
      IncomingRinging(:final callId) => callId,
      InCall(:final session) => session.callId,
      _ => null,
    };
  }

  String _extractErrorMessage(Object error) {
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map && data.containsKey('message')) {
        return data['message'] as String;
      }
      return error.message ?? 'Network error';
    }
    return error.toString();
  }

  void _cleanup() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
    _callTimer?.cancel();
    _callTimer = null;
    _tokenRefreshTimer?.cancel();
    _tokenRefreshTimer = null;
    _callEventSubscription?.cancel();
    _callEventSubscription = null;
  }
}
```

### 5.3 Providers

```dart
// apps/babysitter_app/lib/src/features/calls/presentation/providers/calls_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auth/auth.dart';
import 'package:realtime/realtime.dart';

import '../../data/datasources/calls_remote_data_source.dart';
import '../../data/repositories/calls_repository_impl.dart';
import '../../domain/repositories/calls_repository.dart';
import '../../domain/usecases/initiate_call_usecase.dart';
import '../../domain/usecases/accept_call_usecase.dart';
import '../../domain/usecases/decline_call_usecase.dart';
import '../../domain/usecases/end_call_usecase.dart';
import '../../domain/usecases/get_call_history_usecase.dart';
import '../controllers/call_controller.dart';
import '../controllers/call_state.dart';

// Data Source
final callsRemoteDataSourceProvider = Provider<CallsRemoteDataSource>((ref) {
  final dio = ref.watch(authDioProvider);
  return CallsRemoteDataSourceImpl(dio);
});

// Repository
final callsRepositoryProvider = Provider<CallsRepository>((ref) {
  final dataSource = ref.watch(callsRemoteDataSourceProvider);
  return CallsRepositoryImpl(dataSource);
});

// Use Cases
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

final getCallHistoryUseCaseProvider = Provider<GetCallHistoryUseCase>((ref) {
  return GetCallHistoryUseCase(ref.watch(callsRepositoryProvider));
});

// Main Call Controller
final callControllerProvider = NotifierProvider<CallController, CallState>(() {
  return CallController();
});

// Re-export CallService from realtime package
export 'package:realtime/realtime.dart' show callServiceProvider;
```

### 5.4 Outgoing Call Screen

```dart
// apps/babysitter_app/lib/src/features/calls/presentation/screens/outgoing_call_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../domain/entities/call_enums.dart';
import '../controllers/call_state.dart';
import '../providers/calls_providers.dart';
import '../widgets/call_avatar_header.dart';
import '../widgets/call_background.dart';
import 'in_call_screen.dart';

class OutgoingCallScreen extends ConsumerStatefulWidget {
  final String recipientUserId;
  final String recipientName;
  final String? recipientAvatar;
  final CallType callType;

  const OutgoingCallScreen({
    super.key,
    required this.recipientUserId,
    required this.recipientName,
    this.recipientAvatar,
    required this.callType,
  });

  @override
  ConsumerState<OutgoingCallScreen> createState() => _OutgoingCallScreenState();
}

class _OutgoingCallScreenState extends ConsumerState<OutgoingCallScreen> {
  @override
  void initState() {
    super.initState();
    // Initiate call on screen load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(callControllerProvider.notifier).initiateCall(
        recipientUserId: widget.recipientUserId,
        recipientName: widget.recipientName,
        recipientAvatar: widget.recipientAvatar,
        callType: widget.callType,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final callState = ref.watch(callControllerProvider);

    // Listen for state changes
    ref.listen<CallState>(callControllerProvider, (previous, next) {
      if (next is InCall) {
        // Navigate to in-call screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const InCallScreen()),
        );
      } else if (next is CallEnded) {
        _showCallEndedAndPop(next.reason);
      } else if (next is CallError) {
        _showErrorAndPop(next.message);
      }
    });

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: CallBackground()),
          SafeArea(
            child: Column(
              children: [
                const Spacer(),
                CallAvatarHeader(
                  name: widget.recipientName,
                  avatarUrl: widget.recipientAvatar,
                  statusText: _getStatusText(callState),
                  isVideo: widget.callType == CallType.video,
                ),
                const Spacer(),
                _buildCancelButton(callState),
                SizedBox(height: 48.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusText(CallState state) {
    return switch (state) {
      CallLoading(:final message) => message,
      OutgoingRinging() => 'Calling...',
      _ => 'Connecting...',
    };
  }

  Widget _buildCancelButton(CallState state) {
    final isEnabled = state is OutgoingRinging || state is CallLoading;

    return GestureDetector(
      onTap: isEnabled
          ? () => ref.read(callControllerProvider.notifier).cancelCall()
          : null,
      child: Container(
        width: 64.w,
        height: 64.w,
        decoration: BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.call_end,
          color: Colors.white,
          size: 32.sp,
        ),
      ),
    );
  }

  void _showCallEndedAndPop(CallEndReason reason) {
    final message = switch (reason) {
      CallEndReason.declined => 'Call declined',
      CallEndReason.missed => 'No answer',
      CallEndReason.remoteEnded => 'Call ended',
      _ => 'Call ended',
    };

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
    Navigator.of(context).pop();
  }

  void _showErrorAndPop(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
    Navigator.of(context).pop();
  }
}
```

### 5.5 Incoming Call Screen

```dart
// apps/babysitter_app/lib/src/features/calls/presentation/screens/incoming_call_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../domain/entities/call_enums.dart';
import '../controllers/call_state.dart';
import '../providers/calls_providers.dart';
import '../widgets/call_avatar_header.dart';
import '../widgets/call_background.dart';
import 'in_call_screen.dart';

class IncomingCallScreen extends ConsumerWidget {
  final String callId;
  final CallType callType;
  final String callerName;
  final String callerUserId;
  final String? callerAvatar;

  const IncomingCallScreen({
    super.key,
    required this.callId,
    required this.callType,
    required this.callerName,
    required this.callerUserId,
    this.callerAvatar,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final callState = ref.watch(callControllerProvider);

    // Listen for state changes
    ref.listen<CallState>(callControllerProvider, (previous, next) {
      if (next is InCall) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const InCallScreen()),
        );
      } else if (next is CallEnded || next is CallIdle) {
        Navigator.of(context).pop();
      } else if (next is CallError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.message), backgroundColor: Colors.red),
        );
        Navigator.of(context).pop();
      }
    });

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: CallBackground()),
          SafeArea(
            child: Column(
              children: [
                const Spacer(),
                CallAvatarHeader(
                  name: callerName,
                  avatarUrl: callerAvatar,
                  statusText: _getCallTypeLabel(),
                  isVideo: callType == CallType.video,
                ),
                const Spacer(),
                _buildActionButtons(context, ref, callState),
                SizedBox(height: 48.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getCallTypeLabel() {
    return callType == CallType.video
        ? 'Incoming Video Call...'
        : 'Incoming Audio Call...';
  }

  Widget _buildActionButtons(
    BuildContext context,
    WidgetRef ref,
    CallState state,
  ) {
    final isLoading = state is CallLoading;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Decline Button
        GestureDetector(
          onTap: isLoading
              ? null
              : () => ref.read(callControllerProvider.notifier).declineCall(),
          child: Container(
            width: 64.w,
            height: 64.w,
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.call_end,
              color: Colors.white,
              size: 32.sp,
            ),
          ),
        ),
        SizedBox(width: 60.w),
        // Accept Button
        GestureDetector(
          onTap: isLoading
              ? null
              : () => ref.read(callControllerProvider.notifier).acceptCall(),
          child: Container(
            width: 64.w,
            height: 64.w,
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            child: isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Icon(
                    callType == CallType.video
                        ? Icons.videocam
                        : Icons.call,
                    color: Colors.white,
                    size: 32.sp,
                  ),
          ),
        ),
      ],
    );
  }
}
```

### 5.6 In-Call Screen

```dart
// apps/babysitter_app/lib/src/features/calls/presentation/screens/in_call_screen.dart

import 'dart:async';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:core/core.dart';
import 'package:realtime/realtime.dart';

import '../../domain/entities/call_enums.dart';
import '../controllers/call_state.dart';
import '../providers/calls_providers.dart';
import '../widgets/call_timer.dart';
import '../widgets/video_view_container.dart';

class InCallScreen extends ConsumerStatefulWidget {
  const InCallScreen({super.key});

  @override
  ConsumerState<InCallScreen> createState() => _InCallScreenState();
}

class _InCallScreenState extends ConsumerState<InCallScreen> {
  RtcEngine? _engine;
  bool _localVideoReady = false;
  int? _remoteUid;

  @override
  void initState() {
    super.initState();
    _initializeEngine();
  }

  Future<void> _initializeEngine() async {
    // Get engine from CallService (already initialized)
    final callService = ref.read(callServiceProvider);
    if (callService is AgoraCallService) {
      // Access internal engine for video views
      // Note: You may need to expose engine or create view method in CallService
    }

    _engine = createAgoraRtcEngine();
    await _engine!.initialize(RtcEngineContext(
      appId: EnvConfig.agoraAppId,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    ));

    _engine!.registerEventHandler(RtcEngineEventHandler(
      onJoinChannelSuccess: (connection, elapsed) {
        setState(() => _localVideoReady = true);
      },
      onUserJoined: (connection, remoteUid, elapsed) {
        setState(() => _remoteUid = remoteUid);
      },
      onUserOffline: (connection, remoteUid, reason) {
        setState(() => _remoteUid = null);
      },
    ));
  }

  @override
  void dispose() {
    _engine?.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final callState = ref.watch(callControllerProvider);

    // Handle state changes
    ref.listen<CallState>(callControllerProvider, (previous, next) {
      if (next is CallEnded || next is CallError || next is CallIdle) {
        Navigator.of(context).pop();
      }
    });

    if (callState is! InCall) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final isVideoCall = callState.session.callType == CallType.video;
    final currentUserId = ref.read(currentUserProvider).valueOrNull?.id ?? '';
    final remoteParticipant = callState.session.getRemoteParticipant(currentUserId);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Main content: Video or Audio UI
          if (isVideoCall && callState.isVideoEnabled)
            _buildVideoUI(callState)
          else
            _buildAudioUI(callState, remoteParticipant?.name ?? 'Unknown'),

          // Top bar with call info
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildTopBar(callState, remoteParticipant?.name ?? ''),
          ),

          // Bottom control bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildControlBar(callState, isVideoCall),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoUI(InCall callState) {
    return Stack(
      children: [
        // Remote video (full screen)
        if (callState.remoteJoined && _remoteUid != null)
          Positioned.fill(
            child: AgoraVideoView(
              controller: VideoViewController.remote(
                rtcEngine: _engine!,
                canvas: VideoCanvas(uid: _remoteUid!),
                connection: RtcConnection(
                  channelId: callState.session.channelName,
                ),
              ),
            ),
          )
        else
          Positioned.fill(
            child: Container(
              color: Colors.grey[900],
              child: Center(
                child: Text(
                  'Waiting for video...',
                  style: TextStyle(color: Colors.white, fontSize: 16.sp),
                ),
              ),
            ),
          ),

        // Local video (PiP)
        Positioned(
          top: 100.h,
          right: 16.w,
          child: Container(
            width: 100.w,
            height: 140.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.white, width: 2),
            ),
            clipBehavior: Clip.antiAlias,
            child: _localVideoReady
                ? AgoraVideoView(
                    controller: VideoViewController(
                      rtcEngine: _engine!,
                      canvas: const VideoCanvas(uid: 0),
                    ),
                  )
                : Container(color: Colors.grey[800]),
          ),
        ),
      ],
    );
  }

  Widget _buildAudioUI(InCall callState, String remoteName) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.grey[900]!,
            Colors.black,
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Avatar
            CircleAvatar(
              radius: 60.r,
              backgroundColor: Colors.grey[700],
              child: Text(
                remoteName.isNotEmpty ? remoteName[0].toUpperCase() : '?',
                style: TextStyle(
                  fontSize: 48.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              remoteName,
              style: TextStyle(
                fontSize: 24.sp,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            CallTimer(elapsedSeconds: callState.elapsedSeconds),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(InCall callState, String remoteName) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16.h,
        left: 16.w,
        right: 16.w,
        bottom: 16.h,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.7),
            Colors.transparent,
          ],
        ),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                remoteName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4.h),
              CallTimer(elapsedSeconds: callState.elapsedSeconds),
            ],
          ),
          const Spacer(),
          if (callState.session.callType == CallType.video)
            IconButton(
              icon: Icon(
                callState.isFrontCamera
                    ? Icons.camera_front
                    : Icons.camera_rear,
                color: Colors.white,
              ),
              onPressed: () =>
                  ref.read(callControllerProvider.notifier).switchCamera(),
            ),
        ],
      ),
    );
  }

  Widget _buildControlBar(InCall callState, bool isVideoCall) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 24.h,
        top: 24.h,
        left: 24.w,
        right: 24.w,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.black.withOpacity(0.9),
            Colors.transparent,
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Mute button
          _buildControlButton(
            icon: callState.isAudioMuted ? Icons.mic_off : Icons.mic,
            isActive: !callState.isAudioMuted,
            onTap: () => ref.read(callControllerProvider.notifier).toggleMute(),
          ),
          // Video toggle (for video calls)
          if (isVideoCall)
            _buildControlButton(
              icon: callState.isVideoEnabled
                  ? Icons.videocam
                  : Icons.videocam_off,
              isActive: callState.isVideoEnabled,
              onTap: () =>
                  ref.read(callControllerProvider.notifier).toggleVideo(),
            ),
          // Speaker toggle
          _buildControlButton(
            icon: callState.isSpeakerOn
                ? Icons.volume_up
                : Icons.volume_down,
            isActive: callState.isSpeakerOn,
            onTap: () =>
                ref.read(callControllerProvider.notifier).toggleSpeaker(),
          ),
          // End call button
          _buildControlButton(
            icon: Icons.call_end,
            backgroundColor: Colors.red,
            onTap: () => ref.read(callControllerProvider.notifier).endCall(),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    bool isActive = true,
    Color? backgroundColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56.w,
        height: 56.w,
        decoration: BoxDecoration(
          color: backgroundColor ??
              (isActive ? Colors.white.withOpacity(0.2) : Colors.grey[600]),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 28.sp,
        ),
      ),
    );
  }
}
```

### 5.7 Call History Screen

```dart
// apps/babysitter_app/lib/src/features/calls/presentation/screens/call_history_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/call_history_item.dart';
import '../../domain/entities/call_enums.dart';
import '../providers/call_history_provider.dart';

class CallHistoryScreen extends ConsumerStatefulWidget {
  const CallHistoryScreen({super.key});

  @override
  ConsumerState<CallHistoryScreen> createState() => _CallHistoryScreenState();
}

class _CallHistoryScreenState extends ConsumerState<CallHistoryScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(callHistoryControllerProvider.notifier).loadInitial();
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(callHistoryControllerProvider.notifier).loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final historyState = ref.watch(callHistoryControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Call History'),
      ),
      body: historyState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (message) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(message, style: TextStyle(color: Colors.red)),
              SizedBox(height: 16.h),
              ElevatedButton(
                onPressed: () => ref
                    .read(callHistoryControllerProvider.notifier)
                    .loadInitial(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        loaded: (items, hasMore, isLoadingMore) {
          if (items.isEmpty) {
            return const Center(
              child: Text('No call history'),
            );
          }

          return ListView.builder(
            controller: _scrollController,
            padding: EdgeInsets.symmetric(vertical: 8.h),
            itemCount: items.length + (hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= items.length) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: const CircularProgressIndicator(),
                  ),
                );
              }

              return _CallHistoryTile(item: items[index]);
            },
          );
        },
      ),
    );
  }
}

class _CallHistoryTile extends StatelessWidget {
  final CallHistoryItem item;

  const _CallHistoryTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final isMissed = item.wasMissed;
    final iconColor = isMissed ? Colors.red : Colors.green;
    final isOutgoing = item.isInitiator;

    return ListTile(
      leading: CircleAvatar(
        radius: 24.r,
        backgroundImage: item.otherParticipant.avatar != null
            ? NetworkImage(item.otherParticipant.avatar!)
            : null,
        backgroundColor: Colors.grey[300],
        child: item.otherParticipant.avatar == null
            ? Text(
                item.otherParticipant.name.isNotEmpty
                    ? item.otherParticipant.name[0].toUpperCase()
                    : '?',
              )
            : null,
      ),
      title: Text(
        item.otherParticipant.name,
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Row(
        children: [
          Icon(
            isOutgoing ? Icons.call_made : Icons.call_received,
            size: 14.sp,
            color: iconColor,
          ),
          SizedBox(width: 4.w),
          Text(
            _formatCallInfo(item),
            style: TextStyle(fontSize: 12.sp),
          ),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            _formatDate(item.createdAt),
            style: TextStyle(fontSize: 12.sp, color: Colors.grey),
          ),
          SizedBox(height: 4.h),
          Icon(
            item.callType == CallType.video
                ? Icons.videocam_outlined
                : Icons.call_outlined,
            size: 18.sp,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  String _formatCallInfo(CallHistoryItem item) {
    if (item.wasMissed) {
      return 'Missed';
    }
    if (item.status == CallStatus.declined) {
      return 'Declined';
    }
    return item.durationFormatted;
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final callDate = DateTime(date.year, date.month, date.day);

    if (callDate == today) {
      return DateFormat.jm().format(date);
    } else if (callDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    } else {
      return DateFormat.MMMd().format(date);
    }
  }
}
```

### 5.8 Call History Provider

```dart
// apps/babysitter_app/lib/src/features/calls/presentation/providers/call_history_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/call_history_item.dart';
import '../../domain/usecases/get_call_history_usecase.dart';
import 'calls_providers.dart';

// State
sealed class CallHistoryState {
  const CallHistoryState();

  const factory CallHistoryState.loading() = CallHistoryLoading;
  const factory CallHistoryState.error(String message) = CallHistoryError;
  const factory CallHistoryState.loaded(
    List<CallHistoryItem> items,
    bool hasMore,
    bool isLoadingMore,
  ) = CallHistoryLoaded;

  R when<R>({
    required R Function() loading,
    required R Function(String message) error,
    required R Function(
      List<CallHistoryItem> items,
      bool hasMore,
      bool isLoadingMore,
    )
        loaded,
  }) {
    return switch (this) {
      CallHistoryLoading() => loading(),
      CallHistoryError(:final message) => error(message),
      CallHistoryLoaded(:final items, :final hasMore, :final isLoadingMore) =>
        loaded(items, hasMore, isLoadingMore),
    };
  }
}

class CallHistoryLoading extends CallHistoryState {
  const CallHistoryLoading();
}

class CallHistoryError extends CallHistoryState {
  final String message;
  const CallHistoryError(this.message);
}

class CallHistoryLoaded extends CallHistoryState {
  final List<CallHistoryItem> items;
  final bool hasMore;
  final bool isLoadingMore;

  const CallHistoryLoaded(this.items, this.hasMore, this.isLoadingMore);
}

// Controller
class CallHistoryController extends Notifier<CallHistoryState> {
  static const _pageSize = 20;

  @override
  CallHistoryState build() => const CallHistoryLoading();

  GetCallHistoryUseCase get _useCase => ref.read(getCallHistoryUseCaseProvider);

  Future<void> loadInitial() async {
    state = const CallHistoryLoading();

    try {
      final page = await _useCase.call(
        const GetCallHistoryParams(limit: _pageSize, offset: 0),
      );
      state = CallHistoryLoaded(page.items, page.hasMore, false);
    } catch (e) {
      state = CallHistoryError(e.toString());
    }
  }

  Future<void> loadMore() async {
    final currentState = state;
    if (currentState is! CallHistoryLoaded) return;
    if (currentState.isLoadingMore || !currentState.hasMore) return;

    state = CallHistoryLoaded(
      currentState.items,
      currentState.hasMore,
      true,
    );

    try {
      final page = await _useCase.call(
        GetCallHistoryParams(
          limit: _pageSize,
          offset: currentState.items.length,
        ),
      );

      state = CallHistoryLoaded(
        [...currentState.items, ...page.items],
        page.hasMore,
        false,
      );
    } catch (e) {
      state = CallHistoryLoaded(
        currentState.items,
        currentState.hasMore,
        false,
      );
    }
  }

  Future<void> refresh() => loadInitial();
}

final callHistoryControllerProvider =
    NotifierProvider<CallHistoryController, CallHistoryState>(() {
  return CallHistoryController();
});
```

---

## 6. Agora RTC Integration

### 6.1 Enhanced Call Service

Add these methods to `packages/realtime/lib/src/call_service.dart`:

```dart
// Add to CallService interface:

/// Renew the RTC token
Future<void> renewToken(String token);

/// Get the RTC engine for video views
RtcEngine? get engine;

/// Create a local video view
Widget createLocalVideoView();

/// Create a remote video view
Widget createRemoteVideoView(int uid, String channelId);
```

### 6.2 Enhanced AgoraCallService

```dart
// Add to packages/realtime/lib/src/agora_call_service.dart

@override
Future<void> renewToken(String token) async {
  await _engine?.renewToken(token);
  developer.log('RTC token renewed', name: 'Realtime');
}

@override
RtcEngine? get engine => _engine;

@override
Widget createLocalVideoView() {
  if (_engine == null) {
    return Container(color: Colors.black);
  }
  return AgoraVideoView(
    controller: VideoViewController(
      rtcEngine: _engine!,
      canvas: const VideoCanvas(uid: 0),
    ),
  );
}

@override
Widget createRemoteVideoView(int uid, String channelId) {
  if (_engine == null) {
    return Container(color: Colors.black);
  }
  return AgoraVideoView(
    controller: VideoViewController.remote(
      rtcEngine: _engine!,
      canvas: VideoCanvas(uid: uid),
      connection: RtcConnection(channelId: channelId),
    ),
  );
}
```

### 6.3 Token Provider with Backend

Update `packages/realtime/lib/src/token/env_agora_token_provider.dart` to support backend tokens:

```dart
// packages/realtime/lib/src/token/backend_agora_token_provider.dart

import 'package:dio/dio.dart';
import 'dart:developer' as developer;

import 'agora_token_provider.dart';

/// Token provider that fetches tokens from backend
class BackendAgoraTokenProvider implements AgoraTokenProvider {
  final Dio _dio;

  BackendAgoraTokenProvider(this._dio);

  @override
  Future<String?> getRtmToken(String userId) async {
    try {
      final response = await _dio.get('/calls/config');
      // If backend provides RTM token
      final data = response.data['data'];
      return data?['rtmToken'] as String?;
    } catch (e) {
      developer.log('Failed to get RTM token: $e', name: 'Realtime');
      return null;
    }
  }

  @override
  Future<String?> getRtcToken(String channelName, int uid) async {
    // RTC tokens are provided per-call from the backend
    // This is typically not used directly - use CallSession.rtcToken instead
    return null;
  }
}
```

---

## 7. Incoming Call Notifications

### 7.1 Push Notification Payload Contract

Expected payload from backend:

```json
{
  "type": "incoming_call",
  "callId": "call-uuid-123",
  "callType": "video",
  "callerUserId": "user-id-456",
  "callerName": "John Parent",
  "callerAvatar": "https://...",
  "channelName": "call-call-uuid-123",
  "timestamp": "2024-01-15T10:30:00Z"
}
```

### 7.2 Call Notification Handler

```dart
// packages/notifications/lib/src/call_notification_handler.dart

import 'dart:developer' as developer;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:uuid/uuid.dart';

class CallNotificationHandler {
  static const _uuid = Uuid();

  /// Handle incoming call from FCM message (background or foreground)
  static Future<void> handleIncomingCallMessage(RemoteMessage message) async {
    final data = message.data;

    if (data['type'] != 'incoming_call') return;

    final callId = data['callId'] as String?;
    final callType = data['callType'] as String?;
    final callerName = data['callerName'] as String?;
    final callerAvatar = data['callerAvatar'] as String?;

    if (callId == null || callerName == null) {
      developer.log('Invalid incoming call payload', name: 'Notifications');
      return;
    }

    await _showCallKitUI(
      callId: callId,
      callerName: callerName,
      callerAvatar: callerAvatar,
      isVideo: callType == 'video',
    );
  }

  /// Show CallKit-style incoming call UI
  static Future<void> _showCallKitUI({
    required String callId,
    required String callerName,
    String? callerAvatar,
    bool isVideo = false,
  }) async {
    final params = CallKitParams(
      id: callId,
      nameCaller: callerName,
      appName: 'Special Needs Sitters',
      avatar: callerAvatar,
      handle: callerName,
      type: isVideo ? 1 : 0, // 0 = audio, 1 = video
      textAccept: 'Accept',
      textDecline: 'Decline',
      missedCallNotification: const NotificationParams(
        showNotification: true,
        isShowCallback: true,
        subtitle: 'Missed call',
      ),
      duration: 45000, // 45 seconds ring timeout
      extra: <String, dynamic>{
        'callId': callId,
        'isVideo': isVideo,
      },
      headers: <String, dynamic>{
        'platform': 'flutter',
      },
      android: const AndroidParams(
        isCustomNotification: true,
        isShowLogo: false,
        ringtonePath: 'ringtone_default',
        backgroundColor: '#1E88E5',
        backgroundUrl: null,
        actionColor: '#4CAF50',
        incomingCallNotificationChannelName: 'Incoming Calls',
        isShowFullLockedScreen: true,
      ),
      ios: const IOSParams(
        iconName: 'CallKitLogo',
        handleType: 'generic',
        supportsVideo: true,
        maximumCallGroups: 1,
        maximumCallsPerCallGroup: 1,
        audioSessionMode: 'default',
        audioSessionActive: true,
        audioSessionPreferredSampleRate: 44100.0,
        audioSessionPreferredIOBufferDuration: 0.005,
        supportsDTMF: false,
        supportsHolding: false,
        supportsGrouping: false,
        supportsUngrouping: false,
        ringtonePath: null,
      ),
    );

    await FlutterCallkitIncoming.showCallkitIncoming(params);
    developer.log('Showing incoming call UI for $callId', name: 'Notifications');
  }

  /// End active call UI
  static Future<void> endCall(String callId) async {
    await FlutterCallkitIncoming.endCall(callId);
  }

  /// End all calls
  static Future<void> endAllCalls() async {
    await FlutterCallkitIncoming.endAllCalls();
  }

  /// Get active calls
  static Future<List<dynamic>> getActiveCalls() async {
    return await FlutterCallkitIncoming.activeCalls();
  }
}
```

### 7.3 CallKit Event Listener Setup

```dart
// packages/notifications/lib/src/callkit_service.dart

import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';

/// Represents a CallKit action
sealed class CallKitAction {
  final String callId;
  const CallKitAction(this.callId);
}

class CallAccepted extends CallKitAction {
  const CallAccepted(super.callId);
}

class CallDeclined extends CallKitAction {
  const CallDeclined(super.callId);
}

class CallEnded extends CallKitAction {
  const CallEnded(super.callId);
}

class CallTimedOut extends CallKitAction {
  const CallTimedOut(super.callId);
}

class CallKitService {
  final _actionController = StreamController<CallKitAction>.broadcast();
  StreamSubscription? _eventSubscription;

  Stream<CallKitAction> get actions => _actionController.stream;

  void initialize() {
    _eventSubscription = FlutterCallkitIncoming.onEvent.listen(_handleEvent);
    developer.log('CallKitService initialized', name: 'Notifications');
  }

  void _handleEvent(CallEvent? event) {
    if (event == null) return;

    final callId = event.body['id'] as String? ?? '';
    developer.log('CallKit event: ${event.event} for $callId', name: 'Notifications');

    switch (event.event) {
      case Event.actionCallAccept:
        _actionController.add(CallAccepted(callId));
        break;
      case Event.actionCallDecline:
        _actionController.add(CallDeclined(callId));
        break;
      case Event.actionCallEnded:
        _actionController.add(CallEnded(callId));
        break;
      case Event.actionCallTimeout:
        _actionController.add(CallTimedOut(callId));
        break;
      default:
        break;
    }
  }

  void dispose() {
    _eventSubscription?.cancel();
    _actionController.close();
  }
}
```

### 7.4 Updated Background Message Handler

Update `apps/babysitter_app/lib/main.dart`:

```dart
// apps/babysitter_app/lib/main.dart

import 'dart:developer' as developer;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:notifications/notifications.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'app.dart';

/// Top-level background message handler (required by Firebase)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Ensure Firebase is initialized for background handling
  try {
    await Firebase.initializeApp();
  } catch (_) {}

  developer.log(
    'Background message: ${message.notification?.title}',
    name: 'Notifications',
  );

  // Handle incoming call notifications in background
  final type = message.data['type'];
  if (type == 'incoming_call') {
    await CallNotificationHandler.handleIncomingCallMessage(message);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment configuration
  await EnvConfig.tryLoad();

  // Initialize Stripe
  Stripe.publishableKey =
      'pk_test_51SpPCQA94FXRonexZprCttmNtDC5z91d57n5MVW1r8TjGPApriYe9FTiZXbYOx9TVytNLchLwsAUvfJvuXzDBzmf00LJxEXg8h';
  Stripe.merchantIdentifier = 'merchant.com.specialneedssitters';
  await Stripe.instance.applySettings();

  // Initialize Firebase with try/catch for missing config
  bool firebaseReady = false;
  try {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    firebaseReady = true;
    developer.log('Firebase initialized successfully', name: 'App');
  } catch (e) {
    developer.log(
      'Firebase initialization failed (config may be missing): $e',
      name: 'App',
    );
  }

  runApp(
    ProviderScope(
      overrides: [
        firebaseReadyProvider.overrideWith((ref) => firebaseReady),
      ],
      child: const BabysitterApp(),
    ),
  );
}
```

### 7.5 Incoming Call Handler (App-Level Integration)

```dart
// apps/babysitter_app/lib/src/features/calls/services/incoming_call_handler.dart

import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:notifications/notifications.dart';

import '../domain/entities/call_enums.dart';
import '../presentation/controllers/call_controller.dart';
import '../presentation/controllers/call_state.dart';
import '../presentation/providers/calls_providers.dart';
import '../presentation/screens/incoming_call_screen.dart';

class IncomingCallHandler {
  final Ref _ref;
  final GlobalKey<NavigatorState> navigatorKey;

  StreamSubscription? _foregroundSubscription;
  StreamSubscription? _callKitSubscription;

  IncomingCallHandler(this._ref, {required this.navigatorKey});

  void initialize() {
    // Initialize CallKit service
    final callKitService = _ref.read(callKitServiceProvider);
    callKitService.initialize();

    // Listen for CallKit actions (accept/decline from notification)
    _callKitSubscription = callKitService.actions.listen(_handleCallKitAction);

    // Listen for foreground messages
    _foregroundSubscription = FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    developer.log('IncomingCallHandler initialized', name: 'Calls');
  }

  void _handleForegroundMessage(RemoteMessage message) {
    final type = message.data['type'];

    if (type == 'incoming_call') {
      _handleIncomingCall(message.data);
    } else if (type == 'call_status') {
      _handleCallStatusUpdate(message.data);
    }
  }

  void _handleIncomingCall(Map<String, dynamic> data) {
    final callId = data['callId'] as String?;
    final callType = data['callType'] as String?;
    final callerName = data['callerName'] as String?;
    final callerUserId = data['callerUserId'] as String?;
    final callerAvatar = data['callerAvatar'] as String?;

    if (callId == null || callerName == null || callerUserId == null) {
      developer.log('Invalid incoming call data', name: 'Calls');
      return;
    }

    // Check if already in a call
    final currentState = _ref.read(callControllerProvider);
    if (currentState is InCall || currentState is IncomingRinging) {
      developer.log('Already in a call, ignoring incoming', name: 'Calls');
      // Optionally decline this call or show busy
      return;
    }

    // Update controller state
    _ref.read(callControllerProvider.notifier).handleIncomingCall(
      callId: callId,
      callType: CallType.fromString(callType ?? 'audio'),
      callerName: callerName,
      callerUserId: callerUserId,
      callerAvatar: callerAvatar,
    );

    // Show in-app incoming call screen
    _showIncomingCallScreen(
      callId: callId,
      callType: CallType.fromString(callType ?? 'audio'),
      callerName: callerName,
      callerUserId: callerUserId,
      callerAvatar: callerAvatar,
    );

    // Also show CallKit UI for system integration
    CallNotificationHandler.handleIncomingCallMessage(
      RemoteMessage(data: data),
    );
  }

  void _handleCallStatusUpdate(Map<String, dynamic> data) {
    final callId = data['callId'] as String?;
    final status = data['status'] as String?;

    if (callId == null || status == null) return;

    developer.log('Call status update: $callId -> $status', name: 'Calls');

    // Handle push-driven status updates
    // This supplements polling for faster updates
    final currentState = _ref.read(callControllerProvider);

    if (status == 'accepted' && currentState is OutgoingRinging) {
      // Remote accepted - controller will handle via polling
    } else if (status == 'declined' && currentState is OutgoingRinging) {
      // Remote declined
      _ref.read(callControllerProvider.notifier).reset();
    } else if (status == 'ended') {
      _ref.read(callControllerProvider.notifier).endCall();
    }
  }

  void _handleCallKitAction(CallKitAction action) {
    final callId = action.callId;

    switch (action) {
      case CallAccepted():
        developer.log('CallKit: User accepted $callId', name: 'Calls');
        _ref.read(callControllerProvider.notifier).acceptCall();
        // Navigate to in-call screen if not already
        _navigateToInCallIfNeeded();
        break;

      case CallDeclined():
        developer.log('CallKit: User declined $callId', name: 'Calls');
        _ref.read(callControllerProvider.notifier).declineCall();
        break;

      case CallEnded():
        developer.log('CallKit: Call ended $callId', name: 'Calls');
        _ref.read(callControllerProvider.notifier).endCall();
        break;

      case CallTimedOut():
        developer.log('CallKit: Call timed out $callId', name: 'Calls');
        _ref.read(callControllerProvider.notifier).declineCall(
          reason: 'No answer',
        );
        break;
    }
  }

  void _showIncomingCallScreen({
    required String callId,
    required CallType callType,
    required String callerName,
    required String callerUserId,
    String? callerAvatar,
  }) {
    final navigator = navigatorKey.currentState;
    if (navigator == null) return;

    navigator.push(
      MaterialPageRoute(
        builder: (_) => IncomingCallScreen(
          callId: callId,
          callType: callType,
          callerName: callerName,
          callerUserId: callerUserId,
          callerAvatar: callerAvatar,
        ),
      ),
    );
  }

  void _navigateToInCallIfNeeded() {
    // Check if already on in-call screen
    // If not, navigate there
  }

  void dispose() {
    _foregroundSubscription?.cancel();
    _callKitSubscription?.cancel();
  }
}

// Provider
final incomingCallHandlerProvider = Provider<IncomingCallHandler>((ref) {
  throw UnimplementedError('Must be overridden with navigatorKey');
});

// CallKit service provider
final callKitServiceProvider = Provider<CallKitService>((ref) {
  final service = CallKitService();
  ref.onDispose(() => service.dispose());
  return service;
});
```

---

## 8. Platform Configuration

### 8.1 Android Configuration

#### AndroidManifest.xml Additions

Add these permissions and configurations to `apps/babysitter_app/android/app/src/main/AndroidManifest.xml`:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <!-- Existing permissions... -->

    <!-- Additional permissions for incoming calls -->
    <uses-permission android:name="android.permission.WAKE_LOCK"/>
    <uses-permission android:name="android.permission.USE_FULL_SCREEN_INTENT"/>
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE_PHONE_CALL"/>
    <uses-permission android:name="android.permission.MANAGE_OWN_CALLS"/>
    <uses-permission android:name="android.permission.READ_PHONE_STATE"/>

    <application ...>

        <!-- Existing content... -->

        <!-- CallKit Incoming Activity -->
        <activity
            android:name="com.hiennv.flutter_callkit_incoming.CallkitIncomingActivity"
            android:launchMode="singleInstance"
            android:exported="true"
            android:showOnLockScreen="true"
            android:turnScreenOn="true"
            android:showWhenLocked="true"
            android:theme="@style/Theme.AppCompat.Light.NoActionBar"
            android:excludeFromRecents="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
            </intent-filter>
        </activity>

        <!-- Foreground service for calls -->
        <service
            android:name="com.hiennv.flutter_callkit_incoming.CallkitSoundService"
            android:foregroundServiceType="phoneCall"
            android:exported="false"/>

        <!-- Call notification channel (created programmatically, but can define here) -->

    </application>
</manifest>
```

#### build.gradle Dependencies

Ensure these are in `android/app/build.gradle`:

```groovy
android {
    compileSdkVersion 34

    defaultConfig {
        minSdkVersion 24
        targetSdkVersion 34
    }
}
```

### 8.2 iOS Configuration

#### Info.plist Additions

Add these to `apps/babysitter_app/ios/Runner/Info.plist`:

```xml
<!-- VoIP Background Mode for CallKit -->
<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
    <string>remote-notification</string>
    <string>location</string>
    <string>voip</string>  <!-- ADD THIS -->
</array>

<!-- CallKit Usage Description (if needed) -->
<key>NSVoIPUsageDescription</key>
<string>This app needs VoIP capabilities for incoming call notifications.</string>
```

#### Capabilities in Xcode

Enable these capabilities in Xcode project:
1. **Push Notifications** - Already enabled
2. **Background Modes**:
   - Voice over IP (required for VoIP push)
   - Remote notifications
   - Background fetch
3. **Keychain Sharing** (if using CallKit)

#### AppDelegate.swift for VoIP Push

```swift
// ios/Runner/AppDelegate.swift

import UIKit
import Flutter
import PushKit
import flutter_callkit_incoming

@main
@objc class AppDelegate: FlutterAppDelegate, PKPushRegistryDelegate {

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)

        // Register for VoIP pushes
        let voipRegistry = PKPushRegistry(queue: DispatchQueue.main)
        voipRegistry.delegate = self
        voipRegistry.desiredPushTypes = [.voIP]

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    // MARK: - PKPushRegistryDelegate

    func pushRegistry(_ registry: PKPushRegistry,
                      didUpdate pushCredentials: PKPushCredentials,
                      for type: PKPushType) {
        // Send VoIP token to your backend
        let token = pushCredentials.token.map { String(format: "%02x", $0) }.joined()
        print("VoIP Token: \(token)")

        // You can use a method channel to send this to Flutter
        SwiftFlutterCallkitIncomingPlugin.sharedInstance?.setDevicePushTokenVoIP(token)
    }

    func pushRegistry(_ registry: PKPushRegistry,
                      didReceiveIncomingPushWith payload: PKPushPayload,
                      for type: PKPushType,
                      completion: @escaping () -> Void) {
        guard type == .voIP else {
            completion()
            return
        }

        let data = payload.dictionaryPayload

        // Extract call info from payload
        let callId = data["callId"] as? String ?? UUID().uuidString
        let callerName = data["callerName"] as? String ?? "Unknown"
        let callerAvatar = data["callerAvatar"] as? String
        let isVideo = (data["callType"] as? String) == "video"

        // Show CallKit UI
        let callKitData = flutter_callkit_incoming.Data(
            id: callId,
            nameCaller: callerName,
            handle: callerName,
            type: isVideo ? 1 : 0
        )
        callKitData.avatar = callerAvatar
        callKitData.extra = ["callId": callId, "isVideo": isVideo]

        SwiftFlutterCallkitIncomingPlugin.sharedInstance?.showCallkitIncoming(
            callKitData,
            fromPushKit: true
        )

        completion()
    }
}
```

### 8.3 Dependencies to Add

Add to `apps/babysitter_app/pubspec.yaml`:

```yaml
dependencies:
  # CallKit for incoming call UI
  flutter_callkit_incoming: ^2.0.4

  # Already present:
  # agora_rtc_engine: ^6.3.2
  # firebase_messaging: ^14.7.19
  # flutter_local_notifications: ^17.0.0
```

Add to `packages/notifications/pubspec.yaml`:

```yaml
dependencies:
  flutter_callkit_incoming: ^2.0.4
  uuid: ^4.2.1
```

---

## 9. Manual Test Checklist

### 9.1 Basic Call Flow (Parent App)

- [ ] Parent can initiate audio call to sitter
- [ ] Parent can initiate video call to sitter
- [ ] "Calling..." status shows during outgoing call
- [ ] Parent can cancel call before answer
- [ ] Parent sees "Call declined" when sitter declines
- [ ] Parent sees "No answer" after timeout (~40 seconds)
- [ ] Parent automatically joins call when sitter accepts
- [ ] In-call controls work (mute, speaker, video toggle)
- [ ] Parent can end active call

### 9.2 Basic Call Flow (Sitter App)

- [ ] Sitter receives incoming call notification (foreground)
- [ ] Sitter can accept incoming call
- [ ] Sitter can decline incoming call
- [ ] Sitter joins call after accepting
- [ ] In-call controls work
- [ ] Sitter can end active call

### 9.3 Background Notifications (Android)

- [ ] Sitter receives full-screen call UI when app in background
- [ ] Screen turns on for incoming call
- [ ] Accept button works from notification
- [ ] Decline button works from notification
- [ ] Call UI appears after accepting from notification
- [ ] Call times out and shows missed notification

### 9.4 Background Notifications (Android - Screen Off)

- [ ] Incoming call wakes device and shows full-screen UI
- [ ] Accept/Decline work from lock screen
- [ ] Proper cleanup after decline

### 9.5 Background Notifications (iOS)

- [ ] Sitter receives CallKit UI when app in background
- [ ] Accept works from CallKit UI
- [ ] Decline works from CallKit UI
- [ ] App opens to in-call screen after accept

### 9.6 Killed App Scenario (iOS)

- [ ] VoIP push received when app is killed
- [ ] CallKit UI shows
- [ ] Accept launches app and connects call
- [ ] Decline works without launching app

### 9.7 Token Refresh

- [ ] Long calls (>10 minutes) maintain connection
- [ ] Token refresh occurs before expiry
- [ ] Call continues after token refresh

### 9.8 Call History

- [ ] History loads with pagination
- [ ] Shows correct call type icon (audio/video)
- [ ] Shows correct direction (incoming/outgoing)
- [ ] Shows missed calls in red
- [ ] Shows call duration for connected calls
- [ ] Scroll loads more items

### 9.9 Error Scenarios

- [ ] Network disconnect shows appropriate error
- [ ] "Only parents can initiate" shows for sitter attempt
- [ ] "Call not ringing" when accepting ended call
- [ ] Graceful cleanup on any error

### 9.10 Edge Cases

- [ ] Second incoming call while already in call (busy handling)
- [ ] Both participants end simultaneously
- [ ] App backgrounded during active call continues
- [ ] Switching between audio/video mid-call
- [ ] Camera switch works (front/back)

---

## Appendix: VoIP Push Fallback

If backend cannot send VoIP pushes initially, use this fallback approach:

### Fallback: Standard Push + Quick App Launch

1. Backend sends regular FCM/APNs push with `content-available: 1`
2. App wakes briefly in background via FCM handler
3. FCM handler shows high-priority local notification with action buttons
4. User taps notification → app opens to incoming call screen
5. User can then accept/decline from within app

```dart
// Fallback notification for iOS when VoIP push not available
Future<void> showFallbackIncomingNotification(Map<String, dynamic> data) async {
  final callId = data['callId'] as String?;
  final callerName = data['callerName'] as String?;

  if (callId == null) return;

  await FlutterLocalNotificationsPlugin().show(
    callId.hashCode,
    'Incoming Call',
    '$callerName is calling...',
    NotificationDetails(
      android: AndroidNotificationDetails(
        'incoming_calls',
        'Incoming Calls',
        importance: Importance.max,
        priority: Priority.max,
        fullScreenIntent: true,
        category: AndroidNotificationCategory.call,
        actions: [
          AndroidNotificationAction('accept', 'Accept', showsUserInterface: true),
          AndroidNotificationAction('decline', 'Decline'),
        ],
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentSound: true,
        sound: 'ringtone.caf',
        interruptionLevel: InterruptionLevel.timeSensitive,
      ),
    ),
    payload: 'incoming_call:$callId',
  );
}
```

**Note:** This fallback has limitations:
- iOS may not show notification if app was force-quit
- No native phone call UI (just notification)
- User must tap notification to interact

For production, implementing VoIP push + CallKit is strongly recommended.
