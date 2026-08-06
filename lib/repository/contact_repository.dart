/// ContactRepository implementation.
library;

import 'dart:async';

import 'package:friendzchat/core/errors/exceptions.dart';
import 'package:friendzchat/core/errors/failures.dart';
import 'package:friendzchat/data/datasources/contact_local_datasource.dart';
import 'package:friendzchat/data/datasources/user_remote_datasource.dart';
import 'package:friendzchat/data/models/contact_dto.dart';
import 'package:friendzchat/domain/entities/contact.dart';
import 'package:friendzchat/domain/repositories/repositories.dart';
import 'package:friendzchat/utils/result.dart';

class ContactRepositoryImpl implements ContactRepository {
  ContactRepositoryImpl({
    required ContactLocalDataSource local,
    required UserRemoteDataSource remote,
  })  : _local = local,
        _remote = remote;

  final ContactLocalDataSource _local;

  // ignore: unused_field — reserved for future cloud sync.
  final UserRemoteDataSource _remote;

  @override
  Future<Result<List<Contact>>> getContacts() async {
    try {
      final dtos = await _local.getAll();
      return Result.success(dtos.map((d) => d.toEntity()).toList());
    } catch (e) {
      return Result.failure(_toFailure(e));
    }
  }

  @override
  Future<Result<Contact>> getContact(String id) async {
    try {
      final dto = await _local.getById(id);
      return Result.success(dto.toEntity());
    } catch (e) {
      return Result.failure(_toFailure(e));
    }
  }

  @override
  Future<Result<Contact>> addContact(Contact contact) async {
    try {
      final dto = await _local.save(ContactDto.fromEntity(contact));
      return Result.success(dto.toEntity());
    } catch (e) {
      return Result.failure(_toFailure(e));
    }
  }

  @override
  Future<Result<Contact>> updateContact(Contact contact) async {
    try {
      final dto = await _local.save(ContactDto.fromEntity(contact));
      return Result.success(dto.toEntity());
    } catch (e) {
      return Result.failure(_toFailure(e));
    }
  }

  @override
  Future<Result<void>> deleteContact(String id) async {
    try {
      await _local.delete(id);
      return const Result.success(null);
    } catch (e) {
      return Result.failure(_toFailure(e));
    }
  }

  @override
  Future<Result<Contact>> toggleFavorite(String id) async {
    try {
      final dto = await _local.getById(id);
      final updated = dto.copyWith(isFavorite: !dto.isFavorite);
      await _local.save(updated);
      return Result.success(updated.toEntity());
    } catch (e) {
      return Result.failure(_toFailure(e));
    }
  }

  @override
  Stream<List<Contact>> watchContacts() =>
      _local.watch().map((dtos) => dtos.map((d) => d.toEntity()).toList());

  Failure _toFailure(Object e) {
    if (e is AppException) {
      if (e is CacheException) return CacheFailure(e.message);
      if (e is ValidationException) return ValidationFailure(e.message);
    }
    return UnknownFailure(e.toString());
  }
}