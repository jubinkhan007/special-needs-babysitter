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
    print('DEBUG: RepoImpl profileData: $profileData');

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
      print('DEBUG: Mapping child row: $c');
      try {
        return Child(
          id: (c['id'] ?? '').toString(),
          firstName: (c['firstName'] ?? c['first_name'] ?? '').toString(),
          lastName: (c['lastName'] ?? c['last_name'] ?? '').toString(),
          age: int.tryParse(c['age']?.toString() ?? '0') ?? 0,
          specialNeedsDiagnosis:
              c['specialNeedsDiagnosis'] ?? c['special_needs_diagnosis'] ?? '',
          personalityDescription:
              c['personalityDescription'] ?? c['personality_description'] ?? '',
          medicationDietaryNeeds: c['medicationDietaryNeeds'] ??
              c['medication_dietary_needs'] ??
              '',
          routine: c['routine'] ?? '',
          hasAllergies: c['hasAllergies'] ?? c['has_allergies'] ?? false,
          allergyTypes: (c['allergyTypes'] is List)
              ? (c['allergyTypes'] as List)
                  .where((e) => e != null)
                  .map((e) => e.toString())
                  .toList()
              : (c['allergy_types'] is List)
                  ? (c['allergy_types'] as List)
                      .where((e) => e != null)
                      .map((e) => e.toString())
                      .toList()
                  : [],
          hasTriggers: c['hasTriggers'] ?? c['has_triggers'] ?? false,
          triggerTypes: (c['triggerTypes'] is List)
              ? (c['triggerTypes'] as List)
                  .where((e) => e != null)
                  .map((e) => e.toString())
                  .toList()
              : (c['trigger_types'] is List)
                  ? (c['trigger_types'] as List)
                      .where((e) => e != null)
                      .map((e) => e.toString())
                      .toList()
                  : [],
          calmingMethods: c['calmingMethods'] ?? c['calming_methods'] ?? '',
          triggers: c['triggers'] ?? '',
          transportationModes: (c['transportationModes'] is List)
              ? (c['transportationModes'] as List)
                  .where((e) => e != null)
                  .map((e) => e.toString())
                  .toList()
              : (c['transportation_modes'] is List)
                  ? (c['transportation_modes'] as List)
                      .where((e) => e != null)
                      .map((e) => e.toString())
                      .toList()
                  : [],
          equipmentSafety: (c['equipmentSafety'] is List)
              ? (c['equipmentSafety'] as List)
                  .where((e) => e != null)
                  .map((e) => e.toString())
                  .toList()
              : (c['equipment_safety'] is List)
                  ? (c['equipment_safety'] as List)
                      .where((e) => e != null)
                      .map((e) => e.toString())
                      .toList()
                  : [],
          needsDropoff: c['needsDropoff'] ?? c['needs_dropoff'] ?? false,
          pickupLocation: c['pickupLocation'] ?? c['pickup_location'] ?? '',
          dropoffLocation: c['dropoffLocation'] ?? c['dropoff_location'] ?? '',
          transportSpecialInstructions: c['transportSpecialInstructions'] ??
              c['transport_special_instructions'] ??
              '',
        );
      } catch (e, stack) {
        print('ERROR: Failed mapping child: $e');
        print('DEBUG: Problematic child data: $c');
        print('DEBUG: Stack trace: $stack');
        rethrow;
      }
    }).toList();
    print('DEBUG: RepoImpl children mapped: ${children.length}');

    // Map CareApproach (Derived from first child as per UI/Data structure limitation)
    CareApproach? careApproach;
    if (childrenList.isNotEmpty) {
      final firstChild = childrenList.first;
      final transportModes = (firstChild['transportationModes'] is List)
          ? (firstChild['transportationModes'] as List)
              .where((e) => e != null)
              .map((e) => e.toString())
              .toList()
          : [];

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
      languages: (profileData['languages'] is List)
          ? (profileData['languages'] as List)
              .where((e) => e != null)
              .map((e) => e.toString())
              .toList()
          : [],
      familyName: profileData['familyName'] ?? '',
      hasPets: profileData['hasPets'] ?? false,
      petTypes: (profileData['petTypes'] is List)
          ? (profileData['petTypes'] as List)
              .where((e) => e != null)
              .map((e) => e.toString())
              .toList()
          : [],
      speaksOtherLanguages: profileData['speaksOtherLanguages'] ?? false,
    );
  }

  @override
  Future<void> updateProfileDetails(String userId, Map<String, dynamic> data,
      {int step = 1,}) async {
    await _remoteDataSource.updateProfileDetails(data, step: step);
  }

  Map<String, dynamic> _prepareChildPayload(Map<String, dynamic> data) {
    // Sending both snake_case and camelCase to ensure backend compatibility
    // and avoid "received undefined" errors if naming conventions are mixed.
    return {
      // Identity
      'first_name': data['firstName'],
      'firstName': data['firstName'],
      'last_name': data['lastName'],
      'lastName': data['lastName'],
      'age': data['age'],

      // Special Needs
      'special_needs_diagnosis': data['specialNeedsDiagnosis'],
      'specialNeedsDiagnosis': data['specialNeedsDiagnosis'],
      'personality_description': data['personalityDescription'],
      'personalityDescription': data['personalityDescription'],
      'medication_dietary_needs': data['medicationDietaryNeeds'],
      'medicationDietaryNeeds': data['medicationDietaryNeeds'],
      'routine': data['routine'],
      // routine is same

      // Allergies
      'has_allergies': data['hasAllergies'],
      'hasAllergies': data['hasAllergies'],
      'allergy_types': data['allergyTypes'],
      'allergyTypes': data['allergyTypes'],
      'allergies': data['allergyTypes'], // Common alias

      // Triggers
      'has_triggers': data['hasTriggers'],
      'hasTriggers': data['hasTriggers'],
      'trigger_types': data['triggerTypes'],
      'triggerTypes': data['triggerTypes'],
      'triggers': data['triggers'],
      'trigger_description': data['triggers'], // Alias for description

      // Calming
      'calming_methods': data['calmingMethods'],
      'calmingMethods': data['calmingMethods'],

      // Transport & Equipment
      'transportation_modes': data['transportationModes'],
      'transportationModes': data['transportationModes'],
      'equipment_safety': data['equipmentSafety'],
      'equipmentSafety': data['equipmentSafety'],
      'needs_dropoff': data['needsDropoff'],
      'needsDropoff': data['needsDropoff'],
      'pickup_location': data['pickupLocation'],
      'pickupLocation': data['pickupLocation'],
      'pickup_address': data['pickupLocation'], // Alias
      'dropoff_location': data['dropoffLocation'],
      'dropoffLocation': data['dropoffLocation'],
      'dropoff_address': data['dropoffLocation'], // Alias
      'transport_special_instructions': data['transportSpecialInstructions'],
      'transportSpecialInstructions': data['transportSpecialInstructions'],
    }..removeWhere((key, value) => value == null);
  }

  @override
  Future<void> addChild(Map<String, dynamic> childData) async {
    await _remoteDataSource.addChild(_prepareChildPayload(childData));
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
      id: (c['id'] ?? '').toString(),
      firstName: (c['firstName'] ?? c['first_name'] ?? '').toString(),
      lastName: (c['lastName'] ?? c['last_name'] ?? '').toString(),
      age: int.tryParse(c['age']?.toString() ?? '0') ?? 0,
      specialNeedsDiagnosis:
          c['specialNeedsDiagnosis'] ?? c['special_needs_diagnosis'] ?? '',
      personalityDescription:
          c['personalityDescription'] ?? c['personality_description'] ?? '',
      medicationDietaryNeeds:
          c['medicationDietaryNeeds'] ?? c['medication_dietary_needs'] ?? '',
      routine: c['routine'] ?? '',
      hasAllergies: c['hasAllergies'] ?? c['has_allergies'] ?? false,
      allergyTypes: (c['allergyTypes'] is List)
          ? (c['allergyTypes'] as List)
              .where((e) => e != null)
              .map((e) => e.toString())
              .toList()
          : (c['allergy_types'] is List)
              ? (c['allergy_types'] as List)
                  .where((e) => e != null)
                  .map((e) => e.toString())
                  .toList()
              : [],
      hasTriggers: c['hasTriggers'] ?? c['has_triggers'] ?? false,
      triggerTypes: (c['triggerTypes'] is List)
          ? (c['triggerTypes'] as List)
              .where((e) => e != null)
              .map((e) => e.toString())
              .toList()
          : (c['trigger_types'] is List)
              ? (c['trigger_types'] as List)
                  .where((e) => e != null)
                  .map((e) => e.toString())
                  .toList()
              : [],
      calmingMethods: c['calmingMethods'] ?? c['calming_methods'] ?? '',
      triggers: c['triggers'] ?? '',
      transportationModes: (c['transportationModes'] is List)
          ? (c['transportationModes'] as List)
              .where((e) => e != null)
              .map((e) => e.toString())
              .toList()
          : (c['transportation_modes'] is List)
              ? (c['transportation_modes'] as List)
                  .where((e) => e != null)
                  .map((e) => e.toString())
                  .toList()
              : [],
      equipmentSafety: (c['equipmentSafety'] is List)
          ? (c['equipmentSafety'] as List)
              .where((e) => e != null)
              .map((e) => e.toString())
              .toList()
          : (c['equipment_safety'] is List)
              ? (c['equipment_safety'] as List)
                  .where((e) => e != null)
                  .map((e) => e.toString())
                  .toList()
              : [],
      needsDropoff: c['needsDropoff'] ?? c['needs_dropoff'] ?? false,
      pickupLocation: c['pickupLocation'] ?? c['pickup_location'] ?? '',
      dropoffLocation: c['dropoffLocation'] ?? c['dropoff_location'] ?? '',
      transportSpecialInstructions: c['transportSpecialInstructions'] ??
          c['transport_special_instructions'] ??
          '',
    );
  }

  @override
  Future<void> updateChild(
      String childId, Map<String, dynamic> childData,) async {
    await _remoteDataSource.updateChild(
        childId, _prepareChildPayload(childData),);
  }

  @override
  Future<void> deleteChild(String childId) async {
    await _remoteDataSource.deleteChild(childId);
  }
}
