/// Domain entity: a call record / history entry.
library;

import 'package:equatable/equatable.dart';

enum CallDirection { outgoing, incoming, missed }

enum CallStatus { completed, missed, rejected, failed, busy }

class CallRecord extends Equatable {
  const CallRecord({
    required this.id,
    required this.remoteUserId,
    required this.remoteName,
    required this.startedAt,
    this.direction = CallDirection.outgoing,
    this.duration = Duration.zero,
    this.status = CallStatus.completed,
    this.notes,
    this.remotePhotoUrl,
    this.wasFavorite = false,
  });

  final String id;
  final String remoteUserId;
  final String remoteName;
  final String? remotePhotoUrl;
  final DateTime startedAt;
  final CallDirection direction;
  final Duration duration;
  final CallStatus status;
  final String? notes;
  final bool wasFavorite;

  bool get isMissed =>
      status == CallStatus.missed || direction == CallDirection.missed;

  /// Convenience: formatted dial destination.
  String get dialDestination => '8776$remoteUserId';

  CallRecord copyWith({
    String? id,
    String? remoteUserId,
    String? remoteName,
    String? remotePhotoUrl,
    DateTime? startedAt,
    CallDirection? direction,
    Duration? duration,
    CallStatus? status,
    String? notes,
    bool? wasFavorite,
  }) =>
      CallRecord(
        id: id ?? this.id,
        remoteUserId: remoteUserId ?? this.remoteUserId,
        remoteName: remoteName ?? this.remoteName,
        remotePhotoUrl: remotePhotoUrl ?? this.remotePhotoUrl,
        startedAt: startedAt ?? this.startedAt,
        direction: direction ?? this.direction,
        duration: duration ?? this.duration,
        status: status ?? this.status,
        notes: notes ?? this.notes,
        wasFavorite: wasFavorite ?? this.wasFavorite,
      );

  @override
  List<Object?> get props => [
        id,
        remoteUserId,
        remoteName,
        remotePhotoUrl,
        startedAt,
        direction,
        duration,
        status,
        notes,
        wasFavorite,
      ];
}