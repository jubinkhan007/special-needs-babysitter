import 'package:equatable/equatable.dart';
import '../../entities/user.dart';
import 'child.dart';
import 'emergency_contact.dart';
import 'care_approach.dart';
import 'insurance_plan.dart';

class UserProfileDetails extends Equatable {
  final User user;
  final String familyName;
  final int numberOfFamilyMembers;
  final String familyBio;
  final bool hasPets;
  final int numberOfPets;
  final List<String> petTypes;
  final bool speaksOtherLanguages;
  final List<String> languages;
  final List<Child> children;
  final CareApproach? careApproach;
  final EmergencyContact? emergencyContact;
  final InsurancePlan? insurancePlan;

  const UserProfileDetails({
    required this.user,
    required this.familyName,
    required this.numberOfFamilyMembers,
    required this.familyBio,
    required this.hasPets,
    required this.numberOfPets,
    required this.petTypes,
    required this.speaksOtherLanguages,
    required this.languages,
    required this.children,
    this.careApproach,
    this.emergencyContact,
    this.insurancePlan,
  });

  @override
  List<Object?> get props => [
        user,
        familyName,
        numberOfFamilyMembers,
        familyBio,
        hasPets,
        numberOfPets,
        petTypes,
        speaksOtherLanguages,
        languages,
        children,
        careApproach,
        emergencyContact,
        insurancePlan,
      ];
}
