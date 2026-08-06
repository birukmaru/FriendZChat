// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_record_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CallRecordDto _$CallRecordDtoFromJson(Map<String, dynamic> json) {
  return _CallRecordDto.fromJson(json);
}

/// @nodoc
mixin _$CallRecordDto {
  String get id => throw _privateConstructorUsedError;
  String get remoteUserId => throw _privateConstructorUsedError;
  String get remoteName => throw _privateConstructorUsedError;
  String? get remotePhotoUrl => throw _privateConstructorUsedError;
  DateTime get startedAt => throw _privateConstructorUsedError;
  CallDirection get direction => throw _privateConstructorUsedError;
  Duration get duration => throw _privateConstructorUsedError;
  CallStatus get status => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  bool get wasFavorite => throw _privateConstructorUsedError;

  /// Serializes this CallRecordDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CallRecordDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CallRecordDtoCopyWith<CallRecordDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CallRecordDtoCopyWith<$Res> {
  factory $CallRecordDtoCopyWith(
          CallRecordDto value, $Res Function(CallRecordDto) then) =
      _$CallRecordDtoCopyWithImpl<$Res, CallRecordDto>;
  @useResult
  $Res call(
      {String id,
      String remoteUserId,
      String remoteName,
      String? remotePhotoUrl,
      DateTime startedAt,
      CallDirection direction,
      Duration duration,
      CallStatus status,
      String? notes,
      bool wasFavorite});
}

/// @nodoc
class _$CallRecordDtoCopyWithImpl<$Res, $Val extends CallRecordDto>
    implements $CallRecordDtoCopyWith<$Res> {
  _$CallRecordDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CallRecordDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? remoteUserId = null,
    Object? remoteName = null,
    Object? remotePhotoUrl = freezed,
    Object? startedAt = null,
    Object? direction = null,
    Object? duration = null,
    Object? status = null,
    Object? notes = freezed,
    Object? wasFavorite = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      remoteUserId: null == remoteUserId
          ? _value.remoteUserId
          : remoteUserId // ignore: cast_nullable_to_non_nullable
              as String,
      remoteName: null == remoteName
          ? _value.remoteName
          : remoteName // ignore: cast_nullable_to_non_nullable
              as String,
      remotePhotoUrl: freezed == remotePhotoUrl
          ? _value.remotePhotoUrl
          : remotePhotoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      startedAt: null == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      direction: null == direction
          ? _value.direction
          : direction // ignore: cast_nullable_to_non_nullable
              as CallDirection,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as CallStatus,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      wasFavorite: null == wasFavorite
          ? _value.wasFavorite
          : wasFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CallRecordDtoImplCopyWith<$Res>
    implements $CallRecordDtoCopyWith<$Res> {
  factory _$$CallRecordDtoImplCopyWith(
          _$CallRecordDtoImpl value, $Res Function(_$CallRecordDtoImpl) then) =
      __$$CallRecordDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String remoteUserId,
      String remoteName,
      String? remotePhotoUrl,
      DateTime startedAt,
      CallDirection direction,
      Duration duration,
      CallStatus status,
      String? notes,
      bool wasFavorite});
}

/// @nodoc
class __$$CallRecordDtoImplCopyWithImpl<$Res>
    extends _$CallRecordDtoCopyWithImpl<$Res, _$CallRecordDtoImpl>
    implements _$$CallRecordDtoImplCopyWith<$Res> {
  __$$CallRecordDtoImplCopyWithImpl(
      _$CallRecordDtoImpl _value, $Res Function(_$CallRecordDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of CallRecordDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? remoteUserId = null,
    Object? remoteName = null,
    Object? remotePhotoUrl = freezed,
    Object? startedAt = null,
    Object? direction = null,
    Object? duration = null,
    Object? status = null,
    Object? notes = freezed,
    Object? wasFavorite = null,
  }) {
    return _then(_$CallRecordDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      remoteUserId: null == remoteUserId
          ? _value.remoteUserId
          : remoteUserId // ignore: cast_nullable_to_non_nullable
              as String,
      remoteName: null == remoteName
          ? _value.remoteName
          : remoteName // ignore: cast_nullable_to_non_nullable
              as String,
      remotePhotoUrl: freezed == remotePhotoUrl
          ? _value.remotePhotoUrl
          : remotePhotoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      startedAt: null == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      direction: null == direction
          ? _value.direction
          : direction // ignore: cast_nullable_to_non_nullable
              as CallDirection,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as CallStatus,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      wasFavorite: null == wasFavorite
          ? _value.wasFavorite
          : wasFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CallRecordDtoImpl extends _CallRecordDto {
  const _$CallRecordDtoImpl(
      {required this.id,
      required this.remoteUserId,
      required this.remoteName,
      this.remotePhotoUrl,
      required this.startedAt,
      this.direction = CallDirection.outgoing,
      this.duration = Duration.zero,
      this.status = CallStatus.completed,
      this.notes,
      this.wasFavorite = false})
      : super._();

  factory _$CallRecordDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CallRecordDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String remoteUserId;
  @override
  final String remoteName;
  @override
  final String? remotePhotoUrl;
  @override
  final DateTime startedAt;
  @override
  @JsonKey()
  final CallDirection direction;
  @override
  @JsonKey()
  final Duration duration;
  @override
  @JsonKey()
  final CallStatus status;
  @override
  final String? notes;
  @override
  @JsonKey()
  final bool wasFavorite;

  @override
  String toString() {
    return 'CallRecordDto(id: $id, remoteUserId: $remoteUserId, remoteName: $remoteName, remotePhotoUrl: $remotePhotoUrl, startedAt: $startedAt, direction: $direction, duration: $duration, status: $status, notes: $notes, wasFavorite: $wasFavorite)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CallRecordDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.remoteUserId, remoteUserId) ||
                other.remoteUserId == remoteUserId) &&
            (identical(other.remoteName, remoteName) ||
                other.remoteName == remoteName) &&
            (identical(other.remotePhotoUrl, remotePhotoUrl) ||
                other.remotePhotoUrl == remotePhotoUrl) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.direction, direction) ||
                other.direction == direction) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.wasFavorite, wasFavorite) ||
                other.wasFavorite == wasFavorite));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      remoteUserId,
      remoteName,
      remotePhotoUrl,
      startedAt,
      direction,
      duration,
      status,
      notes,
      wasFavorite);

  /// Create a copy of CallRecordDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CallRecordDtoImplCopyWith<_$CallRecordDtoImpl> get copyWith =>
      __$$CallRecordDtoImplCopyWithImpl<_$CallRecordDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CallRecordDtoImplToJson(
      this,
    );
  }
}

abstract class _CallRecordDto extends CallRecordDto {
  const factory _CallRecordDto(
      {required final String id,
      required final String remoteUserId,
      required final String remoteName,
      final String? remotePhotoUrl,
      required final DateTime startedAt,
      final CallDirection direction,
      final Duration duration,
      final CallStatus status,
      final String? notes,
      final bool wasFavorite}) = _$CallRecordDtoImpl;
  const _CallRecordDto._() : super._();

  factory _CallRecordDto.fromJson(Map<String, dynamic> json) =
      _$CallRecordDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get remoteUserId;
  @override
  String get remoteName;
  @override
  String? get remotePhotoUrl;
  @override
  DateTime get startedAt;
  @override
  CallDirection get direction;
  @override
  Duration get duration;
  @override
  CallStatus get status;
  @override
  String? get notes;
  @override
  bool get wasFavorite;

  /// Create a copy of CallRecordDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CallRecordDtoImplCopyWith<_$CallRecordDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
