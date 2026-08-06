/// DTO for an in-app notification.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:friendzchat/domain/entities/app_notification.dart';

part 'app_notification_dto.freezed.dart';
part 'app_notification_dto.g.dart';

@freezed
class AppNotificationDto with _$AppNotificationDto {
  const factory AppNotificationDto({
    required String id,
    required String title,
    required String body,
    required DateTime createdAt,
    @Default(AppNotificationKind.tip) AppNotificationKind kind,
    @Default(false) bool isRead,
    String? deepLink,
    String? imageUrl,
  }) = _AppNotificationDto;

  factory AppNotificationDto.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationDtoFromJson(json);

  const AppNotificationDto._();

  factory AppNotificationDto.fromEntity(AppNotification n) =>
      AppNotificationDto(
        id: n.id,
        title: n.title,
        body: n.body,
        createdAt: n.createdAt,
        kind: n.kind,
        isRead: n.isRead,
        deepLink: n.deepLink,
        imageUrl: n.imageUrl,
      );

  AppNotification toEntity() => AppNotification(
        id: id,
        title: title,
        body: body,
        createdAt: createdAt,
        kind: kind,
        isRead: isRead,
        deepLink: deepLink,
        imageUrl: imageUrl,
      );
}