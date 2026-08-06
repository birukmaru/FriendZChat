/// Domain entity: a saved contact / favourite.
library;

import 'package:equatable/equatable.dart';

class Contact extends Equatable {
  const Contact({
    required this.id,
    required this.userId,
    required this.name,
    this.photoUrl,
    this.phoneNumber,
    this.notes,
    this.isFavorite = false,
    DateTime? addedAt,
  }) : addedAt = addedAt;

  /// Locally-generated UUID for this contact entry.
  final String id;

  /// The 6-digit FriendZChat user ID of the contact.
  final String userId;

  final String name;
  final String? photoUrl;
  final String? phoneNumber;
  final String? notes;
  final bool isFavorite;
  final DateTime? addedAt;

  /// The fully-formatted dial destination — `8776 + userId`.
  String get dialDestination => '8776$userId';

  Contact copyWith({
    String? id,
    String? userId,
    String? name,
    String? photoUrl,
    String? phoneNumber,
    String? notes,
    bool? isFavorite,
    DateTime? addedAt,
  }) =>
      Contact(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        name: name ?? this.name,
        photoUrl: photoUrl ?? this.photoUrl,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        notes: notes ?? this.notes,
        isFavorite: isFavorite ?? this.isFavorite,
        addedAt: addedAt ?? this.addedAt,
      );

  @override
  List<Object?> get props => [
        id,
        userId,
        name,
        photoUrl,
        phoneNumber,
        notes,
        isFavorite,
        addedAt,
      ];
}