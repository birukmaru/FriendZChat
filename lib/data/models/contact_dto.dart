/// DTO for a Contact — local-cache friendly.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:friendzchat/domain/entities/contact.dart';

part 'contact_dto.freezed.dart';
part 'contact_dto.g.dart';

@freezed
class ContactDto with _$ContactDto {
  const factory ContactDto({
    required String id,
    required String userId,
    required String name,
    String? photoUrl,
    String? phoneNumber,
    String? notes,
    @Default(false) bool isFavorite,
    DateTime? addedAt,
  }) = _ContactDto;

  factory ContactDto.fromJson(Map<String, dynamic> json) =>
      _$ContactDtoFromJson(json);

  const ContactDto._();

  factory ContactDto.fromEntity(Contact c) => ContactDto(
        id: c.id,
        userId: c.userId,
        name: c.name,
        photoUrl: c.photoUrl,
        phoneNumber: c.phoneNumber,
        notes: c.notes,
        isFavorite: c.isFavorite,
        addedAt: c.addedAt,
      );

  Contact toEntity() => Contact(
        id: id,
        userId: userId,
        name: name,
        photoUrl: photoUrl,
        phoneNumber: phoneNumber,
        notes: notes,
        isFavorite: isFavorite,
        addedAt: addedAt,
      );
}