/// Local Hive-backed contact data source.
library;

import 'dart:async';
import 'dart:convert';

import 'package:hive/hive.dart';

import 'package:friendzchat/core/constants/app_constants.dart';
import 'package:friendzchat/core/errors/exceptions.dart';
import 'package:friendzchat/core/storage/hive_storage_service.dart';
import 'package:friendzchat/data/models/contact_dto.dart';

abstract interface class ContactLocalDataSource {
  Future<List<ContactDto>> getAll();
  Future<ContactDto> getById(String id);
  Future<ContactDto> save(ContactDto dto);
  Future<void> delete(String id);
  Stream<List<ContactDto>> watch();
}

class ContactLocalDataSourceImpl implements ContactLocalDataSource {
  ContactLocalDataSourceImpl({required HiveStorageService hive})
      : _hive = hive;

  final HiveStorageService _hive;

  Future<Box<dynamic>> _box() async {
    if (Hive.isBoxOpen(AppConstants.contactsBox)) {
      return Hive.box<dynamic>(AppConstants.contactsBox);
    }
    return Hive.openBox<dynamic>(AppConstants.contactsBox);
  }

  Future<List<ContactDto>> _readAll() async {
    try {
      final box = await _box();
      final raw = box.values
          .whereType<String>()
          .map(jsonDecode)
          .cast<Map<String, dynamic>>()
          .map(ContactDto.fromJson)
          .toList();
      raw.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      return raw;
    } catch (e) {
      throw CacheException('Failed to read contacts', cause: e);
    }
  }

  @override
  Future<List<ContactDto>> getAll() => _readAll();

  @override
  Future<ContactDto> getById(String id) async {
    try {
      final box = await _box();
      final raw = box.get(id);
      if (raw == null) throw CacheException('Contact $id not found');
      return ContactDto.fromJson(
        jsonDecode(raw as String) as Map<String, dynamic>,
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw CacheException('Failed to read contact', cause: e);
    }
  }

  @override
  Future<ContactDto> save(ContactDto dto) async {
    try {
      final box = await _box();
      await box.put(dto.id, jsonEncode(dto.toJson()));
      return dto;
    } catch (e) {
      throw CacheException('Failed to save contact', cause: e);
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      final box = await _box();
      await box.delete(id);
    } catch (e) {
      throw CacheException('Failed to delete contact', cause: e);
    }
  }

  @override
  Stream<List<ContactDto>> watch() async* {
    yield await _readAll();
    yield* _hive.watch(AppConstants.contactsBox).asyncMap((_) => _readAll());
  }
}