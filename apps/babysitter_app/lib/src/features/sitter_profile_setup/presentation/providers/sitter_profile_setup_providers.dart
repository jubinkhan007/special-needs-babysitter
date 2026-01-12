import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AvailabilityMode { singleDay, multipleDays }

class Experience {
  final String title;
  final String month;
  final String year;
  final String description;

  const Experience({
    this.title = '',
    this.month = '',
    this.year = '',
    this.description = '',
  });
}

class SitterProfileState {
  final String bio;
  final DateTime? dob;
  final List<String> ageGroups;
  final List<String> languages;
  final List<String> certifications;
  final List<String> skills;
  final String? yearsExperience;
  final bool hasReliableTransportation;
  final String? transportationDetails;
  final bool willingToTravel;
  final bool overnightStay;
  final String? address;
  final double? latitude;
  final double? longitude;
  final String? profilePhotoPath;
  final String? resumePath;
  final List<Experience> experiences;
  final Map<String, String> certAttachments;

  // Availability Fields
  final AvailabilityMode availabilityMode;
  final DateTime? singleDate;
  final DateTime? dateRangeStart;
  final DateTime? dateRangeEnd;
  final bool noBookings;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;

  // Hourly Rate Fields
  final double hourlyRate;
  final bool isRateNegotiable;

  const SitterProfileState({
    this.bio = '',
    this.dob,
    this.ageGroups = const [],
    this.languages = const [],
    this.certifications = const [],
    this.skills = const [],
    this.yearsExperience,
    this.hasReliableTransportation = false,
    this.transportationDetails,
    this.willingToTravel = false,
    this.overnightStay = false,
    this.address,
    this.latitude,
    this.longitude,
    this.profilePhotoPath,
    this.resumePath,
    this.experiences = const [],
    this.certAttachments = const {},
    this.availabilityMode = AvailabilityMode.singleDay,
    this.singleDate,
    this.dateRangeStart,
    this.dateRangeEnd,
    this.noBookings = false,
    this.startTime,
    this.endTime,
    this.hourlyRate = 15.0,
    this.isRateNegotiable = false,
  });

  SitterProfileState copyWith({
    String? bio,
    DateTime? dob,
    List<String>? ageGroups,
    List<String>? languages,
    List<String>? certifications,
    List<String>? skills,
    String? yearsExperience,
    bool? hasReliableTransportation,
    String? transportationDetails,
    bool? willingToTravel,
    bool? overnightStay,
    String? address,
    double? latitude,
    double? longitude,
    String? profilePhotoPath,
    String? resumePath,
    List<Experience>? experiences,
    Map<String, String>? certAttachments,
    AvailabilityMode? availabilityMode,
    DateTime? singleDate,
    DateTime? dateRangeStart,
    DateTime? dateRangeEnd,
    bool? noBookings,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    double? hourlyRate,
    bool? isRateNegotiable,
  }) {
    return SitterProfileState(
      bio: bio ?? this.bio,
      dob: dob ?? this.dob,
      ageGroups: ageGroups ?? this.ageGroups,
      languages: languages ?? this.languages,
      certifications: certifications ?? this.certifications,
      skills: skills ?? this.skills,
      yearsExperience: yearsExperience ?? this.yearsExperience,
      hasReliableTransportation:
          hasReliableTransportation ?? this.hasReliableTransportation,
      transportationDetails:
          transportationDetails ?? this.transportationDetails,
      willingToTravel: willingToTravel ?? this.willingToTravel,
      overnightStay: overnightStay ?? this.overnightStay,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      profilePhotoPath: profilePhotoPath ?? this.profilePhotoPath,
      resumePath: resumePath ?? this.resumePath,
      experiences: experiences ?? this.experiences,
      certAttachments: certAttachments ?? this.certAttachments,
      availabilityMode: availabilityMode ?? this.availabilityMode,
      singleDate: singleDate ?? this.singleDate,
      dateRangeStart: dateRangeStart ?? this.dateRangeStart,
      dateRangeEnd: dateRangeEnd ?? this.dateRangeEnd,
      noBookings: noBookings ?? this.noBookings,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      isRateNegotiable: isRateNegotiable ?? this.isRateNegotiable,
    );
  }
}

class SitterProfileSetupController extends StateNotifier<SitterProfileState> {
  SitterProfileSetupController() : super(const SitterProfileState());

  void updateProfilePhoto(String? path) {
    state = state.copyWith(profilePhotoPath: path);
  }

  void updateBio(String bio) {
    state = state.copyWith(bio: bio);
  }

  void updateDob(DateTime dob) {
    state = state.copyWith(dob: dob);
  }

