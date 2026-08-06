/// DTOs for User — serialised for transport over the wire / cache.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:friendzchat/domain/entities/user.dart';

part 'user_dto.freezed.dart';
part 'user_dto.g.dart';

@freezed
class UserDto with _$UserDto {
  const factory UserDto({
    required String id,
    String? nickname,
    String? photoUrl,
    String? phoneNumber,
    String? email,
    String? bio,
    DateTime? createdAt,
    DateTime? lastSeen,
    @Default(false) bool isVerified,
  }) = _UserDto;

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);

  const UserDto._();

  factory UserDto.fromEntity(User u) => UserDto(
        id: u.id,
        nickname: u.nickname,
        photoUrl: u.photoUrl,
        phoneNumber: u.phoneNumber,
        email: u.email,
        bio: u.bio,
        createdAt: u.createdAt,
        lastSeen: u.lastSeen,
        isVerified: u.isVerified,
      );

  User toEntity() => User(
        id: id,
        nickname: nickname,
        photoUrl: photoUrl,
        phoneNumber: phoneNumber,
        email: email,
        bio: bio,
        createdAt: createdAt,
        lastSeen: lastSeen,
        isVerified: isVerified,
      );
}