/// Domain entity: the registered FriendZChat user.
library;

import 'package:equatable/equatable.dart';

/// Immutable representation of a user of the service.
class User extends Equatable {
  const User({
    required this.id,
    this.nickname,
    this.photoUrl,
    this.phoneNumber,
    this.bio,
    this.email,
    this.createdAt,
    this.lastSeen,
    this.isVerified = false,
  });

  /// 6-digit FriendZChat ID issued by the telecom service.
  final String id;
  final String? nickname;
  final String? photoUrl;
  final String? phoneNumber;
  final String? email;
  final String? bio;
  final DateTime? createdAt;
  final DateTime? lastSeen;

  /// Whether the telecom operator has verified this ID.
  final bool isVerified;

  /// Display name with sensible fallback.
  String get displayName => (nickname?.trim().isNotEmpty ?? false)
      ? nickname!.trim()
      : 'User $id';

  /// Initial letter used for avatar placeholders.
  String get initial =>
      (nickname?.isNotEmpty == true) ? nickname![0].toUpperCase() : id[0];

  User copyWith({
    String? id,
    String? nickname,
    String? photoUrl,
    String? phoneNumber,
    String? email,
    String? bio,
    DateTime? createdAt,
    DateTime? lastSeen,
    bool? isVerified,
  }) =>
      User(
        id: id ?? this.id,
        nickname: nickname ?? this.nickname,
        photoUrl: photoUrl ?? this.photoUrl,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        email: email ?? this.email,
        bio: bio ?? this.bio,
        createdAt: createdAt ?? this.createdAt,
        lastSeen: lastSeen ?? this.lastSeen,
        isVerified: isVerified ?? this.isVerified,
      );

  @override
  List<Object?> get props => [
        id,
        nickname,
        photoUrl,
        phoneNumber,
        email,
        bio,
        createdAt,
        lastSeen,
        isVerified,
      ];
}