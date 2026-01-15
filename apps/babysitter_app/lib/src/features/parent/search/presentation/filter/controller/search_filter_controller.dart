import 'package:flutter/material.dart';
import '../models/search_filter_ui_model.dart';

class SearchFilterController extends ValueNotifier<SearchFilterUiModel> {
  SearchFilterController() : super(const SearchFilterUiModel());

  void setRadius(double radius) {
    value = value.copyWith(radius: radius);
  }

  void setSpecialNeedsExpertise(String? expertise) {
    value = value.copyWith(specialNeedsExpertise: expertise);
  }

  void setHourlyRate(double rate) {
    value = value.copyWith(hourlyRate: rate);
  }

  void setDate(DateTime? date) {
    value = value.copyWith(date: date);
  }

  void setStartTime(TimeOfDay? time) {
    value = value.copyWith(startTime: time);
  }

  void setEndTime(TimeOfDay? time) {
    value = value.copyWith(endTime: time);
  }

  void toggleExpertise(String expertise) {
    final current = List<String>.from(value.selectedExpertise);
    if (current.contains(expertise)) {
      current.remove(expertise);
    } else {
      current.add(expertise);
    }
    value = value.copyWith(selectedExpertise: current);
  }

  void toggleLanguage(String language) {
    final current = List<String>.from(value.selectedLanguages);
    if (current.contains(language)) {
      current.remove(language);
    } else {
      current.add(language);
    }
    value = value.copyWith(selectedLanguages: current);
  }

  void setOtherLanguage(String? other) {
    value = value.copyWith(otherLanguage: other);
  }

  void reset() {
    value = const SearchFilterUiModel();
  }
}
