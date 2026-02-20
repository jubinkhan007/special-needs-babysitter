// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'child_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChildDto {

 String? get id; String? get firstName; String? get lastName; int? get age; String? get specialNeedsDiagnosis; String? get personalityDescription; String? get medicationDietaryNeeds; String? get routine; bool get hasAllergies; List<String> get allergyTypes; bool get hasTriggers; List<String> get triggerTypes; String? get triggers; String? get calmingMethods; List<String> get transportationModes; List<String> get equipmentSafety; bool get needsDropoff; String? get pickupLocation; String? get dropoffLocation; String? get transportSpecialInstructions;
/// Create a copy of ChildDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChildDtoCopyWith<ChildDto> get copyWith => _$ChildDtoCopyWithImpl<ChildDto>(this as ChildDto, _$identity);

  /// Serializes this ChildDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChildDto&&(identical(other.id, id) || other.id == id)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.age, age) || other.age == age)&&(identical(other.specialNeedsDiagnosis, specialNeedsDiagnosis) || other.specialNeedsDiagnosis == specialNeedsDiagnosis)&&(identical(other.personalityDescription, personalityDescription) || other.personalityDescription == personalityDescription)&&(identical(other.medicationDietaryNeeds, medicationDietaryNeeds) || other.medicationDietaryNeeds == medicationDietaryNeeds)&&(identical(other.routine, routine) || other.routine == routine)&&(identical(other.hasAllergies, hasAllergies) || other.hasAllergies == hasAllergies)&&const DeepCollectionEquality().equals(other.allergyTypes, allergyTypes)&&(identical(other.hasTriggers, hasTriggers) || other.hasTriggers == hasTriggers)&&const DeepCollectionEquality().equals(other.triggerTypes, triggerTypes)&&(identical(other.triggers, triggers) || other.triggers == triggers)&&(identical(other.calmingMethods, calmingMethods) || other.calmingMethods == calmingMethods)&&const DeepCollectionEquality().equals(other.transportationModes, transportationModes)&&const DeepCollectionEquality().equals(other.equipmentSafety, equipmentSafety)&&(identical(other.needsDropoff, needsDropoff) || other.needsDropoff == needsDropoff)&&(identical(other.pickupLocation, pickupLocation) || other.pickupLocation == pickupLocation)&&(identical(other.dropoffLocation, dropoffLocation) || other.dropoffLocation == dropoffLocation)&&(identical(other.transportSpecialInstructions, transportSpecialInstructions) || other.transportSpecialInstructions == transportSpecialInstructions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,firstName,lastName,age,specialNeedsDiagnosis,personalityDescription,medicationDietaryNeeds,routine,hasAllergies,const DeepCollectionEquality().hash(allergyTypes),hasTriggers,const DeepCollectionEquality().hash(triggerTypes),triggers,calmingMethods,const DeepCollectionEquality().hash(transportationModes),const DeepCollectionEquality().hash(equipmentSafety),needsDropoff,pickupLocation,dropoffLocation,transportSpecialInstructions]);

@override
String toString() {
  return 'ChildDto(id: $id, firstName: $firstName, lastName: $lastName, age: $age, specialNeedsDiagnosis: $specialNeedsDiagnosis, personalityDescription: $personalityDescription, medicationDietaryNeeds: $medicationDietaryNeeds, routine: $routine, hasAllergies: $hasAllergies, allergyTypes: $allergyTypes, hasTriggers: $hasTriggers, triggerTypes: $triggerTypes, triggers: $triggers, calmingMethods: $calmingMethods, transportationModes: $transportationModes, equipmentSafety: $equipmentSafety, needsDropoff: $needsDropoff, pickupLocation: $pickupLocation, dropoffLocation: $dropoffLocation, transportSpecialInstructions: $transportSpecialInstructions)';
}


}

