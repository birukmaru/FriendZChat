// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_notification_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AppNotificationDto _$AppNotificationDtoFromJson(Map<String, dynamic> json) {
  return _AppNotificationDto.fromJson(json);
}

/// @nodoc
mixin _$AppNotificationDto {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get body => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  AppNotificationKind get kind => throw _privateConstructorUsedError;
  bool get isRead => throw _privateConstructorUsedError;
  String? get deepLink => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;

  /// Serializes this AppNotificationDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppNotificationDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppNotificationDtoCopyWith<AppNotificationDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppNotificationDtoCopyWith<$Res> {
  factory $AppNotificationDtoCopyWith(
          AppNotificationDto value, $Res Function(AppNotificationDto) then) =
      _$AppNotificationDtoCopyWithImpl<$Res, AppNotificationDto>;
  @useResult
  $Res call(
      {String id,
      String title,
      String body,
      DateTime createdAt,
      AppNotificationKind kind,
      bool isRead,
      String? deepLink,
      String? imageUrl});
}

/// @nodoc
class _$AppNotificationDtoCopyWithImpl<$Res, $Val extends AppNotificationDto>
    implements $AppNotificationDtoCopyWith<$Res> {
  _$AppNotificationDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppNotificationDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? body = null,
    Object? createdAt = null,
    Object? kind = null,
    Object? isRead = null,
    Object? deepLink = freezed,
    Object? imageUrl = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      kind: null == kind
          ? _value.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as AppNotificationKind,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      deepLink: freezed == deepLink
          ? _value.deepLink
          : deepLink // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppNotificationDtoImplCopyWith<$Res>
    implements $AppNotificationDtoCopyWith<$Res> {
  factory _$$AppNotificationDtoImplCopyWith(_$AppNotificationDtoImpl value,
          $Res Function(_$AppNotificationDtoImpl) then) =
      __$$AppNotificationDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String body,
      DateTime createdAt,
      AppNotificationKind kind,
      bool isRead,
      String? deepLink,
      String? imageUrl});
}

/// @nodoc
class __$$AppNotificationDtoImplCopyWithImpl<$Res>
    extends _$AppNotificationDtoCopyWithImpl<$Res, _$AppNotificationDtoImpl>
    implements _$$AppNotificationDtoImplCopyWith<$Res> {
  __$$AppNotificationDtoImplCopyWithImpl(_$AppNotificationDtoImpl _value,
      $Res Function(_$AppNotificationDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppNotificationDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? body = null,
    Object? createdAt = null,
    Object? kind = null,
    Object? isRead = null,
    Object? deepLink = freezed,
    Object? imageUrl = freezed,
  }) {
    return _then(_$AppNotificationDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      kind: null == kind
          ? _value.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as AppNotificationKind,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      deepLink: freezed == deepLink
          ? _value.deepLink
          : deepLink // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AppNotificationDtoImpl extends _AppNotificationDto {
  const _$AppNotificationDtoImpl(
      {required this.id,
      required this.title,
      required this.body,
      required this.createdAt,
      this.kind = AppNotificationKind.tip,
      this.isRead = false,
      this.deepLink,
      this.imageUrl})
      : super._();

  factory _$AppNotificationDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppNotificationDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String body;
  @override
  final DateTime createdAt;
  @override
  @JsonKey()
  final AppNotificationKind kind;
  @override
  @JsonKey()
  final bool isRead;
  @override
  final String? deepLink;
  @override
  final String? imageUrl;

  @override
  String toString() {
    return 'AppNotificationDto(id: $id, title: $title, body: $body, createdAt: $createdAt, kind: $kind, isRead: $isRead, deepLink: $deepLink, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppNotificationDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.kind, kind) || other.kind == kind) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.deepLink, deepLink) ||
                other.deepLink == deepLink) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, body, createdAt, kind,
      isRead, deepLink, imageUrl);

  /// Create a copy of AppNotificationDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppNotificationDtoImplCopyWith<_$AppNotificationDtoImpl> get copyWith =>
      __$$AppNotificationDtoImplCopyWithImpl<_$AppNotificationDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppNotificationDtoImplToJson(
      this,
    );
  }
}

abstract class _AppNotificationDto extends AppNotificationDto {
  const factory _AppNotificationDto(
      {required final String id,
      required final String title,
      required final String body,
      required final DateTime createdAt,
      final AppNotificationKind kind,
      final bool isRead,
      final String? deepLink,
      final String? imageUrl}) = _$AppNotificationDtoImpl;
  const _AppNotificationDto._() : super._();

  factory _AppNotificationDto.fromJson(Map<String, dynamic> json) =
      _$AppNotificationDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get body;
  @override
  DateTime get createdAt;
  @override
  AppNotificationKind get kind;
  @override
  bool get isRead;
  @override
  String? get deepLink;
  @override
  String? get imageUrl;

  /// Create a copy of AppNotificationDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppNotificationDtoImplCopyWith<_$AppNotificationDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