  void toggleAgeGroup(String group) {
    final groups = List<String>.from(state.ageGroups);
    if (groups.contains(group)) {
      groups.remove(group);
    } else {
      groups.add(group);
    }
    state = state.copyWith(ageGroups: groups);
  }

  void updateLanguages(List<String> languages) {
    state = state.copyWith(languages: languages);
  }

  void addLanguage(String language) {
    final langs = List<String>.from(state.languages);
    if (!langs.contains(language)) {
      langs.add(language);
      state = state.copyWith(languages: langs);
    }
  }

  void removeLanguage(String language) {
    final langs = List<String>.from(state.languages);
    if (langs.contains(language)) {
      langs.remove(language);
      state = state.copyWith(languages: langs);
    }
  }

  void updateCertifications(List<String> certifications) {
    state = state.copyWith(certifications: certifications);
  }

  void addCertification(String certification) {
    final certs = List<String>.from(state.certifications);
    if (!certs.contains(certification)) {
      certs.add(certification);
      state = state.copyWith(certifications: certs);
    }
  }

  void removeCertification(String certification) {
    final certs = List<String>.from(state.certifications);
    if (certs.contains(certification)) {
      certs.remove(certification);
      state = state.copyWith(certifications: certs);
    }
  }

  void updateSkills(List<String> skills) {
    state = state.copyWith(skills: skills);
  }

  void addSkill(String skill) {
    final skills = List<String>.from(state.skills);
    if (!skills.contains(skill)) {
      skills.add(skill);
      state = state.copyWith(skills: skills);
    }
  }

  void removeSkill(String skill) {
    final skills = List<String>.from(state.skills);
    if (skills.contains(skill)) {
      skills.remove(skill);
      state = state.copyWith(skills: skills);
    }
  }

  void updateResumePath(String? path) {
    state = state.copyWith(resumePath: path);
  }

  void addExperience(Experience experience) {
    final exps = List<Experience>.from(state.experiences);
    exps.add(experience);
    state = state.copyWith(experiences: exps);
  }

  void removeExperience(int index) {
    if (index >= 0 && index < state.experiences.length) {
      final exps = List<Experience>.from(state.experiences);
      exps.removeAt(index);
      state = state.copyWith(experiences: exps);
    }
  }

  void updateExperience(int index, Experience experience) {
    if (index >= 0 && index < state.experiences.length) {
      final exps = List<Experience>.from(state.experiences);
      exps[index] = experience;
      state = state.copyWith(experiences: exps);
    }
  }

  void updateYearsExperience(String? years) {
    state = state.copyWith(yearsExperience: years);
  }

  void updateTransportation({bool? reliable, String? details}) {
    state = state.copyWith(
      hasReliableTransportation: reliable ?? state.hasReliableTransportation,
      transportationDetails: details ?? state.transportationDetails,
    );
  }

  void updateTravel({bool? willing, bool? overnight}) {
    state = state.copyWith(
      willingToTravel: willing ?? state.willingToTravel,
      overnightStay: overnight ?? state.overnightStay,
    );
  }

  void updateLocation({String? address, double? lat, double? lng}) {
    state = state.copyWith(
      address: address ?? state.address,
      latitude: lat ?? state.latitude,
      longitude: lng ?? state.longitude,
    );
  }

  void updateCertAttachment(String cert, String path) {
    final attachments = Map<String, String>.from(state.certAttachments);
    attachments[cert] = path;
    state = state.copyWith(certAttachments: attachments);
  }

  void setAvailabilityMode(AvailabilityMode mode) {
    state = state.copyWith(availabilityMode: mode);
  }

  void updateSingleDate(DateTime date) {
    state = state.copyWith(singleDate: date);
  }

  void updateDateRange({DateTime? start, DateTime? end}) {
    state = state.copyWith(
      dateRangeStart: start ?? state.dateRangeStart,
      dateRangeEnd: end ?? state.dateRangeEnd,
    );
  }

  void toggleNoBookings(bool value) {
    state = state.copyWith(noBookings: value);
  }

  void updateTime({TimeOfDay? start, TimeOfDay? end}) {
    state = state.copyWith(
      startTime: start ?? state.startTime,
      endTime: end ?? state.endTime,
    );
  }

  void updateHourlyRate(double rate) {
    state = state.copyWith(hourlyRate: rate);
  }

  void toggleRateNegotiable(bool value) {
    state = state.copyWith(isRateNegotiable: value);
  }

  /// Submits the sitter profile to the backend.
  /// Returns true on success, false on failure.
  Future<bool> submitSitterProfile() async {
    // TODO: Replace with actual API call
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    // Simulate success (return false to test error handling)
    return true;
  }
}

final sitterProfileSetupControllerProvider =
    StateNotifierProvider<SitterProfileSetupController, SitterProfileState>(
        (ref) {
  return SitterProfileSetupController();
});
