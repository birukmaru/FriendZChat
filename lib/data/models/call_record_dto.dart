/// DTO for a CallRecord — local-cache friendly.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:friendzchat/domain/entities/call_record.dart';

part 'call_record_dto.freezed.dart';
part 'call_record_dto.g.dart';

@freezed
class CallRecordDto with _$CallRecordDto {
  const factory CallRecordDto({
    required String id,
    required String remoteUserId,
    required String remoteName,
    String? remotePhotoUrl,
    required DateTime startedAt,
    @Default(CallDirection.outgoing) CallDirection direction,
    @Default(Duration.zero) Duration duration,
    @Default(CallStatus.completed) CallStatus status,
    String? notes,
    @Default(false) bool wasFavorite,
  }) = _CallRecordDto;

  factory CallRecordDto.fromJson(Map<String, dynamic> json) =>
      _$CallRecordDtoFromJson(json);

  const CallRecordDto._();

  factory CallRecordDto.fromEntity(CallRecord r) => CallRecordDto(
        id: r.id,
        remoteUserId: r.remoteUserId,
        remoteName: r.remoteName,
        remotePhotoUrl: r.remotePhotoUrl,
        startedAt: r.startedAt,
        direction: r.direction,
        duration: r.duration,
        status: r.status,
        notes: r.notes,
        wasFavorite: r.wasFavorite,
      );

  CallRecord toEntity() => CallRecord(
        id: id,
        remoteUserId: remoteUserId,
        remoteName: remoteName,
        remotePhotoUrl: remotePhotoUrl,
        startedAt: startedAt,
        direction: direction,
        duration: duration,
        status: status,
        notes: notes,
        wasFavorite: wasFavorite,
      );
}