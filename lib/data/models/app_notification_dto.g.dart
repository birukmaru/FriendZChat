// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_notification_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppNotificationDtoImpl _$$AppNotificationDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$AppNotificationDtoImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      kind: $enumDecodeNullable(_$AppNotificationKindEnumMap, json['kind']) ??
          AppNotificationKind.tip,
      isRead: json['isRead'] as bool? ?? false,
      deepLink: json['deepLink'] as String?,
      imageUrl: json['imageUrl'] as String?,
    );

Map<String, dynamic> _$$AppNotificationDtoImplToJson(
        _$AppNotificationDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'createdAt': instance.createdAt.toIso8601String(),
      'kind': _$AppNotificationKindEnumMap[instance.kind]!,
      'isRead': instance.isRead,
      'deepLink': instance.deepLink,
      'imageUrl': instance.imageUrl,
    };

const _$AppNotificationKindEnumMap = {
  AppNotificationKind.reminder: 'reminder',
  AppNotificationKind.tip: 'tip',
  AppNotificationKind.update: 'update',
  AppNotificationKind.alert: 'alert',
  AppNotificationKind.marketing: 'marketing',
};
