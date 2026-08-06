// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ContactDtoImpl _$$ContactDtoImplFromJson(Map<String, dynamic> json) =>
    _$ContactDtoImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      photoUrl: json['photoUrl'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      notes: json['notes'] as String?,
      isFavorite: json['isFavorite'] as bool? ?? false,
      addedAt: json['addedAt'] == null
          ? null
          : DateTime.parse(json['addedAt'] as String),
    );

Map<String, dynamic> _$$ContactDtoImplToJson(_$ContactDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'name': instance.name,
      'photoUrl': instance.photoUrl,
      'phoneNumber': instance.phoneNumber,
      'notes': instance.notes,
      'isFavorite': instance.isFavorite,
      'addedAt': instance.addedAt?.toIso8601String(),
    };
