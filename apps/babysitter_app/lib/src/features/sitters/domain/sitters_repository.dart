import 'package:flutter/material.dart';
import '../../parent/home/presentation/models/home_mock_models.dart';
import '../../parent/search/models/sitter_list_item_model.dart';

abstract class SittersRepository {
  Future<List<SitterListItemModel>> fetchSitters({
    required double latitude,
    required double longitude,
    int limit = 20,
    int offset = 0,
    int? maxDistance,
    DateTime? date,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    String? name,
    List<String>? skills,
    double? minRate,
    double? maxRate,
    String? location,
  });
  Future<SitterModel> getSitterDetails(String id);
  Future<void> bookmarkSitter(String sitterId);
  Future<void> removeBookmarkedSitter(String sitterUserId);
  Future<List<SitterListItemModel>> getSavedSitters();
  Future<Map<String, dynamic>> getUserProfile(String userId);
}
