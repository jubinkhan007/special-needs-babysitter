import 'dart:io';
import 'package:domain/domain.dart';
import '../datasources/profile_details_remote_datasource.dart';

class ProfileDetailsRepositoryImpl implements ProfileDetailsRepository {
  final ProfileDetailsRemoteDataSource _remoteDataSource;
  final AccountRepository
      _accountRepository; // Reuse for getting basic user info

  ProfileDetailsRepositoryImpl(this._remoteDataSource, this._accountRepository);

  @override
  Future<UserProfileDetails> getProfileDetails(String userId) async {
    // Fetch basic account info (User entity)
    final accountOverview = await _accountRepository.getAccountOverview(userId);
    var user = accountOverview.user;

    // Fetch extended details
    print('DEBUG: RepoImpl fetching extended details...');
    final data = await _remoteDataSource.getExtendedProfileDetails(userId);
    print('DEBUG: RepoImpl raw data received: $data');

    // Map from "data" root
    // Handle null profile safely
    final profileData = (data['profile'] as Map<String, dynamic>?) ?? {};

    // Use photoUrl from profile if available (fresher than account repo?)
    final photoUrl = profileData['photoUrl'] as String?;
    if (photoUrl != null && photoUrl.isNotEmpty) {
      user = user.copyWith(avatarUrl: photoUrl);
    }
    final childrenList = data['children'] as List<dynamic>? ?? [];
    final emergencyContactData =
        data['emergencyContact'] as Map<String, dynamic>?;
    final insurancePlans = data['insurancePlans'] as List<dynamic>? ?? [];

    print('DEBUG: RepoImpl mapping children...');
    // Map children
    final children = childrenList.map((c) {
      try {
        return Child(
          id: c['id'],
          firstName: c['firstName'],
          lastName: c['lastName'],
          age: c['age'],
          specialNeedsDiagnosis: c['specialNeedsDiagnosis'] ?? '',
          personalityDescription: c['personalityDescription'] ?? '',
          medicationDietaryNeeds: c['medicationDietaryNeeds'] ?? '',
          routine: c['routine'] ?? '',
          hasAllergies: c['hasAllergies'] ?? false,
          allergyTypes:
              (c['allergyTypes'] as List<dynamic>?)?.cast<String>() ?? [],
          hasTriggers: c['hasTriggers'] ?? false,
          triggerTypes:
              (c['triggerTypes'] as List<dynamic>?)?.cast<String>() ?? [],
          calmingMethods: c['calmingMethods'] ?? '',
          triggers: c['triggers'] ?? '',
          transportationModes:
              (c['transportationModes'] as List<dynamic>?)?.cast<String>() ??
                  [],
          equipmentSafety:
              (c['equipmentSafety'] as List<dynamic>?)?.cast<String>() ?? [],
          needsDropoff: c['needsDropoff'] ?? false,
          pickupLocation: c['pickupLocation'] ?? '',
          dropoffLocation: c['dropoffLocation'] ?? '',
          transportSpecialInstructions: c['transportSpecialInstructions'] ?? '',
        );
      } catch (e) {
        print('DEBUG: Error mapping child: $e');
        rethrow;
      }
    }).toList();
    print('DEBUG: RepoImpl children mapped: ${children.length}');

    // Map CareApproach (Derived from first child as per UI/Data structure limitation)
    CareApproach? careApproach;
    if (childrenList.isNotEmpty) {
      final firstChild = childrenList.first;
      final transportModes =
          (firstChild['transportationModes'] as List<dynamic>?)
                  ?.cast<String>() ??
              [];

      careApproach = CareApproach(
        // Use personality description as general description if not available elsewhere
        description: firstChild['personalityDescription'] ?? '',
        transportationNeeds: transportModes.join(', '),
        needsPickupFromSchool: firstChild['needsDropoff'] ?? false,
        needsDropOffAtTherapy: firstChild['needsDropoff'] ??
            false, // Assuming singular flag covers both or partial
        pickupDropOffRequirements:
            'Pickup: ${firstChild['pickupLocation'] ?? 'N/A'}\nDropoff: ${firstChild['dropoffLocation'] ?? 'N/A'}',
        specialAccommodations: firstChild['transportSpecialInstructions'] ?? '',
      );
    }

    // Map EmergencyContact
    EmergencyContact? emergencyContact;
    if (emergencyContactData != null) {
      emergencyContact = EmergencyContact(
        fullName: emergencyContactData['fullName'] ?? '',
        relationshipToChild: emergencyContactData['relationshipToChild'] ?? '',
        phoneNumber: emergencyContactData['primaryPhone'] ?? '',
        email: emergencyContactData['email'] ?? '',
        address: emergencyContactData['address'] ?? '',
        specialInstructions: emergencyContactData['specialInstructions'] ?? '',
      );
    }

    // Map InsurancePlan (Take first active if available)
    InsurancePlan? insurancePlan;
    if (insurancePlans.isNotEmpty) {
      final plan = insurancePlans.first;
      insurancePlan = InsurancePlan(
        planName: plan['planName'] ?? '',
        insuranceType: plan['insuranceType'] ?? '',
        coverageAmount: (plan['coverageAmount'] as num?)?.toDouble() ?? 0.0,
        monthlyPremium: (plan['monthlyPremium'] as num?)?.toDouble() ?? 0.0,
        yearlyPremium: (plan['yearlyPremium'] as num?)?.toDouble() ?? 0.0,
        description: plan['description'] ?? '',
        isActive: plan['isActive'] ?? false,
      );
    }

    return UserProfileDetails(
      user: user,
      children: children,
      careApproach: careApproach,
      emergencyContact: emergencyContact,
      insurancePlan: insurancePlan,
      numberOfFamilyMembers: profileData['numberOfFamilyMembers'] ?? 0,
      familyBio: profileData['familyBio'] ?? '',
      numberOfPets: profileData['numberOfPets'] ?? 0,
      languages:
          (profileData['languages'] as List<dynamic>?)?.cast<String>() ?? [],
      familyName: profileData['familyName'] ?? '',
      hasPets: profileData['hasPets'] ?? false,
      petTypes:
          (profileData['petTypes'] as List<dynamic>?)?.cast<String>() ?? [],
      speaksOtherLanguages: profileData['speaksOtherLanguages'] ?? false,
    );
  }

