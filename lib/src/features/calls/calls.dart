/// Calls feature module - Audio/Video calling with Agora
///
/// This module implements:
/// - Parent initiates calls to sitter
/// - Sitter receives incoming calls with Accept/Decline
/// - Active call with mute, speaker, video, camera switch controls
/// - Call history with pagination
/// - CallKit integration for background/killed app incoming calls
///
/// API Endpoints used:
/// - GET /calls/config - Agora App ID
/// - POST /calls/initiate - Parent initiates call
/// - POST /calls/{callId}/accept - Sitter accepts
/// - POST /calls/{callId}/decline - Sitter declines
/// - POST /calls/{callId}/end - Either ends
/// - GET /calls/{callId} - Get call details
/// - POST /calls/{callId}/token - Refresh RTC token
/// - GET /calls/history - Call history
library;

// Domain entities
export 'domain/entities/call_enums.dart';
export 'domain/entities/call_participant.dart';
export 'domain/entities/call_config.dart';
export 'domain/entities/call_session.dart';
export 'domain/entities/call_history_item.dart';

// Domain repository interface
export 'domain/repositories/calls_repository.dart';

// Presentation providers
export 'presentation/providers/calls_providers.dart';
export 'presentation/providers/call_history_provider.dart';

// Presentation controllers
export 'presentation/controllers/call_state.dart';
export 'presentation/controllers/call_controller.dart';

// Presentation screens
export 'presentation/screens/outgoing_call_screen.dart';
export 'presentation/screens/incoming_call_screen.dart';
export 'presentation/screens/in_call_screen.dart';
export 'presentation/screens/call_history_screen.dart';

// Services
export 'services/call_notification_service.dart';
export 'services/callkit_event_handler.dart';
export 'services/incoming_call_handler.dart';
