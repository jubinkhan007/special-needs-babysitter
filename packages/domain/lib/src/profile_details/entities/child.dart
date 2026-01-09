import 'package:equatable/equatable.dart';

class Child extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final int age;
  final String specialNeedsDiagnosis;
  final String personalityDescription;
  final String medicationDietaryNeeds;
  final String routine;
  final bool hasAllergies;
  final List<String> allergyTypes;
  final bool hasTriggers;
  final List<String> triggerTypes;
  final String triggers;
  final String calmingMethods;
  final List<String> transportationModes;
  final List<String> equipmentSafety;
  final bool needsDropoff;
  final String pickupLocation;
  final String dropoffLocation;
  final String transportSpecialInstructions;

  const Child({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.specialNeedsDiagnosis,
    required this.personalityDescription,
    required this.medicationDietaryNeeds,
    required this.routine,
    required this.hasAllergies,
    required this.allergyTypes,
    required this.hasTriggers,
    required this.triggerTypes,
    required this.triggers,
    required this.calmingMethods,
    required this.transportationModes,
    required this.equipmentSafety,
    required this.needsDropoff,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.transportSpecialInstructions,
  });

  String get fullName => '$firstName $lastName';

  String get ageDisplay {
    if (age == 0)
      return '6 Months old'; // Mock case from screenshot for 0/small
    return '$age Years old';
  }

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        age,
        specialNeedsDiagnosis,
        personalityDescription,
        medicationDietaryNeeds,
        routine,
        hasAllergies,
        allergyTypes,
        hasTriggers,
        triggerTypes,
        triggers,
        calmingMethods,
        transportationModes,
        equipmentSafety,
        needsDropoff,
        pickupLocation,
        dropoffLocation,
        transportSpecialInstructions,
      ];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'age': age,
      'specialNeedsDiagnosis': specialNeedsDiagnosis,
      'personalityDescription': personalityDescription,
      'medicationDietaryNeeds': medicationDietaryNeeds,
      'routine': routine,
      'hasAllergies': hasAllergies,
      'allergyTypes': allergyTypes,
      'hasTriggers': hasTriggers,
      'triggerTypes': triggerTypes,
      'triggers': triggers,
      'calmingMethods': calmingMethods,
      'transportationModes': transportationModes,
      'equipmentSafety': equipmentSafety,
      'needsDropoff': needsDropoff,
      'pickupLocation': pickupLocation,
      'dropoffLocation': dropoffLocation,
      'transportSpecialInstructions': transportSpecialInstructions,
    };
  }
}
