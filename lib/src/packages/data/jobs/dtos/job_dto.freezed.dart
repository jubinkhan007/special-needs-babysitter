// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'job_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$JobAddressDto implements DiagnosticableTreeMixin {

 String get streetAddress; String? get aptUnit;@JsonKey(fromJson: _cleanAddressField) String get city;@JsonKey(fromJson: _cleanAddressField) String get state;@JsonKey(fromJson: _toString) String get zipCode; double? get latitude; double? get longitude;
/// Create a copy of JobAddressDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JobAddressDtoCopyWith<JobAddressDto> get copyWith => _$JobAddressDtoCopyWithImpl<JobAddressDto>(this as JobAddressDto, _$identity);

  /// Serializes this JobAddressDto to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'JobAddressDto'))
    ..add(DiagnosticsProperty('streetAddress', streetAddress))..add(DiagnosticsProperty('aptUnit', aptUnit))..add(DiagnosticsProperty('city', city))..add(DiagnosticsProperty('state', state))..add(DiagnosticsProperty('zipCode', zipCode))..add(DiagnosticsProperty('latitude', latitude))..add(DiagnosticsProperty('longitude', longitude));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JobAddressDto&&(identical(other.streetAddress, streetAddress) || other.streetAddress == streetAddress)&&(identical(other.aptUnit, aptUnit) || other.aptUnit == aptUnit)&&(identical(other.city, city) || other.city == city)&&(identical(other.state, state) || other.state == state)&&(identical(other.zipCode, zipCode) || other.zipCode == zipCode)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,streetAddress,aptUnit,city,state,zipCode,latitude,longitude);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'JobAddressDto(streetAddress: $streetAddress, aptUnit: $aptUnit, city: $city, state: $state, zipCode: $zipCode, latitude: $latitude, longitude: $longitude)';
}


}

