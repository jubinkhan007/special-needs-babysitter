import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Parsing logic test', () {
    final startDateStr = "2026-01-23";
    final startTimeStr = "02:30";
    
    // Logic from repository
    DateTime scheduledDate = DateTime.parse(startDateStr);
    DateTime? jobStartDateTime;
    
    final timeParts = startTimeStr.split(':');
    if (timeParts.length == 2) {
      jobStartDateTime = DateTime(
        scheduledDate.year,
        scheduledDate.month,
        scheduledDate.day,
        int.parse(timeParts[0]),
        int.parse(timeParts[1]),
      );
    }
    
    // Simulate "Now" as Jan 27, 2026
    final now = DateTime(2026, 1, 27, 10, 0, 0);
    
    final isPast = jobStartDateTime!.isBefore(now);
    
    print('Start: $jobStartDateTime');
    print('Now: $now');
    print('Is Past: $isPast');
    
    expect(isPast, true);
  });
}