/// @nodoc
abstract mixin class $ChildDtoCopyWith<$Res>  {
  factory $ChildDtoCopyWith(ChildDto value, $Res Function(ChildDto) _then) = _$ChildDtoCopyWithImpl;
@useResult
$Res call({
 String? id, String? firstName, String? lastName, int? age, String? specialNeedsDiagnosis, String? personalityDescription, String? medicationDietaryNeeds, String? routine, bool hasAllergies, List<String> allergyTypes, bool hasTriggers, List<String> triggerTypes, String? triggers, String? calmingMethods, List<String> transportationModes, List<String> equipmentSafety, bool needsDropoff, String? pickupLocation, String? dropoffLocation, String? transportSpecialInstructions
});




}
/// @nodoc
class _$ChildDtoCopyWithImpl<$Res>
    implements $ChildDtoCopyWith<$Res> {
  _$ChildDtoCopyWithImpl(this._self, this._then);

  final ChildDto _self;
  final $Res Function(ChildDto) _then;

/// Create a copy of ChildDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? firstName = freezed,Object? lastName = freezed,Object? age = freezed,Object? specialNeedsDiagnosis = freezed,Object? personalityDescription = freezed,Object? medicationDietaryNeeds = freezed,Object? routine = freezed,Object? hasAllergies = null,Object? allergyTypes = null,Object? hasTriggers = null,Object? triggerTypes = null,Object? triggers = freezed,Object? calmingMethods = freezed,Object? transportationModes = null,Object? equipmentSafety = null,Object? needsDropoff = null,Object? pickupLocation = freezed,Object? dropoffLocation = freezed,Object? transportSpecialInstructions = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,age: freezed == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int?,specialNeedsDiagnosis: freezed == specialNeedsDiagnosis ? _self.specialNeedsDiagnosis : specialNeedsDiagnosis // ignore: cast_nullable_to_non_nullable
as String?,personalityDescription: freezed == personalityDescription ? _self.personalityDescription : personalityDescription // ignore: cast_nullable_to_non_nullable
as String?,medicationDietaryNeeds: freezed == medicationDietaryNeeds ? _self.medicationDietaryNeeds : medicationDietaryNeeds // ignore: cast_nullable_to_non_nullable
as String?,routine: freezed == routine ? _self.routine : routine // ignore: cast_nullable_to_non_nullable
as String?,hasAllergies: null == hasAllergies ? _self.hasAllergies : hasAllergies // ignore: cast_nullable_to_non_nullable
as bool,allergyTypes: null == allergyTypes ? _self.allergyTypes : allergyTypes // ignore: cast_nullable_to_non_nullable
as List<String>,hasTriggers: null == hasTriggers ? _self.hasTriggers : hasTriggers // ignore: cast_nullable_to_non_nullable
as bool,triggerTypes: null == triggerTypes ? _self.triggerTypes : triggerTypes // ignore: cast_nullable_to_non_nullable
as List<String>,triggers: freezed == triggers ? _self.triggers : triggers // ignore: cast_nullable_to_non_nullable
as String?,calmingMethods: freezed == calmingMethods ? _self.calmingMethods : calmingMethods // ignore: cast_nullable_to_non_nullable
as String?,transportationModes: null == transportationModes ? _self.transportationModes : transportationModes // ignore: cast_nullable_to_non_nullable
as List<String>,equipmentSafety: null == equipmentSafety ? _self.equipmentSafety : equipmentSafety // ignore: cast_nullable_to_non_nullable
as List<String>,needsDropoff: null == needsDropoff ? _self.needsDropoff : needsDropoff // ignore: cast_nullable_to_non_nullable
as bool,pickupLocation: freezed == pickupLocation ? _self.pickupLocation : pickupLocation // ignore: cast_nullable_to_non_nullable
as String?,dropoffLocation: freezed == dropoffLocation ? _self.dropoffLocation : dropoffLocation // ignore: cast_nullable_to_non_nullable
as String?,transportSpecialInstructions: freezed == transportSpecialInstructions ? _self.transportSpecialInstructions : transportSpecialInstructions // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChildDto].
extension ChildDtoPatterns on ChildDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChildDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChildDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChildDto value)  $default,){
final _that = this;
switch (_that) {
case _ChildDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChildDto value)?  $default,){
final _that = this;
switch (_that) {
case _ChildDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String? firstName,  String? lastName,  int? age,  String? specialNeedsDiagnosis,  String? personalityDescription,  String? medicationDietaryNeeds,  String? routine,  bool hasAllergies,  List<String> allergyTypes,  bool hasTriggers,  List<String> triggerTypes,  String? triggers,  String? calmingMethods,  List<String> transportationModes,  List<String> equipmentSafety,  bool needsDropoff,  String? pickupLocation,  String? dropoffLocation,  String? transportSpecialInstructions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChildDto() when $default != null:
return $default(_that.id,_that.firstName,_that.lastName,_that.age,_that.specialNeedsDiagnosis,_that.personalityDescription,_that.medicationDietaryNeeds,_that.routine,_that.hasAllergies,_that.allergyTypes,_that.hasTriggers,_that.triggerTypes,_that.triggers,_that.calmingMethods,_that.transportationModes,_that.equipmentSafety,_that.needsDropoff,_that.pickupLocation,_that.dropoffLocation,_that.transportSpecialInstructions);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String? firstName,  String? lastName,  int? age,  String? specialNeedsDiagnosis,  String? personalityDescription,  String? medicationDietaryNeeds,  String? routine,  bool hasAllergies,  List<String> allergyTypes,  bool hasTriggers,  List<String> triggerTypes,  String? triggers,  String? calmingMethods,  List<String> transportationModes,  List<String> equipmentSafety,  bool needsDropoff,  String? pickupLocation,  String? dropoffLocation,  String? transportSpecialInstructions)  $default,) {final _that = this;
switch (_that) {
case _ChildDto():
return $default(_that.id,_that.firstName,_that.lastName,_that.age,_that.specialNeedsDiagnosis,_that.personalityDescription,_that.medicationDietaryNeeds,_that.routine,_that.hasAllergies,_that.allergyTypes,_that.hasTriggers,_that.triggerTypes,_that.triggers,_that.calmingMethods,_that.transportationModes,_that.equipmentSafety,_that.needsDropoff,_that.pickupLocation,_that.dropoffLocation,_that.transportSpecialInstructions);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String? firstName,  String? lastName,  int? age,  String? specialNeedsDiagnosis,  String? personalityDescription,  String? medicationDietaryNeeds,  String? routine,  bool hasAllergies,  List<String> allergyTypes,  bool hasTriggers,  List<String> triggerTypes,  String? triggers,  String? calmingMethods,  List<String> transportationModes,  List<String> equipmentSafety,  bool needsDropoff,  String? pickupLocation,  String? dropoffLocation,  String? transportSpecialInstructions)?  $default,) {final _that = this;
switch (_that) {
case _ChildDto() when $default != null:
return $default(_that.id,_that.firstName,_that.lastName,_that.age,_that.specialNeedsDiagnosis,_that.personalityDescription,_that.medicationDietaryNeeds,_that.routine,_that.hasAllergies,_that.allergyTypes,_that.hasTriggers,_that.triggerTypes,_that.triggers,_that.calmingMethods,_that.transportationModes,_that.equipmentSafety,_that.needsDropoff,_that.pickupLocation,_that.dropoffLocation,_that.transportSpecialInstructions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChildDto extends ChildDto {
  const _ChildDto({this.id, this.firstName, this.lastName, this.age, this.specialNeedsDiagnosis, this.personalityDescription, this.medicationDietaryNeeds, this.routine, this.hasAllergies = false, final  List<String> allergyTypes = const [], this.hasTriggers = false, final  List<String> triggerTypes = const [], this.triggers, this.calmingMethods, final  List<String> transportationModes = const [], final  List<String> equipmentSafety = const [], this.needsDropoff = false, this.pickupLocation, this.dropoffLocation, this.transportSpecialInstructions}): _allergyTypes = allergyTypes,_triggerTypes = triggerTypes,_transportationModes = transportationModes,_equipmentSafety = equipmentSafety,super._();
  factory _ChildDto.fromJson(Map<String, dynamic> json) => _$ChildDtoFromJson(json);

@override final  String? id;
@override final  String? firstName;
@override final  String? lastName;
@override final  int? age;
@override final  String? specialNeedsDiagnosis;
@override final  String? personalityDescription;
@override final  String? medicationDietaryNeeds;
@override final  String? routine;
@override@JsonKey() final  bool hasAllergies;
 final  List<String> _allergyTypes;
@override@JsonKey() List<String> get allergyTypes {
  if (_allergyTypes is EqualUnmodifiableListView) return _allergyTypes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allergyTypes);
}

@override@JsonKey() final  bool hasTriggers;
 final  List<String> _triggerTypes;
@override@JsonKey() List<String> get triggerTypes {
  if (_triggerTypes is EqualUnmodifiableListView) return _triggerTypes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_triggerTypes);
}

@override final  String? triggers;
@override final  String? calmingMethods;
 final  List<String> _transportationModes;
@override@JsonKey() List<String> get transportationModes {
  if (_transportationModes is EqualUnmodifiableListView) return _transportationModes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_transportationModes);
}

 final  List<String> _equipmentSafety;
@override@JsonKey() List<String> get equipmentSafety {
  if (_equipmentSafety is EqualUnmodifiableListView) return _equipmentSafety;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_equipmentSafety);
}