/// @nodoc
abstract mixin class $JobAddressDtoCopyWith<$Res>  {
  factory $JobAddressDtoCopyWith(JobAddressDto value, $Res Function(JobAddressDto) _then) = _$JobAddressDtoCopyWithImpl;
@useResult
$Res call({
 String streetAddress, String? aptUnit,@JsonKey(fromJson: _cleanAddressField) String city,@JsonKey(fromJson: _cleanAddressField) String state,@JsonKey(fromJson: _toString) String zipCode, double? latitude, double? longitude
});




}
/// @nodoc
class _$JobAddressDtoCopyWithImpl<$Res>
    implements $JobAddressDtoCopyWith<$Res> {
  _$JobAddressDtoCopyWithImpl(this._self, this._then);

  final JobAddressDto _self;
  final $Res Function(JobAddressDto) _then;

/// Create a copy of JobAddressDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? streetAddress = null,Object? aptUnit = freezed,Object? city = null,Object? state = null,Object? zipCode = null,Object? latitude = freezed,Object? longitude = freezed,}) {
  return _then(_self.copyWith(
streetAddress: null == streetAddress ? _self.streetAddress : streetAddress // ignore: cast_nullable_to_non_nullable
as String,aptUnit: freezed == aptUnit ? _self.aptUnit : aptUnit // ignore: cast_nullable_to_non_nullable
as String?,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,zipCode: null == zipCode ? _self.zipCode : zipCode // ignore: cast_nullable_to_non_nullable
as String,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [JobAddressDto].
extension JobAddressDtoPatterns on JobAddressDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JobAddressDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JobAddressDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JobAddressDto value)  $default,){
final _that = this;
switch (_that) {
case _JobAddressDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JobAddressDto value)?  $default,){
final _that = this;
switch (_that) {
case _JobAddressDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String streetAddress,  String? aptUnit, @JsonKey(fromJson: _cleanAddressField)  String city, @JsonKey(fromJson: _cleanAddressField)  String state, @JsonKey(fromJson: _toString)  String zipCode,  double? latitude,  double? longitude)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JobAddressDto() when $default != null:
return $default(_that.streetAddress,_that.aptUnit,_that.city,_that.state,_that.zipCode,_that.latitude,_that.longitude);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String streetAddress,  String? aptUnit, @JsonKey(fromJson: _cleanAddressField)  String city, @JsonKey(fromJson: _cleanAddressField)  String state, @JsonKey(fromJson: _toString)  String zipCode,  double? latitude,  double? longitude)  $default,) {final _that = this;
switch (_that) {
case _JobAddressDto():
return $default(_that.streetAddress,_that.aptUnit,_that.city,_that.state,_that.zipCode,_that.latitude,_that.longitude);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String streetAddress,  String? aptUnit, @JsonKey(fromJson: _cleanAddressField)  String city, @JsonKey(fromJson: _cleanAddressField)  String state, @JsonKey(fromJson: _toString)  String zipCode,  double? latitude,  double? longitude)?  $default,) {final _that = this;
switch (_that) {
case _JobAddressDto() when $default != null:
return $default(_that.streetAddress,_that.aptUnit,_that.city,_that.state,_that.zipCode,_that.latitude,_that.longitude);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JobAddressDto extends JobAddressDto with DiagnosticableTreeMixin {
  const _JobAddressDto({required this.streetAddress, this.aptUnit, @JsonKey(fromJson: _cleanAddressField) required this.city, @JsonKey(fromJson: _cleanAddressField) required this.state, @JsonKey(fromJson: _toString) required this.zipCode, this.latitude, this.longitude}): super._();
  factory _JobAddressDto.fromJson(Map<String, dynamic> json) => _$JobAddressDtoFromJson(json);

@override final  String streetAddress;
@override final  String? aptUnit;
@override@JsonKey(fromJson: _cleanAddressField) final  String city;
@override@JsonKey(fromJson: _cleanAddressField) final  String state;
@override@JsonKey(fromJson: _toString) final  String zipCode;
@override final  double? latitude;
@override final  double? longitude;

/// Create a copy of JobAddressDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JobAddressDtoCopyWith<_JobAddressDto> get copyWith => __$JobAddressDtoCopyWithImpl<_JobAddressDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JobAddressDtoToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'JobAddressDto'))
    ..add(DiagnosticsProperty('streetAddress', streetAddress))..add(DiagnosticsProperty('aptUnit', aptUnit))..add(DiagnosticsProperty('city', city))..add(DiagnosticsProperty('state', state))..add(DiagnosticsProperty('zipCode', zipCode))..add(DiagnosticsProperty('latitude', latitude))..add(DiagnosticsProperty('longitude', longitude));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JobAddressDto&&(identical(other.streetAddress, streetAddress) || other.streetAddress == streetAddress)&&(identical(other.aptUnit, aptUnit) || other.aptUnit == aptUnit)&&(identical(other.city, city) || other.city == city)&&(identical(other.state, state) || other.state == state)&&(identical(other.zipCode, zipCode) || other.zipCode == zipCode)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,streetAddress,aptUnit,city,state,zipCode,latitude,longitude);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'JobAddressDto(streetAddress: $streetAddress, aptUnit: $aptUnit, city: $city, state: $state, zipCode: $zipCode, latitude: $latitude, longitude: $longitude)';
}


}

/// @nodoc
abstract mixin class _$JobAddressDtoCopyWith<$Res> implements $JobAddressDtoCopyWith<$Res> {
  factory _$JobAddressDtoCopyWith(_JobAddressDto value, $Res Function(_JobAddressDto) _then) = __$JobAddressDtoCopyWithImpl;
@override @useResult
$Res call({
 String streetAddress, String? aptUnit,@JsonKey(fromJson: _cleanAddressField) String city,@JsonKey(fromJson: _cleanAddressField) String state,@JsonKey(fromJson: _toString) String zipCode, double? latitude, double? longitude
});




}
/// @nodoc
class __$JobAddressDtoCopyWithImpl<$Res>
    implements _$JobAddressDtoCopyWith<$Res> {
  __$JobAddressDtoCopyWithImpl(this._self, this._then);

  final _JobAddressDto _self;
  final $Res Function(_JobAddressDto) _then;

/// Create a copy of JobAddressDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? streetAddress = null,Object? aptUnit = freezed,Object? city = null,Object? state = null,Object? zipCode = null,Object? latitude = freezed,Object? longitude = freezed,}) {
  return _then(_JobAddressDto(
streetAddress: null == streetAddress ? _self.streetAddress : streetAddress // ignore: cast_nullable_to_non_nullable
as String,aptUnit: freezed == aptUnit ? _self.aptUnit : aptUnit // ignore: cast_nullable_to_non_nullable
as String?,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,zipCode: null == zipCode ? _self.zipCode : zipCode // ignore: cast_nullable_to_non_nullable
as String,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}


/// @nodoc
mixin _$JobLocationDto implements DiagnosticableTreeMixin {

 double get latitude; double get longitude;
/// Create a copy of JobLocationDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JobLocationDtoCopyWith<JobLocationDto> get copyWith => _$JobLocationDtoCopyWithImpl<JobLocationDto>(this as JobLocationDto, _$identity);

  /// Serializes this JobLocationDto to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'JobLocationDto'))
    ..add(DiagnosticsProperty('latitude', latitude))..add(DiagnosticsProperty('longitude', longitude));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JobLocationDto&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,latitude,longitude);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'JobLocationDto(latitude: $latitude, longitude: $longitude)';
}


}

