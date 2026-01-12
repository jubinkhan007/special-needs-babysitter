// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'job_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

JobAddressDto _$JobAddressDtoFromJson(Map<String, dynamic> json) {
  return _JobAddressDto.fromJson(json);
}

/// @nodoc
mixin _$JobAddressDto {
  String get streetAddress => throw _privateConstructorUsedError;
  String? get aptUnit => throw _privateConstructorUsedError;
  String get city => throw _privateConstructorUsedError;
  String get state => throw _privateConstructorUsedError;
  String get zipCode => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;

  /// Serializes this JobAddressDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of JobAddressDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $JobAddressDtoCopyWith<JobAddressDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JobAddressDtoCopyWith<$Res> {
  factory $JobAddressDtoCopyWith(
          JobAddressDto value, $Res Function(JobAddressDto) then) =
      _$JobAddressDtoCopyWithImpl<$Res, JobAddressDto>;
  @useResult
  $Res call(
      {String streetAddress,
      String? aptUnit,
      String city,
      String state,
      String zipCode,
      double? latitude,
      double? longitude});
}

/// @nodoc
class _$JobAddressDtoCopyWithImpl<$Res, $Val extends JobAddressDto>
    implements $JobAddressDtoCopyWith<$Res> {
  _$JobAddressDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of JobAddressDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? streetAddress = null,
    Object? aptUnit = freezed,
    Object? city = null,
    Object? state = null,
    Object? zipCode = null,
    Object? latitude = freezed,
    Object? longitude = freezed,
  }) {
    return _then(_value.copyWith(
      streetAddress: null == streetAddress
          ? _value.streetAddress
          : streetAddress // ignore: cast_nullable_to_non_nullable
              as String,
      aptUnit: freezed == aptUnit
          ? _value.aptUnit
          : aptUnit // ignore: cast_nullable_to_non_nullable
              as String?,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String,
      zipCode: null == zipCode
          ? _value.zipCode
          : zipCode // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$JobAddressDtoImplCopyWith<$Res>
    implements $JobAddressDtoCopyWith<$Res> {
  factory _$$JobAddressDtoImplCopyWith(
          _$JobAddressDtoImpl value, $Res Function(_$JobAddressDtoImpl) then) =
      __$$JobAddressDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String streetAddress,
      String? aptUnit,
      String city,
      String state,
      String zipCode,
      double? latitude,
      double? longitude});
}

/// @nodoc
class __$$JobAddressDtoImplCopyWithImpl<$Res>
    extends _$JobAddressDtoCopyWithImpl<$Res, _$JobAddressDtoImpl>
    implements _$$JobAddressDtoImplCopyWith<$Res> {
  __$$JobAddressDtoImplCopyWithImpl(
      _$JobAddressDtoImpl _value, $Res Function(_$JobAddressDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of JobAddressDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? streetAddress = null,
    Object? aptUnit = freezed,
    Object? city = null,
    Object? state = null,
    Object? zipCode = null,
    Object? latitude = freezed,
    Object? longitude = freezed,
  }) {
    return _then(_$JobAddressDtoImpl(
      streetAddress: null == streetAddress
          ? _value.streetAddress
          : streetAddress // ignore: cast_nullable_to_non_nullable
              as String,
      aptUnit: freezed == aptUnit
          ? _value.aptUnit
          : aptUnit // ignore: cast_nullable_to_non_nullable
              as String?,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String,
      zipCode: null == zipCode
          ? _value.zipCode
          : zipCode // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$JobAddressDtoImpl extends _JobAddressDto {
  const _$JobAddressDtoImpl(
      {required this.streetAddress,
      this.aptUnit,
      required this.city,
      required this.state,
      required this.zipCode,
      this.latitude,
      this.longitude})
      : super._();

  factory _$JobAddressDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$JobAddressDtoImplFromJson(json);

  @override
  final String streetAddress;
  @override
  final String? aptUnit;
  @override
  final String city;
  @override
  final String state;
  @override
  final String zipCode;
  @override
  final double? latitude;
  @override
  final double? longitude;

  @override
  String toString() {
    return 'JobAddressDto(streetAddress: $streetAddress, aptUnit: $aptUnit, city: $city, state: $state, zipCode: $zipCode, latitude: $latitude, longitude: $longitude)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JobAddressDtoImpl &&
            (identical(other.streetAddress, streetAddress) ||
                other.streetAddress == streetAddress) &&
            (identical(other.aptUnit, aptUnit) || other.aptUnit == aptUnit) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.zipCode, zipCode) || other.zipCode == zipCode) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, streetAddress, aptUnit, city,
      state, zipCode, latitude, longitude);

  /// Create a copy of JobAddressDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JobAddressDtoImplCopyWith<_$JobAddressDtoImpl> get copyWith =>
      __$$JobAddressDtoImplCopyWithImpl<_$JobAddressDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$JobAddressDtoImplToJson(
      this,
    );
  }
}

abstract class _JobAddressDto extends JobAddressDto {
  const factory _JobAddressDto(
      {required final String streetAddress,
      final String? aptUnit,
      required final String city,
      required final String state,
      required final String zipCode,
      final double? latitude,
      final double? longitude}) = _$JobAddressDtoImpl;
  const _JobAddressDto._() : super._();

  factory _JobAddressDto.fromJson(Map<String, dynamic> json) =
      _$JobAddressDtoImpl.fromJson;

  @override
  String get streetAddress;
  @override
  String? get aptUnit;
  @override
  String get city;
  @override
  String get state;
  @override
  String get zipCode;
  @override
  double? get latitude;
  @override
  double? get longitude;

  /// Create a copy of JobAddressDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JobAddressDtoImplCopyWith<_$JobAddressDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

JobLocationDto _$JobLocationDtoFromJson(Map<String, dynamic> json) {
  return _JobLocationDto.fromJson(json);
}

/// @nodoc
mixin _$JobLocationDto {
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;

  /// Serializes this JobLocationDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of JobLocationDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $JobLocationDtoCopyWith<JobLocationDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JobLocationDtoCopyWith<$Res> {
  factory $JobLocationDtoCopyWith(
          JobLocationDto value, $Res Function(JobLocationDto) then) =
      _$JobLocationDtoCopyWithImpl<$Res, JobLocationDto>;
  @useResult
  $Res call({double latitude, double longitude});
}

/// @nodoc
class _$JobLocationDtoCopyWithImpl<$Res, $Val extends JobLocationDto>
    implements $JobLocationDtoCopyWith<$Res> {
  _$JobLocationDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of JobLocationDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latitude = null,
    Object? longitude = null,
  }) {
    return _then(_value.copyWith(
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$JobLocationDtoImplCopyWith<$Res>
    implements $JobLocationDtoCopyWith<$Res> {
  factory _$$JobLocationDtoImplCopyWith(_$JobLocationDtoImpl value,
          $Res Function(_$JobLocationDtoImpl) then) =
      __$$JobLocationDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double latitude, double longitude});
}

/// @nodoc
class __$$JobLocationDtoImplCopyWithImpl<$Res>
    extends _$JobLocationDtoCopyWithImpl<$Res, _$JobLocationDtoImpl>
    implements _$$JobLocationDtoImplCopyWith<$Res> {
  __$$JobLocationDtoImplCopyWithImpl(
      _$JobLocationDtoImpl _value, $Res Function(_$JobLocationDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of JobLocationDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latitude = null,
    Object? longitude = null,
  }) {
    return _then(_$JobLocationDtoImpl(
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$JobLocationDtoImpl extends _JobLocationDto {
  const _$JobLocationDtoImpl({required this.latitude, required this.longitude})
      : super._();

  factory _$JobLocationDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$JobLocationDtoImplFromJson(json);

  @override
  final double latitude;
  @override
  final double longitude;

  @override
  String toString() {
    return 'JobLocationDto(latitude: $latitude, longitude: $longitude)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JobLocationDtoImpl &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, latitude, longitude);

  /// Create a copy of JobLocationDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JobLocationDtoImplCopyWith<_$JobLocationDtoImpl> get copyWith =>
      __$$JobLocationDtoImplCopyWithImpl<_$JobLocationDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$JobLocationDtoImplToJson(
      this,
    );
  }
}

abstract class _JobLocationDto extends JobLocationDto {
  const factory _JobLocationDto(
      {required final double latitude,
      required final double longitude}) = _$JobLocationDtoImpl;
  const _JobLocationDto._() : super._();

  factory _JobLocationDto.fromJson(Map<String, dynamic> json) =
      _$JobLocationDtoImpl.fromJson;

  @override
  double get latitude;
  @override
  double get longitude;

  /// Create a copy of JobLocationDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JobLocationDtoImplCopyWith<_$JobLocationDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

JobDto _$JobDtoFromJson(Map<String, dynamic> json) {
  return _JobDto.fromJson(json);
}

/// @nodoc
mixin _$JobDto {
  String? get id => throw _privateConstructorUsedError;
  List<String> get childIds => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get startDate => throw _privateConstructorUsedError;
  String get endDate => throw _privateConstructorUsedError;
  String get startTime => throw _privateConstructorUsedError;
  String get endTime => throw _privateConstructorUsedError;
  JobAddressDto get address => throw _privateConstructorUsedError;
  JobLocationDto? get location => throw _privateConstructorUsedError;
  String get additionalDetails => throw _privateConstructorUsedError;
  double get payRate => throw _privateConstructorUsedError;
  bool get saveAsDraft => throw _privateConstructorUsedError;

  /// Serializes this JobDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of JobDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $JobDtoCopyWith<JobDto> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JobDtoCopyWith<$Res> {
  factory $JobDtoCopyWith(JobDto value, $Res Function(JobDto) then) =
      _$JobDtoCopyWithImpl<$Res, JobDto>;
  @useResult
  $Res call(
      {String? id,
      List<String> childIds,
      String title,
      String startDate,
      String endDate,
      String startTime,
      String endTime,
      JobAddressDto address,
      JobLocationDto? location,
      String additionalDetails,
      double payRate,
      bool saveAsDraft});

  $JobAddressDtoCopyWith<$Res> get address;
  $JobLocationDtoCopyWith<$Res>? get location;
}

/// @nodoc
class _$JobDtoCopyWithImpl<$Res, $Val extends JobDto>
    implements $JobDtoCopyWith<$Res> {
  _$JobDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of JobDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? childIds = null,
    Object? title = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? address = null,
    Object? location = freezed,
    Object? additionalDetails = null,
    Object? payRate = null,
    Object? saveAsDraft = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      childIds: null == childIds
          ? _value.childIds
          : childIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as String,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as JobAddressDto,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as JobLocationDto?,
      additionalDetails: null == additionalDetails
          ? _value.additionalDetails
          : additionalDetails // ignore: cast_nullable_to_non_nullable
              as String,
      payRate: null == payRate
          ? _value.payRate
          : payRate // ignore: cast_nullable_to_non_nullable
              as double,
      saveAsDraft: null == saveAsDraft
          ? _value.saveAsDraft
          : saveAsDraft // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  /// Create a copy of JobDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $JobAddressDtoCopyWith<$Res> get address {
    return $JobAddressDtoCopyWith<$Res>(_value.address, (value) {
      return _then(_value.copyWith(address: value) as $Val);
    });
  }

  /// Create a copy of JobDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $JobLocationDtoCopyWith<$Res>? get location {
    if (_value.location == null) {
      return null;
    }

    return $JobLocationDtoCopyWith<$Res>(_value.location!, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$JobDtoImplCopyWith<$Res> implements $JobDtoCopyWith<$Res> {
  factory _$$JobDtoImplCopyWith(
          _$JobDtoImpl value, $Res Function(_$JobDtoImpl) then) =
      __$$JobDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      List<String> childIds,
      String title,
      String startDate,
      String endDate,
      String startTime,
      String endTime,
      JobAddressDto address,
      JobLocationDto? location,
      String additionalDetails,
      double payRate,
      bool saveAsDraft});

  @override
  $JobAddressDtoCopyWith<$Res> get address;
  @override
  $JobLocationDtoCopyWith<$Res>? get location;
}

/// @nodoc
class __$$JobDtoImplCopyWithImpl<$Res>
    extends _$JobDtoCopyWithImpl<$Res, _$JobDtoImpl>
    implements _$$JobDtoImplCopyWith<$Res> {
  __$$JobDtoImplCopyWithImpl(
      _$JobDtoImpl _value, $Res Function(_$JobDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of JobDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? childIds = null,
    Object? title = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? address = null,
    Object? location = freezed,
    Object? additionalDetails = null,
    Object? payRate = null,
    Object? saveAsDraft = null,
  }) {
    return _then(_$JobDtoImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      childIds: null == childIds
          ? _value._childIds
          : childIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as String,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as JobAddressDto,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as JobLocationDto?,
      additionalDetails: null == additionalDetails
          ? _value.additionalDetails
          : additionalDetails // ignore: cast_nullable_to_non_nullable
              as String,
      payRate: null == payRate
          ? _value.payRate
          : payRate // ignore: cast_nullable_to_non_nullable
              as double,
      saveAsDraft: null == saveAsDraft
          ? _value.saveAsDraft
          : saveAsDraft // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$JobDtoImpl extends _JobDto {
  const _$JobDtoImpl(
      {this.id,
      required final List<String> childIds,
      required this.title,
      required this.startDate,
      required this.endDate,
      required this.startTime,
      required this.endTime,
      required this.address,
      this.location,
      required this.additionalDetails,
      required this.payRate,
      this.saveAsDraft = false})
      : _childIds = childIds,
        super._();

  factory _$JobDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$JobDtoImplFromJson(json);

  @override
  final String? id;
  final List<String> _childIds;
  @override
  List<String> get childIds {
    if (_childIds is EqualUnmodifiableListView) return _childIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_childIds);
  }

  @override
  final String title;
  @override
  final String startDate;
  @override
  final String endDate;
  @override
  final String startTime;
  @override
  final String endTime;
  @override
  final JobAddressDto address;
  @override
  final JobLocationDto? location;
  @override
  final String additionalDetails;
  @override
  final double payRate;
  @override
  @JsonKey()
  final bool saveAsDraft;

  @override
  String toString() {
    return 'JobDto(id: $id, childIds: $childIds, title: $title, startDate: $startDate, endDate: $endDate, startTime: $startTime, endTime: $endTime, address: $address, location: $location, additionalDetails: $additionalDetails, payRate: $payRate, saveAsDraft: $saveAsDraft)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JobDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(other._childIds, _childIds) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.additionalDetails, additionalDetails) ||
                other.additionalDetails == additionalDetails) &&
            (identical(other.payRate, payRate) || other.payRate == payRate) &&
            (identical(other.saveAsDraft, saveAsDraft) ||
                other.saveAsDraft == saveAsDraft));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      const DeepCollectionEquality().hash(_childIds),
      title,
      startDate,
      endDate,
      startTime,
      endTime,
      address,
      location,
      additionalDetails,
      payRate,
      saveAsDraft);

  /// Create a copy of JobDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JobDtoImplCopyWith<_$JobDtoImpl> get copyWith =>
      __$$JobDtoImplCopyWithImpl<_$JobDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$JobDtoImplToJson(
      this,
    );
  }
}

abstract class _JobDto extends JobDto {
  const factory _JobDto(
      {final String? id,
      required final List<String> childIds,
      required final String title,
      required final String startDate,
      required final String endDate,
      required final String startTime,
      required final String endTime,
      required final JobAddressDto address,
      final JobLocationDto? location,
      required final String additionalDetails,
      required final double payRate,
      final bool saveAsDraft}) = _$JobDtoImpl;
  const _JobDto._() : super._();

  factory _JobDto.fromJson(Map<String, dynamic> json) = _$JobDtoImpl.fromJson;

  @override
  String? get id;
  @override
  List<String> get childIds;
  @override
  String get title;
  @override
  String get startDate;
  @override
  String get endDate;
  @override
  String get startTime;
  @override
  String get endTime;
  @override
  JobAddressDto get address;
  @override
  JobLocationDto? get location;
  @override
  String get additionalDetails;
  @override
  double get payRate;
  @override
  bool get saveAsDraft;

  /// Create a copy of JobDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JobDtoImplCopyWith<_$JobDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
