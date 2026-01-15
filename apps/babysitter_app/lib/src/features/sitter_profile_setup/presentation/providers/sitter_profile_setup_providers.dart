import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:domain/domain.dart';
import 'package:data/data.dart';
import 'package:auth/auth.dart';
import 'package:intl/intl.dart';

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

  /// Saves the current step to the backend.
  /// Returns true on success, false on failure.
  Future<bool> saveStep(int step, SitterProfileRepository repository) async {
    try {
      final data = _buildPayloadForStep(step);

      // Get files for upload if applicable
      File? profilePhoto;
      File? resume;
      List<CertificationFile>? certFiles;

      if (step == 1 && state.profilePhotoPath != null) {
        profilePhoto = File(state.profilePhotoPath!);
      }
      if (step == 5 && state.resumePath != null) {
        resume = File(state.resumePath!);
      }
      if (step == 6 && state.certAttachments.isNotEmpty) {
        certFiles = state.certAttachments.entries.map((e) {
          return CertificationFile(type: e.key, file: File(e.value));
        }).toList();
      }

      await repository.updateProfile(
        step: step,
        data: data,
        profilePhoto: profilePhoto,
        resume: resume,
        certificationFiles: certFiles,
      );

      return true;
    } catch (e) {
      print('DEBUG: saveStep($step) failed: $e');
      return false;
    }
  }

  /// Submits the final profile (Step 9).
  Future<bool> submitSitterProfile(SitterProfileRepository repository) async {
    return saveStep(9, repository);
  }

  /// Builds the API payload for a specific step.
  Map<String, dynamic> _buildPayloadForStep(int step) {
    switch (step) {
      case 1:
        // Photo URL is added by repository after upload
        return {};
      case 2:
        return {
          'bio': state.bio,
          'dateOfBirth': state.dob != null
              ? DateFormat('yyyy-MM-dd').format(state.dob!)
              : null,
          'yearsOfExperience': state.yearsExperience,
          'hasTransportation': state.hasReliableTransportation,
          'transportationDetails': state.transportationDetails ?? '',
          'willingToTravel': state.willingToTravel,
          'overnight': state.overnightStay,
          'ageRanges': state.ageGroups,
          'languages': state.languages,
        };
      case 3:
        return {
          'address': state.address,
          'latitude': state.latitude,
          'longitude': state.longitude,
        };
      case 4:
        return {
          'skills': state.skills,
          'certifications': state.certifications,
        };
      case 5:
        // Resume URL is added by repository after upload
        return {
          'experiences': state.experiences
              .map((e) => {
                    'role': e.title,
                    'startMonth': e.month,
                    'startYear': e.year,
                    'endMonth': 'Present',
                    'endYear': '',
                    'description': e.description,
                  })
              .toList(),
        };
      case 6:
        // Certification documents are added by repository after upload
        return {};
      case 7:
        // Build availability array
        final List<Map<String, dynamic>> availability = [];

        String formatTime(TimeOfDay? time) {
          if (time == null) return '09:00';
          return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
        }

        if (state.availabilityMode == AvailabilityMode.singleDay &&
            state.singleDate != null) {
          availability.add({
            'date': DateFormat('yyyy-MM-dd').format(state.singleDate!),
            'startTime': formatTime(state.startTime),
            'endTime': formatTime(state.endTime),
            'noBookings': state.noBookings,
          });
        } else if (state.dateRangeStart != null && state.dateRangeEnd != null) {
          // Add each date in range
          var current = state.dateRangeStart!;
          while (!current.isAfter(state.dateRangeEnd!)) {
            availability.add({
              'date': DateFormat('yyyy-MM-dd').format(current),
              'startTime': formatTime(state.startTime),
              'endTime': formatTime(state.endTime),
              'noBookings': state.noBookings,
            });
            current = current.add(const Duration(days: 1));
          }
        }

        return {'availability': availability};
      case 8:
        return {
          'hourlyRate': state.hourlyRate.toInt(),
          'openToNegotiating': state.isRateNegotiable,
        };
      case 9:
        return {}; // Empty payload for final submission
      default:
        return {};
    }
  }
}

// ============ PROVIDERS ============

/// Dio provider with auth interceptor for sitter profile API calls.
final sitterProfileDioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://babysitter-backend.waywisetech.com/api',
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));

  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      final authState = ref.read(authNotifierProvider);
      var session = authState.valueOrNull;

      if (session == null) {
        final storedToken =
            await ref.read(sessionStoreProvider).getAccessToken();
        if (storedToken != null && storedToken.isNotEmpty) {
          options.headers['Cookie'] = 'session_id=$storedToken';
        }
      } else {
        options.headers['Cookie'] = 'session_id=${session.accessToken}';
      }

      print('DEBUG SITTER: ${options.method} ${options.uri}');
      return handler.next(options);
    },
  ));

  return dio;
});

/// Remote data source provider.
final sitterProfileRemoteDataSourceProvider =
    Provider<SitterProfileRemoteDataSource>((ref) {
  final dio = ref.watch(sitterProfileDioProvider);
  return SitterProfileRemoteDataSource(dio);
});

/// Repository provider.
final sitterProfileRepositoryProvider =
    Provider<SitterProfileRepository>((ref) {
  final dataSource = ref.watch(sitterProfileRemoteDataSourceProvider);
  return SitterProfileRepositoryImpl(dataSource);
});

/// Main controller provider.
final sitterProfileSetupControllerProvider =
    StateNotifierProvider<SitterProfileSetupController, SitterProfileState>(
        (ref) {
  return SitterProfileSetupController();
});