/// @nodoc
abstract mixin class $JobLocationDtoCopyWith<$Res>  {
  factory $JobLocationDtoCopyWith(JobLocationDto value, $Res Function(JobLocationDto) _then) = _$JobLocationDtoCopyWithImpl;
@useResult
$Res call({
 double latitude, double longitude
});




}
/// @nodoc
class _$JobLocationDtoCopyWithImpl<$Res>
    implements $JobLocationDtoCopyWith<$Res> {
  _$JobLocationDtoCopyWithImpl(this._self, this._then);

  final JobLocationDto _self;
  final $Res Function(JobLocationDto) _then;

/// Create a copy of JobLocationDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? latitude = null,Object? longitude = null,}) {
  return _then(_self.copyWith(
latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [JobLocationDto].
extension JobLocationDtoPatterns on JobLocationDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JobLocationDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JobLocationDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JobLocationDto value)  $default,){
final _that = this;
switch (_that) {
case _JobLocationDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JobLocationDto value)?  $default,){
final _that = this;
switch (_that) {
case _JobLocationDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double latitude,  double longitude)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JobLocationDto() when $default != null:
return $default(_that.latitude,_that.longitude);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double latitude,  double longitude)  $default,) {final _that = this;
switch (_that) {
case _JobLocationDto():
return $default(_that.latitude,_that.longitude);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double latitude,  double longitude)?  $default,) {final _that = this;
switch (_that) {
case _JobLocationDto() when $default != null:
return $default(_that.latitude,_that.longitude);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JobLocationDto extends JobLocationDto with DiagnosticableTreeMixin {
  const _JobLocationDto({required this.latitude, required this.longitude}): super._();
  factory _JobLocationDto.fromJson(Map<String, dynamic> json) => _$JobLocationDtoFromJson(json);

@override final  double latitude;
@override final  double longitude;

/// Create a copy of JobLocationDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JobLocationDtoCopyWith<_JobLocationDto> get copyWith => __$JobLocationDtoCopyWithImpl<_JobLocationDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JobLocationDtoToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'JobLocationDto'))
    ..add(DiagnosticsProperty('latitude', latitude))..add(DiagnosticsProperty('longitude', longitude));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JobLocationDto&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,latitude,longitude);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'JobLocationDto(latitude: $latitude, longitude: $longitude)';
}


}