@override@JsonKey() final  bool needsDropoff;
@override final  String? pickupLocation;
@override final  String? dropoffLocation;
@override final  String? transportSpecialInstructions;

/// Create a copy of ChildDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChildDtoCopyWith<_ChildDto> get copyWith => __$ChildDtoCopyWithImpl<_ChildDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChildDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChildDto&&(identical(other.id, id) || other.id == id)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.age, age) || other.age == age)&&(identical(other.specialNeedsDiagnosis, specialNeedsDiagnosis) || other.specialNeedsDiagnosis == specialNeedsDiagnosis)&&(identical(other.personalityDescription, personalityDescription) || other.personalityDescription == personalityDescription)&&(identical(other.medicationDietaryNeeds, medicationDietaryNeeds) || other.medicationDietaryNeeds == medicationDietaryNeeds)&&(identical(other.routine, routine) || other.routine == routine)&&(identical(other.hasAllergies, hasAllergies) || other.hasAllergies == hasAllergies)&&const DeepCollectionEquality().equals(other._allergyTypes, _allergyTypes)&&(identical(other.hasTriggers, hasTriggers) || other.hasTriggers == hasTriggers)&&const DeepCollectionEquality().equals(other._triggerTypes, _triggerTypes)&&(identical(other.triggers, triggers) || other.triggers == triggers)&&(identical(other.calmingMethods, calmingMethods) || other.calmingMethods == calmingMethods)&&const DeepCollectionEquality().equals(other._transportationModes, _transportationModes)&&const DeepCollectionEquality().equals(other._equipmentSafety, _equipmentSafety)&&(identical(other.needsDropoff, needsDropoff) || other.needsDropoff == needsDropoff)&&(identical(other.pickupLocation, pickupLocation) || other.pickupLocation == pickupLocation)&&(identical(other.dropoffLocation, dropoffLocation) || other.dropoffLocation == dropoffLocation)&&(identical(other.transportSpecialInstructions, transportSpecialInstructions) || other.transportSpecialInstructions == transportSpecialInstructions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,firstName,lastName,age,specialNeedsDiagnosis,personalityDescription,medicationDietaryNeeds,routine,hasAllergies,const DeepCollectionEquality().hash(_allergyTypes),hasTriggers,const DeepCollectionEquality().hash(_triggerTypes),triggers,calmingMethods,const DeepCollectionEquality().hash(_transportationModes),const DeepCollectionEquality().hash(_equipmentSafety),needsDropoff,pickupLocation,dropoffLocation,transportSpecialInstructions]);

