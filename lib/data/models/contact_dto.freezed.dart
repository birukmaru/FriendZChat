// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contact_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ContactDto _$ContactDtoFromJson(Map<String, dynamic> json) {
  return _ContactDto.fromJson(json);
}

/// @nodoc
mixin _$ContactDto {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get photoUrl => throw _privateConstructorUsedError;
  String? get phoneNumber => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  bool get isFavorite => throw _privateConstructorUsedError;
  DateTime? get addedAt => throw _privateConstructorUsedError;

  /// Serializes this ContactDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ContactDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ContactDtoCopyWith<ContactDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContactDtoCopyWith<$Res> {
  factory $ContactDtoCopyWith(
          ContactDto value, $Res Function(ContactDto) then) =
      _$ContactDtoCopyWithImpl<$Res, ContactDto>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String name,
      String? photoUrl,
      String? phoneNumber,
      String? notes,
      bool isFavorite,
      DateTime? addedAt});
}

/// @nodoc
class _$ContactDtoCopyWithImpl<$Res, $Val extends ContactDto>
    implements $ContactDtoCopyWith<$Res> {
  _$ContactDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ContactDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? photoUrl = freezed,
    Object? phoneNumber = freezed,
    Object? notes = freezed,
    Object? isFavorite = null,
    Object? addedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      addedAt: freezed == addedAt
          ? _value.addedAt
          : addedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ContactDtoImplCopyWith<$Res>
    implements $ContactDtoCopyWith<$Res> {
  factory _$$ContactDtoImplCopyWith(
          _$ContactDtoImpl value, $Res Function(_$ContactDtoImpl) then) =
      __$$ContactDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String name,
      String? photoUrl,
      String? phoneNumber,
      String? notes,
      bool isFavorite,
      DateTime? addedAt});
}

/// @nodoc
class __$$ContactDtoImplCopyWithImpl<$Res>
    extends _$ContactDtoCopyWithImpl<$Res, _$ContactDtoImpl>
    implements _$$ContactDtoImplCopyWith<$Res> {
  __$$ContactDtoImplCopyWithImpl(
      _$ContactDtoImpl _value, $Res Function(_$ContactDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ContactDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? photoUrl = freezed,
    Object? phoneNumber = freezed,
    Object? notes = freezed,
    Object? isFavorite = null,
    Object? addedAt = freezed,
  }) {
    return _then(_$ContactDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      addedAt: freezed == addedAt
          ? _value.addedAt
          : addedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ContactDtoImpl extends _ContactDto {
  const _$ContactDtoImpl(
      {required this.id,
      required this.userId,
      required this.name,
      this.photoUrl,
      this.phoneNumber,
      this.notes,
      this.isFavorite = false,
      this.addedAt})
      : super._();

  factory _$ContactDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContactDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String name;
  @override
  final String? photoUrl;
  @override
  final String? phoneNumber;
  @override
  final String? notes;
  @override
  @JsonKey()
  final bool isFavorite;
  @override
  final DateTime? addedAt;

  @override
  String toString() {
    return 'ContactDto(id: $id, userId: $userId, name: $name, photoUrl: $photoUrl, phoneNumber: $phoneNumber, notes: $notes, isFavorite: $isFavorite, addedAt: $addedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContactDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite) &&
            (identical(other.addedAt, addedAt) || other.addedAt == addedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, name, photoUrl,
      phoneNumber, notes, isFavorite, addedAt);

  /// Create a copy of ContactDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ContactDtoImplCopyWith<_$ContactDtoImpl> get copyWith =>
      __$$ContactDtoImplCopyWithImpl<_$ContactDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ContactDtoImplToJson(
      this,
    );
  }
}

abstract class _ContactDto extends ContactDto {
  const factory _ContactDto(
      {required final String id,
      required final String userId,
      required final String name,
      final String? photoUrl,
      final String? phoneNumber,
      final String? notes,
      final bool isFavorite,
      final DateTime? addedAt}) = _$ContactDtoImpl;
  const _ContactDto._() : super._();

  factory _ContactDto.fromJson(Map<String, dynamic> json) =
      _$ContactDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get name;
  @override
  String? get photoUrl;
  @override
  String? get phoneNumber;
  @override
  String? get notes;
  @override
  bool get isFavorite;
  @override
  DateTime? get addedAt;

  /// Create a copy of ContactDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ContactDtoImplCopyWith<_$ContactDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
