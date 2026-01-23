import 'package:flutter/material.dart';

class SearchFilterUiModel {
  final double radius;
  final String? specialNeedsExpertise;
  final double hourlyRate;
  final DateTime? date;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final List<String> selectedExpertise;
  final List<String> selectedLanguages;
  final String? otherLanguage;
  final double latitude;
  final double longitude;

  const SearchFilterUiModel({
    this.radius = 10.0,
    this.specialNeedsExpertise,
    this.hourlyRate = 25.0,
    this.date,
    this.startTime,
    this.endTime,
    this.selectedExpertise = const [],
    this.selectedLanguages = const [],
    this.otherLanguage,
    this.latitude = 36.1627, // Default Nashville latitude
    this.longitude = -86.7816, // Default Nashville longitude
  });

  SearchFilterUiModel copyWith({
    double? radius,
    String? specialNeedsExpertise,
    double? hourlyRate,
    DateTime? date,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    List<String>? selectedExpertise,
    List<String>? selectedLanguages,
    String? otherLanguage,
    double? latitude,
    double? longitude,
  }) {
    return SearchFilterUiModel(
      radius: radius ?? this.radius,
      specialNeedsExpertise:
          specialNeedsExpertise ?? this.specialNeedsExpertise,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      selectedExpertise: selectedExpertise ?? this.selectedExpertise,
      selectedLanguages: selectedLanguages ?? this.selectedLanguages,
      otherLanguage: otherLanguage ?? this.otherLanguage,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}
