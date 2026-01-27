// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserDto _$UserDtoFromJson(Map<String, dynamic> json) {
  return _UserDto.fromJson(json);
}

/// @nodoc
mixin _$UserDto {
  String get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String? get firstName => throw _privateConstructorUsedError;
  String? get lastName => throw _privateConstructorUsedError;
  @JsonKey(readValue: _readPhone)
  String? get phoneNumber => throw _privateConstructorUsedError;
  @JsonKey(readValue: _readAvatarUrl)
  String? get avatarUrl => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;
  @JsonKey(readValue: _readProfileComplete)
  bool get isProfileComplete => throw _privateConstructorUsedError;
  @JsonKey(name: 'phoneVerified')
  bool get isSitterApproved => throw _privateConstructorUsedError;
  @JsonKey(name: 'createdAt')
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this UserDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserDtoCopyWith<UserDto> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserDtoCopyWith<$Res> {
  factory $UserDtoCopyWith(UserDto value, $Res Function(UserDto) then) =
      _$UserDtoCopyWithImpl<$Res, UserDto>;
  @useResult
  $Res call(
      {String id,
      String email,
      String? firstName,
      String? lastName,
      @JsonKey(readValue: _readPhone) String? phoneNumber,
      @JsonKey(readValue: _readAvatarUrl) String? avatarUrl,
      String role,
      @JsonKey(readValue: _readProfileComplete) bool isProfileComplete,
      @JsonKey(name: 'phoneVerified') bool isSitterApproved,
      @JsonKey(name: 'createdAt') DateTime? createdAt});
}

/// @nodoc
class _$UserDtoCopyWithImpl<$Res, $Val extends UserDto>
    implements $UserDtoCopyWith<$Res> {
  _$UserDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? phoneNumber = freezed,
    Object? avatarUrl = freezed,
    Object? role = null,
    Object? isProfileComplete = null,
    Object? isSitterApproved = null,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: freezed == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      isProfileComplete: null == isProfileComplete
          ? _value.isProfileComplete
          : isProfileComplete // ignore: cast_nullable_to_non_nullable
              as bool,
      isSitterApproved: null == isSitterApproved
          ? _value.isSitterApproved
          : isSitterApproved // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserDtoImplCopyWith<$Res> implements $UserDtoCopyWith<$Res> {
  factory _$$UserDtoImplCopyWith(
          _$UserDtoImpl value, $Res Function(_$UserDtoImpl) then) =
      __$$UserDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String email,
      String? firstName,
      String? lastName,
      @JsonKey(readValue: _readPhone) String? phoneNumber,
      @JsonKey(readValue: _readAvatarUrl) String? avatarUrl,
      String role,
      @JsonKey(readValue: _readProfileComplete) bool isProfileComplete,
      @JsonKey(name: 'phoneVerified') bool isSitterApproved,
      @JsonKey(name: 'createdAt') DateTime? createdAt});
}

/// @nodoc
class __$$UserDtoImplCopyWithImpl<$Res>
    extends _$UserDtoCopyWithImpl<$Res, _$UserDtoImpl>
    implements _$$UserDtoImplCopyWith<$Res> {
  __$$UserDtoImplCopyWithImpl(
      _$UserDtoImpl _value, $Res Function(_$UserDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? phoneNumber = freezed,
    Object? avatarUrl = freezed,
    Object? role = null,
    Object? isProfileComplete = null,
    Object? isSitterApproved = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$UserDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: freezed == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      isProfileComplete: null == isProfileComplete
          ? _value.isProfileComplete
          : isProfileComplete // ignore: cast_nullable_to_non_nullable
              as bool,
      isSitterApproved: null == isSitterApproved
          ? _value.isSitterApproved
          : isSitterApproved // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserDtoImpl implements _UserDto {
  const _$UserDtoImpl(
      {required this.id,
      required this.email,
      this.firstName,
      this.lastName,
      @JsonKey(readValue: _readPhone) this.phoneNumber,
      @JsonKey(readValue: _readAvatarUrl) this.avatarUrl,
      this.role = 'parent',
      @JsonKey(readValue: _readProfileComplete) this.isProfileComplete = false,
      @JsonKey(name: 'phoneVerified') this.isSitterApproved = false,
      @JsonKey(name: 'createdAt') this.createdAt});

  factory _$UserDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String email;
  @override
  final String? firstName;
  @override
  final String? lastName;
  @override
  @JsonKey(readValue: _readPhone)
  final String? phoneNumber;
  @override
  @JsonKey(readValue: _readAvatarUrl)
  final String? avatarUrl;
  @override
  @JsonKey()
  final String role;
  @override
  @JsonKey(readValue: _readProfileComplete)
  final bool isProfileComplete;
  @override
  @JsonKey(name: 'phoneVerified')
  final bool isSitterApproved;
  @override
  @JsonKey(name: 'createdAt')
  final DateTime? createdAt;

  @override
  String toString() {
    return 'UserDto(id: $id, email: $email, firstName: $firstName, lastName: $lastName, phoneNumber: $phoneNumber, avatarUrl: $avatarUrl, role: $role, isProfileComplete: $isProfileComplete, isSitterApproved: $isSitterApproved, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.isProfileComplete, isProfileComplete) ||
                other.isProfileComplete == isProfileComplete) &&
            (identical(other.isSitterApproved, isSitterApproved) ||
                other.isSitterApproved == isSitterApproved) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      email,
      firstName,
      lastName,
      phoneNumber,
      avatarUrl,
      role,
      isProfileComplete,
      isSitterApproved,
      createdAt);

  /// Create a copy of UserDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserDtoImplCopyWith<_$UserDtoImpl> get copyWith =>
      __$$UserDtoImplCopyWithImpl<_$UserDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserDtoImplToJson(
      this,
    );
  }
}

abstract class _UserDto implements UserDto {
  const factory _UserDto(
      {required final String id,
      required final String email,
      final String? firstName,
      final String? lastName,
      @JsonKey(readValue: _readPhone) final String? phoneNumber,
      @JsonKey(readValue: _readAvatarUrl) final String? avatarUrl,
      final String role,
      @JsonKey(readValue: _readProfileComplete) final bool isProfileComplete,
      @JsonKey(name: 'phoneVerified') final bool isSitterApproved,
      @JsonKey(name: 'createdAt') final DateTime? createdAt}) = _$UserDtoImpl;

  factory _UserDto.fromJson(Map<String, dynamic> json) = _$UserDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get email;
  @override
  String? get firstName;
  @override
  String? get lastName;
  @override
  @JsonKey(readValue: _readPhone)
  String? get phoneNumber;
  @override
  @JsonKey(readValue: _readAvatarUrl)
  String? get avatarUrl;
  @override
  String get role;
  @override
  @JsonKey(readValue: _readProfileComplete)
  bool get isProfileComplete;
  @override
  @JsonKey(name: 'phoneVerified')
  bool get isSitterApproved;
  @override
  @JsonKey(name: 'createdAt')
  DateTime? get createdAt;

  /// Create a copy of UserDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserDtoImplCopyWith<_$UserDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
