import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:domain/domain.dart';

part 'child_dto.freezed.dart';
part 'child_dto.g.dart';

@freezed
abstract class ChildDto with _$ChildDto {
  const factory ChildDto({
    String? id,
    String? firstName,
    String? lastName,
    int? age,
    String? specialNeedsDiagnosis,
    String? personalityDescription,
    String? medicationDietaryNeeds,
    String? routine,
    @Default(false) bool hasAllergies,
    @Default([]) List<String> allergyTypes,
    @Default(false) bool hasTriggers,
    @Default([]) List<String> triggerTypes,
    String? triggers,
    String? calmingMethods,
    @Default([]) List<String> transportationModes,
    @Default([]) List<String> equipmentSafety,
    @Default(false) bool needsDropoff,
    String? pickupLocation,
    String? dropoffLocation,
    String? transportSpecialInstructions,
  }) = _ChildDto;

  factory ChildDto.fromJson(Map<String, dynamic> json) =>
      _$ChildDtoFromJson(json);

  const ChildDto._();

  Child toDomain() => Child(
        id: id ?? '',
        firstName: firstName ?? '',
        lastName: lastName ?? '',
        age: age ?? 0,
        specialNeedsDiagnosis: specialNeedsDiagnosis ?? '',
        personalityDescription: personalityDescription ?? '',
        medicationDietaryNeeds: medicationDietaryNeeds ?? '',
        routine: routine ?? '',
        hasAllergies: hasAllergies,
        allergyTypes: allergyTypes,
        hasTriggers: hasTriggers,
        triggerTypes: triggerTypes,
        triggers: triggers ?? '',
        calmingMethods: calmingMethods ?? '',
        transportationModes: transportationModes,
        equipmentSafety: equipmentSafety,
        needsDropoff: needsDropoff,
        pickupLocation: pickupLocation ?? '',
        dropoffLocation: dropoffLocation ?? '',
        transportSpecialInstructions: transportSpecialInstructions ?? '',
      );
}
