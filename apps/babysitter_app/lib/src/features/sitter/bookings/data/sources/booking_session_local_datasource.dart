import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/booking_session_model.dart';

class BookingSessionLocalDataSource {
  static const _cacheKey = 'sitter_active_booking_session_cache_v1';

  Future<void> saveSession(BookingSessionModel session) async {
    final prefs = await SharedPreferences.getInstance();
    final payload = jsonEncode(session.toJson());
    await prefs.setString(_cacheKey, payload);
  }

  Future<BookingSessionModel?> readSession() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_cacheKey);
    if (raw == null || raw.isEmpty) {
      return null;
    }
    try {
      final data = jsonDecode(raw) as Map<String, dynamic>;
      return BookingSessionModel.fromJson(data);
    } catch (_) {
      return null;
    }
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey);
  }
}