  @override
  Future<void> updateProfileDetails(String userId, Map<String, dynamic> data,
      {int step = 1}) async {
    await _remoteDataSource.updateProfileDetails(data, step: step);
  }

  @override
  Future<void> addChild(Map<String, dynamic> childData) async {
    await _remoteDataSource.addChild(childData);
  }

  @override
  Future<String> uploadProfilePhoto(File file) async {
    const fileName =
        'profile_photo.jpg'; // Simple name, backend likely uniquely names it or key does
    const contentType = 'image/jpeg'; // Assuming jpeg for now from picker

    final presignedResponse = await _remoteDataSource.getPresignedUrl(
      fileName: fileName,
      contentType: contentType,
    );

    await _remoteDataSource.uploadFileToUrl(
      presignedResponse.uploadUrl,
      file,
      contentType,
    );

    return presignedResponse.publicUrl;
  }

  @override
  Future<Child> getChild(String childId) async {
    final c = await _remoteDataSource.getChild(childId);
    return Child(
      id: c['id'],
      firstName: c['firstName'],
      lastName: c['lastName'],
      age: c['age'],
      specialNeedsDiagnosis: c['specialNeedsDiagnosis'] ?? '',
      personalityDescription: c['personalityDescription'] ?? '',
      medicationDietaryNeeds: c['medicationDietaryNeeds'] ?? '',
      routine: c['routine'] ?? '',
      hasAllergies: c['hasAllergies'] ?? false,
      allergyTypes: (c['allergyTypes'] as List<dynamic>?)?.cast<String>() ?? [],
      hasTriggers: c['hasTriggers'] ?? false,
      triggerTypes: (c['triggerTypes'] as List<dynamic>?)?.cast<String>() ?? [],
      calmingMethods: c['calmingMethods'] ?? '',
      triggers: c['triggers'] ?? '',
      transportationModes:
          (c['transportationModes'] as List<dynamic>?)?.cast<String>() ?? [],
      equipmentSafety:
          (c['equipmentSafety'] as List<dynamic>?)?.cast<String>() ?? [],
      needsDropoff: c['needsDropoff'] ?? false,
      pickupLocation: c['pickupLocation'] ?? '',
      dropoffLocation: c['dropoffLocation'] ?? '',
      transportSpecialInstructions: c['transportSpecialInstructions'] ?? '',
    );
  }

  @override
  Future<void> updateChild(
      String childId, Map<String, dynamic> childData) async {
    await _remoteDataSource.updateChild(childId, childData);
  }
}