@override
String toString() {
  return 'ChildDto(id: $id, firstName: $firstName, lastName: $lastName, age: $age, specialNeedsDiagnosis: $specialNeedsDiagnosis, personalityDescription: $personalityDescription, medicationDietaryNeeds: $medicationDietaryNeeds, routine: $routine, hasAllergies: $hasAllergies, allergyTypes: $allergyTypes, hasTriggers: $hasTriggers, triggerTypes: $triggerTypes, triggers: $triggers, calmingMethods: $calmingMethods, transportationModes: $transportationModes, equipmentSafety: $equipmentSafety, needsDropoff: $needsDropoff, pickupLocation: $pickupLocation, dropoffLocation: $dropoffLocation, transportSpecialInstructions: $transportSpecialInstructions)';
}


}

/// @nodoc
abstract mixin class _$ChildDtoCopyWith<$Res> implements $ChildDtoCopyWith<$Res> {
  factory _$ChildDtoCopyWith(_ChildDto value, $Res Function(_ChildDto) _then) = __$ChildDtoCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? firstName, String? lastName, int? age, String? specialNeedsDiagnosis, String? personalityDescription, String? medicationDietaryNeeds, String? routine, bool hasAllergies, List<String> allergyTypes, bool hasTriggers, List<String> triggerTypes, String? triggers, String? calmingMethods, List<String> transportationModes, List<String> equipmentSafety, bool needsDropoff, String? pickupLocation, String? dropoffLocation, String? transportSpecialInstructions
});




}
/// @nodoc
class __$ChildDtoCopyWithImpl<$Res>
    implements _$ChildDtoCopyWith<$Res> {
  __$ChildDtoCopyWithImpl(this._self, this._then);

  final _ChildDto _self;
  final $Res Function(_ChildDto) _then;

/// Create a copy of ChildDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? firstName = freezed,Object? lastName = freezed,Object? age = freezed,Object? specialNeedsDiagnosis = freezed,Object? personalityDescription = freezed,Object? medicationDietaryNeeds = freezed,Object? routine = freezed,Object? hasAllergies = null,Object? allergyTypes = null,Object? hasTriggers = null,Object? triggerTypes = null,Object? triggers = freezed,Object? calmingMethods = freezed,Object? transportationModes = null,Object? equipmentSafety = null,Object? needsDropoff = null,Object? pickupLocation = freezed,Object? dropoffLocation = freezed,Object? transportSpecialInstructions = freezed,}) {
  return _then(_ChildDto(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,age: freezed == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int?,specialNeedsDiagnosis: freezed == specialNeedsDiagnosis ? _self.specialNeedsDiagnosis : specialNeedsDiagnosis // ignore: cast_nullable_to_non_nullable
as String?,personalityDescription: freezed == personalityDescription ? _self.personalityDescription : personalityDescription // ignore: cast_nullable_to_non_nullable
as String?,medicationDietaryNeeds: freezed == medicationDietaryNeeds ? _self.medicationDietaryNeeds : medicationDietaryNeeds // ignore: cast_nullable_to_non_nullable
as String?,routine: freezed == routine ? _self.routine : routine // ignore: cast_nullable_to_non_nullable
as String?,hasAllergies: null == hasAllergies ? _self.hasAllergies : hasAllergies // ignore: cast_nullable_to_non_nullable
as bool,allergyTypes: null == allergyTypes ? _self._allergyTypes : allergyTypes // ignore: cast_nullable_to_non_nullable
as List<String>,hasTriggers: null == hasTriggers ? _self.hasTriggers : hasTriggers // ignore: cast_nullable_to_non_nullable
as bool,triggerTypes: null == triggerTypes ? _self._triggerTypes : triggerTypes // ignore: cast_nullable_to_non_nullable
as List<String>,triggers: freezed == triggers ? _self.triggers : triggers // ignore: cast_nullable_to_non_nullable
as String?,calmingMethods: freezed == calmingMethods ? _self.calmingMethods : calmingMethods // ignore: cast_nullable_to_non_nullable
as String?,transportationModes: null == transportationModes ? _self._transportationModes : transportationModes // ignore: cast_nullable_to_non_nullable
as List<String>,equipmentSafety: null == equipmentSafety ? _self._equipmentSafety : equipmentSafety // ignore: cast_nullable_to_non_nullable
as List<String>,needsDropoff: null == needsDropoff ? _self.needsDropoff : needsDropoff // ignore: cast_nullable_to_non_nullable
as bool,pickupLocation: freezed == pickupLocation ? _self.pickupLocation : pickupLocation // ignore: cast_nullable_to_non_nullable
as String?,dropoffLocation: freezed == dropoffLocation ? _self.dropoffLocation : dropoffLocation // ignore: cast_nullable_to_non_nullable
as String?,transportSpecialInstructions: freezed == transportSpecialInstructions ? _self.transportSpecialInstructions : transportSpecialInstructions // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
