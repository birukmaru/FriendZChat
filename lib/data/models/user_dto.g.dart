// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserDtoImpl _$$UserDtoImplFromJson(Map<String, dynamic> json) =>
    _$UserDtoImpl(
      id: json['id'] as String,
      nickname: json['nickname'] as String?,
      photoUrl: json['photoUrl'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      email: json['email'] as String?,
      bio: json['bio'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      lastSeen: json['lastSeen'] == null
          ? null
          : DateTime.parse(json['lastSeen'] as String),
      isVerified: json['isVerified'] as bool? ?? false,
    );

Map<String, dynamic> _$$UserDtoImplToJson(_$UserDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nickname': instance.nickname,
      'photoUrl': instance.photoUrl,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'bio': instance.bio,
      'createdAt': instance.createdAt?.toIso8601String(),
      'lastSeen': instance.lastSeen?.toIso8601String(),
      'isVerified': instance.isVerified,
    };
