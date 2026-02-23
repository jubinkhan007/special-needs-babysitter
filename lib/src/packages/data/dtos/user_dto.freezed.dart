// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserDto {

 String get id; String get email; String? get firstName; String? get lastName;@JsonKey(readValue: _readPhone) String? get phoneNumber;@JsonKey(readValue: _readAvatarUrl) String? get avatarUrl; String get role;@JsonKey(readValue: _readProfileComplete) bool get isProfileComplete;@JsonKey(name: 'phoneVerified') bool get isSitterApproved;@JsonKey(name: 'createdAt') DateTime? get createdAt;
/// Create a copy of UserDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserDtoCopyWith<UserDto> get copyWith => _$UserDtoCopyWithImpl<UserDto>(this as UserDto, _$identity);

  /// Serializes this UserDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserDto&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.role, role) || other.role == role)&&(identical(other.isProfileComplete, isProfileComplete) || other.isProfileComplete == isProfileComplete)&&(identical(other.isSitterApproved, isSitterApproved) || other.isSitterApproved == isSitterApproved)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,firstName,lastName,phoneNumber,avatarUrl,role,isProfileComplete,isSitterApproved,createdAt);

@override
String toString() {
  return 'UserDto(id: $id, email: $email, firstName: $firstName, lastName: $lastName, phoneNumber: $phoneNumber, avatarUrl: $avatarUrl, role: $role, isProfileComplete: $isProfileComplete, isSitterApproved: $isSitterApproved, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $UserDtoCopyWith<$Res>  {
  factory $UserDtoCopyWith(UserDto value, $Res Function(UserDto) _then) = _$UserDtoCopyWithImpl;
@useResult
$Res call({
 String id, String email, String? firstName, String? lastName,@JsonKey(readValue: _readPhone) String? phoneNumber,@JsonKey(readValue: _readAvatarUrl) String? avatarUrl, String role,@JsonKey(readValue: _readProfileComplete) bool isProfileComplete,@JsonKey(name: 'phoneVerified') bool isSitterApproved,@JsonKey(name: 'createdAt') DateTime? createdAt
});




}
/// @nodoc
class _$UserDtoCopyWithImpl<$Res>
    implements $UserDtoCopyWith<$Res> {
  _$UserDtoCopyWithImpl(this._self, this._then);

  final UserDto _self;
  final $Res Function(UserDto) _then;

/// Create a copy of UserDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = null,Object? firstName = freezed,Object? lastName = freezed,Object? phoneNumber = freezed,Object? avatarUrl = freezed,Object? role = null,Object? isProfileComplete = null,Object? isSitterApproved = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,isProfileComplete: null == isProfileComplete ? _self.isProfileComplete : isProfileComplete // ignore: cast_nullable_to_non_nullable
as bool,isSitterApproved: null == isSitterApproved ? _self.isSitterApproved : isSitterApproved // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserDto].
extension UserDtoPatterns on UserDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserDto value)  $default,){
final _that = this;
switch (_that) {
case _UserDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserDto value)?  $default,){
final _that = this;
switch (_that) {
case _UserDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String email,  String? firstName,  String? lastName, @JsonKey(readValue: _readPhone)  String? phoneNumber, @JsonKey(readValue: _readAvatarUrl)  String? avatarUrl,  String role, @JsonKey(readValue: _readProfileComplete)  bool isProfileComplete, @JsonKey(name: 'phoneVerified')  bool isSitterApproved, @JsonKey(name: 'createdAt')  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserDto() when $default != null:
return $default(_that.id,_that.email,_that.firstName,_that.lastName,_that.phoneNumber,_that.avatarUrl,_that.role,_that.isProfileComplete,_that.isSitterApproved,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String email,  String? firstName,  String? lastName, @JsonKey(readValue: _readPhone)  String? phoneNumber, @JsonKey(readValue: _readAvatarUrl)  String? avatarUrl,  String role, @JsonKey(readValue: _readProfileComplete)  bool isProfileComplete, @JsonKey(name: 'phoneVerified')  bool isSitterApproved, @JsonKey(name: 'createdAt')  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _UserDto():
return $default(_that.id,_that.email,_that.firstName,_that.lastName,_that.phoneNumber,_that.avatarUrl,_that.role,_that.isProfileComplete,_that.isSitterApproved,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String email,  String? firstName,  String? lastName, @JsonKey(readValue: _readPhone)  String? phoneNumber, @JsonKey(readValue: _readAvatarUrl)  String? avatarUrl,  String role, @JsonKey(readValue: _readProfileComplete)  bool isProfileComplete, @JsonKey(name: 'phoneVerified')  bool isSitterApproved, @JsonKey(name: 'createdAt')  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _UserDto() when $default != null:
return $default(_that.id,_that.email,_that.firstName,_that.lastName,_that.phoneNumber,_that.avatarUrl,_that.role,_that.isProfileComplete,_that.isSitterApproved,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserDto implements UserDto {
  const _UserDto({required this.id, required this.email, this.firstName, this.lastName, @JsonKey(readValue: _readPhone) this.phoneNumber, @JsonKey(readValue: _readAvatarUrl) this.avatarUrl, this.role = 'parent', @JsonKey(readValue: _readProfileComplete) this.isProfileComplete = false, @JsonKey(name: 'phoneVerified') this.isSitterApproved = false, @JsonKey(name: 'createdAt') this.createdAt});
  factory _UserDto.fromJson(Map<String, dynamic> json) => _$UserDtoFromJson(json);

@override final  String id;
@override final  String email;
@override final  String? firstName;
@override final  String? lastName;
@override@JsonKey(readValue: _readPhone) final  String? phoneNumber;
@override@JsonKey(readValue: _readAvatarUrl) final  String? avatarUrl;
@override@JsonKey() final  String role;
@override@JsonKey(readValue: _readProfileComplete) final  bool isProfileComplete;
@override@JsonKey(name: 'phoneVerified') final  bool isSitterApproved;
@override@JsonKey(name: 'createdAt') final  DateTime? createdAt;

/// Create a copy of UserDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserDtoCopyWith<_UserDto> get copyWith => __$UserDtoCopyWithImpl<_UserDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserDto&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.role, role) || other.role == role)&&(identical(other.isProfileComplete, isProfileComplete) || other.isProfileComplete == isProfileComplete)&&(identical(other.isSitterApproved, isSitterApproved) || other.isSitterApproved == isSitterApproved)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,firstName,lastName,phoneNumber,avatarUrl,role,isProfileComplete,isSitterApproved,createdAt);

@override
String toString() {
  return 'UserDto(id: $id, email: $email, firstName: $firstName, lastName: $lastName, phoneNumber: $phoneNumber, avatarUrl: $avatarUrl, role: $role, isProfileComplete: $isProfileComplete, isSitterApproved: $isSitterApproved, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$UserDtoCopyWith<$Res> implements $UserDtoCopyWith<$Res> {
  factory _$UserDtoCopyWith(_UserDto value, $Res Function(_UserDto) _then) = __$UserDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String email, String? firstName, String? lastName,@JsonKey(readValue: _readPhone) String? phoneNumber,@JsonKey(readValue: _readAvatarUrl) String? avatarUrl, String role,@JsonKey(readValue: _readProfileComplete) bool isProfileComplete,@JsonKey(name: 'phoneVerified') bool isSitterApproved,@JsonKey(name: 'createdAt') DateTime? createdAt
});




}
/// @nodoc
class __$UserDtoCopyWithImpl<$Res>
    implements _$UserDtoCopyWith<$Res> {
  __$UserDtoCopyWithImpl(this._self, this._then);

  final _UserDto _self;
  final $Res Function(_UserDto) _then;

/// Create a copy of UserDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = null,Object? firstName = freezed,Object? lastName = freezed,Object? phoneNumber = freezed,Object? avatarUrl = freezed,Object? role = null,Object? isProfileComplete = null,Object? isSitterApproved = null,Object? createdAt = freezed,}) {
  return _then(_UserDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,isProfileComplete: null == isProfileComplete ? _self.isProfileComplete : isProfileComplete // ignore: cast_nullable_to_non_nullable
as bool,isSitterApproved: null == isSitterApproved ? _self.isSitterApproved : isSitterApproved // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
