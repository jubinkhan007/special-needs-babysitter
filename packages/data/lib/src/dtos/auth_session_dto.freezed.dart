// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_session_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AuthSessionDto _$AuthSessionDtoFromJson(Map<String, dynamic> json) {
  return _AuthSessionDto.fromJson(json);
}

/// @nodoc
mixin _$AuthSessionDto {
  UserDto get user => throw _privateConstructorUsedError;
  @JsonKey(name: 'access_token')
  String get accessToken => throw _privateConstructorUsedError;
  @JsonKey(name: 'refresh_token')
  String? get refreshToken => throw _privateConstructorUsedError;
  @JsonKey(name: 'expires_at')
  DateTime? get expiresAt => throw _privateConstructorUsedError;

  /// Serializes this AuthSessionDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AuthSessionDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthSessionDtoCopyWith<AuthSessionDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthSessionDtoCopyWith<$Res> {
  factory $AuthSessionDtoCopyWith(
          AuthSessionDto value, $Res Function(AuthSessionDto) then) =
      _$AuthSessionDtoCopyWithImpl<$Res, AuthSessionDto>;
  @useResult
  $Res call(
      {UserDto user,
      @JsonKey(name: 'access_token') String accessToken,
      @JsonKey(name: 'refresh_token') String? refreshToken,
      @JsonKey(name: 'expires_at') DateTime? expiresAt});

  $UserDtoCopyWith<$Res> get user;
}

/// @nodoc
class _$AuthSessionDtoCopyWithImpl<$Res, $Val extends AuthSessionDto>
    implements $AuthSessionDtoCopyWith<$Res> {
  _$AuthSessionDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthSessionDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
    Object? accessToken = null,
    Object? refreshToken = freezed,
    Object? expiresAt = freezed,
  }) {
    return _then(_value.copyWith(
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserDto,
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: freezed == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  /// Create a copy of AuthSessionDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserDtoCopyWith<$Res> get user {
    return $UserDtoCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AuthSessionDtoImplCopyWith<$Res>
    implements $AuthSessionDtoCopyWith<$Res> {
  factory _$$AuthSessionDtoImplCopyWith(_$AuthSessionDtoImpl value,
          $Res Function(_$AuthSessionDtoImpl) then) =
      __$$AuthSessionDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {UserDto user,
      @JsonKey(name: 'access_token') String accessToken,
      @JsonKey(name: 'refresh_token') String? refreshToken,
      @JsonKey(name: 'expires_at') DateTime? expiresAt});

  @override
  $UserDtoCopyWith<$Res> get user;
}

/// @nodoc
class __$$AuthSessionDtoImplCopyWithImpl<$Res>
    extends _$AuthSessionDtoCopyWithImpl<$Res, _$AuthSessionDtoImpl>
    implements _$$AuthSessionDtoImplCopyWith<$Res> {
  __$$AuthSessionDtoImplCopyWithImpl(
      _$AuthSessionDtoImpl _value, $Res Function(_$AuthSessionDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthSessionDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
    Object? accessToken = null,
    Object? refreshToken = freezed,
    Object? expiresAt = freezed,
  }) {
    return _then(_$AuthSessionDtoImpl(
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserDto,
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: freezed == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AuthSessionDtoImpl implements _AuthSessionDto {
  const _$AuthSessionDtoImpl(
      {required this.user,
      @JsonKey(name: 'access_token') required this.accessToken,
      @JsonKey(name: 'refresh_token') this.refreshToken,
      @JsonKey(name: 'expires_at') this.expiresAt});

  factory _$AuthSessionDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthSessionDtoImplFromJson(json);

  @override
  final UserDto user;
  @override
  @JsonKey(name: 'access_token')
  final String accessToken;
  @override
  @JsonKey(name: 'refresh_token')
  final String? refreshToken;
  @override
  @JsonKey(name: 'expires_at')
  final DateTime? expiresAt;

  @override
  String toString() {
    return 'AuthSessionDto(user: $user, accessToken: $accessToken, refreshToken: $refreshToken, expiresAt: $expiresAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthSessionDtoImpl &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, user, accessToken, refreshToken, expiresAt);

  /// Create a copy of AuthSessionDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthSessionDtoImplCopyWith<_$AuthSessionDtoImpl> get copyWith =>
      __$$AuthSessionDtoImplCopyWithImpl<_$AuthSessionDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthSessionDtoImplToJson(
      this,
    );
  }
}

abstract class _AuthSessionDto implements AuthSessionDto {
  const factory _AuthSessionDto(
          {required final UserDto user,
          @JsonKey(name: 'access_token') required final String accessToken,
          @JsonKey(name: 'refresh_token') final String? refreshToken,
          @JsonKey(name: 'expires_at') final DateTime? expiresAt}) =
      _$AuthSessionDtoImpl;

  factory _AuthSessionDto.fromJson(Map<String, dynamic> json) =
      _$AuthSessionDtoImpl.fromJson;

  @override
  UserDto get user;
  @override
  @JsonKey(name: 'access_token')
  String get accessToken;
  @override
  @JsonKey(name: 'refresh_token')
  String? get refreshToken;
  @override
  @JsonKey(name: 'expires_at')
  DateTime? get expiresAt;

  /// Create a copy of AuthSessionDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthSessionDtoImplCopyWith<_$AuthSessionDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
