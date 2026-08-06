// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_record_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CallRecordDtoImpl _$$CallRecordDtoImplFromJson(Map<String, dynamic> json) =>
    _$CallRecordDtoImpl(
      id: json['id'] as String,
      remoteUserId: json['remoteUserId'] as String,
      remoteName: json['remoteName'] as String,
      remotePhotoUrl: json['remotePhotoUrl'] as String?,
      startedAt: DateTime.parse(json['startedAt'] as String),
      direction:
          $enumDecodeNullable(_$CallDirectionEnumMap, json['direction']) ??
              CallDirection.outgoing,
      duration: json['duration'] == null
          ? Duration.zero
          : Duration(microseconds: (json['duration'] as num).toInt()),
      status: $enumDecodeNullable(_$CallStatusEnumMap, json['status']) ??
          CallStatus.completed,
      notes: json['notes'] as String?,
      wasFavorite: json['wasFavorite'] as bool? ?? false,
    );

Map<String, dynamic> _$$CallRecordDtoImplToJson(_$CallRecordDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'remoteUserId': instance.remoteUserId,
      'remoteName': instance.remoteName,
      'remotePhotoUrl': instance.remotePhotoUrl,
      'startedAt': instance.startedAt.toIso8601String(),
      'direction': _$CallDirectionEnumMap[instance.direction]!,
      'duration': instance.duration.inMicroseconds,
      'status': _$CallStatusEnumMap[instance.status]!,
      'notes': instance.notes,
      'wasFavorite': instance.wasFavorite,
    };

const _$CallDirectionEnumMap = {
  CallDirection.outgoing: 'outgoing',
  CallDirection.incoming: 'incoming',
  CallDirection.missed: 'missed',
};

const _$CallStatusEnumMap = {
  CallStatus.completed: 'completed',
  CallStatus.missed: 'missed',
  CallStatus.rejected: 'rejected',
  CallStatus.failed: 'failed',
  CallStatus.busy: 'busy',
};
