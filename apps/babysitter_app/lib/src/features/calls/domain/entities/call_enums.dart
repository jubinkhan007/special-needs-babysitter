/// Call type - audio or video
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

/// Call status from backend
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
  bool get isTerminal => this == CallStatus.declined || this == CallStatus.ended || this == CallStatus.missed;
}

/// User role in the app
enum UserRole {
  parent,
  sitter;

  static UserRole fromString(String value) {
    switch (value.toLowerCase()) {
      case 'sitter':
        return UserRole.sitter;
      case 'parent':
      default:
        return UserRole.parent;
    }
  }
}
