/// Domain entity: a local push-style notification surfaced inside the app.
library;

import 'package:equatable/equatable.dart';

enum AppNotificationKind { reminder, tip, update, alert, marketing }

class AppNotification extends Equatable {
  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    this.kind = AppNotificationKind.tip,
    this.isRead = false,
    this.deepLink,
    this.imageUrl,
  });

  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  final AppNotificationKind kind;
  final bool isRead;

  /// Optional route to navigate to when tapped.
  final String? deepLink;

  /// Optional image to display.
  final String? imageUrl;

  AppNotification copyWith({
    String? id,
    String? title,
    String? body,
    DateTime? createdAt,
    AppNotificationKind? kind,
    bool? isRead,
    String? deepLink,
    String? imageUrl,
  }) =>
      AppNotification(
        id: id ?? this.id,
        title: title ?? this.title,
        body: body ?? this.body,
        createdAt: createdAt ?? this.createdAt,
        kind: kind ?? this.kind,
        isRead: isRead ?? this.isRead,
        deepLink: deepLink ?? this.deepLink,
        imageUrl: imageUrl ?? this.imageUrl,
      );

  @override
  List<Object?> get props => [id, title, body, createdAt, kind, isRead, deepLink, imageUrl];
}