/// @nodoc
abstract mixin class _$JobLocationDtoCopyWith<$Res> implements $JobLocationDtoCopyWith<$Res> {
  factory _$JobLocationDtoCopyWith(_JobLocationDto value, $Res Function(_JobLocationDto) _then) = __$JobLocationDtoCopyWithImpl;
@override @useResult
$Res call({
 double latitude, double longitude
});




}
/// @nodoc
class __$JobLocationDtoCopyWithImpl<$Res>
    implements _$JobLocationDtoCopyWith<$Res> {
  __$JobLocationDtoCopyWithImpl(this._self, this._then);

  final _JobLocationDto _self;
  final $Res Function(_JobLocationDto) _then;

/// Create a copy of JobLocationDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? latitude = null,Object? longitude = null,}) {
  return _then(_JobLocationDto(
latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$JobDto implements DiagnosticableTreeMixin {

 String? get id;@JsonKey(fromJson: _parentIdFromJson) String? get parentUserId; List<String> get childIds; List<ChildDto> get children; String? get title; String? get startDate; String? get endDate; String? get startTime; String? get endTime; String? get timezone; JobAddressDto? get address;@GeoJsonConverter() JobLocationDto? get location; String? get additionalDetails; double? get payRate; bool get saveAsDraft; String? get status; int? get estimatedDuration; double? get estimatedTotal; List<String> get applicantIds; String? get acceptedSitterId; DateTime? get createdAt; DateTime? get postedAt;
/// Create a copy of JobDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JobDtoCopyWith<JobDto> get copyWith => _$JobDtoCopyWithImpl<JobDto>(this as JobDto, _$identity);

  /// Serializes this JobDto to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'JobDto'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('parentUserId', parentUserId))..add(DiagnosticsProperty('childIds', childIds))..add(DiagnosticsProperty('children', children))..add(DiagnosticsProperty('title', title))..add(DiagnosticsProperty('startDate', startDate))..add(DiagnosticsProperty('endDate', endDate))..add(DiagnosticsProperty('startTime', startTime))..add(DiagnosticsProperty('endTime', endTime))..add(DiagnosticsProperty('timezone', timezone))..add(DiagnosticsProperty('address', address))..add(DiagnosticsProperty('location', location))..add(DiagnosticsProperty('additionalDetails', additionalDetails))..add(DiagnosticsProperty('payRate', payRate))..add(DiagnosticsProperty('saveAsDraft', saveAsDraft))..add(DiagnosticsProperty('status', status))..add(DiagnosticsProperty('estimatedDuration', estimatedDuration))..add(DiagnosticsProperty('estimatedTotal', estimatedTotal))..add(DiagnosticsProperty('applicantIds', applicantIds))..add(DiagnosticsProperty('acceptedSitterId', acceptedSitterId))..add(DiagnosticsProperty('createdAt', createdAt))..add(DiagnosticsProperty('postedAt', postedAt));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JobDto&&(identical(other.id, id) || other.id == id)&&(identical(other.parentUserId, parentUserId) || other.parentUserId == parentUserId)&&const DeepCollectionEquality().equals(other.childIds, childIds)&&const DeepCollectionEquality().equals(other.children, children)&&(identical(other.title, title) || other.title == title)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.address, address) || other.address == address)&&(identical(other.location, location) || other.location == location)&&(identical(other.additionalDetails, additionalDetails) || other.additionalDetails == additionalDetails)&&(identical(other.payRate, payRate) || other.payRate == payRate)&&(identical(other.saveAsDraft, saveAsDraft) || other.saveAsDraft == saveAsDraft)&&(identical(other.status, status) || other.status == status)&&(identical(other.estimatedDuration, estimatedDuration) || other.estimatedDuration == estimatedDuration)&&(identical(other.estimatedTotal, estimatedTotal) || other.estimatedTotal == estimatedTotal)&&const DeepCollectionEquality().equals(other.applicantIds, applicantIds)&&(identical(other.acceptedSitterId, acceptedSitterId) || other.acceptedSitterId == acceptedSitterId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.postedAt, postedAt) || other.postedAt == postedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,parentUserId,const DeepCollectionEquality().hash(childIds),const DeepCollectionEquality().hash(children),title,startDate,endDate,startTime,endTime,timezone,address,location,additionalDetails,payRate,saveAsDraft,status,estimatedDuration,estimatedTotal,const DeepCollectionEquality().hash(applicantIds),acceptedSitterId,createdAt,postedAt]);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'JobDto(id: $id, parentUserId: $parentUserId, childIds: $childIds, children: $children, title: $title, startDate: $startDate, endDate: $endDate, startTime: $startTime, endTime: $endTime, timezone: $timezone, address: $address, location: $location, additionalDetails: $additionalDetails, payRate: $payRate, saveAsDraft: $saveAsDraft, status: $status, estimatedDuration: $estimatedDuration, estimatedTotal: $estimatedTotal, applicantIds: $applicantIds, acceptedSitterId: $acceptedSitterId, createdAt: $createdAt, postedAt: $postedAt)';
}


}

/// @nodoc
abstract mixin class $JobDtoCopyWith<$Res>  {
  factory $JobDtoCopyWith(JobDto value, $Res Function(JobDto) _then) = _$JobDtoCopyWithImpl;
@useResult
$Res call({
 String? id,@JsonKey(fromJson: _parentIdFromJson) String? parentUserId, List<String> childIds, List<ChildDto> children, String? title, String? startDate, String? endDate, String? startTime, String? endTime, String? timezone, JobAddressDto? address,@GeoJsonConverter() JobLocationDto? location, String? additionalDetails, double? payRate, bool saveAsDraft, String? status, int? estimatedDuration, double? estimatedTotal, List<String> applicantIds, String? acceptedSitterId, DateTime? createdAt, DateTime? postedAt
});


$JobAddressDtoCopyWith<$Res>? get address;$JobLocationDtoCopyWith<$Res>? get location;

}
/// @nodoc
class _$JobDtoCopyWithImpl<$Res>
    implements $JobDtoCopyWith<$Res> {
  _$JobDtoCopyWithImpl(this._self, this._then);

  final JobDto _self;
  final $Res Function(JobDto) _then;

/// Create a copy of JobDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? parentUserId = freezed,Object? childIds = null,Object? children = null,Object? title = freezed,Object? startDate = freezed,Object? endDate = freezed,Object? startTime = freezed,Object? endTime = freezed,Object? timezone = freezed,Object? address = freezed,Object? location = freezed,Object? additionalDetails = freezed,Object? payRate = freezed,Object? saveAsDraft = null,Object? status = freezed,Object? estimatedDuration = freezed,Object? estimatedTotal = freezed,Object? applicantIds = null,Object? acceptedSitterId = freezed,Object? createdAt = freezed,Object? postedAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,parentUserId: freezed == parentUserId ? _self.parentUserId : parentUserId // ignore: cast_nullable_to_non_nullable
as String?,childIds: null == childIds ? _self.childIds : childIds // ignore: cast_nullable_to_non_nullable
as List<String>,children: null == children ? _self.children : children // ignore: cast_nullable_to_non_nullable
as List<ChildDto>,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as String?,startTime: freezed == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String?,endTime: freezed == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String?,timezone: freezed == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as JobAddressDto?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as JobLocationDto?,additionalDetails: freezed == additionalDetails ? _self.additionalDetails : additionalDetails // ignore: cast_nullable_to_non_nullable
as String?,payRate: freezed == payRate ? _self.payRate : payRate // ignore: cast_nullable_to_non_nullable
as double?,saveAsDraft: null == saveAsDraft ? _self.saveAsDraft : saveAsDraft // ignore: cast_nullable_to_non_nullable
as bool,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,estimatedDuration: freezed == estimatedDuration ? _self.estimatedDuration : estimatedDuration // ignore: cast_nullable_to_non_nullable
as int?,estimatedTotal: freezed == estimatedTotal ? _self.estimatedTotal : estimatedTotal // ignore: cast_nullable_to_non_nullable
as double?,applicantIds: null == applicantIds ? _self.applicantIds : applicantIds // ignore: cast_nullable_to_non_nullable
as List<String>,acceptedSitterId: freezed == acceptedSitterId ? _self.acceptedSitterId : acceptedSitterId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,postedAt: freezed == postedAt ? _self.postedAt : postedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of JobDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JobAddressDtoCopyWith<$Res>? get address {
    if (_self.address == null) {
    return null;
  }

  return $JobAddressDtoCopyWith<$Res>(_self.address!, (value) {
    return _then(_self.copyWith(address: value));
  });
}/// Create a copy of JobDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JobLocationDtoCopyWith<$Res>? get location {
    if (_self.location == null) {
    return null;
  }

  return $JobLocationDtoCopyWith<$Res>(_self.location!, (value) {
    return _then(_self.copyWith(location: value));
  });
}
}


/// Adds pattern-matching-related methods to [JobDto].
extension JobDtoPatterns on JobDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JobDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JobDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JobDto value)  $default,){
final _that = this;
switch (_that) {
case _JobDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JobDto value)?  $default,){
final _that = this;
switch (_that) {
case _JobDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id, @JsonKey(fromJson: _parentIdFromJson)  String? parentUserId,  List<String> childIds,  List<ChildDto> children,  String? title,  String? startDate,  String? endDate,  String? startTime,  String? endTime,  String? timezone,  JobAddressDto? address, @GeoJsonConverter()  JobLocationDto? location,  String? additionalDetails,  double? payRate,  bool saveAsDraft,  String? status,  int? estimatedDuration,  double? estimatedTotal,  List<String> applicantIds,  String? acceptedSitterId,  DateTime? createdAt,  DateTime? postedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JobDto() when $default != null:
return $default(_that.id,_that.parentUserId,_that.childIds,_that.children,_that.title,_that.startDate,_that.endDate,_that.startTime,_that.endTime,_that.timezone,_that.address,_that.location,_that.additionalDetails,_that.payRate,_that.saveAsDraft,_that.status,_that.estimatedDuration,_that.estimatedTotal,_that.applicantIds,_that.acceptedSitterId,_that.createdAt,_that.postedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id, @JsonKey(fromJson: _parentIdFromJson)  String? parentUserId,  List<String> childIds,  List<ChildDto> children,  String? title,  String? startDate,  String? endDate,  String? startTime,  String? endTime,  String? timezone,  JobAddressDto? address, @GeoJsonConverter()  JobLocationDto? location,  String? additionalDetails,  double? payRate,  bool saveAsDraft,  String? status,  int? estimatedDuration,  double? estimatedTotal,  List<String> applicantIds,  String? acceptedSitterId,  DateTime? createdAt,  DateTime? postedAt)  $default,) {final _that = this;
switch (_that) {
case _JobDto():
return $default(_that.id,_that.parentUserId,_that.childIds,_that.children,_that.title,_that.startDate,_that.endDate,_that.startTime,_that.endTime,_that.timezone,_that.address,_that.location,_that.additionalDetails,_that.payRate,_that.saveAsDraft,_that.status,_that.estimatedDuration,_that.estimatedTotal,_that.applicantIds,_that.acceptedSitterId,_that.createdAt,_that.postedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id, @JsonKey(fromJson: _parentIdFromJson)  String? parentUserId,  List<String> childIds,  List<ChildDto> children,  String? title,  String? startDate,  String? endDate,  String? startTime,  String? endTime,  String? timezone,  JobAddressDto? address, @GeoJsonConverter()  JobLocationDto? location,  String? additionalDetails,  double? payRate,  bool saveAsDraft,  String? status,  int? estimatedDuration,  double? estimatedTotal,  List<String> applicantIds,  String? acceptedSitterId,  DateTime? createdAt,  DateTime? postedAt)?  $default,) {final _that = this;
switch (_that) {
case _JobDto() when $default != null:
return $default(_that.id,_that.parentUserId,_that.childIds,_that.children,_that.title,_that.startDate,_that.endDate,_that.startTime,_that.endTime,_that.timezone,_that.address,_that.location,_that.additionalDetails,_that.payRate,_that.saveAsDraft,_that.status,_that.estimatedDuration,_that.estimatedTotal,_that.applicantIds,_that.acceptedSitterId,_that.createdAt,_that.postedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JobDto extends JobDto with DiagnosticableTreeMixin {
  const _JobDto({this.id, @JsonKey(fromJson: _parentIdFromJson) this.parentUserId, final  List<String> childIds = const [], final  List<ChildDto> children = const [], this.title, this.startDate, this.endDate, this.startTime, this.endTime, this.timezone, this.address, @GeoJsonConverter() this.location, this.additionalDetails, this.payRate, this.saveAsDraft = false, this.status, this.estimatedDuration, this.estimatedTotal, final  List<String> applicantIds = const [], this.acceptedSitterId, this.createdAt, this.postedAt}): _childIds = childIds,_children = children,_applicantIds = applicantIds,super._();
  factory _JobDto.fromJson(Map<String, dynamic> json) => _$JobDtoFromJson(json);

@override final  String? id;
@override@JsonKey(fromJson: _parentIdFromJson) final  String? parentUserId;
 final  List<String> _childIds;
@override@JsonKey() List<String> get childIds {
  if (_childIds is EqualUnmodifiableListView) return _childIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_childIds);
}

 final  List<ChildDto> _children;
@override@JsonKey() List<ChildDto> get children {
  if (_children is EqualUnmodifiableListView) return _children;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_children);
}

@override final  String? title;
@override final  String? startDate;
@override final  String? endDate;
@override final  String? startTime;
@override final  String? endTime;
@override final  String? timezone;
@override final  JobAddressDto? address;
@override@GeoJsonConverter() final  JobLocationDto? location;
@override final  String? additionalDetails;
@override final  double? payRate;
@override@JsonKey() final  bool saveAsDraft;
@override final  String? status;
@override final  int? estimatedDuration;
@override final  double? estimatedTotal;
 final  List<String> _applicantIds;
@override@JsonKey() List<String> get applicantIds {
  if (_applicantIds is EqualUnmodifiableListView) return _applicantIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_applicantIds);
}

@override final  String? acceptedSitterId;
@override final  DateTime? createdAt;
@override final  DateTime? postedAt;

/// Create a copy of JobDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JobDtoCopyWith<_JobDto> get copyWith => __$JobDtoCopyWithImpl<_JobDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JobDtoToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'JobDto'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('parentUserId', parentUserId))..add(DiagnosticsProperty('childIds', childIds))..add(DiagnosticsProperty('children', children))..add(DiagnosticsProperty('title', title))..add(DiagnosticsProperty('startDate', startDate))..add(DiagnosticsProperty('endDate', endDate))..add(DiagnosticsProperty('startTime', startTime))..add(DiagnosticsProperty('endTime', endTime))..add(DiagnosticsProperty('timezone', timezone))..add(DiagnosticsProperty('address', address))..add(DiagnosticsProperty('location', location))..add(DiagnosticsProperty('additionalDetails', additionalDetails))..add(DiagnosticsProperty('payRate', payRate))..add(DiagnosticsProperty('saveAsDraft', saveAsDraft))..add(DiagnosticsProperty('status', status))..add(DiagnosticsProperty('estimatedDuration', estimatedDuration))..add(DiagnosticsProperty('estimatedTotal', estimatedTotal))..add(DiagnosticsProperty('applicantIds', applicantIds))..add(DiagnosticsProperty('acceptedSitterId', acceptedSitterId))..add(DiagnosticsProperty('createdAt', createdAt))..add(DiagnosticsProperty('postedAt', postedAt));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JobDto&&(identical(other.id, id) || other.id == id)&&(identical(other.parentUserId, parentUserId) || other.parentUserId == parentUserId)&&const DeepCollectionEquality().equals(other._childIds, _childIds)&&const DeepCollectionEquality().equals(other._children, _children)&&(identical(other.title, title) || other.title == title)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.address, address) || other.address == address)&&(identical(other.location, location) || other.location == location)&&(identical(other.additionalDetails, additionalDetails) || other.additionalDetails == additionalDetails)&&(identical(other.payRate, payRate) || other.payRate == payRate)&&(identical(other.saveAsDraft, saveAsDraft) || other.saveAsDraft == saveAsDraft)&&(identical(other.status, status) || other.status == status)&&(identical(other.estimatedDuration, estimatedDuration) || other.estimatedDuration == estimatedDuration)&&(identical(other.estimatedTotal, estimatedTotal) || other.estimatedTotal == estimatedTotal)&&const DeepCollectionEquality().equals(other._applicantIds, _applicantIds)&&(identical(other.acceptedSitterId, acceptedSitterId) || other.acceptedSitterId == acceptedSitterId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.postedAt, postedAt) || other.postedAt == postedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,parentUserId,const DeepCollectionEquality().hash(_childIds),const DeepCollectionEquality().hash(_children),title,startDate,endDate,startTime,endTime,timezone,address,location,additionalDetails,payRate,saveAsDraft,status,estimatedDuration,estimatedTotal,const DeepCollectionEquality().hash(_applicantIds),acceptedSitterId,createdAt,postedAt]);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'JobDto(id: $id, parentUserId: $parentUserId, childIds: $childIds, children: $children, title: $title, startDate: $startDate, endDate: $endDate, startTime: $startTime, endTime: $endTime, timezone: $timezone, address: $address, location: $location, additionalDetails: $additionalDetails, payRate: $payRate, saveAsDraft: $saveAsDraft, status: $status, estimatedDuration: $estimatedDuration, estimatedTotal: $estimatedTotal, applicantIds: $applicantIds, acceptedSitterId: $acceptedSitterId, createdAt: $createdAt, postedAt: $postedAt)';
}


}

/// @nodoc
abstract mixin class _$JobDtoCopyWith<$Res> implements $JobDtoCopyWith<$Res> {
  factory _$JobDtoCopyWith(_JobDto value, $Res Function(_JobDto) _then) = __$JobDtoCopyWithImpl;
@override @useResult
$Res call({
 String? id,@JsonKey(fromJson: _parentIdFromJson) String? parentUserId, List<String> childIds, List<ChildDto> children, String? title, String? startDate, String? endDate, String? startTime, String? endTime, String? timezone, JobAddressDto? address,@GeoJsonConverter() JobLocationDto? location, String? additionalDetails, double? payRate, bool saveAsDraft, String? status, int? estimatedDuration, double? estimatedTotal, List<String> applicantIds, String? acceptedSitterId, DateTime? createdAt, DateTime? postedAt
});


@override $JobAddressDtoCopyWith<$Res>? get address;@override $JobLocationDtoCopyWith<$Res>? get location;

}
/// @nodoc
class __$JobDtoCopyWithImpl<$Res>
    implements _$JobDtoCopyWith<$Res> {
  __$JobDtoCopyWithImpl(this._self, this._then);

  final _JobDto _self;
  final $Res Function(_JobDto) _then;

/// Create a copy of JobDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? parentUserId = freezed,Object? childIds = null,Object? children = null,Object? title = freezed,Object? startDate = freezed,Object? endDate = freezed,Object? startTime = freezed,Object? endTime = freezed,Object? timezone = freezed,Object? address = freezed,Object? location = freezed,Object? additionalDetails = freezed,Object? payRate = freezed,Object? saveAsDraft = null,Object? status = freezed,Object? estimatedDuration = freezed,Object? estimatedTotal = freezed,Object? applicantIds = null,Object? acceptedSitterId = freezed,Object? createdAt = freezed,Object? postedAt = freezed,}) {
  return _then(_JobDto(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,parentUserId: freezed == parentUserId ? _self.parentUserId : parentUserId // ignore: cast_nullable_to_non_nullable
as String?,childIds: null == childIds ? _self._childIds : childIds // ignore: cast_nullable_to_non_nullable
as List<String>,children: null == children ? _self._children : children // ignore: cast_nullable_to_non_nullable
as List<ChildDto>,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as String?,startTime: freezed == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String?,endTime: freezed == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String?,timezone: freezed == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as JobAddressDto?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as JobLocationDto?,additionalDetails: freezed == additionalDetails ? _self.additionalDetails : additionalDetails // ignore: cast_nullable_to_non_nullable
as String?,payRate: freezed == payRate ? _self.payRate : payRate // ignore: cast_nullable_to_non_nullable
as double?,saveAsDraft: null == saveAsDraft ? _self.saveAsDraft : saveAsDraft // ignore: cast_nullable_to_non_nullable
as bool,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,estimatedDuration: freezed == estimatedDuration ? _self.estimatedDuration : estimatedDuration // ignore: cast_nullable_to_non_nullable
as int?,estimatedTotal: freezed == estimatedTotal ? _self.estimatedTotal : estimatedTotal // ignore: cast_nullable_to_non_nullable
as double?,applicantIds: null == applicantIds ? _self._applicantIds : applicantIds // ignore: cast_nullable_to_non_nullable
as List<String>,acceptedSitterId: freezed == acceptedSitterId ? _self.acceptedSitterId : acceptedSitterId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,postedAt: freezed == postedAt ? _self.postedAt : postedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of JobDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JobAddressDtoCopyWith<$Res>? get address {
    if (_self.address == null) {
    return null;
  }

  return $JobAddressDtoCopyWith<$Res>(_self.address!, (value) {
    return _then(_self.copyWith(address: value));
  });
}/// Create a copy of JobDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JobLocationDtoCopyWith<$Res>? get location {
    if (_self.location == null) {
    return null;
  }

  return $JobLocationDtoCopyWith<$Res>(_self.location!, (value) {
    return _then(_self.copyWith(location: value));
  });
}
}

// dart format on
