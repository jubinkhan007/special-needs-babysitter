import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../dtos/job_dto.dart';

class JobLocalDataSource {
  static const _draftKey = 'job_draft';

  Future<void> saveDraft(JobDto jobDto) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = jsonEncode(jobDto.toJson());
    await prefs.setString(_draftKey, jsonStr);
  }

  Future<JobDto?> getDraft() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_draftKey);
    if (jsonStr == null) return null;

    try {
      final jsonMap = jsonDecode(jsonStr) as Map<String, dynamic>;
      return JobDto.fromJson(jsonMap);
    } catch (_) {
      return null;
    }
  }

  Future<void> clearDraft() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_draftKey);
  }
}
