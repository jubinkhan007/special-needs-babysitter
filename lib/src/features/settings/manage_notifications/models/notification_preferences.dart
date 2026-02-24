class NotificationPreferences {
  final bool pushNotifications;
  final bool jobUpdates;
  final bool messages;
  final bool reminders;
  final bool appUpdatesAndEvents;

  const NotificationPreferences({
    this.pushNotifications = true,
    this.jobUpdates = true,
    this.messages = true,
    this.reminders = true,
    this.appUpdatesAndEvents = true,
  });

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    return NotificationPreferences(
      pushNotifications: json['pushNotifications'] as bool? ?? true,
      jobUpdates: json['jobUpdates'] as bool? ?? true,
      messages: json['messages'] as bool? ?? true,
      reminders: json['reminders'] as bool? ?? true,
      appUpdatesAndEvents: json['appUpdatesAndEvents'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    'pushNotifications': pushNotifications,
    'jobUpdates': jobUpdates,
    'messages': messages,
    'reminders': reminders,
    'appUpdatesAndEvents': appUpdatesAndEvents,
  };

  NotificationPreferences copyWith({
    bool? pushNotifications,
    bool? jobUpdates,
    bool? messages,
    bool? reminders,
    bool? appUpdatesAndEvents,
  }) {
    return NotificationPreferences(
      pushNotifications: pushNotifications ?? this.pushNotifications,
      jobUpdates: jobUpdates ?? this.jobUpdates,
      messages: messages ?? this.messages,
      reminders: reminders ?? this.reminders,
      appUpdatesAndEvents: appUpdatesAndEvents ?? this.appUpdatesAndEvents,
    );
  }
}
