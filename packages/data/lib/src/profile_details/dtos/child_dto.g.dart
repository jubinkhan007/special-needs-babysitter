// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'child_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChildDtoImpl _$$ChildDtoImplFromJson(Map<String, dynamic> json) =>
    _$ChildDtoImpl(
      id: json['id'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      age: (json['age'] as num?)?.toInt(),
      specialNeedsDiagnosis: json['specialNeedsDiagnosis'] as String?,
      personalityDescription: json['personalityDescription'] as String?,
      medicationDietaryNeeds: json['medicationDietaryNeeds'] as String?,
      routine: json['routine'] as String?,
      hasAllergies: json['hasAllergies'] as bool? ?? false,
      allergyTypes: (json['allergyTypes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      hasTriggers: json['hasTriggers'] as bool? ?? false,
      triggerTypes: (json['triggerTypes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      triggers: json['triggers'] as String?,
      calmingMethods: json['calmingMethods'] as String?,
      transportationModes: (json['transportationModes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      equipmentSafety: (json['equipmentSafety'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      needsDropoff: json['needsDropoff'] as bool? ?? false,
      pickupLocation: json['pickupLocation'] as String?,
      dropoffLocation: json['dropoffLocation'] as String?,
      transportSpecialInstructions:
          json['transportSpecialInstructions'] as String?,
    );

Map<String, dynamic> _$$ChildDtoImplToJson(_$ChildDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'age': instance.age,
      'specialNeedsDiagnosis': instance.specialNeedsDiagnosis,
      'personalityDescription': instance.personalityDescription,
      'medicationDietaryNeeds': instance.medicationDietaryNeeds,
      'routine': instance.routine,
      'hasAllergies': instance.hasAllergies,
      'allergyTypes': instance.allergyTypes,
      'hasTriggers': instance.hasTriggers,
      'triggerTypes': instance.triggerTypes,
      'triggers': instance.triggers,
      'calmingMethods': instance.calmingMethods,
      'transportationModes': instance.transportationModes,
      'equipmentSafety': instance.equipmentSafety,
      'needsDropoff': instance.needsDropoff,
      'pickupLocation': instance.pickupLocation,
      'dropoffLocation': instance.dropoffLocation,
      'transportSpecialInstructions': instance.transportSpecialInstructions,
    };
