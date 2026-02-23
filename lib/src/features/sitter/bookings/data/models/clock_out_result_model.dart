class ClockOutResultModel {
  final String message;
  final DateTime? clockOutTime;
  final int? totalWorkedMinutes;
  final bool isFinalDay;
  final bool hasMoreShifts;

  const ClockOutResultModel({
    required this.message,
    required this.clockOutTime,
    required this.totalWorkedMinutes,
    required this.isFinalDay,
    required this.hasMoreShifts,
  });

  factory ClockOutResultModel.fromJson(Map<String, dynamic> json) {
    return ClockOutResultModel(
      message: json['message'] as String? ?? '',
      clockOutTime: _parseDateTime(json['clockOutTime']),
      totalWorkedMinutes: _parseInt(json['totalWorkedMinutes']),
      isFinalDay: json['isFinalDay'] == true,
      hasMoreShifts: json['hasMoreShifts'] == true,
    );
  }
}

DateTime? _parseDateTime(dynamic value) {
  if (value == null) {
    return null;
  }
  if (value is String) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    return DateTime.tryParse(trimmed);
  }
  return null;
}

int? _parseInt(dynamic value) {
  if (value == null) {
    return null;
  }
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  if (value is String) {
    return int.tryParse(value);
  }
  return null;
}
